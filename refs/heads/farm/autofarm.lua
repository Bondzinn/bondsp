-- =========================================================
-- BONDSP NEXUS V5 - ELITE EDITION (SYNC TAGS)
-- =========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- LIMPEZA
if _G.BondspInstance then _G.BondspInstance:Destroy() end

-- =========================================================
-- CONFIG & ACCESS
-- =========================================================

local ENABLED = false
local MENU_KEY = Enum.KeyCode.B

local Keys = {
    ["1"] = {enabled = false, slot = 1, interval = 0.5, timer = 0},
    ["2"] = {enabled = false, slot = 2, interval = 0.5, timer = 0},
    ["3"] = {enabled = false, slot = 3, interval = 0.5, timer = 0},
    ["4"] = {enabled = false, slot = 4, interval = 0.5, timer = 0},
    ["W"] = {enabled = false},
    ["A"] = {enabled = false},
    ["S"] = {enabled = false},
    ["D"] = {enabled = false},
    ["SPACE"] = {enabled = false, interval = 0.5, timer = 0},
}

local AccessLevels = {
    DEV = { ids = {4885351053}, color = Color3.fromRGB(255,0,50) },
    Support = { ids = {609332724}, color = Color3.fromRGB(0,170,255) },
    Marketing = { ids = {22222222}, color = Color3.fromRGB(255,170,0) },
    VIP = { ids = {33333333}, color = Color3.fromRGB(170,0,255) },
    User = { ids = {}, color = Color3.fromRGB(0,255,255) } -- Ciano para destaque
}

-- =========================================================
-- SISTEMA DE SINCRONIZAÇÃO DE TAGS (MUTUAL DETECTION)
-- =========================================================

-- 1. MARCAR VOCÊ COMO USUÁRIO DO SCRIPT
local function markMyCharacter(char)
    if not char:FindFirstChild("Bondsp_User") then
        local tagVal = Instance.new("StringValue")
        tagVal.Name = "Bondsp_User"
        
        -- Define o cargo para os outros verem
        local role = "User"
        for r, data in pairs(AccessLevels) do
            if table.find(data.ids, player.UserId) then role = r break end
        end
        tagVal.Value = role
        tagVal.Parent = char
    end
end

-- 2. CRIAR TAG NA CABEÇA DE ALGUÉM
local function applyTag(targetPlayer, role)
    local char = targetPlayer.Character
    if not char then return end
    local head = char:WaitForChild("Head", 5)
    if not head or head:FindFirstChild("BondspTag") then return end

    local color = AccessLevels[role] and AccessLevels[role].color or AccessLevels.User.color

    local bb = Instance.new("BillboardGui", head)
    bb.Name = "BondspTag"
    bb.Size = UDim2.new(0, 180, 0, 40)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true

    local txt = Instance.new("TextLabel", bb)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "BONDSP ["..role.."]"
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.TextColor3 = color
    txt.TextStrokeTransparency = 0.4
end

-- 3. SCANNER CONSTANTE
task.spawn(function()
    while task.wait(2) do -- Varre a cada 2 segundos
        if player.Character then markMyCharacter(player.Character) end
        
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Bondsp_User") then
                local roleFound = p.Character.Bondsp_User.Value
                applyTag(p, roleFound)
            end
        end
    end
end)

-- =========================================================
-- UI & ENGINE (SIMPLIFICADA PARA SEU LAYOUT)
-- =========================================================

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "Bondsp_Nexus_V5"
gui.ResetOnSpawn = false
_G.BondspInstance = gui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 280, 0, 60)
main.Position = UDim2.new(0.5, -140, 0.85, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
Instance.new("UICorner", main)

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(1, -20, 1, -20)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "ATIVAR NEXUS"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 217, 255)
toggleBtn.TextColor3 = Color3.fromRGB(15, 16, 20)
Instance.new("UICorner", toggleBtn)

toggleBtn.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    toggleBtn.Text = ENABLED and "SISTEMA OPERANDO" or "ATIVAR NEXUS"
    toggleBtn.BackgroundColor3 = ENABLED and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 217, 255)
end)

-- ENGINE DE MOVIMENTO E CLIQUE
RunService.Heartbeat:Connect(function(dt)
    if not ENABLED then return end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Movimento WASD (Lógica simples)
    local mv = Vector3.zero
    -- Nota: Aqui você deve mapear o estado das teclas via InputBegan/Ended se quiser movimento WASD real
    -- Mas manteremos a estrutura de repetição que você pediu

    for name, data in pairs(Keys) do
        if data.enabled and (data.slot or name == "SPACE") then
            data.timer += dt
            if data.timer >= data.interval then
                data.timer = 0
                task.spawn(function()
                    if name == "SPACE" then hum.Jump = true 
                    elseif data.slot then
                        local tools = player.Backpack:GetChildren()
                        local tool = tools[data.slot]
                        if tool then
                            hum:EquipTool(tool)
                            task.wait(0.02)
                            tool:Activate()
                            task.wait(0.02)
                            tool:Deactivate()
                        end
                    end
                end)
            end
        end
    end
end)

UIS.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == MENU_KEY then main.Visible = not main.Visible end
end)

print("BONDSP NEXUS V5 | SINCRONIZAÇÃO DE USUÁRIOS ATIVA")