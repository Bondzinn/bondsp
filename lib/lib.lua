--[[
    288 Panel — lib.lua
    Biblioteca central. Fornece HTTP, cache, JSON, logs e helpers de UI.
    Carregada pelo Panel.lua via HttpGet.
    Versão corrigida - Sem BindToClose e funções server-side
]]

local lib = {}

-- ==================== ESTADO INTERNO ====================
local _config      = {}
local _moduleCache = {}   -- cache de módulos carregados { [path] = moduleTable }
local _httpCache   = {}   -- cache de respostas HTTP    { [url] = { data, timestamp } }
local HTTP_CACHE_TTL = 30 -- segundos

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local RAW_BASE    = "https://raw.githubusercontent.com/Bondzinn/288-Panel/main/"

-- ==================== INIT ====================
function lib.init(config)
    _config = config or {}
    lib.log("lib.lua iniciada — API: " .. (_config.apiBase or "?"))
    lib.log("Ambiente: " .. (RunService:IsServer() and "Servidor" or "Cliente"))
end

-- ==================== LOGS ====================
function lib.log(msg)
    print("[288] " .. tostring(msg))
end

function lib.warn(msg)
    warn("[288] " .. tostring(msg))
end

function lib.error(msg)
    error("[288] " .. tostring(msg))
end

-- ==================== JSON ====================
function lib.encode(t)
    local success, result = pcall(function()
        return HttpService:JSONEncode(t)
    end)
    if success then
        return result
    else
        lib.warn("JSON encode falhou: " .. tostring(result))
        return "{}"
    end
end

function lib.decode(s)
    if not s or s == "" then return nil end
    local ok, r = pcall(function() 
        return HttpService:JSONDecode(s) 
    end)
    if ok then return r end
    lib.warn("JSON decode falhou: " .. tostring(r))
    return nil
end

-- ==================== HTTP REQUESTS (API BACKEND) ====================
function lib.request(method, endpoint, body)
    if not _config.apiBase then
        lib.warn("API Base não configurada")
        return nil
    end
    
    local url = _config.apiBase .. endpoint

    -- GET: usa HttpGet simples (mais compatível com executores)
    if method == "GET" and not body then
        local ok, res = pcall(function()
            return game:HttpGet(url)
        end)
        if not ok then
            lib.warn("Request falhou [GET " .. endpoint .. "]: " .. tostring(res))
            return nil
        end
        return lib.decode(res)
    end

    -- POST: usa HttpService
    local ok, res = pcall(function()
        return HttpService:RequestAsync({
            Url     = url,
            Method  = method,
            Headers = {
                ["Content-Type"]    = "application/json",
                ["X-Panel-Version"] = _config.version or "1.0.0",
            },
            Body = body and lib.encode(body) or nil
        })
    end)

    if not ok then
        lib.warn("Request falhou [" .. method .. " " .. endpoint .. "]: " .. tostring(res))
        return nil
    end

    if not res.Success then
        lib.warn("HTTP " .. tostring(res.StatusCode) .. " em " .. endpoint)
        return nil
    end

    return lib.decode(res.Body)
end

-- ==================== CACHE HTTP ====================
function lib.cachedGet(endpoint)
    local now = os.time()
    local cached = _httpCache[endpoint]
    if cached and (now - cached.timestamp) < HTTP_CACHE_TTL then
        return cached.data
    end
    local data = lib.request("GET", endpoint)
    if data then
        _httpCache[endpoint] = { data = data, timestamp = now }
    end
    return data
end

function lib.clearCache()
    _httpCache = {}
    lib.log("Cache HTTP limpo")
end

-- ==================== SANDBOX PARA MÓDULOS ====================
-- Cria um ambiente seguro para executar módulos (bloqueia funções server-side)
function lib.createSandbox(modulePath)
    local sandbox = {
        -- Funções permitidas
        print = print,
        warn = warn,
        task = task,
        pcall = pcall,
        xpcall = xpcall,
        wait = wait,
        spawn = spawn,
        delay = delay,
        
        -- Bibliotecas padrão
        string = string,
        table = table,
        math = math,
        os = { time = os.time, date = os.date, clock = os.clock, difftime = os.difftime },
        
        -- Serviços seguros (readonly)
        game = game,
        workspace = workspace,
        Players = game:GetService("Players"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        Lighting = game:GetService("Lighting"),
        TweenService = game:GetService("TweenService"),
        UserInputService = game:GetService("UserInputService"),
        RunService = RunService,
        HttpService = HttpService,
        
        -- Construtores
        Instance = Instance,
        Color3 = Color3,
        Color3fromRGB = Color3.fromRGB,
        Color3fromHSV = Color3.fromHSV,
        UDim = UDim,
        UDim2 = UDim2,
        Vector2 = Vector2,
        Vector3 = Vector3,
        CFrame = CFrame,
        Ray = Ray,
        Rect = Rect,
        Region3 = Region3,
        Enum = Enum,
        
        -- Lib exposta para módulos
        lib = lib,
        
        -- Variáveis de ambiente
        _ENV = {},
        _G = {},
    }
    
    -- Bloquear funções server-side específicas
    local blockedFunctions = {
        "BindToClose",
        "OnShutdown",
        "SetStudioScale",
        "GetStudioScale",
        "SetMasterVolume",
        "GetMasterVolume"
    }
    
    for _, funcName in ipairs(blockedFunctions) do
        sandbox[funcName] = nil
    end
    
    -- Metatable para capturar acessos não permitidos
    setmetatable(sandbox, {
        __index = function(_, key)
            if key == "BindToClose" then
                error("BindToClose não pode ser usado no cliente", 2)
            end
            -- Permite acesso a outras globais mas com warn
            if _G[key] ~= nil then
                lib.warn("⚠️ Módulo tentou acessar variável global não permitida: " .. tostring(key))
                return nil
            end
            return nil
        end,
        __newindex = function(_, key, value)
            lib.warn("⚠️ Módulo tentou criar variável global: " .. tostring(key))
        end
    })
    
    return sandbox
end

-- ==================== LOAD MODULE (LAZY) ====================
-- Carrega um módulo do GitHub pelo path relativo.
-- Usa cache para não fazer múltiplos HttpGet do mesmo módulo.
function lib.loadModule(path)
    if _moduleCache[path] then
        return _moduleCache[path]
    end

    local url = RAW_BASE .. path
    lib.log("Carregando módulo: " .. path)
    
    local code, err = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not code then
        lib.warn("Falha ao baixar módulo [" .. path .. "]: " .. tostring(err))
        return nil
    end
    
    if not code or code == "" then
        lib.warn("Módulo vazio: " .. path)
        return nil
    end
    
    -- Pré-processar o código para remover BindToClose
    local safeCode = code
    if string.find(safeCode, "BindToClose") then
        lib.warn("⚠️ Removendo BindToClose do módulo: " .. path)
        safeCode = string.gsub(safeCode, ":BindToClose%s*%(", ":--BindToCloseRemoved(")
        safeCode = string.gsub(safeCode, "game%s*%.BindToClose", "game.--BindToCloseRemoved")
        safeCode = string.gsub(safeCode, "BindToClose%s*=", "--BindToCloseRemoved=")
    end
    
    -- Criar ambiente seguro
    local sandbox = lib.createSandbox(path)
    
    -- Compilar código
    local fn, compileErr = loadstring(safeCode)
    if not fn then
        -- Tentar sem remoção de BindToClose
        fn, compileErr = loadstring(code)
        if not fn then
            lib.warn("Erro ao compilar módulo [" .. path .. "]: " .. tostring(compileErr))
            return nil
        end
    end
    
    -- Executar no sandbox
    setfenv(fn, sandbox)
    local success, result = pcall(fn)
    
    if not success then
        lib.warn("Falha ao executar módulo [" .. path .. "]: " .. tostring(result))
        -- Se falhar por BindToClose, tentar novamente com código sanitizado
        if string.find(tostring(result), "BindToClose") then
            lib.warn("Tentando novamente com sanitização adicional...")
            local moreSafeCode = string.gsub(code, "BindToClose", "nil")
            fn, compileErr = loadstring(moreSafeCode)
            if fn then
                setfenv(fn, sandbox)
                success, result = pcall(fn)
            end
        end
        if not success then
            return nil
        end
    end

    -- Validação de estrutura mínima
    if type(result) ~= "table" then
        -- Tenta converter para table se necessário
        result = result or {}
    end
    
    -- Validação dos campos obrigatórios
    if not result.Name then
        result.Name = path:match("([^/]+)%.lua$") or "Módulo sem nome"
        lib.warn("Módulo sem nome: " .. path .. ", usando: " .. result.Name)
    end
    
    if not result.Enable then
        result.Enable = function() 
            lib.log(result.Name .. " habilitado (placeholder)")
        end
    end
    
    if not result.Disable then
        result.Disable = function() 
            lib.log(result.Name .. " desabilitado (placeholder)")
        end
    end

    _moduleCache[path] = result
    lib.log("✅ Módulo carregado: " .. result.Name)
    return result
end

-- ==================== HELPERS DE DEVICE ====================
function lib.getDevice()
    local UIS = game:GetService("UserInputService")
    if UIS.TouchEnabled and not UIS.MouseEnabled then
        return "Mobile"
    elseif UIS.GamepadEnabled then
        return "Console"
    end
    return "PC"
end

-- ==================== HELPERS DE RANK ====================
local RANK_COLORS = {
    Owner      = Color3.fromRGB(255, 50,  50),
    Supervisor = Color3.fromRGB(255, 140,  0),
    Support    = Color3.fromRGB(50,  150, 255),
    VIP        = Color3.fromRGB(180,  0, 255),
    User       = Color3.fromRGB(80,   80,  90),
}

function lib.getRankColor(rank)
    return RANK_COLORS[rank] or RANK_COLORS["User"]
end

-- ==================== UI HELPERS ====================
function lib.applyCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
    return corner
end

function lib.applyStroke(instance, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color     = color or Color3.fromRGB(50, 50, 60)
    stroke.Thickness = thickness or 1
    stroke.Parent    = instance
    return stroke
end

function lib.applyPadding(instance, px)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop    = UDim.new(0, px)
    pad.PaddingBottom = UDim.new(0, px)
    pad.PaddingLeft   = UDim.new(0, px)
    pad.PaddingRight  = UDim.new(0, px)
    pad.Parent        = instance
    return pad
end

function lib.applyShadow(instance, size, transparency)
    local shadow = Instance.new("UIShadow")
    shadow.Size = size or 4
    shadow.Transparency = transparency or 0.5
    shadow.Parent = instance
    return shadow
end

-- ==================== NOTIFICAÇÃO FLUTUANTE ====================
function lib.showNotification(screenGui, message, duration, isError)
    duration = duration or 3
    isError = isError or false
    
    local notif = Instance.new("Frame")
    notif.Size             = UDim2.new(0, 340, 0, 48)
    notif.Position         = UDim2.new(0.5, -170, 1, -80)
    notif.BackgroundColor3 = isError and Color3.fromRGB(80, 30, 30) or Color3.fromRGB(30, 30, 38)
    notif.Parent           = screenGui
    notif.ZIndex = 100
    lib.applyCorner(notif, 10)
    lib.applyStroke(notif, isError and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(80, 80, 120), 1)

    local label = Instance.new("TextLabel")
    label.Size                = UDim2.new(1, -20, 1, 0)
    label.Position            = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text                = (isError and "❌ " or "✓ ") .. message
    label.TextColor3          = Color3.fromRGB(220, 220, 230)
    label.TextScaled          = true
    label.Font                = Enum.Font.Gotham
    label.Parent              = notif

    -- Animação de entrada
    notif.Position = UDim2.new(0.5, -170, 1, -60)
    task.spawn(function()
        task.wait(duration)
        if notif and notif.Parent then
            notif:Destroy()
        end
    end)
    
    return notif
end

-- ==================== TOGGLE SWITCH ====================
function lib.createToggle(parent, labelText, yOffset, isActive, onToggle, isDisabled)
    local container = Instance.new("Frame")
    container.Size             = UDim2.new(1, -12, 0, 48)
    container.Position         = UDim2.new(0, 6, 0, yOffset)
    container.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    container.Parent           = parent
    container.BackgroundTransparency = isDisabled and 0.5 or 0
    lib.applyCorner(container, 8)

    local label = Instance.new("TextLabel")
    label.Size              = UDim2.new(1, -75, 1, 0)
    label.Position          = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text              = labelText
    label.TextColor3        = isDisabled and Color3.fromRGB(120, 120, 130) or Color3.fromRGB(210, 210, 215)
    label.TextSize          = 14
    label.Font              = Enum.Font.GothamBold
    label.TextXAlignment    = Enum.TextXAlignment.Left
    label.TextTruncate      = Enum.TextTruncate.AtEnd
    label.Parent            = container

    local trackOn  = Color3.fromRGB(0, 200, 100)
    local trackOff = Color3.fromRGB(60, 60, 70)

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(0, 46, 0, 24)
    track.Position         = UDim2.new(1, -56, 0.5, -12)
    track.BackgroundColor3 = isActive and trackOn or trackOff
    track.Parent           = container
    track.BackgroundTransparency = isDisabled and 0.5 or 0
    lib.applyCorner(track, 12)

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 20, 0, 20)
    knob.Position         = isActive and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent           = track
    knob.BackgroundTransparency = isDisabled and 0.3 or 0
    lib.applyCorner(knob, 10)

    if not isDisabled then
        local hitbox = Instance.new("TextButton")
        hitbox.Size               = UDim2.new(1, 0, 1, 0)
        hitbox.BackgroundTransparency = 1
        hitbox.Text               = ""
        hitbox.Parent             = track

        local active = isActive
        hitbox.MouseButton1Click:Connect(function()
            active = not active
            track.BackgroundColor3 = active and trackOn or trackOff
            knob.Position = active and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
            if onToggle then onToggle(active) end
        end)
    end

    return container
end

-- ==================== ACTION BUTTON ====================
function lib.createButton(parent, labelText, yOffset, callback, buttonText)
    local container = Instance.new("Frame")
    container.Size             = UDim2.new(1, -12, 0, 48)
    container.Position         = UDim2.new(0, 6, 0, yOffset)
    container.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    container.Parent           = parent
    lib.applyCorner(container, 8)

    local label = Instance.new("TextLabel")
    label.Size              = UDim2.new(1, -110, 1, 0)
    label.Position          = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text              = labelText
    label.TextColor3        = Color3.fromRGB(210, 210, 215)
    label.TextSize          = 14
    label.Font              = Enum.Font.GothamBold
    label.TextXAlignment    = Enum.TextXAlignment.Left
    label.Parent            = container

    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, 88, 0, 32)
    btn.Position         = UDim2.new(1, -98, 0.5, -16)
    btn.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
    btn.Text             = buttonText or "▶ EXECUTAR"
    btn.TextColor3       = Color3.new(1, 1, 1)
    btn.TextSize         = 12
    btn.Font             = Enum.Font.GothamBold
    btn.Parent           = container
    lib.applyCorner(btn, 6)

    btn.MouseEnter:Connect(function() 
        if not btn.Disabled then
            btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220)
        end
    end)
    btn.MouseLeave:Connect(function() 
        if not btn.Disabled then
            btn.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        if callback and not btn.Disabled then
            local success, err = pcall(callback)
            if not success then
                lib.warn("Erro no callback do botão: " .. tostring(err))
                local player = game:GetService("Players").LocalPlayer
                local gui = player:WaitForChild("PlayerGui"):FindFirstChild("288Panel")
                if gui then
                    lib.showNotification(gui, "Erro: " .. tostring(err), 3, true)
                end
            end
        end
    end)

    return container
end

-- ==================== FRAME BUILDER: HOME ====================
function lib.buildHomeFrame(parent, userData, apiBase)
    local Players    = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local frame = Instance.new("Frame")
    frame.Size             = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible          = false
    frame.Parent           = parent

    -- Avatar
    local avatar = Instance.new("ImageLabel")
    avatar.Size             = UDim2.new(0, 90, 0, 90)
    avatar.Position         = UDim2.new(0.5, -45, 0, 20)
    avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    avatar.Parent           = frame
    lib.applyCorner(avatar, 45)
    lib.applyStroke(avatar, lib.getRankColor(userData.rank), 2)
    avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

    task.spawn(function()
        local success, img = pcall(function()
            return Players:GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size420x420
            )
        end)
        if success and img and img ~= "" then 
            avatar.Image = img 
        end
    end)

    -- Nome
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size              = UDim2.new(1, -40, 0, 36)
    nameLabel.Position          = UDim2.new(0, 20, 0, 120)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text              = LocalPlayer.DisplayName
    nameLabel.TextColor3        = Color3.new(1, 1, 1)
    nameLabel.TextScaled        = true
    nameLabel.Font              = Enum.Font.GothamBold
    nameLabel.Parent            = frame

    -- Rank badge
    local rankBadge = Instance.new("TextLabel")
    rankBadge.Size             = UDim2.new(0, 100, 0, 24)
    rankBadge.Position         = UDim2.new(0.5, -50, 0, 162)
    rankBadge.BackgroundColor3 = lib.getRankColor(userData.rank)
    rankBadge.TextColor3       = Color3.new(1,1,1)
    rankBadge.Text             = userData.rank or "User"
    rankBadge.TextScaled       = true
    rankBadge.Font             = Enum.Font.GothamBold
    rankBadge.Parent           = frame
    lib.applyCorner(rankBadge, 6)

    -- Info dinâmica
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size              = UDim2.new(1, -40, 0, 100)
    infoLabel.Position          = UDim2.new(0, 20, 0, 200)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3        = Color3.fromRGB(180, 180, 190)
    infoLabel.TextSize          = 14
    infoLabel.Font              = Enum.Font.Gotham
    infoLabel.TextWrapped       = true
    infoLabel.TextXAlignment    = Enum.TextXAlignment.Center
    infoLabel.Parent            = frame

    -- Atualiza info a cada 2s
    local running = true
    task.spawn(function()
        while running and infoLabel and infoLabel.Parent do
            local success, stats = pcall(lib.cachedGet, "/stats")
            local ping = 0
            local successPing, p = pcall(function() return LocalPlayer:GetPing() end)
            if successPing then ping = p end
            local online = (stats and stats.online) or #Players:GetPlayers()
            local total  = (stats and stats.totalUsers) or 0
            infoLabel.Text = string.format(
                "🏓 Ping: %dms   •   👥 Online: %d   •   📊 Total: %d\n🔘 [INSERT] para abrir/fechar",
                math.floor(ping), online, total
            )
            task.wait(4)
        end
    end)

    -- Announcements
    task.spawn(function()
        local success, ann = pcall(lib.cachedGet, "/announcements")
        if success and ann and ann[1] and ann[1].message then
            local annLabel = Instance.new("TextLabel")
            annLabel.Size              = UDim2.new(1, -40, 0, 50)
            annLabel.Position          = UDim2.new(0, 20, 0, 310)
            annLabel.BackgroundColor3  = Color3.fromRGB(30, 30, 40)
            annLabel.TextColor3        = Color3.fromRGB(255, 220, 80)
            annLabel.TextSize          = 13
            annLabel.Font              = Enum.Font.Gotham
            annLabel.TextWrapped       = true
            annLabel.Text              = "📢 " .. tostring(ann[1].message)
            annLabel.Parent            = frame
            lib.applyCorner(annLabel, 8)
            lib.applyPadding(annLabel, 8)
        end
    end)
    
    -- Cleanup
    frame.Destroying:Connect(function()
        running = false
    end)

    return frame
end

-- ==================== FRAME BUILDER: CATEGORIA ====================
function lib.buildCategoryFrame(parent, category, modules, userData)
    local frame = Instance.new("Frame")
    frame.Size             = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible          = false
    frame.Parent           = parent

    -- Título
    local title = Instance.new("TextLabel")
    title.Size              = UDim2.new(1, -20, 0, 40)
    title.Position          = UDim2.new(0, 10, 0, 8)
    title.BackgroundTransparency = 1
    title.Text              = category
    title.TextColor3        = Color3.fromRGB(255, 255, 255)
    title.TextSize          = 18
    title.Font              = Enum.Font.GothamBold
    title.TextXAlignment    = Enum.TextXAlignment.Left
    title.Parent            = frame

    -- Scroll
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size             = UDim2.new(1, -10, 1, -56)
    scroll.Position         = UDim2.new(0, 5, 0, 52)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    scroll.CanvasSize       = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent           = frame

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding   = UDim.new(0, 6)
    layout.Parent    = scroll

    -- Filtrar módulos da categoria
    local catModules = {}
    for _, m in ipairs(modules) do
        if m.Category == category then
            table.insert(catModules, m)
        end
    end

    if #catModules == 0 then
        local empty = Instance.new("TextLabel")
        empty.Size              = UDim2.new(1, -20, 0, 40)
        empty.BackgroundTransparency = 1
        empty.Text              = "Nenhum módulo disponível."
        empty.TextColor3        = Color3.fromRGB(120, 120, 130)
        empty.TextScaled        = true
        empty.Font              = Enum.Font.Gotham
        empty.Parent            = scroll
    end

    for i, modDef in ipairs(catModules) do
        local isVipLocked = modDef.RequireVip and not userData.vip
        
        task.spawn(function()
            local modTable = lib.loadModule(modDef.Path)
            if not modTable then
                -- Mostrar módulo como indisponível
                lib.createToggle(
                    scroll,
                    "❌ " .. (modDef.Name or modDef.Path),
                    0,
                    false,
                    nil,
                    true
                )
                return
            end

            lib.createToggle(
                scroll,
                (isVipLocked and "🔒 " or "") .. modTable.Name,
                0,
                modTable.Enabled or false,
                function(state)
                    if isVipLocked then
                        local player = game:GetService("Players").LocalPlayer
                        local gui = player:WaitForChild("PlayerGui"):FindFirstChild("288Panel")
                        if gui then
                            lib.showNotification(gui, "🔒 Este módulo requer VIP!", 3, true)
                        end
                        return
                    end
                    
                    local success, err = pcall(function()
                        if state then
                            if modTable.Enable then modTable:Enable() end
                        else
                            if modTable.Disable then modTable:Disable() end
                        end
                    end)
                    
                    if not success then
                        lib.warn("Erro ao " .. (state and "habilitar" or "desabilitar") .. " módulo " .. modTable.Name .. ": " .. tostring(err))
                        local player = game:GetService("Players").LocalPlayer
                        local gui = player:WaitForChild("PlayerGui"):FindFirstChild("288Panel")
                        if gui then
                            lib.showNotification(gui, "Erro no módulo: " .. tostring(err), 3, true)
                        end
                        return
                    end
                    
                    modTable.Enabled = state
                end,
                isVipLocked
            )
        end)
    end

    return frame
end

-- ==================== FRAME BUILDER: PLACEHOLDER ====================
function lib.buildPlaceholderFrame(parent, name)
    local frame = Instance.new("Frame")
    frame.Size             = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible          = false
    frame.Parent           = parent

    local label = Instance.new("TextLabel")
    label.Size              = UDim2.new(1, -40, 0, 60)
    label.Position          = UDim2.new(0, 20, 0.4, 0)
    label.BackgroundTransparency = 1
    label.Text              = name .. "\n🚧 Em breve... 🚧"
    label.TextColor3        = Color3.fromRGB(130, 130, 140)
    label.TextScaled        = true
    label.Font              = Enum.Font.Gotham
    label.TextWrapped       = true
    label.Parent            = frame

    return frame
end

-- ==================== UTILITÁRIOS GERAIS ====================
function lib.getPlayerGui()
    local player = game:GetService("Players").LocalPlayer
    if not player then return nil end
    return player:FindFirstChild("PlayerGui")
end

function lib.isModuleLoaded(path)
    return _moduleCache[path] ~= nil
end

function lib.unloadModule(path)
    if _moduleCache[path] then
        -- Tentar desabilitar primeiro
        local mod = _moduleCache[path]
        if mod and mod.Disable then
            pcall(mod.Disable, mod)
        end
        _moduleCache[path] = nil
        lib.log("Módulo descarregado: " .. path)
        return true
    end
    return false
end

function lib.reloadModule(path)
    lib.unloadModule(path)
    return lib.loadModule(path)
end

return lib
