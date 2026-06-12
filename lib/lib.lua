--[[
    288 Panel — lib.lua
    Biblioteca central. Fornece HTTP, cache, JSON, logs e helpers de UI.
    Carregada pelo Panel.lua via HttpGet.
]]

local lib = {}

-- ==================== ESTADO INTERNO ====================
local _config      = {}
local _moduleCache = {}   -- cache de módulos carregados { [path] = moduleTable }
local _httpCache   = {}   -- cache de respostas HTTP    { [url] = { data, timestamp } }
local HTTP_CACHE_TTL = 30 -- segundos

local HttpService = game:GetService("HttpService")
local RAW_BASE    = "https://raw.githubusercontent.com/Bondzinn/288-Panel/main/"

-- ==================== INIT ====================
function lib.init(config)
    _config = config or {}
    lib.log("lib.lua iniciada — API: " .. (_config.apiBase or "?"))
end

-- ==================== LOGS ====================
function lib.log(msg)
    print("[288] " .. tostring(msg))
end

function lib.warn(msg)
    warn("[288] " .. tostring(msg))
end

-- ==================== JSON ====================
function lib.encode(t)
    return HttpService:JSONEncode(t)
end

function lib.decode(s)
    local ok, r = pcall(function() return HttpService:JSONDecode(s) end)
    if ok then return r end
    lib.warn("JSON decode falhou: " .. tostring(r))
    return nil
end

-- ==================== HTTP REQUESTS (API BACKEND) ====================
function lib.request(method, endpoint, body)
    local url = (_config.apiBase or "") .. endpoint

    local req = (syn and syn.request)
        or http_request
        or request

    if not req then
        lib.warn("Executor não suporta HTTP request")
        return nil
    end

    local res = req({
        Url = url,
        Method = method,
        Headers = {
            ["Content-Type"] = "application/json",
            ["X-Panel-Version"] = _config.version or "1.0.0",
        },
        Body = body and HttpService:JSONEncode(body) or nil
    })

    if not res then
        return nil
    end

    -- compatibilidade com diferentes formatos
    local raw = res.Body or res.body
    if not raw then
        return nil
    end

    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(raw)
    end)

    if not ok then
        lib.warn("JSON inválido em: " .. endpoint)
        return nil
    end

    return decoded
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

-- ==================== LOAD MODULE (LAZY) ====================
-- Carrega um módulo do GitHub pelo path relativo.
-- Usa cache para não fazer múltiplos HttpGet do mesmo módulo.
function lib.loadModule(path)
    if _moduleCache[path] then
        return _moduleCache[path]
    end

    local url = RAW_BASE .. path
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if not ok then
        lib.warn("Falha ao carregar módulo [" .. path .. "]: " .. tostring(result))
        return nil
    end

    -- Validação de estrutura mínima
    if type(result) ~= "table" or not result.Name or not result.Enable then
        lib.warn("Módulo inválido (estrutura incorreta): " .. path)
        return nil
    end

    _moduleCache[path] = result
    lib.log("Módulo carregado: " .. result.Name)
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

-- ==================== NOTIFICAÇÃO FLUTUANTE ====================
function lib.showNotification(screenGui, message, duration)
    duration = duration or 3
    local notif = Instance.new("Frame")
    notif.Size             = UDim2.new(0, 320, 0, 48)
    notif.Position         = UDim2.new(0.5, -160, 1, -80)
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    notif.Parent           = screenGui
    lib.applyCorner(notif, 10)
    lib.applyStroke(notif, Color3.fromRGB(80, 80, 120), 1)

    local label = Instance.new("TextLabel")
    label.Size                = UDim2.new(1, -20, 1, 0)
    label.Position            = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text                = message
    label.TextColor3          = Color3.fromRGB(220, 220, 230)
    label.TextScaled          = true
    label.Font                = Enum.Font.Gotham
    label.Parent              = notif

    task.delay(duration, function()
        if notif and notif.Parent then notif:Destroy() end
    end)
end

-- ==================== TOGGLE SWITCH ====================
function lib.createToggle(parent, labelText, yOffset, isActive, onToggle)
    local container = Instance.new("Frame")
    container.Size             = UDim2.new(1, -12, 0, 48)
    container.Position         = UDim2.new(0, 6, 0, yOffset)
    container.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    container.Parent           = parent
    lib.applyCorner(container, 8)

    local label = Instance.new("TextLabel")
    label.Size              = UDim2.new(1, -75, 1, 0)
    label.Position          = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text              = labelText
    label.TextColor3        = Color3.fromRGB(210, 210, 215)
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
    lib.applyCorner(track, 12)

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 20, 0, 20)
    knob.Position         = isActive and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent           = track
    lib.applyCorner(knob, 10)

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
        onToggle(active)
    end)

    return container
end

-- ==================== ACTION BUTTON ====================
function lib.createButton(parent, labelText, yOffset, callback)
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
    btn.Text             = "▶ EXECUTAR"
    btn.TextColor3       = Color3.new(1, 1, 1)
    btn.TextSize         = 12
    btn.Font             = Enum.Font.GothamBold
    btn.Parent           = container
    lib.applyCorner(btn, 6)

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(0, 160, 220) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(0, 140, 200) end)
    btn.MouseButton1Click:Connect(callback)

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

    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size420x420
            )
        end)
        if ok and img then avatar.Image = img end
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
    task.spawn(function()
        while infoLabel and infoLabel.Parent do
            local stats = lib.cachedGet("/stats")
            local ping  = LocalPlayer:GetPing() or 0
            local online = (stats and stats.online) or #Players:GetPlayers()
            local total  = (stats and stats.totalUsers) or 0
            infoLabel.Text = string.format(
                "Ping: %dms   •   Online: %d   •   Total: %d\n[INSERT] para abrir/fechar",
                math.floor(ping), online, total
            )
            task.wait(4)
        end
    end)

    -- Announcements
    task.spawn(function()
        local ann = lib.cachedGet("/announcements")
        if ann and ann[1] then
            local annLabel = Instance.new("TextLabel")
            annLabel.Size              = UDim2.new(1, -40, 0, 50)
            annLabel.Position          = UDim2.new(0, 20, 0, 310)
            annLabel.BackgroundColor3  = Color3.fromRGB(30, 30, 40)
            annLabel.TextColor3        = Color3.fromRGB(255, 220, 80)
            annLabel.TextSize          = 13
            annLabel.Font              = Enum.Font.Gotham
            annLabel.TextWrapped       = true
            annLabel.Text              = "📢 " .. (ann[1].message or "")
            annLabel.Parent            = frame
            lib.applyCorner(annLabel, 8)
            lib.applyPadding(annLabel, 8)
        end
    end)

    return frame
end

-- ==================== FRAME BUILDER: CATEGORIA ====================
-- Carrega todos os módulos de uma categoria e monta a grade de toggles/botões.
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
        -- VIP gate por módulo
        local isVipLocked = modDef.RequireVip and not userData.vip

        task.spawn(function()
            local modTable = lib.loadModule(modDef.Path)
            if not modTable then return end

            lib.createToggle(
                scroll,
                (isVipLocked and "🔒 " or "") .. modTable.Name,
                0,
                modTable.Enabled,
                function(state)
                    if isVipLocked then
                        lib.showNotification(
                            game:GetService("Players").LocalPlayer
                                :WaitForChild("PlayerGui"):WaitForChild("288Panel"),
                            "🔒 Requer VIP!"
                        )
                        return
                    end
                    if state then
                        modTable:Enable()
                    else
                        modTable:Disable()
                    end
                    modTable.Enabled = state
                end
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
    label.Text              = name .. "\nEm breve..."
    label.TextColor3        = Color3.fromRGB(130, 130, 140)
    label.TextScaled        = true
    label.Font              = Enum.Font.Gotham
    label.TextWrapped       = true
    label.Parent            = frame

    return frame
end

return lib
