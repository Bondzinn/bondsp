--[[ 
    288 Panel - Versão Completa
    GitHub: https://github.com/288panel/288panel
    API: http://localhost:3000
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==================== CONFIGURAÇÕES ====================
local API_URL = "https://phoenix-indicators-done-association.trycloudflare.com" -- Mude para sua API
local VERSION = "1.0.0"
local TOGGLE_KEY = Enum.KeyCode.B -- Tecla para abrir/fechar

-- ==================== VARIÁVEIS GLOBAIS ====================
local modules = {}
local activeFeatures = {
    noclip = false,
    jerkoff = false,
    facebang = false,
    spin = false,
    flashback = false,
    antivoid = false,
    esp = false,
    aimbot = false,
    antiAFK = false,
    fly = false
}

local characterSettings = {
    walkSpeed = 16,
    jumpPower = 50,
    flySpeed = 50
}

local targetSettings = {
    currentTarget = nil,
    activeAction = nil,
    following = false
}

-- ==================== GUI PRINCIPAL ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "288Panel"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 900, 0, 600)
MainFrame.Position = UDim2.new(0.5, -450, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Shadow
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.7
Shadow.BorderSizePixel = 0
Shadow.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "288 PANEL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 80, 1, 0)
Version.Position = UDim2.new(0, 115, 0, 0)
Version.BackgroundTransparency = 1
Version.Text = "v" .. VERSION
Version.TextColor3 = Color3.fromRGB(150, 150, 150)
Version.TextSize = 12
Version.Font = Enum.Font.Gotham
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 7.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 180, 1, -55)
Sidebar.Position = UDim2.new(0, 0, 0, 55)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("Frame")
SidebarPadding.Size = UDim2.new(1, 0, 0, 10)
SidebarPadding.BackgroundTransparency = 1
SidebarPadding.Parent = Sidebar

-- Content Area
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -180, 1, -55)
ContentContainer.Position = UDim2.new(0, 180, 0, 55)
ContentContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -20, 1, -20)
ContentScroll.Position = UDim2.new(0, 10, 0, 10)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.ScrollBarThickness = 6
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ContentScroll.Parent = ContentContainer

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.Parent = ContentScroll

-- ==================== FUNÇÕES AUXILIARES ====================
local function CreateButton(text, callback, isActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = isActive and Color3.fromRGB(80, 60, 150) or Color3.fromRGB(40, 40, 48)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    
    btn.MouseEnter:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(80, 60, 150) then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(80, 60, 150) then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateSlider(label, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    frame.BorderSizePixel = 0
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = label .. ": " .. default
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -10, 0, 4)
    slider.Position = UDim2.new(0, 5, 0, 35)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 80, 180)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 12, 0, 12)
    handle.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    handle.BackgroundColor3 = Color3.fromRGB(150, 130, 230)
    handle.BorderSizePixel = 0
    handle.Parent = slider
    
    local dragging = false
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    handle.InputEnded:Connect(function()
        dragging = false
    end)
    
    handle.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * pos
            value = math.floor(value)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            handle.Position = UDim2.new(pos, -6, 0.5, -6)
            lbl.Text = label .. ": " .. value
            callback(value)
        end
    end)
    
    return frame
end

local function CreateToggle(text, key, activeVar, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    frame.BorderSizePixel = 0
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.8, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. (key and (" [" .. key .. "]") or "")
    lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0, 40, 0, 24)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
    toggleBtn.BackgroundColor3 = activeVar and Color3.fromRGB(100, 80, 180) or Color3.fromRGB(60, 60, 70)
    toggleBtn.BorderSizePixel = 0
    
    local toggler = Instance.new("Frame")
    toggler.Size = UDim2.new(0, 20, 0, 20)
    toggler.Position = activeVar and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
    toggler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggler.BorderSizePixel = 0
    toggler.Parent = toggleBtn
    
    toggleBtn.Parent = frame
    
    local function updateToggle()
        local newState = not activeVar
        activeVar = newState
        toggleBtn.BackgroundColor3 = activeVar and Color3.fromRGB(100, 80, 180) or Color3.fromRGB(60, 60, 70)
        local goalPos = activeVar and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
        TweenService:Create(toggler, TweenInfo.new(0.1), {Position = goalPos}):Play()
        callback(activeVar)
    end
    
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateToggle()
        end
    end)
    
    return frame, function() return activeVar end
end

-- ==================== ABA HOME ====================
local function CreateHomeTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 250)
    container.BackgroundTransparency = 1
    container.Parent = ContentScroll
    
    -- Avatar
    local AvatarContainer = Instance.new("Frame")
    AvatarContainer.Size = UDim2.new(0, 120, 0, 120)
    AvatarContainer.Position = UDim2.new(0.5, -60, 0, 20)
    AvatarContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    AvatarContainer.BorderSizePixel = 0
    
    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(1, -4, 1, -4)
    Avatar.Position = UDim2.new(0, 2, 0, 2)
    Avatar.BackgroundTransparency = 1
    pcall(function()
        Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    Avatar.Parent = AvatarContainer
    AvatarContainer.Parent = container
    
    local WelcomeText = Instance.new("TextLabel")
    WelcomeText.Size = UDim2.new(1, 0, 0, 40)
    WelcomeText.Position = UDim2.new(0, 0, 0, 160)
    WelcomeText.BackgroundTransparency = 1
    WelcomeText.Text = "Bem-vindo, " .. LocalPlayer.DisplayName
    WelcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    WelcomeText.TextSize = 24
    WelcomeText.Font = Enum.Font.GothamBold
    WelcomeText.Parent = container
    
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1, -40, 0, 80)
    StatsFrame.Position = UDim2.new(0, 20, 0, 210)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    StatsFrame.BorderSizePixel = 0
    StatsFrame.Parent = container
    
    local PingText = Instance.new("TextLabel")
    PingText.Size = UDim2.new(0.33, 0, 1, 0)
    PingText.BackgroundTransparency = 1
    PingText.Text = "Ping: --ms"
    PingText.TextColor3 = Color3.fromRGB(200, 200, 200)
    PingText.TextSize = 12
    PingText.Font = Enum.Font.Gotham
    PingText.Parent = StatsFrame
    
    local OnlineText = Instance.new("TextLabel")
    OnlineText.Size = UDim2.new(0.33, 0, 1, 0)
    OnlineText.Position = UDim2.new(0.33, 0, 0, 0)
    OnlineText.BackgroundTransparency = 1
    OnlineText.Text = "Online: --"
    OnlineText.TextColor3 = Color3.fromRGB(200, 200, 200)
    OnlineText.TextSize = 12
    OnlineText.Font = Enum.Font.Gotham
    OnlineText.Parent = StatsFrame
    
    local TotalText = Instance.new("TextLabel")
    TotalText.Size = UDim2.new(0.34, 0, 1, 0)
    TotalText.Position = UDim2.new(0.66, 0, 0, 0)
    TotalText.BackgroundTransparency = 1
    TotalText.Text = "Total: --"
    TotalText.TextColor3 = Color3.fromRGB(200, 200, 200)
    TotalText.TextSize = 12
    TotalText.Font = Enum.Font.Gotham
    TotalText.Parent = StatsFrame
    
    -- Atualizar stats
    spawn(function()
        while container.Parent do
            local ping = LocalPlayer:GetPing()
            PingText.Text = "Ping: " .. math.floor(ping) .. "ms"
            
            pcall(function()
                local stats = HttpService:JSONDecode(HttpService:GetAsync(API_URL .. "/stats"))
                OnlineText.Text = "Online: " .. (stats.online or "--")
                TotalText.Text = "Total: " .. (stats.totalUsers or "--")
            end)
            wait(2)
        end
    end)
    
    container.Size = UDim2.new(1, 0, 0, 320)
    return container
end

-- ==================== ABA EMPHASIS ====================
local function CreateEmphasisTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 400)
    container.BackgroundTransparency = 1
    container.Parent = ContentScroll
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "⚡ EMPHASIS MODULES"
    title.TextColor3 = Color3.fromRGB(150, 130, 230)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = container
    
    -- Grid de botões
    local grid = Instance.new("Frame")
    grid.Size = UDim2.new(1, 0, 0, 200)
    grid.Position = UDim2.new(0, 0, 0, 40)
    grid.BackgroundTransparency = 1
    grid.Parent = container
    
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 120, 0, 45)
    gridLayout.CellPadding = UDim.new(0, 10)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = grid
    
    local emphModules = {
        {name = "Invisible", key = "Ctrl+Click", func = function()
            print("[EMPHASIS] Invisible ativado")
        end},
        {name = "ClickTP", key = "Ctrl+Click", func = function()
            if not activeFeatures.clickTP then
                activeFeatures.clickTP = true
                local connection
                connection = Mouse.Button1Down:Connect(function()
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        local target = Mouse.Hit
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = target
                        end
                    end
                end)
                modules.clickTP = connection
            else
                if modules.clickTP then modules.clickTP:Disconnect() end
                activeFeatures.clickTP = false
            end
        end},
        {name = "NoClip", key = "N", func = function()
            activeFeatures.noclip = not activeFeatures.noclip
            if activeFeatures.noclip then
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                -- Mantém o noclip
                modules.noclip = RunService.Stepped:Connect(function()
                    if activeFeatures.noclip and LocalPlayer.Character then
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            else
                if modules.noclip then modules.noclip:Disconnect() end
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end},
        {name = "JerkOff", key = "R", func = function()
            activeFeatures.jerkoff = not activeFeatures.jerkoff
            if activeFeatures.jerkoff then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    modules.jerkoff = RunService.RenderStepped:Connect(function()
                        if activeFeatures.jerkoff and char and char.Humanoid then
                            char.Humanoid.Jump = true
                            wait(0.05)
                            char.Humanoid.Jump = false
                        end
                    end)
                end
            else
                if modules.jerkoff then modules.jerkoff:Disconnect() end
            end
        end},
        {name = "Impulse", key = "", func = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = char.HumanoidRootPart.CFrame.LookVector * 150
            end
        end},
        {name = "Facebang", key = "Z", func = function()
            activeFeatures.facebang = not activeFeatures.facebang
            if activeFeatures.facebang and targetSettings.currentTarget and targetSettings.currentTarget.Character then
                modules.facebang = RunService.RenderStepped:Connect(function()
                    if activeFeatures.facebang and targetSettings.currentTarget and targetSettings.currentTarget.Character then
                        local targetHRP = targetSettings.currentTarget.Character:FindFirstChild("HumanoidRootPart")
                        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if targetHRP and myHRP then
                            myHRP.CFrame = CFrame.new(myHRP.Position, targetHRP.Position)
                        end
                    end
                end)
            else
                if modules.facebang then modules.facebang:Disconnect() end
            end
        end},
        {name = "Spin", key = "", func = function()
            activeFeatures.spin = not activeFeatures.spin
            if activeFeatures.spin then
                modules.spin = RunService.RenderStepped:Connect(function()
                    if activeFeatures.spin and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(25), 0)
                    end
                end)
            else
                if modules.spin then modules.spin:Disconnect() end
            end
        end},
        {name = "AnimeSpeed", key = "", func = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 50
                wait(0.5)
                char.Humanoid.WalkSpeed = characterSettings.walkSpeed
            end
        end},
        {name = "feFlip", key = "", func = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(180), 0, 0)
            end
        end},
        {name = "Flashback", key = "V", func = function()
            activeFeatures.flashback = not activeFeatures.flashback
            if activeFeatures.flashback then
                local startPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
                modules.flashback = UserInputService.InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.V then
                        if startPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(startPos)
                        end
                    end
                end)
            else
                if modules.flashback then modules.flashback:Disconnect() end
            end
        end},
        {name = "AntiVoid", key = "G", func = function()
            activeFeatures.antivoid = not activeFeatures.antivoid
            if activeFeatures.antivoid then
                modules.antivoid = RunService.Heartbeat:Connect(function()
                    if activeFeatures.antivoid and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local pos = LocalPlayer.Character.HumanoidRootPart.Position
                        if pos.Y < -20 then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
                        end
                    end
                end)
            else
                if modules.antivoid then modules.antivoid:Disconnect() end
            end
        end}
    }
    
    for _, mod in pairs(emphModules) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        btn.Text = mod.name .. (mod.key ~= "" and ("\n[" .. mod.key .. "]") or "")
        btn.TextColor3 = Color3.fromRGB(230, 230, 230)
        btn.TextSize = 12
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        btn.Parent = grid
        
        btn.MouseButton1Click:Connect(mod.func)
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 72)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}):Play()
        end)
    end
    
    container.Size = UDim2.new(1, 0, 0, 280)
    return container
end

-- ==================== ABA CHARACTER ====================
local function CreateCharacterTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 250)
    container.BackgroundTransparency = 1
    container.Parent = ContentScroll
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "🎮 CHARACTER SETTINGS"
    title.TextColor3 = Color3.fromRGB(150, 130, 230)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = container
    
    -- Walk Speed Slider
    local wsSlider = CreateSlider("Walk Speed", 16, 100, characterSettings.walkSpeed, function(val)
        characterSettings.walkSpeed = val
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
        pcall(function()
            HttpService:PostAsync(API_URL .. "/character/update", 
                HttpService:JSONEncode({userid = LocalPlayer.UserId, walkSpeed = val}), 
                Enum.HttpContentType.ApplicationJson)
        end)
    end)
    wsSlider.Parent = container
    
    -- Jump Power Slider
    local jpSlider = CreateSlider("Jump Power", 50, 150, characterSettings.jumpPower, function(val)
        characterSettings.jumpPower = val
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = val
        end
        pcall(function()
            HttpService:PostAsync(API_URL .. "/character/update", 
                HttpService:JSONEncode({userid = LocalPlayer.UserId, jumpPower = val}), 
                Enum.HttpContentType.ApplicationJson)
        end)
    end)
    jpSlider.Parent = container
    
    -- Fly Toggle
    local flyToggle, getFlyState = CreateToggle("Fly", "", activeFeatures.fly, function(state)
        activeFeatures.fly = state
        if state then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.PlatformStand = true
                local bodyGyro = Instance.new("BodyGyro")
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyGyro.P = 10000
                bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000
                bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
                bodyGyro.Parent = char.HumanoidRootPart
                bodyVelocity.Parent = char.HumanoidRootPart
                modules.flyParts = {bodyGyro, bodyVelocity}
                
                modules.flyControl = RunService.RenderStepped:Connect(function()
                    if activeFeatures.fly and LocalPlayer.Character then
                        local direction = Vector3.new()
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + Vector3.new(0, 0, -1) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction + Vector3.new(0, 0, 1) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction + Vector3.new(-1, 0, 0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + Vector3.new(1, 0, 0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction + Vector3.new(0, -1, 0) end
                        
                        if direction.Magnitude > 0 then direction = direction.Unit end
                        local camera = workspace.CurrentCamera
                        bodyVelocity.Velocity = (camera.CFrame:VectorToWorldSpace(direction) * characterSettings.walkSpeed * 2)
                        bodyGyro.CFrame = camera.CFrame
                    end
                end)
            end
        else
            if modules.flyControl then modules.flyControl:Disconnect() end
            if modules.flyParts then
                for _, part in pairs(modules.flyParts) do
                    if part and part.Parent then part:Destroy() end
                end
            end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.PlatformStand = false
            end
        end
        pcall(function()
            HttpService:PostAsync(API_URL .. "/character/update", 
                HttpService:JSONEncode({userid = LocalPlayer.UserId, flyEnabled = state}), 
                Enum.HttpContentType.ApplicationJson)
        end)
    end)
    flyToggle.Parent = container
    
    container.Size = UDim2.new(1, 0, 0, 220)
    return container
end

-- ==================== ABA TARGET ====================
local function CreateTargetTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 450)
    container.BackgroundTransparency = 1
    container.Parent = ContentScroll
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "🎯 TARGET SYSTEM"
    title.TextColor3 = Color3.fromRGB(150, 130, 230)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = container
    
    -- Avatar do alvo
    local AvatarFrame = Instance.new("Frame")
    AvatarFrame.Size = UDim2.new(0, 100, 0, 100)
    AvatarFrame.Position = UDim2.new(0.5, -50, 0, 50)
    AvatarFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    AvatarFrame.BorderSizePixel = 0
    AvatarFrame.Parent = container
    
    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Size = UDim2.new(1, -4, 1, -4)
    AvatarImg.Position = UDim2.new(0, 2, 0, 2)
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.Parent = AvatarFrame
    
    local TargetName = Instance.new("TextLabel")
    TargetName.Size = UDim2.new(1, 0, 0, 25)
    TargetName.Position = UDim2.new(0, 0, 0, 165)
    TargetName.BackgroundTransparency = 1
    TargetName.Text = "Nenhum alvo selecionado"
    TargetName.TextColor3 = Color3.fromRGB(200, 200, 200)
    TargetName.TextSize = 14
    TargetName.Font = Enum.Font.Gotham
    TargetName.Parent = container
    
    -- Search box
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Size = UDim2.new(1, -40, 0, 40)
    SearchFrame.Position = UDim2.new(0, 20, 0, 200)
    SearchFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    SearchFrame.BorderSizePixel = 0
    SearchFrame.Parent = container
    
    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, -10, 1, -10)
    SearchBox.Position = UDim2.new(0, 5, 0, 5)
    SearchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "Digite o username..."
    SearchBox.TextColor3 = Color3.fromRGB(230, 230, 230)
    SearchBox.TextSize = 14
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.Parent = SearchFrame
    
    -- Search results
    local ResultsScroll = Instance.new("ScrollingFrame")
    ResultsScroll.Size = UDim2.new(1, -40, 0, 120)
    ResultsScroll.Position = UDim2.new(0, 20, 0, 250)
    ResultsScroll.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    ResultsScroll.BorderSizePixel = 0
    ResultsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ResultsScroll.ScrollBarThickness = 4
    ResultsScroll.Parent = container
    
    local ResultsLayout = Instance.new("UIListLayout")
    ResultsLayout.Padding = UDim.new(0, 2)
    ResultsLayout.Parent = ResultsScroll
    
    -- Actions grid
    local ActionsFrame = Instance.new("Frame")
    ActionsFrame.Size = UDim2.new(1, -40, 0, 120)
    ActionsFrame.Position = UDim2.new(0, 20, 0, 380)
    ActionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    ActionsFrame.BorderSizePixel = 0
    ActionsFrame.Parent = container
    
    local ActionsGrid = Instance.new("UIGridLayout")
    ActionsGrid.CellSize = UDim2.new(0, 85, 0, 35)
    ActionsGrid.CellPadding = UDim.new(0, 5)
    ActionsGrid.SortOrder = Enum.SortOrder.LayoutOrder
    ActionsGrid.Parent = ActionsFrame
    
    local actions = {"view", "copy ID", "focus", "follow", "stand", "bang", "drag", "headsit", "doggy", "backpack", "bring", "teleport"}
    
    for _, action in pairs(actions) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 54)
        btn.Text = action:upper()
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Parent = ActionsGrid
        
        btn.MouseButton1Click:Connect(function()
            if not targetSettings.currentTarget then
                print("Selecione um alvo primeiro!")
                return
            end
            
            -- Desativar ação anterior
            if targetSettings.activeAction then
                if targetSettings.activeAction == "follow" and modules.follow then
                    modules.follow:Disconnect()
                end
            end
            
            targetSettings.activeAction = action
            
            pcall(function()
                HttpService:PostAsync(API_URL .. "/target/action", 
                    HttpService:JSONEncode({
                        action = action,
                        targetUserId = targetSettings.currentTarget.UserId,
                        sourceUserId = LocalPlayer.UserId
                    }), 
                    Enum.HttpContentType.ApplicationJson)
            end)
            
            if action == "follow" then
                modules.follow = RunService.RenderStepped:Connect(function()
                    if targetSettings.currentTarget and targetSettings.currentTarget.Character and targetSettings.currentTarget.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPos = targetSettings.currentTarget.Character.HumanoidRootPart.Position
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 0, 3), targetPos)
                        end
                    end
                end)
            elseif action == "teleport" then
                if targetSettings.currentTarget.Character and targetSettings.currentTarget.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetSettings.currentTarget.Character.HumanoidRootPart.CFrame
                end
            elseif action == "bring" then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and targetSettings.currentTarget.Character then
                    targetSettings.currentTarget.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end)
    end
    
    -- Função de busca
    local debounce = false
    SearchBox.Changed:Connect(function()
        if debounce then return end
        debounce = true
        
        task.wait(0.3)
        
        local query = SearchBox.Text
        if #query >= 3 then
            pcall(function()
                local results = HttpService:JSONDecode(HttpService:GetAsync(API_URL .. "/target/search/" .. query))
                
                -- Limpar resultados
                for _, child in pairs(ResultsScroll:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                for _, user in pairs(results) do
                    local resultBtn = Instance.new("TextButton")
                    resultBtn.Size = UDim2.new(1, -10, 0, 35)
                    resultBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 54)
                    resultBtn.Text = user.username .. " (" .. (user.displayName or "") .. ")"
                    resultBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    resultBtn.TextSize = 12
                    resultBtn.Font = Enum.Font.Gotham
                    resultBtn.BorderSizePixel = 0
                    resultBtn.Parent = ResultsScroll
                    
                    resultBtn.MouseButton1Click:Connect(function()
                        targetSettings.currentTarget = Players:FindFirstChild(user.username) or Players:GetUserIdFromNameAsync(user.username)
                        if targetSettings.currentTarget then
                            TargetName.Text = "Alvo: " .. user.username
                            pcall(function()
                                AvatarImg.Image = Players:GetUserThumbnailAsync(targetSettings.currentTarget.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                            end)
                        end
                    end)
                end
                
                ResultsScroll.CanvasSize = UDim2.new(0, 0, 0, #results * 40)
            end)
        end
        
        debounce = false
    end)
    
    container.Size = UDim2.new(1, 0, 0, 530)
    return container
end

-- ==================== ABA MORE ====================
local function CreateMoreTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 150)
    container.BackgroundTransparency = 1
    container.Parent = ContentScroll
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "🔧 MORE MODULES"
    title.TextColor3 = Color3.fromRGB(150, 130, 230)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = container
    
    -- ESP Toggle
    local espToggle, getEspState = CreateToggle("ESP", "E", activeFeatures.esp, function(state)
        activeFeatures.esp = state
        if state then
            -- Criar ESP para todos os players
            modules.espConnections = {}
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "288ESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.7
                    highlight.Adornee = player.Character
                    highlight.Parent = player.Character
                    modules.espConnections[player] = highlight
                end
            end
            
            Players.PlayerAdded:Connect(function(player)
                if activeFeatures.esp and player ~= LocalPlayer then
                    player.CharacterAdded:Connect(function(character)
                        wait(0.5)
                        if activeFeatures.esp and character then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "288ESP"
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.7
                            highlight.Adornee = character
                            highlight.Parent = character
                            modules.espConnections[player] = highlight
                        end
                    end)
                end
            end)
        else
            -- Remover ESP
            for _, highlight in pairs(modules.espConnections or {}) do
                if highlight and highlight.Parent then highlight:Destroy() end
            end
            modules.espConnections = {}
        end
    end)
    espToggle.Parent = container
    
    -- Aimbot Toggle
    local aimbotToggle, getAimbotState = CreateToggle("Aimbot", "F", activeFeatures.aimbot, function(state)
        activeFeatures.aimbot = state
        if state and targetSettings.currentTarget and targetSettings.currentTarget.Character then
            modules.aimbot = RunService.RenderStepped:Connect(function()
                if activeFeatures.aimbot and targetSettings.currentTarget and targetSettings.currentTarget.Character then
                    local targetHRP = targetSettings.currentTarget.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP and workspace.CurrentCamera then
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetHRP.Position)
                    end
                end
            end)
        else
            if modules.aimbot then modules.aimbot:Disconnect() end
        end
    end)
    aimbotToggle.Parent = container
    
    container.Size = UDim2.new(1, 0, 0, 130)
    return container
end

-- ==================== ABA MISC ====================
local function CreateMiscTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 150)
    container.BackgroundTransparency = 1
    container.Parent = ContentScroll
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "⚙️ MISC SETTINGS"
    title.TextColor3 = Color3.fromRGB(150, 130, 230)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = container
    
    -- Anti AFK Toggle
    local afkToggle, getAfkState = CreateToggle("Anti AFK", "", activeFeatures.antiAFK, function(state)
        activeFeatures.antiAFK = state
        if state then
            modules.antiAFK = RunService.RenderStepped:Connect(function()
                if activeFeatures.antiAFK then
                    LocalPlayer.Idled:Connect(function()
                        local VirtualUser = game:GetService("VirtualUser")
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end
            end)
        else
            if modules.antiAFK then modules.antiAFK:Disconnect() end
        end
    end)
    afkToggle.Parent = container
    
    -- Rejoin Button
    local rejoinBtn = CreateButton("Rejoin", function()
        local ts = game:GetService("TeleportService")
        ts:Teleport(game.PlaceId, LocalPlayer)
    end)
    rejoinBtn.Parent = container
    
    container.Size = UDim2.new(1, 0, 0, 130)
    return container
end

-- ==================== ABA SERVERS ====================
local function CreateServersTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 300)
    container.BackgroundTransparency = 1
    container.Parent = ContentScroll
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "🌐 SERVER LIST"
    title.TextColor3 = Color3.fromRGB(150, 130, 230)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = container
    
    local ServerList = Instance.new("ScrollingFrame")
    ServerList.Size = UDim2.new(1, -40, 0, 250)
    ServerList.Position = UDim2.new(0, 20, 0, 40)
    ServerList.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    ServerList.BorderSizePixel = 0
    ServerList.CanvasSize = UDim2.new(0, 0, 0, 0)
    ServerList.ScrollBarThickness = 4
    ServerList.Parent = container
    
    local ServerLayout = Instance.new("UIListLayout")
    ServerLayout.Padding = UDim.new(0, 5)
    ServerLayout.Parent = ServerList
    
    -- Carregar servidores
    spawn(function()
        while container.Parent do
            pcall(function()
                local servers = HttpService:JSONDecode(HttpService:GetAsync(API_URL .. "/servers"))
                
                -- Limpar
                for _, child in pairs(ServerList:GetChildren()) do
                    if child:IsA("Frame") then
                        child:Destroy()
                    end
                end
                
                for _, server in pairs(servers) do
                    local serverFrame = Instance.new("Frame")
                    serverFrame.Size = UDim2.new(1, -10, 0, 45)
                    serverFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
                    serverFrame.BorderSizePixel = 0
                    serverFrame.Parent = ServerList
                    
                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
                    nameLabel.Position = UDim2.new(0, 10, 0, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Text = server.name
                    nameLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                    nameLabel.TextSize = 12
                    nameLabel.Font = Enum.Font.Gotham
                    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                    nameLabel.Parent = serverFrame
                    
                    local playersLabel = Instance.new("TextLabel")
                    playersLabel.Size = UDim2.new(0.2, 0, 1, 0)
                    playersLabel.Position = UDim2.new(0.4, 0, 0, 0)
                    playersLabel.BackgroundTransparency = 1
                    playersLabel.Text = server.players .. "/" .. server.maxPlayers
                    playersLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    playersLabel.TextSize = 12
                    playersLabel.Font = Enum.Font.Gotham
                    playersLabel.Parent = serverFrame
                    
                    local pingLabel = Instance.new("TextLabel")
                    pingLabel.Size = UDim2.new(0.2, 0, 1, 0)
                    pingLabel.Position = UDim2.new(0.6, 0, 0, 0)
                    pingLabel.BackgroundTransparency = 1
                    
                    local pingColor = server.ping < 100 and Color3.fromRGB(0, 255, 0) or (server.ping < 150 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 0, 0))
                    pingLabel.TextColor3 = pingColor
                    pingLabel.Text = "Ping: " .. server.ping .. "ms"
                    pingLabel.TextSize = 12
                    pingLabel.Font = Enum.Font.Gotham
                    pingLabel.Parent = serverFrame
                    
                    local joinBtn = Instance.new("TextButton")
                    joinBtn.Size = UDim2.new(0.15, 0, 0.8, 0)
                    joinBtn.Position = UDim2.new(0.85, 0, 0.1, 0)
                    joinBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 150)
                    joinBtn.Text = "JOIN"
                    joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    joinBtn.TextSize = 10
                    joinBtn.Font = Enum.Font.GothamBold
                    joinBtn.BorderSizePixel = 0
                    joinBtn.Parent = serverFrame
                    
                    joinBtn.MouseButton1Click:Connect(function()
                        -- Teleport para o servidor
                        local ts = game:GetService("TeleportService")
                        local jobId = "server_" .. server.id
                        ts:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
                    end)
                end
                
                ServerList.CanvasSize = UDim2.new(0, 0, 0, #servers * 55)
            end)
            
            wait(5)
        end
    end)
    
    container.Size = UDim2.new(1, 0, 0, 320)
    return container
end

-- ==================== CONFIGURAR ABAS ====================
local tabs = {
    {name = "🏠 HOME", create = CreateHomeTab},
    {name = "⚡ EMPHASIS", create = CreateEmphasisTab},
    {name = "🎮 CHARACTER", create = CreateCharacterTab},
    {name = "🎯 TARGET", create = CreateTargetTab},
    {name = "🔧 MORE", create = CreateMoreTab},
    {name = "⚙️ MISC", create = CreateMiscTab},
    {name = "🌐 SERVERS", create = CreateServersTab}
}

local currentContent = nil

for _, tabInfo in pairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    btn.Text = tabInfo.name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    
    btn.MouseButton1Click:Connect(function()
        if currentContent then currentContent:Destroy() end
        currentContent = tabInfo.create()
        
        -- Atualizar canvas size
        task.wait()
        local contentHeight = 0
        for _, child in pairs(ContentScroll:GetChildren()) do
            if child:IsA("Frame") and child ~= ContentLayout then
                contentHeight = contentHeight + child.AbsoluteSize.Y + 10
            end
        end
        ContentScroll.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
    end)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 36)}):Play()
    end)
end

-- Carregar aba inicial
currentContent = CreateHomeTab()

-- ==================== TECLA PARA ABRIR/FECHAR ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == TOGGLE_KEY then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
    
    -- Teclas para módulos
    if input.KeyCode == Enum.KeyCode.N then
        if activeFeatures.noclip then
            activeFeatures.noclip = false
            if modules.noclip then modules.noclip:Disconnect() end
        else
            activeFeatures.noclip = true
            -- Ativar noclip
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
            modules.noclip = RunService.Stepped:Connect(function()
                if activeFeatures.noclip and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
    
    if input.KeyCode == Enum.KeyCode.R then
        activeFeatures.jerkoff = not activeFeatures.jerkoff
        if activeFeatures.jerkoff then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                modules.jerkoff = RunService.RenderStepped:Connect(function()
                    if activeFeatures.jerkoff and char and char.Humanoid then
                        char.Humanoid.Jump = true
                        wait(0.05)
                        char.Humanoid.Jump = false
                    end
                end)
            end
        else
            if modules.jerkoff then modules.jerkoff:Disconnect() end
        end
    end
    
    if input.KeyCode == Enum.KeyCode.Z then
        activeFeatures.facebang = not activeFeatures.facebang
        if activeFeatures.facebang and targetSettings.currentTarget and targetSettings.currentTarget.Character then
            modules.facebang = RunService.RenderStepped:Connect(function()
                if activeFeatures.facebang and targetSettings.currentTarget and targetSettings.currentTarget.Character then
                    local targetHRP = targetSettings.currentTarget.Character:FindFirstChild("HumanoidRootPart")
                    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP and myHRP then
                        myHRP.CFrame = CFrame.new(myHRP.Position, targetHRP.Position)
                    end
                end
            end)
        else
            if modules.facebang then modules.facebang:Disconnect() end
        end
    end
    
    if input.KeyCode == Enum.KeyCode.V then
        activeFeatures.flashback = not activeFeatures.flashback
        if activeFeatures.flashback then
            local startPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
            modules.flashback = UserInputService.InputBegan:Connect(function(input2)
                if input2.KeyCode == Enum.KeyCode.V then
                    if startPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(startPos)
                    end
                end
            end)
        else
            if modules.flashback then modules.flashback:Disconnect() end
        end
    end
    
    if input.KeyCode == Enum.KeyCode.G then
        activeFeatures.antivoid = not activeFeatures.antivoid
        if activeFeatures.antivoid then
            modules.antivoid = RunService.Heartbeat:Connect(function()
                if activeFeatures.antivoid and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local pos = LocalPlayer.Character.HumanoidRootPart.Position
                    if pos.Y < -20 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
                    end
                end
            end)
        else
            if modules.antivoid then modules.antivoid:Disconnect() end
        end
    end
    
    if input.KeyCode == Enum.KeyCode.E then
        activeFeatures.esp = not activeFeatures.esp
        if activeFeatures.esp then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "288ESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.7
                    highlight.Adornee = player.Character
                    highlight.Parent = player.Character
                    if not modules.espConnections then modules.espConnections = {} end
                    modules.espConnections[player] = highlight
                end
            end
        else
            if modules.espConnections then
                for _, highlight in pairs(modules.espConnections) do
                    if highlight and highlight.Parent then highlight:Destroy() end
                end
                modules.espConnections = {}
            end
        end
    end
    
    if input.KeyCode == Enum.KeyCode.F then
        activeFeatures.aimbot = not activeFeatures.aimbot
        if activeFeatures.aimbot and targetSettings.currentTarget and targetSettings.currentTarget.Character then
            modules.aimbot = RunService.RenderStepped:Connect(function()
                if activeFeatures.aimbot and targetSettings.currentTarget and targetSettings.currentTarget.Character then
                    local targetHRP = targetSettings.currentTarget.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP and workspace.CurrentCamera then
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetHRP.Position)
                    end
                end
            end)
        else
            if modules.aimbot then modules.aimbot:Disconnect() end
        end
    end
end)

print("✅ 288 Panel v" .. VERSION .. " carregado!")
print("📌 Pressione B para abrir/fechar")
