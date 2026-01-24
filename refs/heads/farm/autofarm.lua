-- =========================
-- BONDSP AUTO KEYS (REAL ACTIONS)
-- =========================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

-- =========================
-- SISTEMA DE ACESSO E TAGS
-- =========================

local AccessLevels = {
    DEV = { 
        ids = {4885351053}, 
        color = Color3.fromRGB(255, 50, 50),
        tag = "[DEV]",
        priority = 3
    },
    Support = { 
        ids = {609332724}, 
        color = Color3.fromRGB(0, 170, 255),
        tag = "[SUPPORT]",
        priority = 2
    },
    User = { 
        ids = {}, 
        color = Color3.fromRGB(0, 255, 150),
        tag = "[USER]",
        priority = 1
    }
}

-- =========================
-- VARIÁVEIS GLOBAIS
-- =========================

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local backpack = player:WaitForChild("Backpack")

local localPlayerId = player.UserId
local localAccessLevel, localAccessData = nil, nil
local ScriptUsers = {}
local TagCache = {}
local ENABLED = false
local MENU_KEY = Enum.KeyCode.B

-- =========================
-- CONFIGURAÇÃO DAS TECLAS
-- =========================

local Keys = {
    W = {enabled=false, dir=Vector3.new(0,0,-1), interval=0.1, lastAction=0},
    A = {enabled=false, dir=Vector3.new(-1,0,0), interval=0.1, lastAction=0},
    S = {enabled=false, dir=Vector3.new(0,0,1), interval=0.1, lastAction=0},
    D = {enabled=false, dir=Vector3.new(1,0,0), interval=0.1, lastAction=0},
    SPACE = {enabled=false, interval=0.5, lastAction=0},
    ["1"] = {enabled=false, slot=1, interval=0.2, lastAction=0},
    ["2"] = {enabled=false, slot=2, interval=0.2, lastAction=0},
    ["3"] = {enabled=false, slot=3, interval=0.2, lastAction=0},
    ["4"] = {enabled=false, slot=4, interval=0.2, lastAction=0},
}

-- =========================
-- FUNÇÕES DO SISTEMA DE TAGS
-- =========================

local function getAccessLevel(playerId)
    for levelName, levelData in pairs(AccessLevels) do
        for _, id in ipairs(levelData.ids) do
            if playerId == id then
                return levelName, levelData
            end
        end
    end
    return "User", AccessLevels.User
end

local function showNotification(message, color)
    local notification = Instance.new("ScreenGui", player.PlayerGui)
    notification.Name = "ScriptNotification"
    notification.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    local frame = Instance.new("Frame", notification)
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(1, -320, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.2
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = color or Color3.fromRGB(0, 255, 100)
    stroke.Thickness = 2
    
    local icon = Instance.new("TextLabel", frame)
    icon.Size = UDim2.new(0, 40, 1, 0)
    icon.Text = "🛠️"
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 20
    icon.TextColor3 = Color3.new(1, 1, 1)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 45, 0, 0)
    label.Text = message
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    
    frame.Position = UDim2.new(1, 300, 0, 20)
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -320, 0, 20)
    })
    tweenIn:Play()
    
    task.delay(5, function()
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 300, 0, 20)
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()
        notification:Destroy()
    end)
end

local function createHeadTag(player, accessData)
    if not player or not player.Character then return end
    
    if TagCache[player] then
        TagCache[player]:Destroy()
        TagCache[player] = nil
    end
    
    local character = player.Character
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local tagGui = Instance.new("BillboardGui")
    tagGui.Name = "BondspTag"
    tagGui.Adornee = head
    tagGui.AlwaysOnTop = true
    tagGui.Size = UDim2.new(0, 200, 0, 50)
    tagGui.StudsOffset = Vector3.new(0, 2.5, 0)
    tagGui.MaxDistance = 100
    tagGui.Parent = head
    
    local container = Instance.new("Frame", tagGui)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    
    local tagFrame = Instance.new("Frame", container)
    tagFrame.Size = UDim2.new(0, 80, 0, 24)
    tagFrame.Position = UDim2.new(0.5, -40, 0, 0)
    tagFrame.BackgroundColor3 = accessData.color
    tagFrame.BackgroundTransparency = 0.2
    
    local tagCorner = Instance.new("UICorner", tagFrame)
    tagCorner.CornerRadius = UDim.new(0, 8)
    
    local tagStroke = Instance.new("UIStroke", tagFrame)
    tagStroke.Color = accessData.color
    tagStroke.Thickness = 2
    
    local tagLabel = Instance.new("TextLabel", tagFrame)
    tagLabel.Size = UDim2.new(1, 0, 1, 0)
    tagLabel.Text = accessData.tag
    tagLabel.BackgroundTransparency = 1
    tagLabel.Font = Enum.Font.GothamBold
    tagLabel.TextSize = 12
    tagLabel.TextColor3 = Color3.new(1, 1, 1)
    tagLabel.TextStrokeTransparency = 0.5
    tagLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    
    local nameFrame = Instance.new("Frame", container)
    nameFrame.Size = UDim2.new(0, 120, 0, 20)
    nameFrame.Position = UDim2.new(0.5, -60, 0, 25)
    nameFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    nameFrame.BackgroundTransparency = 0.3
    
    local nameCorner = Instance.new("UICorner", nameFrame)
    nameCorner.CornerRadius = UDim.new(0, 6)
    
    local nameLabel = Instance.new("TextLabel", nameFrame)
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.Text = player.DisplayName
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.TextSize = 11
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    
    local scriptIndicator = Instance.new("Frame", container)
    scriptIndicator.Size = UDim2.new(0, 100, 0, 18)
    scriptIndicator.Position = UDim2.new(0.5, -50, 0, 45)
    scriptIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    scriptIndicator.BackgroundTransparency = 0.8
    
    local indicatorCorner = Instance.new("UICorner", scriptIndicator)
    indicatorCorner.CornerRadius = UDim.new(0, 6)
    
    local indicatorLabel = Instance.new("TextLabel", scriptIndicator)
    indicatorLabel.Size = UDim2.new(1, 0, 1, 0)
    indicatorLabel.Text = "🛠️ USING SCRIPT"
    indicatorLabel.BackgroundTransparency = 1
    indicatorLabel.Font = Enum.Font.GothamBold
    indicatorLabel.TextSize = 10
    indicatorLabel.TextColor3 = Color3.new(1, 1, 1)
    
    tagFrame.Size = UDim2.new(0, 0, 0, 24)
    tagFrame.Position = UDim2.new(0.5, 0, 0, 0)
    
    local tween = TweenService:Create(tagFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 80, 0, 24),
        Position = UDim2.new(0.5, -40, 0, 0)
    })
    tween:Play()
    
    local pulseConnection
    pulseConnection = RunService.Heartbeat:Connect(function()
        local time = tick()
        local pulse = math.sin(time * 3) * 0.1 + 0.9
        tagFrame.BackgroundTransparency = 0.2 + (0.1 * (1 - pulse))
    end)
    
    TagCache[player] = {
        gui = tagGui,
        pulse = pulseConnection
    }
    
    local function cleanup()
        if TagCache[player] then
            if TagCache[player].pulse then
                TagCache[player].pulse:Disconnect()
            end
            if TagCache[player].gui then
                TagCache[player].gui:Destroy()
            end
            TagCache[player] = nil
        end
    end
    
    player.CharacterAdded:Connect(function()
        cleanup()
        task.wait(1)
        createHeadTag(player, accessData)
    end)
    
    player.CharacterRemoving:Connect(cleanup)
end

local function detectOtherScriptUsers()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local playerGui = otherPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local scriptGui = playerGui:FindFirstChild("bondsp_keys")
                if scriptGui then
                    local accessLevel, accessData = getAccessLevel(otherPlayer.UserId)
                    ScriptUsers[otherPlayer.UserId] = {
                        player = otherPlayer,
                        accessLevel = accessLevel,
                        accessData = accessData,
                        tagVisible = true,
                        detectedAt = os.time()
                    }
                    createHeadTag(otherPlayer, accessData)
                end
            end
        end
    end
end

local function monitorScriptUsers()
    while task.wait(3) do
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player and not ScriptUsers[otherPlayer.UserId] then
                local playerGui = otherPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    local scriptGui = playerGui:FindFirstChild("bondsp_keys")
                    if scriptGui then
                        local accessLevel, accessData = getAccessLevel(otherPlayer.UserId)
                        ScriptUsers[otherPlayer.UserId] = {
                            player = otherPlayer,
                            accessLevel = accessLevel,
                            accessData = accessData,
                            tagVisible = true
                        }
                        
                        createHeadTag(otherPlayer, accessData)
                        
                        showNotification(
                            string.format("%s entrou com o script! (%s)", 
                                otherPlayer.Name, accessData.tag),
                            accessData.color
                        )
                    end
                end
            end
        end
        
        for userId, userData in pairs(ScriptUsers) do
            if userId ~= localPlayerId then
                local stillInGame = false
                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer.UserId == userId then
                        stillInGame = true
                        break
                    end
                end
                
                if not stillInGame then
                    if TagCache[userData.player] then
                        TagCache[userData.player]:Destroy()
                    end
                    ScriptUsers[userId] = nil
                    
                    showNotification(
                        string.format("%s saiu do jogo", userData.player.Name),
                        Color3.fromRGB(255, 100, 100)
                    )
                end
            end
        end
    end
end

-- =========================
-- CONFIGURAÇÃO INICIAL DAS TAGS
-- =========================

localAccessLevel, localAccessData = getAccessLevel(localPlayerId)
ScriptUsers[localPlayerId] = {
    player = player,
    accessLevel = localAccessLevel,
    accessData = localAccessData,
    tagVisible = true,
    lastSeen = os.time()
}

task.wait(1)
createHeadTag(player, localAccessData)
detectOtherScriptUsers()

task.spawn(monitorScriptUsers)

showNotification(
    string.format("Script iniciado! Acesso: %s", localAccessData.tag),
    localAccessData.color
)

-- =========================
-- INTERFACE DO USUÁRIO
-- =========================

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "bondsp_keys"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 420, 0, 550)
main.Position = UDim2.new(0.5, -210, 0.5, -275)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
main.Visible = false
main.Active = true
main.Draggable = true
main.ClipsDescendants = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = localAccessData.color
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10, 0, 0)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = string.format("🔧 BONDSP AUTO KEYS | %s", localAccessData.tag)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = false
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)

closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

local scrollContainer = Instance.new("ScrollingFrame", main)
scrollContainer.Size = UDim2.new(1, 0, 1, -40)
scrollContainer.Position = UDim2.new(0, 0, 0, 40)
scrollContainer.BackgroundTransparency = 1
scrollContainer.BorderSizePixel = 0
scrollContainer.ScrollBarThickness = 4
scrollContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

local content = Instance.new("Frame", scrollContainer)
content.Size = UDim2.new(1, 0, 0, 0)
content.BackgroundTransparency = 1
content.AutomaticSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 15)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- =========================
-- TOGGLE GLOBAL
-- =========================

local globalContainer = Instance.new("Frame", content)
globalContainer.Size = UDim2.new(0.9, 0, 0, 50)
globalContainer.BackgroundTransparency = 1
globalContainer.LayoutOrder = 1

local globalBtn = Instance.new("TextButton", globalContainer)
globalBtn.Size = UDim2.new(1, 0, 1, 0)
globalBtn.Text = ""
globalBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
globalBtn.AutoButtonColor = false
Instance.new("UICorner", globalBtn).CornerRadius = UDim.new(0, 8)

local toggleCircle = Instance.new("Frame", globalBtn)
toggleCircle.Size = UDim2.new(0, 20, 0, 20)
toggleCircle.Position = UDim2.new(0, 15, 0.5, -10)
toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)

local toggleLabel = Instance.new("TextLabel", globalBtn)
toggleLabel.Size = UDim2.new(1, -50, 1, 0)
toggleLabel.Position = UDim2.new(0, 50, 0, 0)
toggleLabel.Text = "SISTEMA DESATIVADO"
toggleLabel.BackgroundTransparency = 1
toggleLabel.Font = Enum.Font.GothamSemibold
toggleLabel.TextSize = 14
toggleLabel.TextColor3 = Color3.new(1, 1, 1)
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

globalBtn.MouseEnter:Connect(function()
    globalBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
end)

globalBtn.MouseLeave:Connect(function()
    globalBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
end)

globalBtn.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    
    if ENABLED then
        local tween = TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(80, 200, 120),
            Position = UDim2.new(1, -40, 0.5, -10)
        })
        tween:Play()
        globalBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 70)
        toggleLabel.Text = "SISTEMA ATIVADO"
    else
        local tween = TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 80, 80),
            Position = UDim2.new(0, 15, 0.5, -10)
        })
        tween:Play()
        globalBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        toggleLabel.Text = "SISTEMA DESATIVADO"
    end
end)

-- =========================
-- FUNÇÃO PARA CRIAR CONTROLE DE KEY
-- =========================

local function createKeyControl(keyName, keyData, layoutOrder)
    local keyContainer = Instance.new("Frame", content)
    keyContainer.Size = UDim2.new(0.9, 0, 0, 80)
    keyContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    keyContainer.LayoutOrder = layoutOrder
    Instance.new("UICorner", keyContainer).CornerRadius = UDim.new(0, 8)
    
    local header = Instance.new("Frame", keyContainer)
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    header.BorderSizePixel = 0
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8, 0, 0)
    
    local keyLabel = Instance.new("TextLabel", header)
    keyLabel.Size = UDim2.new(0, 100, 1, 0)
    keyLabel.Position = UDim2.new(0, 10, 0, 0)
    keyLabel.Text = "Tecla ["..keyName.."]"
    keyLabel.BackgroundTransparency = 1
    keyLabel.Font = Enum.Font.GothamMedium
    keyLabel.TextSize = 14
    keyLabel.TextColor3 = Color3.new(1, 1, 1)
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBtn = Instance.new("TextButton", header)
    toggleBtn.Size = UDim2.new(0, 70, 0, 22)
    toggleBtn.Position = UDim2.new(1, -85, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    toggleBtn.Text = "OFF"
    toggleBtn.Font = Enum.Font.GothamMedium
    toggleBtn.TextSize = 12
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.AutoButtonColor = false
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    
    local toggleCircle = Instance.new("Frame", toggleBtn)
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = UDim2.new(0, 3, 0.5, -8)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)
    
    local intervalContainer = Instance.new("Frame", keyContainer)
    intervalContainer.Size = UDim2.new(1, -20, 0, 40)
    intervalContainer.Position = UDim2.new(0, 10, 0, 35)
    intervalContainer.BackgroundTransparency = 1
    
    local intervalLabel = Instance.new("TextLabel", intervalContainer)
    intervalLabel.Size = UDim2.new(0, 100, 1, 0)
    intervalLabel.Text = "Intervalo: "..string.format("%.2f", keyData.interval).."s"
    intervalLabel.BackgroundTransparency = 1
    intervalLabel.Font = Enum.Font.Gotham
    intervalLabel.TextSize = 12
    intervalLabel.TextColor3 = Color3.new(1, 1, 1)
    intervalLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local intervalSlider = Instance.new("Frame", intervalContainer)
    intervalSlider.Size = UDim2.new(0, 180, 0, 20)
    intervalSlider.Position = UDim2.new(1, -180, 0.5, -10)
    intervalSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Instance.new("UICorner", intervalSlider).CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame", intervalSlider)
    sliderFill.Size = UDim2.new((keyData.interval - 0.05) / 0.95, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(80, 140, 200)
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    
    local sliderDot = Instance.new("TextButton", intervalSlider)
    sliderDot.Size = UDim2.new(0, 24, 0, 24)
    sliderDot.Position = UDim2.new((keyData.interval - 0.05) / 0.95, -12, 0.5, -12)
    sliderDot.Text = ""
    sliderDot.BackgroundColor3 = Color3.fromRGB(100, 160, 220)
    sliderDot.AutoButtonColor = false
    Instance.new("UICorner", sliderDot).CornerRadius = UDim.new(1, 0)
    
    local minLabel = Instance.new("TextLabel", intervalContainer)
    minLabel.Size = UDim2.new(0, 30, 0, 15)
    minLabel.Position = UDim2.new(0, 180, 1, -12)
    minLabel.Text = "0.05"
    minLabel.BackgroundTransparency = 1
    minLabel.Font = Enum.Font.Gotham
    minLabel.TextSize = 10
    minLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    local maxLabel = Instance.new("TextLabel", intervalContainer)
    maxLabel.Size = UDim2.new(0, 30, 0, 15)
    maxLabel.Position = UDim2.new(1, -30, 1, -12)
    maxLabel.Text = "1.0"
    maxLabel.BackgroundTransparency = 1
    maxLabel.Font = Enum.Font.Gotham
    maxLabel.TextSize = 10
    maxLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    local function updateSlider(value)
        value = math.clamp(value, 0.05, 1.0)
        keyData.interval = value
        intervalLabel.Text = "Intervalo: "..string.format("%.2f", value).."s"
        
        local fillSize = (value - 0.05) / 0.95
        sliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        sliderDot.Position = UDim2.new(fillSize, -12, 0.5, -12)
    end
    
    local dragging = false
    
    sliderDot.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = game:GetService("Players").LocalPlayer:GetMouse()
            local sliderAbsolute = intervalSlider.AbsolutePosition
            local sliderSize = intervalSlider.AbsoluteSize
            
            local relativeX = math.clamp(
                (mouse.X - sliderAbsolute.X) / sliderSize.X,
                0, 1
            )
            
            local value = 0.05 + (relativeX * 0.95)
            updateSlider(value)
        end
    end)
    
    toggleBtn.MouseButton1Click:Connect(function()
        keyData.enabled = not keyData.enabled
        
        if keyData.enabled then
            local tween = TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(80, 200, 120),
                Position = UDim2.new(1, -19, 0.5, -8)
            })
            tween:Play()
            
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 70)
            keyContainer.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
        else
            local tween = TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(150, 150, 150),
                Position = UDim2.new(0, 3, 0.5, -8)
            })
            tween:Play()
            
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            keyContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        end
    end)
    
    toggleBtn.MouseEnter:Connect(function()
        if keyData.enabled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 110, 80)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
        end
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        if keyData.enabled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 70)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        end
    end)
    
    return keyContainer
end

-- =========================
-- SEÇÃO DE MOVIMENTO
-- =========================

local movementTitle = Instance.new("TextLabel", content)
movementTitle.Size = UDim2.new(0.9, 0, 0, 20)
movementTitle.Text = "🎮 CONTROLES DE MOVIMENTO"
movementTitle.BackgroundTransparency = 1
movementTitle.Font = Enum.Font.GothamSemibold
movementTitle.TextSize = 13
movementTitle.TextColor3 = Color3.new(1, 1, 1)
movementTitle.TextXAlignment = Enum.TextXAlignment.Left
movementTitle.LayoutOrder = 2

local movementKeys = {"W", "A", "S", "D", "SPACE"}
for i, keyName in ipairs(movementKeys) do
    createKeyControl(keyName, Keys[keyName], 2 + i)
end

-- =========================
-- SEPARADOR
-- =========================

local separator = Instance.new("Frame", content)
separator.Size = UDim2.new(0.9, 0, 0, 1)
separator.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
separator.BorderSizePixel = 0
separator.LayoutOrder = #movementKeys + 3

-- =========================
-- SEÇÃO DE AÇÕES
-- =========================

local actionsTitle = Instance.new("TextLabel", content)
actionsTitle.Size = UDim2.new(0.9, 0, 0, 20)
actionsTitle.Text = "⚡ AÇÕES (SLOTS 1-4)"
actionsTitle.BackgroundTransparency = 1
actionsTitle.Font = Enum.Font.GothamSemibold
actionsTitle.TextSize = 13
actionsTitle.TextColor3 = Color3.new(1, 1, 1)
actionsTitle.TextXAlignment = Enum.TextXAlignment.Left
actionsTitle.LayoutOrder = #movementKeys + 4

local actionKeys = {"1", "2", "3", "4"}
for i, keyName in ipairs(actionKeys) do
    createKeyControl(keyName, Keys[keyName], #movementKeys + 4 + i)
end

-- =========================
-- SEÇÃO DE USUÁRIOS ONLINE
-- =========================

local usersSection = Instance.new("Frame", content)
usersSection.Size = UDim2.new(0.9, 0, 0, 200)
usersSection.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
usersSection.LayoutOrder = #movementKeys + #actionKeys + 5
Instance.new("UICorner", usersSection).CornerRadius = UDim.new(0, 8)

local usersTitle = Instance.new("TextLabel", usersSection)
usersTitle.Size = UDim2.new(1, 0, 0, 30)
usersTitle.Text = "🌐 USUÁRIOS DO SCRIPT"
usersTitle.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
usersTitle.Font = Enum.Font.GothamSemibold
usersTitle.TextSize = 13
usersTitle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", usersTitle).CornerRadius = UDim.new(0, 8, 0, 0)

local userCountLabel = Instance.new("TextLabel", usersSection)
userCountLabel.Size = UDim2.new(1, 0, 0, 20)
userCountLabel.Position = UDim2.new(0, 0, 0, 30)
userCountLabel.Text = "👥 Carregando..."
userCountLabel.BackgroundTransparency = 1
userCountLabel.Font = Enum.Font.GothamMedium
userCountLabel.TextSize = 12
userCountLabel.TextColor3 = Color3.fromRGB(180, 180, 180)

local usersListContainer = Instance.new("ScrollingFrame", usersSection)
usersListContainer.Size = UDim2.new(1, -10, 1, -80)
usersListContainer.Position = UDim2.new(0, 5, 0, 55)
usersListContainer.BackgroundTransparency = 1
usersListContainer.ScrollBarThickness = 4
usersListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
usersListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

local usersListLayout = Instance.new("UIListLayout", usersListContainer)
usersListLayout.Padding = UDim.new(0, 5)

local function updateUserList()
    for _, child in ipairs(usersListContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local userCount = 0
    
    local localEntry = Instance.new("Frame", usersListContainer)
    localEntry.Size = UDim2.new(1, -10, 0, 30)
    localEntry.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
    localEntry.BorderSizePixel = 0
    
    local localCorner = Instance.new("UICorner", localEntry)
    localCorner.CornerRadius = UDim.new(0, 6)
    
    local localTag = Instance.new("TextLabel", localEntry)
    localTag.Size = UDim2.new(0, 60, 1, 0)
    localTag.Position = UDim2.new(0, 5, 0, 0)
    localTag.Text = localAccessData.tag
    localTag.BackgroundTransparency = 1
    localTag.Font = Enum.Font.GothamBold
    localTag.TextSize = 11
    localTag.TextColor3 = localAccessData.color
    
    local localName = Instance.new("TextLabel", localEntry)
    localName.Size = UDim2.new(1, -70, 1, 0)
    localName.Position = UDim2.new(0, 65, 0, 0)
    localName.Text = player.Name .. " (Você)"
    localName.BackgroundTransparency = 1
    localName.Font = Enum.Font.GothamMedium
    localName.TextSize = 12
    localName.TextColor3 = Color3.new(1, 1, 1)
    localName.TextXAlignment = Enum.TextXAlignment.Left
    
    userCount = userCount + 1
    
    for userId, userData in pairs(ScriptUsers) do
        if userId ~= localPlayerId and userData.player then
            userCount = userCount + 1
            
            local userEntry = Instance.new("Frame", usersListContainer)
            userEntry.Size = UDim2.new(1, -10, 0, 25)
            userEntry.BackgroundColor3 = Color3.fromRGB(35, 40, 45)
            userEntry.BorderSizePixel = 0
            
            local userCorner = Instance.new("UICorner", userEntry)
            userCorner.CornerRadius = UDim.new(0, 6)
            
            local userTag = Instance.new("TextLabel", userEntry)
            userTag.Size = UDim2.new(0, 50, 1, 0)
            userTag.Position = UDim2.new(0, 5, 0, 0)
            userTag.Text = userData.accessData.tag
            userTag.BackgroundTransparency = 1
            userTag.Font = Enum.Font.GothamBold
            userTag.TextSize = 10
            userTag.TextColor3 = userData.accessData.color
            
            local userName = Instance.new("TextLabel", userEntry)
            userName.Size = UDim2.new(1, -60, 1, 0)
            userName.Position = UDim2.new(0, 55, 0, 0)
            userName.Text = userData.player.Name
            userName.BackgroundTransparency = 1
            userName.Font = Enum.Font.Gotham
            userName.TextSize = 11
            userName.TextColor3 = Color3.fromRGB(200, 200, 200)
            userName.TextXAlignment = Enum.TextXAlignment.Left
        end
    end
    
    userCountLabel.Text = string.format("👥 Usuários Online: %d", userCount)
end

local refreshBtn = Instance.new("TextButton", usersSection)
refreshBtn.Size = UDim2.new(0, 100, 0, 25)
refreshBtn.Position = UDim2.new(0.5, -50, 1, -30)
refreshBtn.Text = "🔄 Atualizar"
refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 200)
refreshBtn.Font = Enum.Font.GothamMedium
refreshBtn.TextSize = 12
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)

refreshBtn.MouseButton1Click:Connect(function()
    updateUserList()
end)

-- =========================
-- RODAPÉ
-- =========================

local footer = Instance.new("TextLabel", content)
footer.Size = UDim2.new(0.9, 0, 0, 40)
footer.Text = string.format("💡 Pressione [B] para abrir/fechar\n🔑 Seu acesso: %s", localAccessData.tag)
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.Gotham
footer.TextSize = 11
footer.TextColor3 = Color3.fromRGB(150, 150, 150)
footer.TextYAlignment = Enum.TextYAlignment.Top
footer.TextWrapped = true
footer.LayoutOrder = #movementKeys + #actionKeys + 6

-- =========================
-- FUNÇÕES DO SCRIPT
-- =========================

local function activateTool(slot)
    local tools = {}
    for _,t in ipairs(backpack:GetChildren()) do
        if t:IsA("Tool") then
            table.insert(tools, t)
        end
    end

    local tool = tools[slot]
    if tool then
        humanoid:EquipTool(tool)
        tool:Activate()
    end
end

local lastUpdate = tick()

RunService.RenderStepped:Connect(function()
    local currentTime = tick()
    
    if not ENABLED or humanoid.Health <= 0 then return end
    
    local moveVec = Vector3.zero
    for _,k in pairs({"W","A","S","D"}) do
        if Keys[k].enabled then
            moveVec += Keys[k].dir
        end
    end

    if moveVec.Magnitude > 0 then
        humanoid:Move(moveVec.Unit, true)
    end

    for _, keyName in ipairs({"SPACE", "1", "2", "3", "4"}) do
        local keyData = Keys[keyName]
        if keyData.enabled then
            if currentTime - keyData.lastAction >= keyData.interval then
                keyData.lastAction = currentTime
                
                if keyName == "SPACE" then
                    humanoid.Jump = true
                else
                    activateTool(keyData.slot)
                end
            end
        end
    end
end)

-- =========================
-- CONTROLE DO MENU
-- =========================

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == MENU_KEY then
        main.Visible = not main.Visible
        
        if main.Visible then
            main.Position = UDim2.new(0.5, -210, 0.5, -325)
            main.Size = UDim2.new(0, 420, 0, 0)
            
            local tween = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 420, 0, 550),
                Position = UDim2.new(0.5, -210, 0.5, -275)
            })
            tween:Play()
            
            updateUserList()
        end
    end
end)

-- =========================
-- ATUALIZAÇÃO PERIÓDICA
-- =========================

task.spawn(function()
    while task.wait(3) do
        if main.Visible then
            updateUserList()
        end
    end
end)

-- =========================
-- RESPAWN FIX
-- =========================

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
end)

-- =========================
-- INICIALIZAÇÃO
-- =========================

updateUserList()

print("====================================")
print(string.format("BONDSP AUTO KEYS - Acesso: %s", localAccessData.tag))
print("Pressione B para abrir o menu")
print("Usuários do script serão marcados")
print("====================================")
