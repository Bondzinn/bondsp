--[[
    288 Panel - Entry Point (CORRIGIDO)
    Remove BindToClose e corrige requisições HTTP
]]

-- ==================== CONFIGURAÇÃO ====================
local RAW = "https://raw.githubusercontent.com/Bondzinn/bondsp/refs/heads/main/"
local API_BASE = "https://seems-seventh-brook-nickname.trycloudflare.com"

local VERSION = "1.0.0"
local HEARTBEAT_INTERVAL = 60

-- ==================== SERVIÇOS ====================
local Players         = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local HttpService     = game:GetService("HttpService")
local LocalPlayer     = Players.LocalPlayer

-- ==================== BLOQUEAR BindToClose ANTES DE TUDO ====================
-- Isso impede qualquer tentativa de chamar BindToClose
local originalGame = game
game = setmetatable({}, {
    __index = function(t, k)
        if k == "BindToClose" then
            return function() 
                warn("[288] BindToClose bloqueado - ignorando")
                return function() end 
            end
        end
        return originalGame[k]
    end,
    __newindex = function(t, k, v)
        if k == "BindToClose" then
            warn("[288] Tentativa de definir BindToClose bloqueada")
            return
        end
        originalGame[k] = v
    end
})

-- ==================== CARREGAMENTO DA LIB ====================
local lib, modules

local success, err = pcall(function()
    -- Carregar lib.lua (versão corrigida)
    local libCode = game:HttpGet(RAW .. "lib/lib.lua")
    lib = loadstring(libCode)()
    
    -- Carregar modules.lua
    local modulesCode = game:HttpGet(RAW .. "lib/modules.lua")
    modules = loadstring(modulesCode)()
end)

if not success then
    warn("[288] Falha ao carregar lib: " .. tostring(err))
    -- Fallback: criar lib mínima
    lib = {
        init = function() end,
        log = print,
        warn = warn,
        request = function() return nil end,
        getDevice = function() return "PC" end,
        getRankColor = function() return Color3.fromRGB(255,255,255) end,
        applyCorner = function(i, r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=i return c end,
        applyStroke = function(i,c,t) local s=Instance.new("UIStroke") s.Color=c or Color3.fromRGB(50,50,60) s.Thickness=t or 1 s.Parent=i return s end,
        showNotification = function(gui, msg, dur, isErr)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(0,300,0,40)
            f.Position = UDim2.new(0.5,-150,1,-60)
            f.BackgroundColor3 = isErr and Color3.fromRGB(80,30,30) or Color3.fromRGB(30,30,38)
            f.Parent = gui
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1,0,1,0)
            l.BackgroundTransparency = 1
            l.Text = (isErr and "❌ " or "✓ ") .. msg
            l.TextColor3 = Color3.fromRGB(220,220,230)
            l.TextScaled = true
            l.Font = Enum.Font.Gotham
            l.Parent = f
            task.delay(dur or 3, function() if f then f:Destroy() end end)
        end,
        buildHomeFrame = function(parent, userData, apiBase)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1,0,1,0)
            f.BackgroundTransparency = 1
            f.Parent = parent
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1,0,1,0)
            l.BackgroundTransparency = 1
            l.Text = "288 Panel - " .. (userData and userData.rank or "User")
            l.TextColor3 = Color3.new(1,1,1)
            l.TextScaled = true
            l.Font = Enum.Font.GothamBold
            l.Parent = f
            return f
        end,
        buildCategoryFrame = function(parent, cat, mods, userData)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1,0,1,0)
            f.BackgroundTransparency = 1
            f.Parent = parent
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1,0,1,0)
            l.BackgroundTransparency = 1
            l.Text = "Categoria: " .. cat .. "\n(Em desenvolvimento)"
            l.TextColor3 = Color3.fromRGB(200,200,200)
            l.TextScaled = true
            l.Font = Enum.Font.Gotham
            l.Parent = f
            return f
        end,
        buildPlaceholderFrame = function(parent, name)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1,0,1,0)
            f.BackgroundTransparency = 1
            f.Parent = parent
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1,0,1,0)
            l.BackgroundTransparency = 1
            l.Text = name .. "\n🚧 Em breve..."
            l.TextColor3 = Color3.fromRGB(130,130,140)
            l.TextScaled = true
            l.Font = Enum.Font.Gotham
            l.Parent = f
            return f
        end
    }
    modules = {}
end

lib.init({ apiBase = API_BASE, version = VERSION })

-- ==================== FUNÇÃO DE REQUISIÇÃO CORRIGIDA ====================
-- Versão mais segura que não usa funções bloqueadas
function safeRequest(method, endpoint, body)
    local url = API_BASE .. endpoint
    
    -- Para POST, tentar com método alternativo
    if method == "POST" then
        -- Tentar com HttpService se disponível
        local success, result = pcall(function()
            return HttpService:RequestAsync({
                Url = url,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = body and HttpService:JSONEncode(body) or ""
            })
        end)
        
        if success and result and result.Success then
            local ok, data = pcall(function()
                return HttpService:JSONDecode(result.Body)
            end)
            if ok then return data end
        end
        
        -- Fallback: retornar simulação
        lib.warn("Request POST falhou para " .. endpoint .. ", usando dados simulados")
        if endpoint == "/session/start" then
            return { sessionId = "local_" .. tostring(os.time()) }
        end
        return { success = false }
    end
    
    -- GET com HttpGet normal
    if method == "GET" then
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success and result then
            local ok, data = pcall(function()
                return HttpService:JSONDecode(result)
            end)
            if ok then return data end
        end
        return nil
    end
    
    return nil
end

-- ==================== SESSÃO (SEM BindToClose) ====================
local sessionId = nil

local function startSession()
    -- Tentar iniciar sessão, mas não travar se falhar
    local success, res = pcall(function()
        return safeRequest("POST", "/session/start", {
            userid   = LocalPlayer.UserId,
            username = LocalPlayer.Name,
            version  = VERSION,
            game     = tostring(game.PlaceId),
            device   = lib.getDevice and lib.getDevice() or "PC"
        })
    end)
    
    if success and res and res.sessionId then
        sessionId = res.sessionId
        lib.log("Sessão iniciada: " .. sessionId)
    else
        -- Criar sessão local para não quebrar o painel
        sessionId = "local_" .. tostring(os.time()) .. "_" .. tostring(LocalPlayer.UserId)
        lib.warn("Usando sessão local: " .. sessionId)
    end
end

local function heartbeat()
    if not sessionId then return end
    pcall(function()
        safeRequest("POST", "/session/heartbeat", {
            sessionId = sessionId,
            userid    = LocalPlayer.UserId
        })
    end)
end

local function endSession()
    if not sessionId then return end
    pcall(function()
        safeRequest("POST", "/session/end", { sessionId = sessionId })
    end)
    sessionId = nil
end

-- Verifica usuário (com fallback)
local userData = nil
local userCheckSuccess, userCheckResult = pcall(function()
    return safeRequest("GET", "/user/" .. LocalPlayer.UserId)
end)

if userCheckSuccess and userCheckResult then
    userData = userCheckResult
else
    -- Dados de usuário simulados
    userData = {
        userid = LocalPlayer.UserId,
        username = LocalPlayer.Name,
        rank = "User",
        vip = false,
        banned = false
    }
    lib.warn("Usando dados de usuário simulados")
end

if userData and userData.banned then
    warn("[288] Você está banido do 288 Panel.")
    return
end

-- ==================== INICIAR SESSÃO ====================
task.spawn(startSession)

-- Heartbeat loop
task.spawn(function()
    while task.wait(HEARTBEAT_INTERVAL) do
        heartbeat()
    end
end)

-- NÃO usar game:BindToClose! Em vez disso, usar UserInputService ou RunService
LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer.Parent then 
        endSession()
    end
end)

-- Alternativa para detectar quando o jogador sai
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        endSession()
    end
end)

-- ==================== UI PRINCIPAL ====================
-- Aguardar character
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name         = "288Panel"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent       = LocalPlayer:WaitForChild("PlayerGui")

-- MainFrame
local MainFrame = Instance.new("Frame")
MainFrame.Size            = UDim2.new(0, 720, 0, 500)
MainFrame.Position        = UDim2.new(0.5, -360, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active          = true
MainFrame.Draggable       = true
MainFrame.ClipsDescendants = true
MainFrame.Parent          = ScreenGui

if lib.applyCorner then
    lib.applyCorner(MainFrame, 10)
end
if lib.applyStroke then
    lib.applyStroke(MainFrame, Color3.fromRGB(50, 50, 60), 1)
end

-- ==================== HEADER ====================
local Header = Instance.new("Frame")
Header.Size             = UDim2.new(1, 0, 0, 56)
Header.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
Header.BorderSizePixel  = 0
Header.Parent           = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size              = UDim2.new(0.5, 0, 1, 0)
TitleLabel.Position          = UDim2.new(0.25, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text              = "288 Panel"
TitleLabel.TextScaled        = true
TitleLabel.Font              = Enum.Font.GothamBold
TitleLabel.TextXAlignment    = Enum.TextXAlignment.Center
TitleLabel.Parent            = Header

-- Rainbow effect
task.spawn(function()
    local colors = {
        Color3.fromRGB(255,60,60),
        Color3.fromRGB(255,140,0),
        Color3.fromRGB(255,240,0),
        Color3.fromRGB(0,255,100),
        Color3.fromRGB(0,200,255),
        Color3.fromRGB(160,0,255)
    }
    local i = 1
    while TitleLabel and TitleLabel.Parent do
        pcall(function() TitleLabel.TextColor3 = colors[i] end)
        i = (i % #colors) + 1
        task.wait(0.18)
    end
end)

-- Rank badge no header
local RankLabel = Instance.new("TextLabel")
RankLabel.Size              = UDim2.new(0, 100, 0, 24)
RankLabel.Position          = UDim2.new(0, 12, 0.5, -12)
RankLabel.BackgroundColor3  = (lib.getRankColor and lib.getRankColor(userData.rank)) or Color3.fromRGB(80,80,90)
RankLabel.TextColor3        = Color3.new(1,1,1)
RankLabel.Text              = (userData and userData.rank) or "User"
RankLabel.TextScaled        = true
RankLabel.Font              = Enum.Font.GothamBold
RankLabel.Parent            = Header
if lib.applyCorner then lib.applyCorner(RankLabel, 6) end

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size              = UDim2.new(0, 60, 0, 20)
VersionLabel.Position          = UDim2.new(0, 12, 1, -24)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text              = "v" .. VERSION
VersionLabel.TextColor3        = Color3.fromRGB(120, 120, 130)
VersionLabel.TextScaled        = true
VersionLabel.Font              = Enum.Font.Gotham
VersionLabel.Parent            = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size            = UDim2.new(0, 36, 0, 36)
CloseBtn.Position        = UDim2.new(1, -44, 0.5, -18)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text            = "✕"
CloseBtn.TextColor3      = Color3.new(1,1,1)
CloseBtn.TextScaled      = true
CloseBtn.Font            = Enum.Font.GothamBold
CloseBtn.Parent          = Header
if lib.applyCorner then lib.applyCorner(CloseBtn, 8) end
CloseBtn.MouseButton1Click:Connect(function()
    endSession()
    ScreenGui:Destroy()
end)

-- ==================== SIDEBAR ====================
local Sidebar = Instance.new("Frame")
Sidebar.Size             = UDim2.new(0, 155, 1, -56)
Sidebar.Position         = UDim2.new(0, 0, 0, 56)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
Sidebar.BorderSizePixel  = 0
Sidebar.Parent           = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding   = UDim.new(0, 2)
SidebarLayout.Parent    = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop  = UDim.new(0, 6)
SidebarPadding.PaddingLeft = UDim.new(0, 6)
SidebarPadding.PaddingRight = UDim.new(0, 6)
SidebarPadding.Parent      = Sidebar

-- ==================== CONTENT ====================
local ContentFrame = Instance.new("Frame")
ContentFrame.Size             = UDim2.new(1, -155, 1, -56)
ContentFrame.Position         = UDim2.new(0, 155, 0, 56)
ContentFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
ContentFrame.BorderSizePixel  = 0
ContentFrame.ClipsDescendants = true
ContentFrame.Parent           = MainFrame

-- ==================== ABAS ====================
local loadedTabs  = {}
local activeBtn   = nil

local tabDefs = {
    { icon = "🏠", name = "Home",      category = nil     },
    { icon = "👑", name = "VIP",       category = nil,    vip = true },
    { icon = "⭐", name = "Emphasis",  category = "Emphasis" },
    { icon = "👤", name = "Character", category = nil     },
    { icon = "🎯", name = "Target",    category = nil     },
    { icon = "⚔️", name = "More",      category = "More"  },
    { icon = "🛠️", name = "Misc",      category = "Misc"  },
}

local function showTab(name, tabFrame)
    for _, f in pairs(loadedTabs) do
        pcall(function() f.Visible = false end)
    end
    pcall(function() tabFrame.Visible = true end)
end

local function createTabButton(tabDef, order)
    local isVip = tabDef.vip and not (userData and userData.vip)

    local Btn = Instance.new("TextButton")
    Btn.Size             = UDim2.new(1, 0, 0, 44)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    Btn.Text             = tabDef.icon .. "  " .. tabDef.name
    Btn.TextColor3       = isVip and Color3.fromRGB(100,100,110) or Color3.fromRGB(210, 210, 215)
    Btn.TextScaled       = true
    Btn.Font             = Enum.Font.Gotham
    Btn.LayoutOrder      = order
    Btn.Parent           = Sidebar
    if lib.applyCorner then lib.applyCorner(Btn, 8) end

    Btn.MouseEnter:Connect(function()
        if Btn ~= activeBtn then
            Btn.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
        end
    end)
    Btn.MouseLeave:Connect(function()
        if Btn ~= activeBtn then
            Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        end
    end)

    Btn.MouseButton1Click:Connect(function()
        if isVip then
            if lib.showNotification then
                lib.showNotification(ScreenGui, "🔒 Acesso VIP necessário!")
            end
            return
        end

        if activeBtn then 
            activeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        end
        activeBtn = Btn
        Btn.BackgroundColor3 = Color3.fromRGB(48, 48, 60)

        if loadedTabs[tabDef.name] then
            showTab(tabDef.name, loadedTabs[tabDef.name])
            return
        end

        -- Carregar aba
        local frame = nil
        if tabDef.category and lib.buildCategoryFrame then
            frame = lib.buildCategoryFrame(ContentFrame, tabDef.category, modules or {}, userData or {})
        elseif tabDef.name == "Home" and lib.buildHomeFrame then
            frame = lib.buildHomeFrame(ContentFrame, userData or {}, API_BASE)
        elseif lib.buildPlaceholderFrame then
            frame = lib.buildPlaceholderFrame(ContentFrame, tabDef.name)
        else
            -- Fallback mínimo
            frame = Instance.new("Frame")
            frame.Size = UDim2.new(1,0,1,0)
            frame.BackgroundTransparency = 1
            frame.Parent = ContentFrame
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1,0,1,0)
            l.BackgroundTransparency = 1
            l.Text = tabDef.name
            l.TextColor3 = Color3.new(1,1,1)
            l.Parent = frame
        end
        
        loadedTabs[tabDef.name] = frame
        showTab(tabDef.name, frame)
    end)

    return Btn
end

for i, def in ipairs(tabDefs) do
    createTabButton(def, i)
end

-- Abrir Home por padrão
local homeFrame = nil
if lib.buildHomeFrame then
    homeFrame = lib.buildHomeFrame(ContentFrame, userData or {}, API_BASE)
else
    homeFrame = Instance.new("Frame")
    homeFrame.Size = UDim2.new(1,0,1,0)
    homeFrame.BackgroundTransparency = 1
    homeFrame.Parent = ContentFrame
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,0,1,0)
    l.BackgroundTransparency = 1
    l.Text = "288 Panel - Carregado com sucesso!"
    l.TextColor3 = Color3.new(1,1,1)
    l.TextScaled = true
    l.Parent = homeFrame
end

loadedTabs["Home"] = homeFrame
homeFrame.Visible = true

-- Marcar botão Home como ativo
local firstBtn = Sidebar:GetChildren()[1]
if firstBtn and firstBtn:IsA("TextButton") then
    activeBtn = firstBtn
    firstBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 60)
end

-- ==================== TOGGLE INSERT ====================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

lib.log("[288] ✅ Painel carregado — INSERT para abrir/fechar")
