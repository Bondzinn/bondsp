-- =========================================================
-- BONDSP NEXUS V5 - ELITE EDITION (FIX TAG + AUTOCLICK)
-- =========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- LIMPEZA
if _G.BondspInstance then
    _G.BondspInstance:Destroy()
end

-- =========================================================
-- CONFIG
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

-- =========================================================
-- SISTEMA DE ACESSO / TAG (LOCAL ONLY)
-- =========================================================

local AccessLevels = {
    DEV = { ids = {4885351053}, color = Color3.fromRGB(255,0,50) },
    Support = { ids = {609332724}, color = Color3.fromRGB(0,170,255) },
    Marketing = { ids = {22222222}, color = Color3.fromRGB(255,170,0) },
    VIP = { ids = {33333333}, color = Color3.fromRGB(170,0,255) },
    User = { ids = {}, color = Color3.fromRGB(200,200,200) }
}

local function getRole()
    for role, data in pairs(AccessLevels) do
        if table.find(data.ids, player.UserId) then
            return role, data.color
        end
    end
    return "User", AccessLevels.User.color
end

local function createLocalTag(character)
    local head = character:WaitForChild("Head",5)
    if not head then return end

    local old = head:FindFirstChild("BondspTag")
    if old then old:Destroy() end

    local role, color = getRole()

    local bb = Instance.new("BillboardGui")
    bb.Name = "BondspTag"
    bb.Parent = head
    bb.Adornee = head
    bb.Size = UDim2.new(0,180,0,40)
    bb.StudsOffset = Vector3.new(0,2.8,0)
    bb.AlwaysOnTop = true

    local txt = Instance.new("TextLabel")
    txt.Parent = bb
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = ("%s"):format(role)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.TextColor3 = color
    txt.TextStrokeTransparency = 0.4
end

if player.Character then
    createLocalTag(player.Character)
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    createLocalTag(char)
end)

-- =========================================================
-- UI BASE (RESUMIDA, NÃO QUEBRA ENGINE)
-- =========================================================

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "Bondsp_Nexus_V5"
gui.ResetOnSpawn = false
_G.BondspInstance = gui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 280, 0, 60)
main.Position = UDim2.new(0.5,-140,0.85,0)
main.BackgroundColor3 = Color3.fromRGB(15,16,20)
Instance.new("UICorner", main)

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(1,-20,1,-20)
toggleBtn.Position = UDim2.new(0,10,0,10)
toggleBtn.Text = "ATIVAR NEXUS"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,217,255)
toggleBtn.TextColor3 = Color3.fromRGB(15,16,20)
Instance.new("UICorner", toggleBtn)

toggleBtn.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    toggleBtn.Text = ENABLED and "SISTEMA OPERANDO" or "ATIVAR NEXUS"
    toggleBtn.BackgroundColor3 = ENABLED and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,217,255)
end)

-- =========================================================
-- ENGINE AUTOCLICK + MOVIMENTO (INALTERADA)
-- =========================================================

RunService.Heartbeat:Connect(function(dt)
    if not ENABLED then return end

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local mv = Vector3.zero
    if Keys.W.enabled then mv += Vector3.new(0,0,-1) end
    if Keys.S.enabled then mv += Vector3.new(0,0,1) end
    if Keys.A.enabled then mv += Vector3.new(-1,0,0) end
    if Keys.D.enabled then mv += Vector3.new(1,0,0) end
    if mv.Magnitude > 0 then
        hum:Move(mv.Unit, true)
    end

    for name, data in pairs(Keys) do
        if data.enabled and (data.slot or name == "SPACE") then
            data.timer += dt
            if data.timer >= data.interval then
                data.timer = 0
                task.spawn(function()
                    if name == "SPACE" then
                        hum.Jump = true
                    else
                        local tool = player.Backpack:GetChildren()[data.slot]
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

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == MENU_KEY then
        main.Visible = not main.Visible
    end
end)

print("BONDSP NEXUS V5 INJETADO | TAG LOCAL + AUTOCLICK ATIVO")