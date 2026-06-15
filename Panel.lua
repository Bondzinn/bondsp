--[[
    288 Panel
    Versão Completa - UI + Gerenciador de Módulos
    Hotkey: B
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== CONFIG ====================
local PANEL_VERSION = "1.0.0"
local API_BASE = "http://localhost:3000"  -- Altere conforme necessário
local GITHUB_RAW = "https://raw.githubusercontent.com/Bondzinn/288/main"  -- Substitua pelo repo real

-- ==================== CRIAR GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "288Panel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 720, 0, 500)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UI Corner global
local function applyCorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = obj
end

applyCorner(MainFrame, 12)

-- ==================== HEADER ====================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
applyCorner(Header, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.25, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "288 Panel"
TitleLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = Header

-- Rainbow Effect
spawn(function()
    local colors = {
        Color3.fromRGB(255, 60, 60),
        Color3.fromRGB(255, 140, 0),
        Color3.fromRGB(255, 240, 0),
        Color3.fromRGB(0, 255, 100),
        Color3.fromRGB(0, 200, 255)
    }
    local i = 1
    while TitleLabel.Parent do
        TitleLabel.TextColor3 = colors[i]
        i = (i % #colors) + 1
        wait(0.12)
    end
end)

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Name = "Version"
VersionLabel.Size = UDim2.new(0, 100, 1, 0)
VersionLabel.Position = UDim2.new(0, 20, 0, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v" .. PANEL_VERSION
VersionLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
VersionLabel.TextScaled = true
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
applyCorner(CloseBtn, 8)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ==================== SIDEBAR ====================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 4)
SidebarList.Parent = Sidebar

-- ==================== CONTENT FRAME ====================
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -160, 1, -60)
ContentFrame.Position = UDim2.new(0, 160, 0, 60)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame
applyCorner(ContentFrame, 12)

-- ==================== TABS ====================
local Tabs = {}
local CurrentTab = "Home"

local function CreateTab(name, isVIP)
    local tab = Instance.new("Frame")
    tab.Name = name .. "Frame"
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.BackgroundTransparency = 1
    tab.Visible = (name == "Home")
    tab.Parent = ContentFrame
    Tabs[name] = tab
    return tab
end

local HomeFrame = CreateTab("Home")
local VIPFrame = CreateTab("VIP")
local EmphasisFrame = CreateTab("Emphasis")
local CharacterFrame = CreateTab("Character")
local TargetFrame = CreateTab("Target")
local MoreFrame = CreateTab("More")
local MiscFrame = CreateTab("Misc")
local ServersFrame = CreateTab("Servers")

-- ==================== SIDEBAR BUTTONS ====================
local tabButtons = {}

local function CreateSidebarButton(name, isVIPLocked)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 46)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.Text = name
    btn.TextColor3 = isVIPLocked and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(230, 230, 230)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = Sidebar
    applyCorner(btn, 6)

    if isVIPLocked then
        btn.Text = name .. " [VIP]"
    end

    btn.MouseButton1Click:Connect(function()
        for _, frame in pairs(Tabs) do
            frame.Visible = false
        end
        if Tabs[name] then
            Tabs[name].Visible = true
        end
        CurrentTab = name

        -- Hover effect
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        wait(0.2)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
    end)

    tabButtons[name] = btn
    return btn
end

CreateSidebarButton("Home")
CreateSidebarButton("VIP", true)
CreateSidebarButton("Emphasis")
CreateSidebarButton("Character")
CreateSidebarButton("Target")
CreateSidebarButton("More")
CreateSidebarButton("Misc")
CreateSidebarButton("Servers")

-- ==================== HOME TAB ====================
local AvatarLabel = Instance.new("ImageLabel")
AvatarLabel.Size = UDim2.new(0, 110, 0, 110)
AvatarLabel.Position = UDim2.new(0.5, -55, 0, 30)
AvatarLabel.BackgroundTransparency = 1
AvatarLabel.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
AvatarLabel.Parent = HomeFrame
applyCorner(AvatarLabel, 999)

local DisplayNameLabel = Instance.new("TextLabel")
DisplayNameLabel.Size = UDim2.new(1, 0, 0, 30)
DisplayNameLabel.Position = UDim2.new(0, 0, 0, 160)
DisplayNameLabel.BackgroundTransparency = 1
DisplayNameLabel.Text = LocalPlayer.DisplayName
DisplayNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DisplayNameLabel.TextScaled = true
DisplayNameLabel.Font = Enum.Font.GothamBold
DisplayNameLabel.Parent = HomeFrame

local UserInfo = Instance.new("TextLabel")
UserInfo.Size = UDim2.new(1, -40, 0, 100)
UserInfo.Position = UDim2.new(0, 20, 0, 200)
UserInfo.BackgroundTransparency = 1
UserInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
UserInfo.TextScaled = true
UserInfo.Font = Enum.Font.Gotham
UserInfo.TextWrapped = true
UserInfo.Parent = HomeFrame

spawn(function()
    while wait(2) do
        local ping = (LocalPlayer:GetPing and LocalPlayer:GetPing()) or 0
        UserInfo.Text = string.format("UserId: %d\nPing: %d ms\nVersão: %s", LocalPlayer.UserId, math.floor(ping), PANEL_VERSION)
    end
end)

-- ==================== EMPHASIS TAB ====================
local EmphasisScroll = Instance.new("ScrollingFrame")
EmphasisScroll.Size = UDim2.new(1, -20, 1, -20)
EmphasisScroll.Position = UDim2.new(0, 10, 0, 10)
EmphasisScroll.BackgroundTransparency = 1
EmphasisScroll.ScrollBarThickness = 6
EmphasisScroll.Parent = EmphasisFrame

local EmphasisGrid = Instance.new("UIGridLayout")
EmphasisGrid.CellSize = UDim2.new(0.48, 0, 0, 55)
EmphasisGrid.CellPadding = UDim2.new(0, 10, 0, 10)
EmphasisGrid.Parent = EmphasisScroll

local emphasisModules = {}

local function CreateModuleButton(parent, moduleName, moduleTable)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = moduleName
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    applyCorner(btn, 8)

    local stateLabel = Instance.new("TextLabel")
    stateLabel.Size = UDim2.new(0, 60, 0, 20)
    stateLabel.Position = UDim2.new(1, -70, 0.5, -10)
    stateLabel.BackgroundTransparency = 1
    stateLabel.Text = "OFF"
    stateLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
    stateLabel.TextScaled = true
    stateLabel.Font = Enum.Font.GothamBold
    stateLabel.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if moduleTable.Toggle then
            moduleTable.Enabled = not moduleTable.Enabled
            if moduleTable.Enabled then
                pcall(moduleTable.Enable)
                stateLabel.Text = "ON"
                stateLabel.TextColor3 = Color3.fromRGB(50, 200, 50)
                btn.BackgroundColor3 = Color3.fromRGB(45, 85, 45)
            else
                pcall(moduleTable.Disable)
                stateLabel.Text = "OFF"
                stateLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end
        end
    end)

    return btn
end

local function LoadEmphasisModules()
    for _, child in pairs(EmphasisScroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then child:Destroy() end
    end

    local modulesList = {"Invisible", "ClickTP", "NoClip", "JerkOff", "Impulse", "Facebang", "Spin", "AnimeSpeed", "feFlip", "Flashback", "AntiVoid"}

    for _, modName in ipairs(modulesList) do
        local success, module = pcall(function()
            local url = GITHUB_RAW .. "/modules/Emphasis/" .. modName .. ".lua"
            local code = HttpService:GetAsync(url)
            return loadstring(code)()
        end)

        if success and module then
            local container = Instance.new("Frame")
            container.BackgroundTransparency = 1
            container.Parent = EmphasisScroll
            CreateModuleButton(container, modName, module)
            table.insert(emphasisModules, module)
        else
            warn("Falha ao carregar módulo Emphasis: " .. modName)
        end
    end
end

-- ==================== MORE TAB ====================
local MoreScroll = Instance.new("ScrollingFrame")
MoreScroll.Size = UDim2.new(1, -20, 1, -20)
MoreScroll.Position = UDim2.new(0, 10, 0, 10)
MoreScroll.BackgroundTransparency = 1
MoreScroll.ScrollBarThickness = 6
MoreScroll.Parent = MoreFrame

local MoreGrid = Instance.new("UIGridLayout")
MoreGrid.CellSize = UDim2.new(0.48, 0, 0, 55)
MoreGrid.CellPadding = UDim2.new(0, 10, 0, 10)
MoreGrid.Parent = MoreScroll

local function LoadMoreModules()
    local modulesList = {"ESP", "Aimbot"}
    for _, modName in ipairs(modulesList) do
        local success, module = pcall(function()
            local url = GITHUB_RAW .. "/modules/More/" .. modName .. ".lua"
            local code = HttpService:GetAsync(url)
            return loadstring(code)()
        end)

        if success and module then
            local container = Instance.new("Frame")
            container.BackgroundTransparency = 1
            container.Parent = MoreScroll
            CreateModuleButton(container, modName, module)
        end
    end
end

-- ==================== CHARACTER TAB ====================
local CharacterScroll = Instance.new("ScrollingFrame")
CharacterScroll.Size = UDim2.new(1, -20, 1, -20)
CharacterScroll.Position = UDim2.new(0, 10, 0, 10)
CharacterScroll.BackgroundTransparency = 1
CharacterScroll.ScrollBarThickness = 6
CharacterScroll.Parent = CharacterFrame

local CharGrid = Instance.new("UIGridLayout")
CharGrid.CellSize = UDim2.new(0.48, 0, 0, 80)
CharGrid.CellPadding = UDim2.new(0, 15, 0, 15)
CharGrid.Parent = CharacterScroll

local function CreateCharacterCard(title, defaultValue)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    card.Parent = CharacterScroll
    applyCorner(card, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Parent = card

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.6, 0, 0, 30)
    input.Position = UDim2.new(0.05, 0, 0.45, 0)
    input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    input.Text = tostring(defaultValue)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Font = Enum.Font.Gotham
    input.TextScaled = true
    input.Parent = card
    applyCorner(input, 6)

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.3, 0, 0, 30)
    toggleBtn.Position = UDim2.new(0.65, 0, 0.45, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = card
    applyCorner(toggleBtn, 6)

    return input, toggleBtn
end

local wsInput, wsToggle = CreateCharacterCard("WalkSpeed", 16)
local jpInput, jpToggle = CreateCharacterCard("JumpPower", 50)
local flyInput, flyToggle = CreateCharacterCard("Fly Speed", 50)

-- ==================== TARGET TAB ====================
local TargetSearch = Instance.new("TextBox")
TargetSearch.Size = UDim2.new(1, -40, 0, 40)
TargetSearch.Position = UDim2.new(0, 20, 0, 20)
TargetSearch.PlaceholderText = "Digite um username..."
TargetSearch.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TargetSearch.TextColor3 = Color3.new(1,1,1)
TargetSearch.Parent = TargetFrame
applyCorner(TargetSearch, 8)

local TargetResults = Instance.new("ScrollingFrame")
TargetResults.Size = UDim2.new(1, -40, 0, 140)
TargetResults.Position = UDim2.new(0, 20, 0, 80)
TargetResults.BackgroundTransparency = 1
TargetResults.ScrollBarThickness = 6
TargetResults.Parent = TargetFrame

local ResultsList = Instance.new("UIListLayout")
ResultsList.Padding = UDim.new(0, 6)
ResultsList.Parent = TargetResults

-- ==================== TARGET ACTIONS ====================
local ActionsScroll = Instance.new("ScrollingFrame")
ActionsScroll.Size = UDim2.new(1, -40, 1, -280)
ActionsScroll.Position = UDim2.new(0, 20, 0, 240)
ActionsScroll.BackgroundTransparency = 1
ActionsScroll.ScrollBarThickness = 6
ActionsScroll.Parent = TargetFrame

local ActionsGrid = Instance.new("UIGridLayout")
ActionsGrid.CellSize = UDim2.new(0.48, 0, 0, 50)
ActionsGrid.CellPadding = UDim2.new(0, 12, 0, 12)
ActionsGrid.Parent = ActionsScroll

local actions = {"View", "Copy ID", "Focus", "Follow", "Stand", "Bang", "Drag", "Headsit", "Doggy", "Backpack", "Bring", "Teleport"}

for _, act in ipairs(actions) do
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = act
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = ActionsScroll
    applyCorner(btn, 8)
end

-- ==================== MISC TAB ====================
local MiscScroll = Instance.new("ScrollingFrame")
MiscScroll.Size = UDim2.new(1, -20, 1, -20)
MiscScroll.Position = UDim2.new(0, 10, 0, 10)
MiscScroll.BackgroundTransparency = 1
MiscScroll.Parent = MiscFrame

local MiscGrid = Instance.new("UIGridLayout")
MiscGrid.CellSize = UDim2.new(0.48, 0, 0, 60)
MiscGrid.CellPadding = UDim2.new(0, 15, 0, 15)
MiscGrid.Parent = MiscScroll

local antiAFKBtn = Instance.new("TextButton")
antiAFKBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
antiAFKBtn.Text = "Anti AFK"
antiAFKBtn.TextColor3 = Color3.new(1,1,1)
antiAFKBtn.TextScaled = true
antiAFKBtn.Parent = MiscScroll
applyCorner(antiAFKBtn, 8)

local rejoinBtn = Instance.new("TextButton")
rejoinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
rejoinBtn.Text = "Rejoin"
rejoinBtn.TextColor3 = Color3.new(1,1,1)
rejoinBtn.TextScaled = true
rejoinBtn.Parent = MiscScroll
applyCorner(rejoinBtn, 8)

-- ==================== SERVERS TAB ====================
local ServersScroll = Instance.new("ScrollingFrame")
ServersScroll.Size = UDim2.new(1, -20, 1, -20)
ServersScroll.Position = UDim2.new(0, 10, 0, 10)
ServersScroll.BackgroundTransparency = 1
ServersScroll.Parent = ServersFrame

local ServersList = Instance.new("UIListLayout")
ServersList.Padding = UDim.new(0, 8)
ServersList.Parent = ServersScroll

-- ==================== KEYBINDS ====================
local keybinds = {
    [Enum.KeyCode.E] = "ESP",
    [Enum.KeyCode.F] = "Aimbot",
    [Enum.KeyCode.N] = "NoClip",
    [Enum.KeyCode.R] = "JerkOff",
    [Enum.KeyCode.Z] = "Facebang",
    [Enum.KeyCode.V] = "Flashback",
    [Enum.KeyCode.G] = "AntiVoid",
}

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if keybinds[input.KeyCode] then
        -- Aqui você pode disparar toggle dos módulos carregados
        print("Keybind ativado: " .. keybinds[input.KeyCode])
    end
end)

-- ==================== TOGGLE PANEL ====================
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.B then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- ==================== INICIALIZAÇÃO ====================
LoadEmphasisModules()
LoadMoreModules()

print("✅ 288 Panel carregado com sucesso!")
print("Pressione B para abrir/fechar o painel.")

-- Exemplo de chamada API (pode ser expandido)
local function FetchServers()
    pcall(function()
        local response = HttpService:GetAsync(API_BASE .. "/servers")
        -- Parse e popular ServersScroll
    end)
end

FetchServers()
