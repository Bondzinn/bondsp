--[[
    288 Panel - 288 Panel
    UI completa — scripts carregados da API/GitHub
    Estrutura:
        288/
            Panel.lua         ← este arquivo
            lib/
                lib.lua
                modules.lua
            modules/
                Emphasis/...
                More/...
]]

-- ==================== SETUP ====================
local Players         = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local TweenService    = game:GetService("TweenService")
local HttpService     = game:GetService("HttpService")
local LocalPlayer     = Players.LocalPlayer

-- Configuração da API
local API_BASE = "https://milk-three-bones-adrian.trycloudflare.com" -- trocar pela URL real

-- GitHub raw base
local GITHUB_RAW = "https://raw.githubusercontent.com/Bondzinn/bondsp/refs/heads/main"

local VERSION = "v1.0.0"

-- ==================== HELPERS ====================
local function safeLoadstring(url)
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and res and res ~= "" then
        local fn, err = loadstring(res)
        if fn then
            return fn
        else
            warn("[288] Erro ao compilar " .. url .. ": " .. tostring(err))
        end
    else
        warn("[288] Erro ao buscar " .. url)
    end
    return nil
end

local function loadModule(path)
    local url = GITHUB_RAW .. "/" .. path
    local fn = safeLoadstring(url)
    if fn then
        local ok2, err2 = pcall(fn)
        if not ok2 then
            warn("[288] Erro ao executar módulo " .. path .. ": " .. tostring(err2))
        end
    end
end

local function apiGet(endpoint)
    local ok, res = pcall(function()
        return game:HttpGet(API_BASE .. endpoint)
    end)
    if ok and res then
        local ok2, data = pcall(function() return HttpService:JSONDecode(res) end)
        if ok2 then return data end
    end
    return nil
end

local function apiPost(endpoint, body)
    local ok, res = pcall(function()
        return HttpService:PostAsync(
            API_BASE .. endpoint,
            HttpService:JSONEncode(body),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    if ok and res then
        local ok2, data = pcall(function() return HttpService:JSONDecode(res) end)
        if ok2 then return data end
    end
    return nil
end

-- ==================== GUI ====================
-- Destruir panel antigo se existir
if LocalPlayer.PlayerGui:FindFirstChild("288Panel") then
    LocalPlayer.PlayerGui["288Panel"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "288Panel"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== MAIN FRAME ====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 380)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Sombra leve na borda
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 60)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Background image (watermark "PANEL")
local BgLabel = Instance.new("ImageLabel")
BgLabel.Size = UDim2.new(1, 0, 1, 0)
BgLabel.Position = UDim2.new(0, 0, 0, 0)
BgLabel.BackgroundTransparency = 1
BgLabel.Image = "rbxassetid://13286350915" -- imagem escura genérica; trocar por asset real
BgLabel.ImageTransparency = 0.82
BgLabel.ScaleType = Enum.ScaleType.Crop
BgLabel.ZIndex = 0
BgLabel.Parent = MainFrame

-- ==================== HEADER ====================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Header.BorderSizePixel = 0
Header.ZIndex = 2
Header.Parent = MainFrame

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 70, 1, 0)
VersionLabel.Position = UDim2.new(0, 8, 0, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = VERSION
VersionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
VersionLabel.TextSize = 13
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.ZIndex = 3
VersionLabel.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.25, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "288 Panel"
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.ZIndex = 3
TitleLabel.Parent = Header

-- Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 4
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ==================== SIDEBAR ====================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 108, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 2
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 0)
SidebarLayout.Parent = Sidebar

-- ==================== CONTENT ====================
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -108, 1, -42)
ContentFrame.Position = UDim2.new(0, 108, 0, 42)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.BackgroundTransparency = 0.15
ContentFrame.BorderSizePixel = 0
ContentFrame.ZIndex = 1
ContentFrame.Parent = MainFrame

-- ==================== TABS TABLE ====================
local Tabs = {}
local CurrentTab = nil

local TABS_DEF = {
    { name = "Home",       layoutOrder = 1 },
    { name = "VIP",        layoutOrder = 2 },
    { name = "Emphasis",   layoutOrder = 3 },
    { name = "Character",  layoutOrder = 4 },
    { name = "Target",     layoutOrder = 5 },
    { name = "Animations", layoutOrder = 6 },
    { name = "More",       layoutOrder = 7 },
    { name = "Misc",       layoutOrder = 8 },
    { name = "Servers",    layoutOrder = 9 },
    { name = "About",      layoutOrder = 10 },
}

local function setTab(name)
    if CurrentTab == name then return end
    CurrentTab = name
    for _, t in pairs(Tabs) do
        t.frame.Visible = (t.name == name)
        t.btn.BackgroundColor3 = (t.name == name)
            and Color3.fromRGB(45, 45, 45)
            or  Color3.fromRGB(20, 20, 20)
        t.btn.TextColor3 = (t.name == name)
            and Color3.fromRGB(255, 255, 255)
            or  Color3.fromRGB(190, 190, 190)
    end
end

-- Cria botão de sidebar + frame de conteúdo para cada tab
for _, def in ipairs(TABS_DEF) do
    -- Botão
    local btn = Instance.new("TextButton")
    btn.Name = def.name .. "Btn"
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel = 0
    btn.Text = def.name
    btn.TextColor3 = Color3.fromRGB(190, 190, 190)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.LayoutOrder = def.layoutOrder
    btn.ZIndex = 3
    btn.Parent = Sidebar

    -- Linha separadora
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 1)
    sep.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    sep.BorderSizePixel = 0
    sep.ZIndex = 3
    sep.Parent = btn

    -- Frame de conteúdo
    local frame = Instance.new("Frame")
    frame.Name = def.name .. "Frame"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.ZIndex = 2
    frame.Parent = ContentFrame

    Tabs[def.name] = { name = def.name, btn = btn, frame = frame }

    btn.MouseButton1Click:Connect(function()
        setTab(def.name)
    end)
end

-- ==================== UTILS DE UI ====================
local function makeButton(parent, text, x, y, w, h, vipOnly)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, w or 120, 0, h or 32)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.ZIndex = 4
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    -- Indicador VIP (asterisco vermelho)
    if vipOnly then
        local star = Instance.new("TextLabel")
        star.Size = UDim2.new(0, 14, 0, 14)
        star.Position = UDim2.new(1, -2, 0, -2)
        star.BackgroundTransparency = 1
        star.Text = "✦"
        star.TextColor3 = Color3.fromRGB(220, 50, 50)
        star.TextSize = 11
        star.Font = Enum.Font.GothamBold
        star.ZIndex = 5
        star.Parent = btn
    end

    return btn
end

local function makeSectionLabel(parent, text, x, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -x, 0, 20)
    lbl.Position = UDim2.new(0, x, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(160, 160, 160)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 4
    lbl.Parent = parent
    return lbl
end

local function makeInput(parent, placeholder, x, y, w, h)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, w or 120, 0, h or 30)
    box.Position = UDim2.new(0, x, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    box.BorderSizePixel = 0
    box.Text = ""
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    box.TextColor3 = Color3.fromRGB(230, 230, 230)
    box.TextSize = 12
    box.Font = Enum.Font.Gotham
    box.ZIndex = 4
    box.Parent = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    return box
end

-- Toggle state tracker
local toggleStates = {}
local function makeToggleButton(parent, text, x, y, w, h, vipOnly)
    local btn = makeButton(parent, text, x, y, w, h, vipOnly)
    toggleStates[btn] = false
    btn.MouseButton1Click:Connect(function()
        toggleStates[btn] = not toggleStates[btn]
        btn.BackgroundColor3 = toggleStates[btn]
            and Color3.fromRGB(60, 60, 60)
            or  Color3.fromRGB(38, 38, 38)
    end)
    return btn
end

-- ==================== HOME TAB ====================
do
    local f = Tabs["Home"].frame

    -- Avatar
    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.new(0, 90, 0, 90)
    avatarImg.Position = UDim2.new(0, 10, 0, 8)
    avatarImg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    avatarImg.BorderSizePixel = 0
    avatarImg.Image = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.AvatarBust,
        Enum.ThumbnailSize.Size420x420
    )
    avatarImg.ZIndex = 4
    avatarImg.Parent = f
    Instance.new("UIStroke", avatarImg).Color = Color3.fromRGB(70, 70, 70)

    -- Greeting
    local greetLabel = Instance.new("TextLabel")
    greetLabel.Size = UDim2.new(1, -115, 0, 30)
    greetLabel.Position = UDim2.new(0, 108, 0, 12)
    greetLabel.BackgroundTransparency = 1
    greetLabel.Text = "Olá! 288."
    greetLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    greetLabel.TextSize = 14
    greetLabel.Font = Enum.Font.GothamBold
    greetLabel.TextXAlignment = Enum.TextXAlignment.Left
    greetLabel.ZIndex = 4
    greetLabel.Parent = f

    -- Key hint
    local hintLabel = Instance.new("TextLabel")
    hintLabel.Size = UDim2.new(1, -115, 0, 40)
    hintLabel.Position = UDim2.new(0, 108, 0, 40)
    hintLabel.BackgroundTransparency = 1
    hintLabel.Text = "Pressione [B] para\nabrir/fechar o painel"
    hintLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    hintLabel.TextSize = 12
    hintLabel.Font = Enum.Font.Gotham
    hintLabel.TextXAlignment = Enum.TextXAlignment.Left
    hintLabel.TextWrapped = true
    hintLabel.ZIndex = 4
    hintLabel.Parent = f

    -- Ping label (verde)
    local pingLabel = Instance.new("TextLabel")
    pingLabel.Size = UDim2.new(1, -20, 0, 22)
    pingLabel.Position = UDim2.new(0, 10, 0, 108)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "Ping: --ms"
    pingLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    pingLabel.TextSize = 13
    pingLabel.Font = Enum.Font.Gotham
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left
    pingLabel.ZIndex = 4
    pingLabel.Parent = f

    -- Ping value colorido
    local pingVal = Instance.new("TextLabel")
    pingVal.Size = UDim2.new(0, 60, 1, 0)
    pingVal.Position = UDim2.new(0, 38, 0, 0)
    pingVal.BackgroundTransparency = 1
    pingVal.Text = "--ms"
    pingVal.TextColor3 = Color3.fromRGB(80, 220, 80)
    pingVal.TextSize = 13
    pingVal.Font = Enum.Font.GothamBold
    pingVal.TextXAlignment = Enum.TextXAlignment.Left
    pingVal.ZIndex = 5
    pingVal.Parent = pingLabel

    -- Substitui "Ping: --ms" para só ter "Ping: "
    pingLabel.Text = "Ping: "

    -- Online
    local onlineLabel = Instance.new("TextLabel")
    onlineLabel.Size = UDim2.new(1, -20, 0, 20)
    onlineLabel.Position = UDim2.new(0, 10, 0, 136)
    onlineLabel.BackgroundTransparency = 1
    onlineLabel.Text = "Online: --"
    onlineLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    onlineLabel.TextSize = 12
    onlineLabel.Font = Enum.Font.Gotham
    onlineLabel.TextXAlignment = Enum.TextXAlignment.Left
    onlineLabel.ZIndex = 4
    onlineLabel.Parent = f

    -- Users
    local usersLabel = Instance.new("TextLabel")
    usersLabel.Size = UDim2.new(1, -20, 0, 20)
    usersLabel.Position = UDim2.new(0, 10, 0, 158)
    usersLabel.BackgroundTransparency = 1
    usersLabel.Text = "Users: --"
    usersLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    usersLabel.TextSize = 12
    usersLabel.Font = Enum.Font.Gotham
    usersLabel.TextXAlignment = Enum.TextXAlignment.Left
    usersLabel.ZIndex = 4
    usersLabel.Parent = f

    -- Date
    local dateLabel = Instance.new("TextLabel")
    dateLabel.Size = UDim2.new(1, -20, 0, 20)
    dateLabel.Position = UDim2.new(0, 10, 0, 184)
    dateLabel.BackgroundTransparency = 1
    dateLabel.Text = "Date: --"
    dateLabel.TextColor3 = Color3.fromRGB(80, 180, 255)
    dateLabel.TextSize = 12
    dateLabel.Font = Enum.Font.Gotham
    dateLabel.TextXAlignment = Enum.TextXAlignment.Left
    dateLabel.ZIndex = 4
    dateLabel.Parent = f

    -- Atualiza ping e stats
    spawn(function()
        while wait(3) do
            if not ScreenGui.Parent then break end

            -- Ping
            local ping = LocalPlayer:GetPing() or 0
            pingVal.Text = math.floor(ping) .. "ms"
            pingVal.TextColor3 = ping < 80
                and Color3.fromRGB(80, 220, 80)
                or ping < 150
                    and Color3.fromRGB(255, 200, 50)
                    or Color3.fromRGB(220, 60, 60)

            -- Stats da API
            local stats = apiGet("/stats")
            if stats then
                onlineLabel.Text = "Online: " .. tostring(stats.online or "--")
                usersLabel.Text = "Users: " .. tostring(stats.totalUsers or "--")
            end

            -- Data/hora local
            local t = os.date("*t")
            dateLabel.Text = string.format("Date: %02d/%02d/%04d - %02d:%02d",
                t.day, t.month, t.year, t.hour, t.min)
        end
    end)
end

-- ==================== VIP TAB ====================
do
    local f = Tabs["VIP"].frame

    -- Grid de botões bloqueados (desfocados)
    local vipButtons = {
        {"Fling", 10, 10}, {"AntiFling", 140, 10, true},
        {"AntiForce", 10, 50}, {"AntiChatSpy", 140, 50, true},
        {"AutoSacrifice", 10, 90}, {"EscapeHandcuffs", 140, 90},
        {"AutoParry", 10, 130}, {"ButterflyFarm", 140, 130},
        {"EggCollect", 10, 170},
    }

    for _, v in ipairs(vipButtons) do
        local btn = makeButton(f, v[1], v[2], v[3], 120, 32, v[4])
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        btn.TextColor3 = Color3.fromRGB(120, 120, 120)
        btn.TextTransparency = 0.3
    end

    -- Overlay VIP
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    overlay.BackgroundTransparency = 0.35
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 6
    overlay.Parent = f

    local vipTitle = Instance.new("TextLabel")
    vipTitle.Size = UDim2.new(1, 0, 0, 40)
    vipTitle.Position = UDim2.new(0, 0, 0.35, 0)
    vipTitle.BackgroundTransparency = 1
    vipTitle.Text = "ADQUIRIR VIP"
    vipTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
    vipTitle.TextSize = 22
    vipTitle.Font = Enum.Font.GothamBold
    vipTitle.TextXAlignment = Enum.TextXAlignment.Center
    vipTitle.ZIndex = 7
    vipTitle.Parent = overlay

    local vipLink = Instance.new("TextLabel")
    vipLink.Size = UDim2.new(1, 0, 0, 24)
    vipLink.Position = UDim2.new(0, 0, 0.35, 44)
    vipLink.BackgroundTransparency = 1
    vipLink.Text = "ACESSE: https://discord.gg/288s"
    vipLink.TextColor3 = Color3.fromRGB(200, 200, 200)
    vipLink.TextSize = 13
    vipLink.Font = Enum.Font.Gotham
    vipLink.TextXAlignment = Enum.TextXAlignment.Center
    vipLink.ZIndex = 7
    vipLink.Parent = overlay
end

-- ==================== EMPHASIS TAB ====================
do
    local f = Tabs["Emphasis"].frame

    -- Layout: 2 colunas, cada botão chama módulo do GitHub
    local emphasisButtons = {
        {name="Invisible",  col=0, row=0},
        {name="ClickTP",    col=1, row=0},
        {name="NoClip",     col=0, row=1},
        {name="JerkOff",    col=1, row=1},
        {name="Impulse",    col=0, row=2},
        {name="FaceBang",   col=1, row=2},
        {name="Spin",       col=0, row=3},
        {name="AnimSpeed",  col=1, row=3},
        {name="feFlip",     col=0, row=4},
        {name="Flashback",  col=1, row=4},
        {name="AntiVoid",   col=0, row=5, wide=true},
    }

    for _, v in ipairs(emphasisButtons) do
        local W = v.wide and 258 or 120
        local x = v.wide and 10 or (v.col == 0 and 10 or 140)
        local y = v.row * 44 + 10
        local btn = makeToggleButton(f, v.name, x, y, W, 34)
        btn.MouseButton1Click:Connect(function()
            loadModule("modules/Emphasis/" .. v.name .. ".lua")
        end)
    end
end

-- ==================== CHARACTER TAB ====================
do
    local f = Tabs["Character"].frame

    -- Walk Speed
    local wsBtn = makeButton(f, "Walk Speed", 10, 10, 160, 34)
    local wsStar = Instance.new("TextLabel")
    wsStar.Size = UDim2.new(0, 20, 0, 20)
    wsStar.Position = UDim2.new(0, 178, 0, 21)
    wsStar.BackgroundTransparency = 1
    wsStar.Text = "✦"
    wsStar.TextColor3 = Color3.fromRGB(220, 50, 50)
    wsStar.TextSize = 14
    wsStar.Font = Enum.Font.GothamBold
    wsStar.ZIndex = 4
    wsStar.Parent = f

    local wsInput = makeInput(f, "[0 - n]", 200, 14, 80, 26)

    -- Jump Power
    local jpBtn = makeButton(f, "Jump Power", 10, 56, 160, 34)
    local jpStar = wsStar:Clone()
    jpStar.Position = UDim2.new(0, 178, 0, 67)
    jpStar.Parent = f
    local jpInput = makeInput(f, "[0 - n]", 200, 60, 80, 26)

    -- Fly
    local flyBtn = makeButton(f, "Fly", 10, 102, 160, 34)
    local flyStar = wsStar:Clone()
    flyStar.Position = UDim2.new(0, 178, 0, 113)
    flyStar.Parent = f
    local flyInput = makeInput(f, "[0 - n]", 200, 106, 80, 26)

    -- Respawn + Checkpoint
    local respawnBtn = makeButton(f, "Respawn", 10, 162, 120, 34)
    local ckBtn = makeButton(f, "Checkpoint", 148, 162, 120, 34, true)

    -- Handlers
    wsBtn.MouseButton1Click:Connect(function()
        local val = tonumber(wsInput.Text)
        if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end)
    jpBtn.MouseButton1Click:Connect(function()
        local val = tonumber(jpInput.Text)
        if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = val
        end
    end)
    flyBtn.MouseButton1Click:Connect(function()
        loadModule("modules/Emphasis/Fly.lua")
    end)
    respawnBtn.MouseButton1Click:Connect(function()
        LocalPlayer.Character:BreakJoints()
    end)
end

-- ==================== TARGET TAB ====================
do
    local f = Tabs["Target"].frame

    -- Avatar do target
    local targetAvatar = Instance.new("ImageLabel")
    targetAvatar.Size = UDim2.new(0, 72, 0, 72)
    targetAvatar.Position = UDim2.new(0, 8, 0, 8)
    targetAvatar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    targetAvatar.BorderSizePixel = 0
    targetAvatar.Image = ""
    targetAvatar.ZIndex = 4
    targetAvatar.Parent = f
    Instance.new("UIStroke", targetAvatar).Color = Color3.fromRGB(70, 70, 70)

    -- Input username
    local usernameInput = makeInput(f, "@username...", 90, 8, 185, 28)

    -- Info labels
    local userIdLbl  = Instance.new("TextLabel")
    userIdLbl.Size   = UDim2.new(0, 185, 0, 18)
    userIdLbl.Position = UDim2.new(0, 90, 0, 42)
    userIdLbl.BackgroundTransparency = 1
    userIdLbl.Text  = "UserID:"
    userIdLbl.TextColor3 = Color3.fromRGB(190, 190, 190)
    userIdLbl.TextSize = 12
    userIdLbl.Font  = Enum.Font.Gotham
    userIdLbl.TextXAlignment = Enum.TextXAlignment.Left
    userIdLbl.ZIndex = 4
    userIdLbl.Parent = f

    local displayLbl = userIdLbl:Clone()
    displayLbl.Position = UDim2.new(0, 90, 0, 60)
    displayLbl.Text = "Display:"
    displayLbl.Parent = f

    local createdLbl = userIdLbl:Clone()
    createdLbl.Position = UDim2.new(0, 90, 0, 78)
    createdLbl.Text = "Created:"
    createdLbl.Parent = f

    -- Search icon button
    local searchBtn = Instance.new("TextButton")
    searchBtn.Size = UDim2.new(0, 32, 0, 32)
    searchBtn.Position = UDim2.new(0, 244, 0, 38)
    searchBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    searchBtn.Text = "🔍"
    searchBtn.TextSize = 14
    searchBtn.BorderSizePixel = 0
    searchBtn.ZIndex = 4
    searchBtn.Parent = f
    Instance.new("UICorner", searchBtn).CornerRadius = UDim.new(0, 5)

    -- Buttons grid
    local targetBtns = {
        {name="View",    col=0, row=0},
        {name="Copy ID", col=1, row=0},
        {name="Focus",   col=0, row=1, vip=true},
        {name="Follow",  col=1, row=1, vip=true},
        {name="Stand",   col=0, row=2},
        {name="Bang",    col=1, row=2},
        {name="Drag",    col=0, row=3},
        {name="Headsit", col=1, row=3},
        {name="Kill",    col=0, row=4},
        {name="Orbit",   col=1, row=4},
    }

    local targetUser = nil

    for _, v in ipairs(targetBtns) do
        local x = v.col == 0 and 8 or 140
        local y = v.row * 40 + 100
        local btn = makeButton(f, v.name, x, y, 120, 32, v.vip)
        btn.MouseButton1Click:Connect(function()
            if not targetUser then return end
            loadModule("modules/Target/" .. v.name:gsub(" ", "") .. ".lua")
        end)
    end

    -- Search handler
    searchBtn.MouseButton1Click:Connect(function()
        local uname = usernameInput.Text
        if uname == "" then return end
        local results = apiGet("/target/search/" .. uname)
        if results and results[1] then
            local u = results[1]
            targetUser = u
            userIdLbl.Text  = "UserID: " .. tostring(u.userid or "")
            displayLbl.Text = "Display: " .. tostring(u.displayName or "")
            createdLbl.Text = "Created: " .. tostring(u.created or "--")
            -- avatar
            local ok, img = pcall(function()
                return Players:GetUserThumbnailAsync(u.userid, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
            end)
            if ok then targetAvatar.Image = img end
        end
    end)
end

-- ==================== ANIMATIONS TAB ====================
do
    local f = Tabs["Animations"].frame

    local animBtns = {
        "Dance1","Dance2","Dance3","Emote1","Emote2",
        "Laugh","Wave","Cheer","Point","Custom"
    }

    for i, name in ipairs(animBtns) do
        local col = (i-1) % 2
        local row = math.floor((i-1) / 2)
        local btn = makeToggleButton(f, name, col == 0 and 10 or 140, row * 40 + 10, 120, 32)
        btn.MouseButton1Click:Connect(function()
            loadModule("modules/Animations/" .. name .. ".lua")
        end)
    end
end

-- ==================== MORE TAB ====================
do
    local f = Tabs["More"].frame

    makeSectionLabel(f, "Casual", 10, 8)

    local antiBanState = false
    local antiBanBtn = makeToggleButton(f, "AntiBanVC", 10, 28, 120, 32)
    local antiBanStatusLbl = Instance.new("TextLabel")
    antiBanStatusLbl.Size = UDim2.new(0, 30, 0, 22)
    antiBanStatusLbl.Position = UDim2.new(0, 138, 0, 35)
    antiBanStatusLbl.BackgroundTransparency = 1
    antiBanStatusLbl.Text = "[O]"
    antiBanStatusLbl.TextColor3 = Color3.fromRGB(120, 120, 120)
    antiBanStatusLbl.TextSize = 12
    antiBanStatusLbl.Font = Enum.Font.Gotham
    antiBanStatusLbl.ZIndex = 4
    antiBanStatusLbl.Parent = f

    antiBanBtn.MouseButton1Click:Connect(function()
        antiBanState = not antiBanState
        antiBanStatusLbl.Text = antiBanState and "[I]" or "[O]"
        antiBanStatusLbl.TextColor3 = antiBanState
            and Color3.fromRGB(80, 220, 80)
            or  Color3.fromRGB(120, 120, 120)
        loadModule("modules/More/AntiBanVC.lua")
    end)

    local pianoBtn = makeButton(f, "PianoAuto", 170, 28, 110, 32)
    pianoBtn.MouseButton1Click:Connect(function()
        loadModule("modules/More/PianoAuto.lua")
    end)

    makeSectionLabel(f, "FPS", 10, 72)

    local espBtn  = makeToggleButton(f, "ESP",    10,  92, 120, 32)
    local aimBtn  = makeToggleButton(f, "Aimbot", 140, 92, 120, 32)

    espBtn.MouseButton1Click:Connect(function()
        loadModule("modules/More/ESP.lua")
    end)
    aimBtn.MouseButton1Click:Connect(function()
        loadModule("modules/More/Aimbot.lua")
    end)
end

-- ==================== MISC TAB ====================
do
    local f = Tabs["Misc"].frame

    local miscButtons = {
        {name="Anti AFK",       col=0, row=0, vip=true},
        {name="TpToOwner",      col=1, row=0},
        {name="Shaders",        col=0, row=1, vip=true},
        {name="Day/Night",      col=1, row=1, vip=true},
        {name="Reset Lighting", col=0, row=2},
        {name="Destroy GUI",    col=1, row=2},
        {name="Free Emotes",    col=0, row=3},
        {name="Clear Chat",     col=1, row=3},
        {name="Rejoin",         col=0, row=4},
        {name="Infinite Premium", col=1, row=4},
    }

    for _, v in ipairs(miscButtons) do
        local x = v.col == 0 and 8 or 142
        local y = v.row * 40 + 10
        local btn = makeToggleButton(f, v.name, x, y, 124, 32, v.vip)
        local safeName = v.name:gsub("/", ""):gsub(" ", "")
        btn.MouseButton1Click:Connect(function()
            loadModule("modules/Misc/" .. safeName .. ".lua")
        end)
    end
end

-- ==================== SERVERS TAB ====================
do
    local f = Tabs["Servers"].frame

    local refreshBtn = makeButton(f, "↻ Atualizar", 8, 8, 90, 26)
    local serverList = Instance.new("ScrollingFrame")
    serverList.Size = UDim2.new(1, -16, 1, -44)
    serverList.Position = UDim2.new(0, 8, 0, 40)
    serverList.BackgroundTransparency = 1
    serverList.ScrollBarThickness = 4
    serverList.BorderSizePixel = 0
    serverList.ZIndex = 4
    serverList.Parent = f

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = serverList

    local function loadServers()
        -- Limpar lista
        for _, c in pairs(serverList:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        local servers = apiGet("/servers")
        if servers then
            for i, s in ipairs(servers) do
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 30)
                row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                row.BorderSizePixel = 0
                row.LayoutOrder = i
                row.ZIndex = 5
                row.Parent = serverList
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size = UDim2.new(0.55, 0, 1, 0)
                nameLbl.Position = UDim2.new(0, 8, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text = s.name
                nameLbl.TextColor3 = Color3.fromRGB(210, 210, 210)
                nameLbl.TextSize = 11
                nameLbl.Font = Enum.Font.Gotham
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.ZIndex = 6
                nameLbl.Parent = row

                local pingLbl = Instance.new("TextLabel")
                pingLbl.Size = UDim2.new(0.25, 0, 1, 0)
                pingLbl.Position = UDim2.new(0.55, 0, 0, 0)
                pingLbl.BackgroundTransparency = 1
                pingLbl.Text = s.ping .. "ms"
                pingLbl.TextColor3 = s.ping < 80 and Color3.fromRGB(80,220,80) or Color3.fromRGB(255,180,50)
                pingLbl.TextSize = 11
                pingLbl.Font = Enum.Font.Gotham
                pingLbl.ZIndex = 6
                pingLbl.Parent = row

                local joinBtn = Instance.new("TextButton")
                joinBtn.Size = UDim2.new(0, 44, 0, 22)
                joinBtn.Position = UDim2.new(1, -50, 0.5, -11)
                joinBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
                joinBtn.Text = "Join"
                joinBtn.TextColor3 = Color3.new(1,1,1)
                joinBtn.TextSize = 11
                joinBtn.Font = Enum.Font.GothamBold
                joinBtn.BorderSizePixel = 0
                joinBtn.ZIndex = 6
                joinBtn.Parent = row
                Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0, 4)
                joinBtn.MouseButton1Click:Connect(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(
                        game.PlaceId, s.id, LocalPlayer
                    )
                end)
            end
            serverList.CanvasSize = UDim2.new(0, 0, 0, #servers * 34)
        end
    end

    refreshBtn.MouseButton1Click:Connect(loadServers)
    spawn(loadServers)
end

-- ==================== ABOUT TAB ====================
do
    local f = Tabs["About"].frame

    local devLabel = Instance.new("TextLabel")
    devLabel.Size = UDim2.new(1, -20, 0, 28)
    devLabel.Position = UDim2.new(0, 10, 0, 20)
    devLabel.BackgroundTransparency = 1
    devLabel.Text = "Developed by "
    devLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    devLabel.TextSize = 14
    devLabel.Font = Enum.Font.Gotham
    devLabel.TextXAlignment = Enum.TextXAlignment.Left
    devLabel.ZIndex = 4
    devLabel.Parent = f

    -- "288" em azul
    local 288Label = Instance.new("TextLabel")
    288Label.Size = UDim2.new(0, 40, 0, 28)
    288Label.Position = UDim2.new(0, 107, 0, 20)
    288Label.BackgroundTransparency = 1
    288Label.Text = "288"
    288Label.TextColor3 = Color3.fromRGB(80, 160, 255)
    288Label.TextSize = 14
    288Label.Font = Enum.Font.GothamBold
    288Label.TextXAlignment = Enum.TextXAlignment.Left
    288Label.ZIndex = 5
    288Label.Parent = f

    -- Version
    local verLabel = Instance.new("TextLabel")
    verLabel.Size = UDim2.new(1, -20, 0, 28)
    verLabel.Position = UDim2.new(0, 10, 0, 60)
    verLabel.BackgroundTransparency = 1
    verLabel.Text = "Version: "
    verLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    verLabel.TextSize = 14
    verLabel.Font = Enum.Font.Gotham
    verLabel.TextXAlignment = Enum.TextXAlignment.Left
    verLabel.ZIndex = 4
    verLabel.Parent = f

    local verValLabel = Instance.new("TextLabel")
    verValLabel.Size = UDim2.new(0, 60, 0, 28)
    verValLabel.Position = UDim2.new(0, 74, 0, 60)
    verValLabel.BackgroundTransparency = 1
    verValLabel.Text = VERSION
    verValLabel.TextColor3 = Color3.fromRGB(220, 50, 50)
    verValLabel.TextSize = 14
    verValLabel.Font = Enum.Font.GothamBold
    verValLabel.TextXAlignment = Enum.TextXAlignment.Left
    verValLabel.ZIndex = 5
    verValLabel.Parent = f

    -- Donate
    local donateRow = Instance.new("TextLabel")
    donateRow.Size = UDim2.new(1, -20, 0, 22)
    donateRow.Position = UDim2.new(0, 10, 0, 200)
    donateRow.BackgroundTransparency = 1
    donateRow.Text = "Donate: "
    donateRow.TextColor3 = Color3.fromRGB(180, 180, 180)
    donateRow.TextSize = 12
    donateRow.Font = Enum.Font.Gotham
    donateRow.TextXAlignment = Enum.TextXAlignment.Left
    donateRow.ZIndex = 4
    donateRow.Parent = f

    local donateLink = Instance.new("TextLabel")
    donateLink.Size = UDim2.new(0, 160, 0, 22)
    donateLink.Position = UDim2.new(0, 64, 0, 200)
    donateLink.BackgroundTransparency = 1
    donateLink.Text = "aguilar.gg/donate"
    donateLink.TextColor3 = Color3.fromRGB(80, 140, 255)
    donateLink.TextSize = 12
    donateLink.Font = Enum.Font.Gotham
    donateLink.TextXAlignment = Enum.TextXAlignment.Left
    donateLink.ZIndex = 5
    donateLink.Parent = f

    -- Support
    local supportRow = donateRow:Clone()
    supportRow.Position = UDim2.new(0, 10, 0, 228)
    supportRow.Text = "Support: "
    supportRow.Parent = f

    local supportLink1 = donateLink:Clone()
    supportLink1.Position = UDim2.new(0, 68, 0, 228)
    supportLink1.Text = "discord.gg/288"
    supportLink1.Parent = f

    -- Sun icon (canto inferior direito)
    local sunIcon = Instance.new("TextLabel")
    sunIcon.Size = UDim2.new(0, 30, 0, 30)
    sunIcon.Position = UDim2.new(1, -36, 1, -36)
    sunIcon.BackgroundTransparency = 1
    sunIcon.Text = "☀"
    sunIcon.TextColor3 = Color3.fromRGB(220, 180, 50)
    sunIcon.TextSize = 22
    sunIcon.Font = Enum.Font.Gotham
    sunIcon.ZIndex = 4
    sunIcon.Parent = f
end

-- ==================== START STATE ====================
setTab("Home")

-- Sessão na API
spawn(function()
    apiPost("/session/start", {
        userid   = LocalPlayer.UserId,
        username = LocalPlayer.Name,
        version  = VERSION,
        game     = tostring(game.PlaceId),
    })
end)

-- Heartbeat a cada 30s
spawn(function()
    while wait(30) do
        if not ScreenGui.Parent then break end
        apiPost("/session/heartbeat", {
            userid = LocalPlayer.UserId,
        })
    end
end)

-- ==================== KEYBIND [B] ====================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.B then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("✅ 288 Panel [" .. VERSION .. "] carregado — pressione B para abrir/fechar")
