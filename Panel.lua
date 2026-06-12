--[[
    288 Panel - Entry Point (VERSÃO COMPATÍVEL COM EXECUTORES)
    Usa apenas game:HttpGet e game:HttpPost - NÃO usa RequestAsync
]]

-- ==================== CONFIGURAÇÃO ====================
local RAW = "https://raw.githubusercontent.com/Bondzinn/bondsp/refs/heads/main/"
local API_BASE = "https://seems-seventh-brook-nickname.trycloudflare.com"

local VERSION = "1.0.0"
local HEARTBEAT_INTERVAL = 60

-- ==================== SERVIÇOS ====================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ==================== HTTP FUNCTIONS COMPATÍVEIS ====================
-- POST usando HttpPost (compatível com maioria dos executores)
function httpPost(url, data)
    local success, result = pcall(function()
        local encodedData = HttpService:JSONEncode(data)
        return game:HttpPost(url, encodedData, false, "application/json")
    end)
    if success and result then
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(result)
        end)
        if ok then return decoded end
    end
    return nil
end

-- GET usando HttpGet
function httpGet(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result and result ~= "" then
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(result)
        end)
        if ok then return decoded end
    end
    return nil
end

-- ==================== CARREGAMENTO DA LIB ====================
local lib = {}
local modules = {}

-- Tentar carregar lib.lua
local libLoadSuccess, libCode = pcall(function()
    return game:HttpGet(RAW .. "lib/lib.lua")
end)

if libLoadSuccess and libCode then
    local fn, err = loadstring(libCode)
    if fn then
        local execSuccess, libResult = pcall(fn)
        if execSuccess and libResult then
            lib = libResult
        end
    end
end

-- Fallback se lib não carregou
if not lib.init then
    lib = {
        init = function(config) 
            print("[288] lib iniciada (fallback) - API: " .. (config and config.apiBase or "?"))
        end,
        log = print,
        warn = warn,
        getDevice = function() 
            local uis = game:GetService("UserInputService")
            return uis.TouchEnabled and "Mobile" or "PC"
        end,
        getRankColor = function(rank)
            local colors = {
                Owner = Color3.fromRGB(255, 50, 50),
                Supervisor = Color3.fromRGB(255, 140, 0),
                Support = Color3.fromRGB(50, 150, 255),
                VIP = Color3.fromRGB(180, 0, 255),
            }
            return colors[rank] or Color3.fromRGB(80, 80, 90)
        end,
        applyCorner = function(i, r) 
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, r or 8)
            c.Parent = i
            return c
        end,
        applyStroke = function(i, c, t) 
            local s = Instance.new("UIStroke")
            s.Color = c or Color3.fromRGB(50, 50, 60)
            s.Thickness = t or 1
            s.Parent = i
            return s
        end,
        showNotification = function(gui, msg, dur, isErr)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(0, 300, 0, 40)
            f.Position = UDim2.new(0.5, -150, 1, -60)
            f.BackgroundColor3 = isErr and Color3.fromRGB(80, 30, 30) or Color3.fromRGB(30, 30, 38)
            f.Parent = gui
            lib.applyCorner(f, 8)
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, 0, 1, 0)
            l.BackgroundTransparency = 1
            l.Text = (isErr and "❌ " or "✓ ") .. msg
            l.TextColor3 = Color3.fromRGB(220, 220, 230)
            l.TextScaled = true
            l.Font = Enum.Font.Gotham
            l.Parent = f
            task.delay(dur or 3, function() if f then f:Destroy() end end)
        end,
        buildHomeFrame = function(parent, userData, apiBase)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 1, 0)
            f.BackgroundTransparency = 1
            f.Parent = parent
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -40, 0, 60)
            l.Position = UDim2.new(0, 20, 0.3, 0)
            l.BackgroundTransparency = 1
            l.Text = "288 Panel\nBem-vindo, " .. (userData and userData.username or LocalPlayer.Name)
            l.TextColor3 = Color3.new(1, 1, 1)
            l.TextScaled = true
            l.Font = Enum.Font.GothamBold
            l.Parent = f
            return f
        end,
        buildCategoryFrame = function(parent, cat, mods, userData)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 1, 0)
            f.BackgroundTransparency = 1
            f.Parent = parent
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -40, 0, 60)
            l.Position = UDim2.new(0, 20, 0.4, 0)
            l.BackgroundTransparency = 1
            l.Text = cat .. "\n🚧 Módulos em desenvolvimento..."
            l.TextColor3 = Color3.fromRGB(200, 200, 200)
            l.TextScaled = true
            l.Font = Enum.Font.Gotham
            l.Parent = f
            return f
        end,
        buildPlaceholderFrame = function(parent, name)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 1, 0)
            f.BackgroundTransparency = 1
            f.Parent = parent
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -40, 0, 60)
            l.Position = UDim2.new(0, 20, 0.4, 0)
            l.BackgroundTransparency = 1
            l.Text = name .. "\n🚧 Em breve..."
            l.TextColor3 = Color3.fromRGB(130, 130, 140)
            l.TextScaled = true
            l.Font = Enum.Font.Gotham
            l.Parent = f
            return f
        end
    }
    modules = {}
end

lib.init({ apiBase = API_BASE, version = VERSION })

-- ==================== FUNÇÕES DE REQUISIÇÃO ====================
function safeRequest(method, endpoint, body)
    local url = API_BASE .. endpoint
    
    if method == "POST" then
        if body then
            local result = httpPost(url, body)
            if result then return result end
        end
        
        -- Simular resposta se falhar
        if endpoint == "/session/start" then
            return { sessionId = "local_" .. tostring(os.time()) .. "_" .. tostring(LocalPlayer.UserId) }
        end
        return { success = true }
    end
    
    if method == "GET" then
        local result = httpGet(url)
        return result
    end
    
    return nil
end

-- ==================== SESSÃO ====================
local sessionId = nil

local function startSession()
    local res = safeRequest("POST", "/session/start", {
        userid = LocalPlayer.UserId,
        username = LocalPlayer.Name,
        version = VERSION,
        game = tostring(game.PlaceId),
        device = lib.getDevice()
    })
    
    if res and res.sessionId then
        sessionId = res.sessionId
        lib.log("Sessão iniciada: " .. sessionId)
    else
        sessionId = "local_" .. tostring(os.time()) .. "_" .. tostring(LocalPlayer.UserId)
        lib.log("Usando sessão local: " .. sessionId)
    end
end

local function heartbeat()
    if not sessionId then return end
    pcall(function()
        safeRequest("POST", "/session/heartbeat", {
            sessionId = sessionId,
            userid = LocalPlayer.UserId
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

-- Verificar usuário
local userData = httpGet(API_BASE .. "/user/" .. LocalPlayer.UserId)

if not userData then
    userData = {
        userid = LocalPlayer.UserId,
        username = LocalPlayer.Name,
        rank = "User",
        vip = false,
        banned = false
    }
    lib.log("Usando dados de usuário simulados")
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

-- Detectar saída
Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        endSession()
    end
end)

-- ==================== UI PRINCIPAL ====================
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end
task.wait(1)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "288Panel"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- MainFrame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 720, 0, 500)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

lib.applyCorner(MainFrame, 10)
lib.applyStroke(MainFrame, Color3.fromRGB(50, 50, 60), 1)

-- ==================== HEADER ====================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 56)
Header.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.25, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "288 Panel"
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = Header

-- Rainbow effect
task.spawn(function()
    local colors = {
        Color3.fromRGB(255, 60, 60),
        Color3.fromRGB(255, 140, 0),
        Color3.fromRGB(255, 240, 0),
        Color3.fromRGB(0, 255, 100),
        Color3.fromRGB(0, 200, 255),
        Color3.fromRGB(160, 0, 255)
    }
    local i = 1
    while TitleLabel and TitleLabel.Parent do
        pcall(function() TitleLabel.TextColor3 = colors[i] end)
        i = (i % #colors) + 1
        task.wait(0.18)
    end
end)

-- Rank badge
local RankLabel = Instance.new("TextLabel")
RankLabel.Size = UDim2.new(0, 100, 0, 24)
RankLabel.Position = UDim2.new(0, 12, 0.5, -12)
RankLabel.BackgroundColor3 = lib.getRankColor(userData.rank)
RankLabel.TextColor3 = Color3.new(1, 1, 1)
RankLabel.Text = userData.rank or "User"
RankLabel.TextScaled = true
RankLabel.Font = Enum.Font.GothamBold
RankLabel.Parent = Header
lib.applyCorner(RankLabel, 6)

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 60, 0, 20)
VersionLabel.Position = UDim2.new(0, 12, 1, -24)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v" .. VERSION
VersionLabel.TextColor3 = Color3.fromRGB(120, 120, 130)
VersionLabel.TextScaled = true
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -44, 0.5, -18)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
lib.applyCorner(CloseBtn, 8)
CloseBtn.MouseButton1Click:Connect(function()
    endSession()
    ScreenGui:Destroy()
end)

-- ==================== SIDEBAR ====================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 155, 1, -56)
Sidebar.Position = UDim2.new(0, 0, 0, 56)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 2)
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 6)
SidebarPadding.PaddingLeft = UDim.new(0, 6)
SidebarPadding.PaddingRight = UDim.new(0, 6)
SidebarPadding.Parent = Sidebar

-- ==================== CONTENT ====================
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -155, 1, -56)
ContentFrame.Position = UDim2.new(0, 155, 0, 56)
ContentFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- ==================== ABAS ====================
local loadedTabs = {}
local activeBtn = nil

local tabDefs = {
    { icon = "🏠", name = "Home" },
    { icon = "👑", name = "VIP", vip = true },
    { icon = "⭐", name = "Emphasis", category = "Emphasis" },
    { icon = "👤", name = "Character" },
    { icon = "🎯", name = "Target" },
    { icon = "⚔️", name = "More", category = "More" },
    { icon = "🛠️", name = "Misc", category = "Misc" },
}

local function showTab(name, tabFrame)
    for _, f in pairs(loadedTabs) do
        pcall(function() f.Visible = false end)
    end
    pcall(function() tabFrame.Visible = true end)
end

for i, tabDef in ipairs(tabDefs) do
    local isVip = tabDef.vip and not userData.vip
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 44)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    Btn.Text = tabDef.icon .. "  " .. tabDef.name
    Btn.TextColor3 = isVip and Color3.fromRGB(100, 100, 110) or Color3.fromRGB(210, 210, 215)
    Btn.TextScaled = true
    Btn.Font = Enum.Font.Gotham
    Btn.LayoutOrder = i
    Btn.Parent = Sidebar
    lib.applyCorner(Btn, 8)
    
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
            lib.showNotification(ScreenGui, "🔒 Acesso VIP necessário!", 3, true)
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
        
        local frame = nil
        if tabDef.category then
            frame = lib.buildCategoryFrame(ContentFrame, tabDef.category, modules, userData)
        elseif tabDef.name == "Home" then
            frame = lib.buildHomeFrame(ContentFrame, userData, API_BASE)
        else
            frame = lib.buildPlaceholderFrame(ContentFrame, tabDef.name)
        end
        
        loadedTabs[tabDef.name] = frame
        showTab(tabDef.name, frame)
    end)
end

-- Abrir Home por padrão
local homeFrame = lib.buildHomeFrame(ContentFrame, userData, API_BASE)
loadedTabs["Home"] = homeFrame
homeFrame.Visible = true

-- Marcar botão Home como ativo
for _, btn in ipairs(Sidebar:GetChildren()) do
    if btn:IsA("TextButton") and string.find(btn.Text, "Home") then
        activeBtn = btn
        btn.BackgroundColor3 = Color3.fromRGB(48, 48, 60)
        break
    end
end

-- ==================== TOGGLE INSERT ====================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

lib.log("[288] ✅ Painel carregado — INSERT para abrir/fechar")
