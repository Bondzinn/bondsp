-- =========================================================
-- BONDSP NEXUS V5.1 - ELITE SYNC + RECORDER + UI FIX
-- =========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if _G.BondspInstance then _G.BondspInstance:Destroy() end

-- =========================================================
-- CONFIGURAÇÕES E ESTADO
-- =========================================================

local ENABLED = false
local MENU_KEY = Enum.KeyCode.B
local Recording = false
local Playing = false
local History = {}
local RecordStart = 0

local Keys = {
    ["1"] = {enabled = false, slot = 1, interval = 0.5, timer = 0},
    ["2"] = {enabled = false, slot = 2, interval = 0.5, timer = 0},
    ["3"] = {enabled = false, slot = 3, interval = 0.5, timer = 0},
    ["4"] = {enabled = false, slot = 4, interval = 0.5, timer = 0},
    ["W"] = {enabled = false, active = false},
    ["A"] = {enabled = false, active = false},
    ["S"] = {enabled = false, active = false},
    ["D"] = {enabled = false, active = false},
    ["Space"] = {enabled = false, interval = 0.5, timer = 0},
}

local AccessLevels = {
    DEV = { ids = {4885351053}, color = Color3.fromRGB(255,0,50) },
    User = { ids = {}, color = Color3.fromRGB(0,255,255) }
}

-- =========================================================
-- SINCRONIZAÇÃO GLOBAL (TAGS)
-- =========================================================

local function markChar(char)
    if not char:FindFirstChild("Bondsp_User") then
        local v = Instance.new("StringValue", char)
        v.Name = "Bondsp_User"
        v.Value = table.find(AccessLevels.DEV.ids, player.UserId) and "DEV" or "User"
    end
end

local function applyTag(p, role)
    local head = p.Character and p.Character:FindFirstChild("Head")
    if head and not head:FindFirstChild("BondspTag") then
        local bb = Instance.new("BillboardGui", head)
        bb.Name = "BondspTag"
        bb.Size = UDim2.new(0,150,0,40)
        bb.StudsOffset = Vector3.new(0,3,0)
        bb.AlwaysOnTop = true
        local t = Instance.new("TextLabel", bb)
        t.Size = UDim2.new(1,0,1,0)
        t.BackgroundTransparency = 1
        t.Text = "BONDSP ["..role.."]"
        t.TextColor3 = AccessLevels[role] and AccessLevels[role].color or Color3.new(1,1,1)
        t.Font = Enum.Font.GothamBold
        t.TextSize = 14
    end
end

task.spawn(function()
    while task.wait(2) do
        if player.Character then markChar(player.Character) end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Bondsp_User") then
                applyTag(p, p.Character.Bondsp_User.Value)
            end
        end
    end
end)

-- =========================================================
-- INTERFACE MODERNA
-- =========================================================

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "Bondsp_Nexus_V5"
_G.BondspInstance = gui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 480)
main.Position = UDim2.new(0.5, -160, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(15,16,20)
Instance.new("UICorner", main)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -140)
scroll.Position = UDim2.new(0, 10, 0, 60)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

local function createKeyControl(name)
    local data = Keys[name]
    local f = Instance.new("Frame", scroll)
    f.Size = UDim2.new(1, 0, 0, 50)
    f.BackgroundColor3 = Color3.fromRGB(25,26,30)
    Instance.new("UICorner", f)

    local txt = Instance.new("TextLabel", f)
    txt.Text = " Tecla: "..name
    txt.Size = UDim2.new(0, 80, 1, 0)
    txt.TextColor3 = Color3.new(1,1,1)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBold
    txt.TextXAlignment = Enum.TextXAlignment.Left

    local toggle = Instance.new("TextButton", f)
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Position = UDim2.new(1, -50, 0, 5)
    toggle.Text = ""
    toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Instance.new("UICorner", toggle)

    toggle.MouseButton1Click:Connect(function()
        data.enabled = not data.enabled
        toggle.BackgroundColor3 = data.enabled and Color3.fromRGB(0,217,255) or Color3.fromRGB(50,50,50)
    end)

    if data.interval then
        local slider = Instance.new("TextButton", f)
        slider.Size = UDim2.new(0, 150, 0, 15)
        slider.Position = UDim2.new(0, 80, 0, 28)
        slider.BackgroundColor3 = Color3.new(0,0,0)
        slider.Text = "Intervalo: "..data.interval.."s"
        slider.TextColor3 = Color3.new(1,1,1)
        slider.TextSize = 10

        slider.MouseButton1Click:Connect(function()
            data.interval = (data.interval >= 30) and 0.1 or data.interval + 0.5
            slider.Text = "Intervalo: "..data.interval.."s"
        end)
    end
end

for _, k in ipairs({"1","2","3","4","W","A","S","D","Space"}) do createKeyControl(k) end

-- Botões de Controle de Loop
local recBtn = Instance.new("TextButton", main)
recBtn.Size = UDim2.new(0.45, 0, 0, 40)
recBtn.Position = UDim2.new(0.05, 0, 1, -110)
recBtn.Text = "GRAVAR LOOP"
recBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
Instance.new("UICorner", recBtn)

local playBtn = Instance.new("TextButton", main)
playBtn.Size = UDim2.new(0.45, 0, 0, 40)
playBtn.Position = UDim2.new(0.5, 0, 1, -110)
playBtn.Text = "REPRODUZIR"
playBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
Instance.new("UICorner", playBtn)

local masterBtn = Instance.new("TextButton", main)
masterBtn.Size = UDim2.new(0.9, 0, 0, 50)
masterBtn.Position = UDim2.new(0.05, 0, 1, -60)
masterBtn.Text = "ATIVAR TUDO"
masterBtn.BackgroundColor3 = Color3.fromRGB(0,217,255)
Instance.new("UICorner", masterBtn)

-- =========================================================
-- LÓGICA DE GRAVAÇÃO E LOOP
-- =========================================================

recBtn.MouseButton1Click:Connect(function()
    Recording = not Recording
    if Recording then
        History = {}
        RecordStart = tick()
        recBtn.Text = "PARAR GRAVAÇÃO"
    else
        recBtn.Text = "GRAVAR LOOP"
    end
end)

playBtn.MouseButton1Click:Connect(function()
    Playing = not Playing
    playBtn.Text = Playing and "PARAR LOOP" or "REPRODUZIR"
end)

masterBtn.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    masterBtn.Text = ENABLED and "ON" or "OFF"
end)

-- Captura de movimento para o Gravador
UIS.InputBegan:Connect(function(i, gp)
    if not gp and Recording then
        table.insert(History, {key = i.KeyCode, state = "Began", time = tick() - RecordStart})
    end
end)

UIS.InputEnded:Connect(function(i, gp)
    if not gp and Recording then
        table.insert(History, {key = i.KeyCode, state = "Ended", time = tick() - RecordStart})
    end
end)

-- =========================================================
-- ENGINE FINAL
-- =========================================================

task.spawn(function()
    while true do
        local dt = task.wait()
        if not ENABLED then continue end
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if not hum then continue end

        -- Auto Clicker 1-4
        for _, kName in ipairs({"1","2","3","4","Space"}) do
            local d = Keys[kName]
            if d.enabled then
                d.timer = d.timer + dt
                if d.timer >= d.interval then
                    d.timer = 0
                    if kName == "Space" then hum.Jump = true else
                        local tool = player.Backpack:GetChildren()[d.slot]
                        if tool then hum:EquipTool(tool) tool:Activate() end
                    end
                end
            end
        end

        -- Reprodução do Loop
        if Playing and #History > 0 then
            local loopTime = (tick() - RecordStart) % (History[#History].time + 1)
            for _, event in ipairs(History) do
                if math.abs(event.time - loopTime) < 0.05 then
                    -- Simula o input (simplificado para movimento)
                    if event.state == "Began" then
                        -- Lógica de pressionar
                    end
                end
            end
        end
    end
end)

UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == MENU_KEY then main.Visible = not main.Visible end end)
