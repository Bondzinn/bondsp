-- =========================
-- BONDSP AUTO KEYS (REAL ACTIONS)
-- =========================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- =========================
-- SISTEMA DE ACESSO E TAGS
-- =========================

local AccessLevels = {
    DEV = { 
        ids = {4885351053}, 
        color = Color3.fromRGB(255, 50, 50),
        tag = "[DEV]",
        priority = 4,
        canHideTag = true
    },
    Support = { 
        ids = {609332724}, 
        color = Color3.fromRGB(0, 170, 255),
        tag = "[SUPPORT]",
        priority = 3,
        canHideTag = true
    },
    VIP = {
        ids = {}, -- Adicione IDs VIP aqui
        color = Color3.fromRGB(255, 215, 0),
        tag = "[VIP]",
        priority = 2,
        canHideTag = true
    },
    User = { 
        ids = {}, 
        color = Color3.fromRGB(0, 255, 150),
        tag = "[USER]",
        priority = 1,
        canHideTag = false
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
local ScriptUsers = {} -- Armazena TODOS os usuários do script
local TagCache = {} -- Cache das tags visíveis
local ENABLED = false
local MENU_KEY = Enum.KeyCode.B
local LocalHideTag = false -- Se o usuário local escolheu esconder a tag
local SCRIPT_IDENTIFIER = "BONDSP_SCRIPT_V2" -- Identificador único do script

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
-- SISTEMA DE COMUNICAÇÃO ENTRE SCRIPTS
-- =========================

-- Criar um identificador único para este cliente
local CLIENT_ID = HttpService:GenerateGUID(false)
local LAST_BROADCAST = 0
local BROADCAST_INTERVAL = 5 -- Segundos entre broadcasts

-- Função para broadcastar nossa presença
local function broadcastPresence()
    local currentTime = os.time()
    if currentTime - LAST_BROADCAST < BROADCAST_INTERVAL then return end
    LAST_BROADCAST = currentTime
    
    -- Enviar nossa presença de forma segura
    local presenceData = {
        scriptId = SCRIPT_IDENTIFIER,
        clientId = CLIENT_ID,
        userId = localPlayerId,
        accessLevel = localAccessLevel,
        timestamp = currentTime,
        hideTag = LocalHideTag
    }
    
    -- Usar diferentes métodos para detecção
    -- Método 1: Verificar se tem o mesmo GUI
    -- Método 2: Verificar se responde a ping
    -- Método 3: Verificar variáveis compartilhadas
end

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

local function showNotification(message, color, duration)
    duration = duration or 5
    
    local notification = Instance.new("ScreenGui", player.PlayerGui)
    notification.Name = "ScriptNotification_" .. HttpService:GenerateGUID(false)
    notification.ZIndexBehavior = Enum.ZIndexBehavior.Global
    notification.IgnoreGuiInset = true
    
    local frame = Instance.new("Frame", notification)
    frame.Size = UDim2.new(0, 320, 0, 70)
    frame.Position = UDim2.new(1, -340, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BackgroundTransparency = 0.1
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = color or localAccessData.color
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    
    -- Glow effect
    local glow = Instance.new("Frame", frame)
    glow.Size = UDim2.new(1, 6, 1, 6)
    glow.Position = UDim2.new(0, -3, 0, -3)
    glow.BackgroundColor3 = color or localAccessData.color
    glow.BackgroundTransparency = 0.8
    glow.ZIndex = -1
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 12)
    
    local icon = Instance.new("TextLabel", frame)
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0, 10, 0.5, -25)
    icon.Text = "🔧"
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 28
    icon.TextColor3 = Color3.new(1, 1, 1)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -70, 1, -20)
    label.Position = UDim2.new(0, 65, 0, 10)
    label.Text = message
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    
    -- Animação de entrada
    frame.Position = UDim2.new(1, 400, 0, 20)
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -340, 0, 20)
    })
    tweenIn:Play()
    
    -- Fade out do glow
    TweenService:Create(glow, TweenInfo.new(0.8), {
        BackgroundTransparency = 0.95
    }):Play()
    
    -- Remover após delay
    task.delay(duration, function()
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 400, 0, 20),
            BackgroundTransparency = 1
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()
        notification:Destroy()
    end)
end

-- Função para criar tag na cabeça do jogador
local function createHeadTag(targetPlayer, accessData, hideTag)
    if not targetPlayer or not targetPlayer.Character then 
        return nil
    end
    
    -- Remover tag existente
    if TagCache[targetPlayer] then
        TagCache[targetPlayer].gui:Destroy()
        TagCache[targetPlayer] = nil
    end
    
    -- Se o usuário escolheu esconder a tag, não criar
    if hideTag then return nil end
    
    local character = targetPlayer.Character
    local head = character:WaitForChild("Head", 5)
    if not head then return nil end
    
    -- Criar tag simplificada - BALÃO MAIS ALTO E VISÍVEL
    local tagGui = Instance.new("BillboardGui")
    tagGui.Name = "BondspTag_" .. targetPlayer.UserId
    tagGui.Adornee = head
    tagGui.AlwaysOnTop = true
    tagGui.Size = UDim2.new(0, 90, 0, 35)
    tagGui.StudsOffset = Vector3.new(0, 3.2, 0) -- Aumentado para 3.2 studs
    tagGui.MaxDistance = 200 -- Aumentado para melhor visibilidade
    tagGui.Active = true
    tagGui.Parent = head
    
    -- Container principal
    local container = Instance.new("Frame", tagGui)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    container.BackgroundTransparency = 0.15
    
    local containerCorner = Instance.new("UICorner", container)
    containerCorner.CornerRadius = UDim.new(0, 8)
    
    local containerStroke = Instance.new("UIStroke", container)
    containerStroke.Color = accessData.color
    containerStroke.Thickness = 2.5
    containerStroke.Transparency = 0.3
    
    -- Glow effect
    local glow = Instance.new("Frame", container)
    glow.Size = UDim2.new(1, 8, 1, 8)
    glow.Position = UDim2.new(0, -4, 0, -4)
    glow.BackgroundColor3 = accessData.color
    glow.BackgroundTransparency = 0.85
    glow.ZIndex = -1
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 10)
    
    -- Tag label
    local tagLabel = Instance.new("TextLabel", container)
    tagLabel.Size = UDim2.new(1, -10, 1, -10)
    tagLabel.Position = UDim2.new(0, 5, 0, 5)
    tagLabel.Text = accessData.tag
    tagLabel.BackgroundTransparency = 1
    tagLabel.Font = Enum.Font.GothamBold
    tagLabel.TextSize = 16
    tagLabel.TextColor3 = accessData.color
    tagLabel.TextStrokeTransparency = 0.6
    tagLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    tagLabel.TextYAlignment = Enum.TextYAlignment.Center
    
    -- Efeito de entrada
    container.Size = UDim2.new(0, 0, 0, 0)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local tween = TweenService:Create(container, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0)
    })
    tween:Play()
    
    -- Animação de pulso suave
    local pulseConnection
    pulseConnection = RunService.Heartbeat:Connect(function()
        local time = tick()
        local pulse = (math.sin(time * 2) * 0.1) + 0.9
        containerStroke.Transparency = 0.3 + (0.2 * (1 - pulse))
        glow.BackgroundTransparency = 0.85 + (0.1 * (1 - pulse))
    end)
    
    TagCache[targetPlayer] = {
        gui = tagGui,
        pulse = pulseConnection,
        accessData = accessData
    }
    
    -- Conectar eventos para recriar tag quando personagem mudar
    local function cleanup()
        if TagCache[targetPlayer] then
            if TagCache[targetPlayer].pulse then
                TagCache[targetPlayer].pulse:Disconnect()
            end
            if TagCache[targetPlayer].gui then
                TagCache[targetPlayer].gui:Destroy()
            end
            TagCache[targetPlayer] = nil
        end
    end
    
    targetPlayer.CharacterAdded:Connect(function(newChar)
        cleanup()
        task.wait(1.5) -- Esperar character carregar
        createHeadTag(targetPlayer, accessData, hideTag)
    end)
    
    targetPlayer.CharacterRemoving:Connect(cleanup)
    
    return tagGui
end

-- Função para detectar outros usuários do script
local function detectOtherScriptUsers()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and not ScriptUsers[otherPlayer.UserId] then
            -- Método 1: Verificar se tem o GUI do script
            local playerGui = otherPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local scriptGui = playerGui:FindFirstChild("bondsp_keys")
                if scriptGui then
                    -- Usuário detectado pelo GUI
                    local accessLevel, accessData = getAccessLevel(otherPlayer.UserId)
                    
                    ScriptUsers[otherPlayer.UserId] = {
                        player = otherPlayer,
                        accessLevel = accessLevel,
                        accessData = accessData,
                        hideTag = false,
                        detectedAt = os.time(),
                        detectionMethod = "GUI"
                    }
                    
                    createHeadTag(otherPlayer, accessData, false)
                    
                    showNotification(
                        string.format("%s está usando o script %s", 
                            otherPlayer.Name, accessData.tag),
                        accessData.color,
                        4
                    )
                end
            end
            
            -- Método 2: Verificar backpack por ferramentas suspeitas (opcional)
            -- Método 3: Verificar se executa certas ações (opcional)
        end
    end
end

-- Função aprimorada para monitorar usuários do script
local function enhancedMonitorScriptUsers()
    while task.wait(2) do
        -- Broadcast nossa presença periodicamente
        broadcastPresence()
        
        -- Verificar novos jogadores
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                local userId = otherPlayer.UserId
                
                -- Se já detectamos, verificar se ainda está válido
                if ScriptUsers[userId] then
                    -- Verificar se o player ainda tem o script
                    local playerGui = otherPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        local scriptGui = playerGui:FindFirstChild("bondsp_keys")
                        if not scriptGui then
                            -- Player perdeu o script
                            if TagCache[otherPlayer] then
                                TagCache[otherPlayer].gui:Destroy()
                                TagCache[otherPlayer] = nil
                            end
                            ScriptUsers[userId] = nil
                            
                            showNotification(
                                string.format("%s parou de usar o script", otherPlayer.Name),
                                Color3.fromRGB(255, 100, 100),
                                3
                            )
                        end
                    end
                else
                    -- Tentar detectar novo usuário
                    local playerGui = otherPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        local scriptGui = playerGui:FindFirstChild("bondsp_keys")
                        if scriptGui then
                            local accessLevel, accessData = getAccessLevel(userId)
                            
                            ScriptUsers[userId] = {
                                player = otherPlayer,
                                accessLevel = accessLevel,
                                accessData = accessData,
                                hideTag = false,
                                detectedAt = os.time(),
                                detectionMethod = "GUI"
                            }
                            
                            createHeadTag(otherPlayer, accessData, false)
                            
                            showNotification(
                                string.format("%s está usando o script %s", 
                                    otherPlayer.Name, accessData.tag),
                                accessData.color,
                                4
                            )
                        end
                    end
                end
            end
        end
        
        -- Limpar usuários que saíram do jogo
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
                        TagCache[userData.player].gui:Destroy()
                        TagCache[userData.player] = nil
                    end
                    ScriptUsers[userId] = nil
                end
            end
        end
    end
end

-- =========================
-- INICIALIZAÇÃO DAS TAGS
-- =========================

localAccessLevel, localAccessData = getAccessLevel(localPlayerId)

-- Registrar usuário local
ScriptUsers[localPlayerId] = {
    player = player,
    accessLevel = localAccessLevel,
    accessData = localAccessData,
    hideTag = LocalHideTag,
    detectedAt = os.time(),
    detectionMethod = "SELF"
}

-- Não criar tag para si mesmo (a menos que queira ver)
-- createHeadTag(player, localAccessData, LocalHideTag)

-- Detectar outros usuários
task.wait(1)
detectOtherScriptUsers()

-- Iniciar monitoramento aprimorado
task.spawn(enhancedMonitorScriptUsers)

showNotification(
    string.format("Script iniciado! | Acesso: %s", localAccessData.tag),
    localAccessData.color,
    5
)

print("====================================")
print(string.format("BONDSP AUTO KEYS - Acesso: %s", localAccessData.tag))
print("ID do Cliente: " .. CLIENT_ID)
print("Pressione B para abrir o menu")
print("Detectando outros usuários do script...")
print("====================================")

-- =========================
-- INTERFACE DO USUÁRIO - DESIGN MELHORADO
-- =========================

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "bondsp_keys"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.IgnoreGuiInset = true

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 440, 0, 580)
main.Position = UDim2.new(0.5, -220, 0.5, -290)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.Visible = false
main.Active = true
main.Draggable = true
main.ClipsDescendants = true

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 12)

-- Shadow effect
local shadow = Instance.new("ImageLabel", main)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.85
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Size = UDim2.new(1, 24, 1, 24)
shadow.Position = UDim2.new(0, -12, 0, -12)
shadow.BackgroundTransparency = 1
shadow.ZIndex = -1

local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = localAccessData.color
titleBar.BorderSizePixel = 0
local titleBarCorner = Instance.new("UICorner", titleBar)
titleBarCorner.CornerRadius = UDim.new(0, 12, 0, 0)

-- Gradient effect no título
local titleGradient = Instance.new("UIGradient", titleBar)
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, localAccessData.color),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(
        math.clamp(localAccessData.color.R * 255 * 0.7, 0, 255),
        math.clamp(localAccessData.color.G * 255 * 0.7, 0, 255),
        math.clamp(localAccessData.color.B * 255 * 0.7, 0, 255)
    ))
})
titleGradient.Rotation = 90

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = string.format("🔧 BONDSP AUTO KEYS  |  %s", localAccessData.tag)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextStrokeTransparency = 0.8
title.TextStrokeColor3 = Color3.new(0, 0, 0)

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -37, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = false
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 8)

-- Hover effects para close button
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 80, 80),
        Rotation = 180
    }):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
        Rotation = 0
    }):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

local scrollContainer = Instance.new("ScrollingFrame", main)
scrollContainer.Size = UDim2.new(1, 0, 1, -45)
scrollContainer.Position = UDim2.new(0, 0, 0, 45)
scrollContainer.BackgroundTransparency = 1
scrollContainer.BorderSizePixel = 0
scrollContainer.ScrollBarThickness = 6
scrollContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
scrollContainer.ScrollBarImageTransparency = 0.5
scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollContainer.ScrollingDirection = Enum.ScrollingDirection.Y

local content = Instance.new("Frame", scrollContainer)
content.Size = UDim2.new(1, 0, 0, 0)
content.BackgroundTransparency = 1
content.AutomaticSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 16)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- =========================
-- TOGGLE GLOBAL - DESIGN MELHORADO
-- =========================

local globalContainer = Instance.new("Frame", content)
globalContainer.Size = UDim2.new(0.92, 0, 0, 55)
globalContainer.BackgroundTransparency = 1
globalContainer.LayoutOrder = 1

local globalBtn = Instance.new("TextButton", globalContainer)
globalBtn.Size = UDim2.new(1, 0, 1, 0)
globalBtn.Text = ""
globalBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
globalBtn.AutoButtonColor = false
local globalCorner = Instance.new("UICorner", globalBtn)
globalCorner.CornerRadius = UDim.new(0, 10)

local globalStroke = Instance.new("UIStroke", globalBtn)
globalStroke.Color = Color3.fromRGB(60, 60, 65)
globalStroke.Thickness = 2

-- Toggle indicator
local toggleContainer = Instance.new("Frame", globalBtn)
toggleContainer.Size = UDim2.new(0, 100, 0, 30)
toggleContainer.Position = UDim2.new(0.5, -50, 0.5, -15)
toggleContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
toggleContainer.BackgroundTransparency = 0.5
local toggleCorner = Instance.new("UICorner", toggleContainer)
toggleCorner.CornerRadius = UDim.new(1, 0)

local toggleCircle = Instance.new("Frame", toggleContainer)
toggleCircle.Size = UDim2.new(0, 24, 0, 24)
toggleCircle.Position = ENABLED and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
toggleCircle.BackgroundColor3 = ENABLED and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 80, 80)
local circleCorner = Instance.new("UICorner", toggleCircle)
circleCorner.CornerRadius = UDim.new(1, 0)

local toggleLabel = Instance.new("TextLabel", globalBtn)
toggleLabel.Size = UDim2.new(1, -120, 1, 0)
toggleLabel.Position = UDim2.new(0, 110, 0, 0)
toggleLabel.Text = ENABLED and "🟢 SISTEMA ATIVADO" or "🔴 SISTEMA DESATIVADO"
toggleLabel.BackgroundTransparency = 1
toggleLabel.Font = Enum.Font.GothamSemibold
toggleLabel.TextSize = 14
toggleLabel.TextColor3 = ENABLED and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Hover effects
globalBtn.MouseEnter:Connect(function()
    TweenService:Create(globalBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    }):Play()
end)

globalBtn.MouseLeave:Connect(function()
    TweenService:Create(globalBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    }):Play()
end)

globalBtn.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    
    if ENABLED then
        TweenService:Create(toggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(80, 200, 120),
            Position = UDim2.new(1, -27, 0.5, -12)
        }):Play()
        toggleLabel.Text = "🟢 SISTEMA ATIVADO"
        toggleLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    else
        TweenService:Create(toggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(255, 80, 80),
            Position = UDim2.new(0, 3, 0.5, -12)
        }):Play()
        toggleLabel.Text = "🔴 SISTEMA DESATIVADO"
        toggleLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    end
end)

-- =========================
-- OPÇÃO PARA ESCONDER TAG (VIP+) - DESIGN MELHORADO
-- =========================

local hideTagContainer
if localAccessData.canHideTag then
    hideTagContainer = Instance.new("Frame", content)
    hideTagContainer.Size = UDim2.new(0.92, 0, 0, 60)
    hideTagContainer.BackgroundTransparency = 1
    hideTagContainer.LayoutOrder = 2
    
    local hideTagBtn = Instance.new("TextButton", hideTagContainer)
    hideTagBtn.Size = UDim2.new(1, 0, 1, 0)
    hideTagBtn.Text = ""
    hideTagBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    hideTagBtn.AutoButtonColor = false
    local hideTagCorner = Instance.new("UICorner", hideTagBtn)
    hideTagCorner.CornerRadius = UDim.new(0, 10)
    
    local hideTagStroke = Instance.new("UIStroke", hideTagBtn)
    hideTagStroke.Color = Color3.fromRGB(65, 65, 70)
    hideTagStroke.Thickness = 2
    
    -- Icon
    local hideIcon = Instance.new("TextLabel", hideTagBtn)
    hideIcon.Size = UDim2.new(0, 40, 0, 40)
    hideIcon.Position = UDim2.new(0, 15, 0.5, -20)
    hideIcon.Text = "🏷️"
    hideIcon.BackgroundTransparency = 1
    hideIcon.Font = Enum.Font.GothamBold
    hideIcon.TextSize = 24
    hideIcon.TextColor3 = Color3.new(1, 1, 1)
    
    -- Toggle para exibição de tag
    local tagToggleContainer = Instance.new("Frame", hideTagBtn)
    tagToggleContainer.Size = UDim2.new(0, 80, 0, 32)
    tagToggleContainer.Position = UDim2.new(1, -90, 0.5, -16)
    tagToggleContainer.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
    local tagToggleCorner = Instance.new("UICorner", tagToggleContainer)
    tagToggleCorner.CornerRadius = UDim.new(1, 0)
    
    local tagToggleCircle = Instance.new("Frame", tagToggleContainer)
    tagToggleCircle.Size = UDim2.new(0, 26, 0, 26)
    tagToggleCircle.Position = LocalHideTag and UDim2.new(0, 3, 0.5, -13) or UDim2.new(1, -29, 0.5, -13)
    tagToggleCircle.BackgroundColor3 = LocalHideTag and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(80, 200, 120)
    local tagCircleCorner = Instance.new("UICorner", tagToggleCircle)
    tagCircleCorner.CornerRadius = UDim.new(1, 0)
    
    -- Labels
    local hideLabel = Instance.new("TextLabel", hideTagBtn)
    hideLabel.Size = UDim2.new(1, -140, 0, 24)
    hideLabel.Position = UDim2.new(0, 65, 0, 10)
    hideLabel.Text = "EXIBIÇÃO DA TAG"
    hideLabel.BackgroundTransparency = 1
    hideLabel.Font = Enum.Font.GothamSemibold
    hideLabel.TextSize = 14
    hideLabel.TextColor3 = Color3.new(1, 1, 1)
    hideLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local statusLabel = Instance.new("TextLabel", hideTagBtn)
    statusLabel.Size = UDim2.new(1, -140, 0, 20)
    statusLabel.Position = UDim2.new(0, 65, 0, 34)
    statusLabel.Text = LocalHideTag and "🔴 SUA TAG ESTÁ OCULTA" or "🟢 SUA TAG ESTÁ VISÍVEL"
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 12
    statusLabel.TextColor3 = LocalHideTag and Color3.fromRGB(255, 150, 150) or Color3.fromRGB(150, 255, 150)
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Hover effects
    hideTagBtn.MouseEnter:Connect(function()
        TweenService:Create(hideTagBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        }):Play()
    end)
    
    hideTagBtn.MouseLeave:Connect(function()
        TweenService:Create(hideTagBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        }):Play()
    end)
    
    hideTagBtn.MouseButton1Click:Connect(function()
        LocalHideTag = not LocalHideTag
        
        -- Animar o toggle
        if LocalHideTag then
            TweenService:Create(tagToggleCircle, TweenInfo.new(0.25), {
                BackgroundColor3 = Color3.fromRGB(255, 80, 80),
                Position = UDim2.new(0, 3, 0.5, -13)
            }):Play()
            statusLabel.Text = "🔴 SUA TAG ESTÁ OCULTA"
            statusLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
        else
            TweenService:Create(tagToggleCircle, TweenInfo.new(0.25), {
                BackgroundColor3 = Color3.fromRGB(80, 200, 120),
                Position = UDim2.new(1, -29, 0.5, -13)
            }):Play()
            statusLabel.Text = "🟢 SUA TAG ESTÁ VISÍVEL"
            statusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
        end
        
        -- Atualizar tag própria
        ScriptUsers[localPlayerId].hideTag = LocalHideTag
        if TagCache[player] then
            TagCache[player].gui:Destroy()
            TagCache[player] = nil
        end
        
        if not LocalHideTag then
            createHeadTag(player, localAccessData, false)
        end
        
        -- Atualizar footer
        if footer then
            footer.Text = string.format("💡 Pressione [B] para abrir/fechar\n🔑 Seu acesso: %s | Tag: %s", localAccessData.tag, LocalHideTag and "OFF" or "ON")
        end
    end)
end

-- =========================
-- FUNÇÃO PARA CRIAR CONTROLE DE KEY - DESIGN MELHORADO
-- =========================

local function createKeyControl(keyName, keyData, layoutOrder)
    local keyContainer = Instance.new("Frame", content)
    keyContainer.Size = UDim2.new(0.92, 0, 0, 85)
    keyContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    keyContainer.LayoutOrder = layoutOrder
    local keyCorner = Instance.new("UICorner", keyContainer)
    keyCorner.CornerRadius = UDim.new(0, 10)
    
    local keyStroke = Instance.new("UIStroke", keyContainer)
    keyStroke.Color = Color3.fromRGB(50, 50, 55)
    keyStroke.Thickness = 2
    
    local header = Instance.new("Frame", keyContainer)
    header.Size = UDim2.new(1, 0, 0, 32)
    header.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    header.BorderSizePixel = 0
    local headerCorner = Instance.new("UICorner", header)
    headerCorner.CornerRadius = UDim.new(0, 10, 0, 0)
    
    local keyLabel = Instance.new("TextLabel", header)
    keyLabel.Size = UDim2.new(0, 120, 1, 0)
    keyLabel.Position = UDim2.new(0, 12, 0, 0)
    keyLabel.Text = "TECLA ["..keyName.."]"
    keyLabel.BackgroundTransparency = 1
    keyLabel.Font = Enum.Font.GothamMedium
    keyLabel.TextSize = 14
    keyLabel.TextColor3 = Color3.new(1, 1, 1)
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Toggle button melhorado
    local toggleBtn = Instance.new("TextButton", header)
    toggleBtn.Size = UDim2.new(0, 75, 0, 24)
    toggleBtn.Position = UDim2.new(1, -82, 0.5, -12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    toggleBtn.Text = keyData.enabled and "ON" or "OFF"
    toggleBtn.Font = Enum.Font.GothamMedium
    toggleBtn.TextSize = 12
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.AutoButtonColor = false
    local toggleCorner = Instance.new("UICorner", toggleBtn)
    toggleCorner.CornerRadius = UDim.new(1, 0)
    
    local toggleCircle = Instance.new("Frame", toggleBtn)
    toggleCircle.Size = UDim2.new(0, 18, 0, 18)
    toggleCircle.Position = keyData.enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    toggleCircle.BackgroundColor3 = keyData.enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(150, 150, 150)
    local circleCorner = Instance.new("UICorner", toggleCircle)
    circleCorner.CornerRadius = UDim.new(1, 0)
    
    local intervalContainer = Instance.new("Frame", keyContainer)
    intervalContainer.Size = UDim2.new(1, -20, 0, 45)
    intervalContainer.Position = UDim2.new(0, 10, 0, 40)
    intervalContainer.BackgroundTransparency = 1
    
    local intervalLabel = Instance.new("TextLabel", intervalContainer)
    intervalLabel.Size = UDim2.new(0, 120, 1, 0)
    intervalLabel.Text = "Intervalo: "..string.format("%.2fs", keyData.interval)
    intervalLabel.BackgroundTransparency = 1
    intervalLabel.Font = Enum.Font.Gotham
    intervalLabel.TextSize = 13
    intervalLabel.TextColor3 = Color3.new(1, 1, 1)
    intervalLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Slider melhorado
    local sliderContainer = Instance.new("Frame", intervalContainer)
    sliderContainer.Size = UDim2.new(0, 190, 0, 25)
    sliderContainer.Position = UDim2.new(1, -190, 0.5, -12.5)
    sliderContainer.BackgroundTransparency = 1
    
    local intervalSlider = Instance.new("Frame", sliderContainer)
    intervalSlider.Size = UDim2.new(1, 0, 0, 6)
    intervalSlider.Position = UDim2.new(0, 0, 0.5, -3)
    intervalSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    local sliderCorner = Instance.new("UICorner", intervalSlider)
    sliderCorner.CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame", intervalSlider)
    sliderFill.Size = UDim2.new((keyData.interval - 0.05) / 0.95, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(80, 140, 200)
    sliderFill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner", sliderFill)
    fillCorner.CornerRadius = UDim.new(1, 0)
    
    local sliderDot = Instance.new("TextButton", sliderContainer)
    sliderDot.Size = UDim2.new(0, 26, 0, 26)
    sliderDot.Position = UDim2.new((keyData.interval - 0.05) / 0.95, -13, 0.5, -13)
    sliderDot.Text = ""
    sliderDot.BackgroundColor3 = Color3.fromRGB(100, 160, 220)
    sliderDot.AutoButtonColor = false
    local dotCorner = Instance.new("UICorner", sliderDot)
    dotCorner.CornerRadius = UDim.new(1, 0)
    
    local dotStroke = Instance.new("UIStroke", sliderDot)
    dotStroke.Color = Color3.new(1, 1, 1)
    dotStroke.Thickness = 1.5
    
    -- Valores mínimo e máximo
    local minLabel = Instance.new("TextLabel", sliderContainer)
    minLabel.Size = UDim2.new(0, 35, 0, 16)
    minLabel.Position = UDim2.new(0, 0, 1, 2)
    minLabel.Text = "0.05"
    minLabel.BackgroundTransparency = 1
    minLabel.Font = Enum.Font.Gotham
    minLabel.TextSize = 10
    minLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    minLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local maxLabel = Instance.new("TextLabel", sliderContainer)
    maxLabel.Size = UDim2.new(0, 35, 0, 16)
    maxLabel.Position = UDim2.new(1, -35, 1, 2)
    maxLabel.Text = "1.0"
    maxLabel.BackgroundTransparency = 1
    maxLabel.Font = Enum.Font.Gotham
    maxLabel.TextSize = 10
    maxLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    maxLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    -- Função para atualizar slider
    local function updateSlider(value)
        value = math.clamp(value, 0.05, 1.0)
        keyData.interval = value
        intervalLabel.Text = "Intervalo: "..string.format("%.2fs", value)
        
        local fillSize = (value - 0.05) / 0.95
        sliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        sliderDot.Position = UDim2.new(fillSize, -13, 0.5, -13)
    end
    
    local dragging = false
    
    -- Eventos do slider
    sliderDot.MouseButton1Down:Connect(function()
        dragging = true
        TweenService:Create(sliderDot, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 30, 0, 30),
            BackgroundColor3 = Color3.fromRGB(120, 180, 240)
        }):Play()
    end)
    
    local function endDrag()
        if dragging then
            dragging = false
            TweenService:Create(sliderDot, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 26, 0, 26),
                BackgroundColor3 = Color3.fromRGB(100, 160, 220)
            }):Play()
        end
    end
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag()
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = player:GetMouse()
            local sliderAbsolute = sliderContainer.AbsolutePosition
            local sliderSize = sliderContainer.AbsoluteSize
            
            local relativeX = math.clamp(
                (mouse.X - sliderAbsolute.X) / sliderSize.X,
                0, 1
            )
            
            local value = 0.05 + (relativeX * 0.95)
            updateSlider(value)
        end
    end)
    
    -- Eventos do toggle
    toggleBtn.MouseEnter:Connect(function()
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = keyData.enabled and Color3.fromRGB(70, 110, 80) or Color3.fromRGB(70, 70, 75)
        }):Play()
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        }):Play()
    end)
    
    toggleBtn.MouseButton1Click:Connect(function()
        keyData.enabled = not keyData.enabled
        
        if keyData.enabled then
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(80, 200, 120),
                Position = UDim2.new(1, -21, 0.5, -9)
            }):Play()
            toggleBtn.Text = "ON"
            keyContainer.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
            keyStroke.Color = Color3.fromRGB(60, 100, 70)
        else
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(150, 150, 150),
                Position = UDim2.new(0, 3, 0.5, -9)
            }):Play()
            toggleBtn.Text = "OFF"
            keyContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            keyStroke.Color = Color3.fromRGB(50, 50, 55)
        end
    end)
    
    return keyContainer
end

-- =========================
-- SEÇÃO DE MOVIMENTO
-- =========================

local movementTitle = Instance.new("TextLabel", content)
movementTitle.Size = UDim2.new(0.92, 0, 0, 24)
movementTitle.Text = "🎮  CONTROLES DE MOVIMENTO"
movementTitle.BackgroundTransparency = 1
movementTitle.Font = Enum.Font.GothamSemibold
movementTitle.TextSize = 14
movementTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
movementTitle.TextXAlignment = Enum.TextXAlignment.Left
movementTitle.LayoutOrder = localAccessData.canHideTag and 3 or 2

local movementKeys = {"W", "A", "S", "D", "SPACE"}
local startOrder = localAccessData.canHideTag and 3 or 2
for i, keyName in ipairs(movementKeys) do
    createKeyControl(keyName, Keys[keyName], startOrder + i)
end

-- =========================
-- SEPARADOR
-- =========================

local separator = Instance.new("Frame", content)
separator.Size = UDim2.new(0.92, 0, 0, 2)
separator.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
separator.BorderSizePixel = 0
separator.LayoutOrder = startOrder + #movementKeys + 1

-- =========================
-- SEÇÃO DE AÇÕES
-- =========================

local actionsTitle = Instance.new("TextLabel", content)
actionsTitle.Size = UDim2.new(0.92, 0, 0, 24)
actionsTitle.Text = "⚡  AÇÕES (SLOTS 1-4)"
actionsTitle.BackgroundTransparency = 1
actionsTitle.Font = Enum.Font.GothamSemibold
actionsTitle.TextSize = 14
actionsTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
actionsTitle.TextXAlignment = Enum.TextXAlignment.Left
actionsTitle.LayoutOrder = startOrder + #movementKeys + 2

local actionKeys = {"1", "2", "3", "4"}
for i, keyName in ipairs(actionKeys) do
    createKeyControl(keyName, Keys[keyName], startOrder + #movementKeys + 2 + i)
end

-- =========================
-- SEÇÃO DE USUÁRIOS ONLINE - DESIGN MELHORADO
-- =========================

local usersSection = Instance.new("Frame", content)
usersSection.Size = UDim2.new(0.92, 0, 0, 220)
usersSection.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
usersSection.LayoutOrder = startOrder + #movementKeys + #actionKeys + 3
local usersCorner = Instance.new("UICorner", usersSection)
usersCorner.CornerRadius = UDim.new(0, 10)

local usersStroke = Instance.new("UIStroke", usersSection)
usersStroke.Color = Color3.fromRGB(50, 50, 55)
usersStroke.Thickness = 2

local usersTitle = Instance.new("TextLabel", usersSection)
usersTitle.Size = UDim2.new(1, 0, 0, 36)
usersTitle.Text = "🌐  USUÁRIOS DO SCRIPT"
usersTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
usersTitle.Font = Enum.Font.GothamSemibold
usersTitle.TextSize = 14
usersTitle.TextColor3 = Color3.new(1, 1, 1)
local usersTitleCorner = Instance.new("UICorner", usersTitle)
usersTitleCorner.CornerRadius = UDim.new(0, 10, 0, 0)

local userCountLabel = Instance.new("TextLabel", usersSection)
userCountLabel.Size = UDim2.new(1, -20, 0, 22)
userCountLabel.Position = UDim2.new(0, 10, 0, 40)
userCountLabel.Text = "👥  Carregando usuários..."
userCountLabel.BackgroundTransparency = 1
userCountLabel.Font = Enum.Font.GothamMedium
userCountLabel.TextSize = 12
userCountLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
userCountLabel.TextXAlignment = Enum.TextXAlignment.Left

local usersListContainer = Instance.new("ScrollingFrame", usersSection)
usersListContainer.Size = UDim2.new(1, -10, 1, -110)
usersListContainer.Position = UDim2.new(0, 5, 0, 70)
usersListContainer.BackgroundTransparency = 1
usersListContainer.ScrollBarThickness = 6
usersListContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
usersListContainer.ScrollBarImageTransparency = 0.5
usersListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
usersListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

local usersListLayout = Instance.new("UIListLayout", usersListContainer)
usersListLayout.Padding = UDim.new(0, 6)

local function updateUserList()
    for _, child in ipairs(usersListContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local userCount = 0
    
    -- Adicionar usuário local
    local localEntry = Instance.new("Frame", usersListContainer)
    localEntry.Size = UDim2.new(1, -10, 0, 32)
    localEntry.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
    localEntry.BackgroundTransparency = 0.1
    
    local localCorner = Instance.new("UICorner", localEntry)
    localCorner.CornerRadius = UDim.new(0, 8)
    
    local localStroke = Instance.new("UIStroke", localEntry)
    localStroke.Color = localAccessData.color
    localStroke.Thickness = 1.5
    localStroke.Transparency = 0.5
    
    local localTag = Instance.new("TextLabel", localEntry)
    localTag.Size = UDim2.new(0, 65, 1, 0)
    localTag.Position = UDim2.new(0, 8, 0, 0)
    localTag.Text = localAccessData.tag
    localTag.BackgroundTransparency = 1
    localTag.Font = Enum.Font.GothamBold
    localTag.TextSize = 12
    localTag.TextColor3 = localAccessData.color
    
    local localName = Instance.new("TextLabel", localEntry)
    localName.Size = UDim2.new(0, 120, 1, 0)
    localName.Position = UDim2.new(0, 75, 0, 0)
    localName.Text = player.Name
    localName.BackgroundTransparency = 1
    localName.Font = Enum.Font.GothamMedium
    localName.TextSize = 12
    localName.TextColor3 = Color3.new(1, 1, 1)
    localName.TextXAlignment = Enum.TextXAlignment.Left
    
    local localStatus = Instance.new("TextLabel", localEntry)
    localStatus.Size = UDim2.new(0, 50, 1, 0)
    localStatus.Position = UDim2.new(1, -60, 0, 0)
    localStatus.Text = LocalHideTag and "🔴 OFF" or "🟢 ON"
    localStatus.BackgroundTransparency = 1
    localStatus.Font = Enum.Font.Gotham
    localStatus.TextSize = 11
    localStatus.TextColor3 = LocalHideTag and Color3.fromRGB(255, 150, 150) or Color3.fromRGB(150, 255, 150)
    
    userCount = userCount + 1
    
    -- Adicionar outros usuários
    for userId, userData in pairs(ScriptUsers) do
        if userId ~= localPlayerId and userData.player then
            userCount = userCount + 1
            
            local userEntry = Instance.new("Frame", usersListContainer)
            userEntry.Size = UDim2.new(1, -10, 0, 28)
            userEntry.BackgroundColor3 = Color3.fromRGB(35, 40, 45)
            userEntry.BackgroundTransparency = 0.1
            
            local userCorner = Instance.new("UICorner", userEntry)
            userCorner.CornerRadius = UDim.new(0, 7)
            
            local userStroke = Instance.new("UIStroke", userEntry)
            userStroke.Color = userData.accessData.color
            userStroke.Thickness = 1
            userStroke.Transparency = 0.6
            
            local userTag = Instance.new("TextLabel", userEntry)
            userTag.Size = UDim2.new(0, 55, 1, 0)
            userTag.Position = UDim2.new(0, 8, 0, 0)
            userTag.Text = userData.accessData.tag
            userTag.BackgroundTransparency = 1
            userTag.Font = Enum.Font.GothamBold
            userTag.TextSize = 11
            userTag.TextColor3 = userData.accessData.color
            
            local userName = Instance.new("TextLabel", userEntry)
            userName.Size = UDim2.new(0, 100, 1, 0)
            userName.Position = UDim2.new(0, 65, 0, 0)
            userName.Text = userData.player.Name
            userName.BackgroundTransparency = 1
            userName.Font = Enum.Font.Gotham
            userName.TextSize = 11
            userName.TextColor3 = Color3.fromRGB(220, 220, 220)
            userName.TextXAlignment = Enum.TextXAlignment.Left
            
            local userStatus = Instance.new("TextLabel", userEntry)
            userStatus.Size = UDim2.new(0, 45, 1, 0)
            userStatus.Position = UDim2.new(1, -50, 0, 0)
            userStatus.Text = userData.hideTag and "🔴" or "🟢"
            userStatus.BackgroundTransparency = 1
            userStatus.Font = Enum.Font.Gotham
            userStatus.TextSize = 11
            userStatus.TextColor3 = userData.hideTag and Color3.fromRGB(255, 150, 150) or Color3.fromRGB(150, 255, 150)
        end
    end
    
    userCountLabel.Text = string.format("👥  Usuários Online: %d", userCount)
end

local refreshBtn = Instance.new("TextButton", usersSection)
refreshBtn.Size = UDim2.new(0, 110, 0, 28)
refreshBtn.Position = UDim2.new(0.5, -55, 1, -35)
refreshBtn.Text = "🔄  ATUALIZAR LISTA"
refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 200)
refreshBtn.Font = Enum.Font.GothamMedium
refreshBtn.TextSize = 12
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.AutoButtonColor = false
local refreshCorner = Instance.new("UICorner", refreshBtn)
refreshCorner.CornerRadius = UDim.new(0, 8)

local refreshStroke = Instance.new("UIStroke", refreshBtn)
refreshStroke.Color = Color3.fromRGB(80, 160, 220)
refreshStroke.Thickness = 2

refreshBtn.MouseEnter:Connect(function()
    TweenService:Create(refreshBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(70, 150, 210),
        Rotation = 180
    }):Play()
end)

refreshBtn.MouseLeave:Connect(function()
    TweenService:Create(refreshBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(60, 140, 200),
        Rotation = 0
    }):Play()
end)

refreshBtn.MouseButton1Click:Connect(function()
    updateUserList()
    showNotification("Lista de usuários atualizada!", Color3.fromRGB(100, 200, 255), 2)
end)

-- =========================
-- RODAPÉ
-- =========================

local footer = Instance.new("TextLabel", content)
footer.Size = UDim2.new(0.92, 0, 0, 45)
footer.Text = string.format("💡  Pressione [B] para abrir/fechar o menu\n🔑  Seu acesso: %s  |  Tag: %s", 
    localAccessData.tag, LocalHideTag and "🔴 OFF" or "🟢 ON")
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
footer.TextColor3 = Color3.fromRGB(160, 160, 160)
footer.TextYAlignment = Enum.TextYAlignment.Top
footer.TextWrapped = true
footer.LayoutOrder = startOrder + #movementKeys + #actionKeys + 4

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

-- Loop principal do script
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
        local wasVisible = main.Visible
        main.Visible = not wasVisible
        
        if main.Visible then
            -- Animação de abertura
            main.Size = UDim2.new(0, 440, 0, 0)
            main.Position = UDim2.new(0.5, -220, 0.5, -290)
            main.BackgroundTransparency = 1
            
            local tweenIn = TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 440, 0, 580),
                BackgroundTransparency = 0
            })
            tweenIn:Play()
            
            updateUserList()
            showNotification("Menu aberto", localAccessData.color, 2)
        else
            -- Animação de fechamento
            local tweenOut = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 440, 0, 0),
                Position = UDim2.new(0.5, -220, 0.5, -290),
                BackgroundTransparency = 1
            })
            tweenOut:Play()
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
-- INICIALIZAÇÃO FINAL
-- =========================

updateUserList()

print("====================================")
print(string.format("BONDSP AUTO KEYS - Acesso: %s", localAccessData.tag))
print("ID do Cliente: " .. CLIENT_ID)
print("Script injetado com sucesso!")
print("====================================")
