--[[
    288 Panel - Entry Point
    Carrega lib.lua e modules.lua do GitHub, renderiza UI e gerencia navegação.
    NÃO contém lógica de backend.
]]

-- ==================== CONFIGURAÇÃO ====================
local RAW = "https://raw.githubusercontent.com/Bondzinn/288-Panel/main/"
local API_BASE = "https://seems-seventh-brook-nickname.trycloudflare.com" -- Backend externo

local VERSION = "1.0.0"
local HEARTBEAT_INTERVAL = 60

-- ==================== SERVIÇOS ====================
local Players         = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local HttpService     = game:GetService("HttpService")
local LocalPlayer     = Players.LocalPlayer

-- ==================== CARREGAMENTO DA LIB ====================
local lib, modules

local ok, err = pcall(function()
    lib     = loadstring(game:HttpGet(RAW .. "lib/lib.lua"))()
    modules = loadstring(game:HttpGet(RAW .. "lib/modules.lua"))()
end)

if not ok then
    warn("[288] Falha ao carregar lib: " .. tostring(err))
    return
end

lib.init({ apiBase = API_BASE, version = VERSION })

-- ==================== SESSÃO ====================
local sessionId = nil

local function startSession()
    local res = lib.request("POST", "/session/start", {
        userid   = LocalPlayer.UserId,
        username = LocalPlayer.Name,
        version  = VERSION,
        game     = tostring(game.PlaceId),
        device   = lib.getDevice()
    })
    if res and res.sessionId then
        sessionId = res.sessionId
        lib.log("Sessão iniciada: " .. sessionId)
    end
end

local function heartbeat()
    if not sessionId then return end
    lib.request("POST", "/session/heartbeat", {
        sessionId = sessionId,
        userid    = LocalPlayer.UserId
    })
end

local function endSession()
    if not sessionId then return end
    lib.request("POST", "/session/end", { sessionId = sessionId })
end

-- Verifica usuário e blacklist
local userData = lib.request("GET", "/user/" .. LocalPlayer.UserId)
if not userData then
    warn("[288] Falha ao verificar usuário.")
    return
end

if userData.banned then
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

-- Encerrar sessão ao sair
game:BindToClose(endSession)
LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer.Parent then endSession() end
end)

-- ==================== UI PRINCIPAL ====================
task.wait(2)
repeat task.wait() until LocalPlayer.Character

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

lib.applyCorner(MainFrame, 10)
lib.applyStroke(MainFrame, Color3.fromRGB(50, 50, 60), 1)

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
        TitleLabel.TextColor3 = colors[i]
        i = (i % #colors) + 1
        task.wait(0.18)
    end
end)

-- Rank badge no header
local RankLabel = Instance.new("TextLabel")
RankLabel.Size              = UDim2.new(0, 100, 0, 24)
RankLabel.Position          = UDim2.new(0, 12, 0.5, -12)
RankLabel.BackgroundColor3  = lib.getRankColor(userData.rank)
RankLabel.TextColor3        = Color3.new(1,1,1)
RankLabel.Text              = userData.rank or "User"
RankLabel.TextScaled        = true
RankLabel.Font              = Enum.Font.GothamBold
RankLabel.Parent            = Header
lib.applyCorner(RankLabel, 6)

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
lib.applyCorner(CloseBtn, 8)
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
local loadedTabs  = {}  -- cache de frames já carregados
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
        f.Visible = false
    end
    tabFrame.Visible = true
end

local function createTabButton(tabDef, order)
    local isVip = tabDef.vip and not userData.vip

    local Btn = Instance.new("TextButton")
    Btn.Size             = UDim2.new(1, 0, 0, 44)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    Btn.Text             = tabDef.icon .. "  " .. tabDef.name
    Btn.TextColor3       = isVip and Color3.fromRGB(100,100,110) or Color3.fromRGB(210, 210, 215)
    Btn.TextScaled       = true
    Btn.Font             = Enum.Font.Gotham
    Btn.LayoutOrder      = order
    Btn.Parent           = Sidebar
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
        -- VIP gate
        if isVip then
            lib.showNotification(ScreenGui, "🔒 Acesso VIP necessário!")
            return
        end

        if activeBtn then activeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32) end
        activeBtn = Btn
        Btn.BackgroundColor3 = Color3.fromRGB(48, 48, 60)

        -- Lazy load
        if loadedTabs[tabDef.name] then
            showTab(tabDef.name, loadedTabs[tabDef.name])
            return
        end

        -- Carregar aba
        if tabDef.category then
            -- Carrega todos os módulos da categoria via modules.lua
            local frame = lib.buildCategoryFrame(ContentFrame, tabDef.category, modules, userData)
            loadedTabs[tabDef.name] = frame
            showTab(tabDef.name, frame)
        elseif tabDef.name == "Home" then
            local frame = lib.buildHomeFrame(ContentFrame, userData, API_BASE)
            loadedTabs[tabDef.name] = frame
            showTab(tabDef.name, frame)
        else
            local frame = lib.buildPlaceholderFrame(ContentFrame, tabDef.name)
            loadedTabs[tabDef.name] = frame
            showTab(tabDef.name, frame)
        end
    end)

    return Btn
end

for i, def in ipairs(tabDefs) do
    createTabButton(def, i)
end

-- Abrir Home por padrão
do
    local homeFrame = lib.buildHomeFrame(ContentFrame, userData, API_BASE)
    loadedTabs["Home"] = homeFrame
    homeFrame.Visible = true
    -- Marcar botão Home como ativo
    local firstBtn = Sidebar:GetChildren()[1]
    if firstBtn and firstBtn:IsA("TextButton") then
        activeBtn = firstBtn
        firstBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 60)
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
