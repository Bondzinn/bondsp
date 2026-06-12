--[[
    288 Panel - Entry Point (VERSÃO CORRIGIDA PARA REQUISIÇÕES)
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

-- ==================== FUNÇÕES HTTP CORRIGIDAS ====================

-- Função segura para enviar POST
function httpPost(url, data)
    -- Garantir que data é uma string JSON válida
    local jsonData = HttpService:JSONEncode(data or {})
    
    local success, result = pcall(function()
        return game:HttpPost(url, jsonData, false, "application/json")
    end)
    
    if success and result and result ~= "" and result ~= "nil" then
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(result)
        end)
        if ok then 
            return decoded 
        else
            -- Se falhar, tentar limpar o resultado
            local cleaned = string.gsub(result, "^nil$", "")
            if cleaned ~= "" then
                local ok2, decoded2 = pcall(function()
                    return HttpService:JSONDecode(cleaned)
                end)
                if ok2 then return decoded2 end
            end
        end
    end
    
    return nil
end

-- Função segura para GET
function httpGet(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result and result ~= "" and result ~= "nil" then
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(result)
        end)
        if ok then return decoded end
    end
    
    return nil
end

-- ==================== FUNÇÃO DE REQUISIÇÃO PRINCIPAL ====================
function safeRequest(method, endpoint, body)
    local url = API_BASE .. endpoint
    
    if method == "POST" then
        local result = httpPost(url, body or {})
        if result then 
            return result 
        end
        
        -- Fallback para simulação
        if endpoint == "/session/start" then
            return { sessionId = "local_" .. tostring(os.time()) .. "_" .. tostring(LocalPlayer.UserId) }
        end
        return { success = true }
    end
    
    if method == "GET" then
        return httpGet(url)
    end
    
    return nil
end

-- ==================== LOAD DA LIB ====================
local lib = {
    init = function(config) 
        print("[288] lib iniciada - API: " .. (config and config.apiBase or "?"))
    end,
    log = print,
    warn = warn,
    getDevice = function() 
        local uis = game:GetService("UserInputService")
        if uis.TouchEnabled then return "Mobile" end
        return "PC"
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
        f.Size = UDim2.new(0, 320, 0, 44)
        f.Position = UDim2.new(0.5, -160, 1, -60)
        f.BackgroundColor3 = isErr and Color3.fromRGB(80, 30, 30) or Color3.fromRGB(30, 30, 38)
        f.Parent = gui
        lib.applyCorner(f, 8)
        
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -16, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = (isErr and "❌ " or "✓ ") .. msg
        l.TextColor3 = Color3.fromRGB(220, 220, 230)
        l.TextSize = 14
        l.Font = Enum.Font.Gotham
        l.TextWrapped = true
        l.Parent = f
        
        task.delay(dur or 3, function()
            if f then f:Destroy() end
        end)
    end,
    buildHomeFrame = function(parent, userData, apiBase)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundTransparency = 1
        f.Parent = parent
        
        local welcome = Instance.new("TextLabel")
        welcome.Size = UDim2.new(1, -40, 0, 80)
        welcome.Position = UDim2.new(0, 20, 0.3, 0)
        welcome.BackgroundTransparency = 1
        welcome.Text = "🎮 288 Panel\n\nBem-vindo, " .. (userData and userData.username or LocalPlayer.Name)
        welcome.TextColor3 = Color3.new(1, 1, 1)
        welcome.TextScaled = true
        welcome.Font = Enum.Font.GothamBold
        welcome.TextWrapped = true
        welcome.Parent = f
        
        return f
    end,
    buildCategoryFrame = function(parent, cat, mods, userData)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundTransparency = 1
        f.Parent = parent
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -40, 0, 40)
        title.Position = UDim2.new(0, 20, 0, 10)
        title.BackgroundTransparency = 1
        title.Text = "📁 " .. cat
        title.TextColor3 = Color3.fromRGB(255, 200, 100)
        title.TextSize = 18
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = f
        
        local placeholder = Instance.new("TextLabel")
        placeholder.Size = UDim2.new(1, -40, 0, 40)
        placeholder.Position = UDim2.new(0, 20, 0, 60)
        placeholder.BackgroundTransparency = 1
        placeholder.Text = "🚧 Módulos em desenvolvimento..."
        placeholder.TextColor3 = Color3.fromRGB(150, 150, 160)
        placeholder.TextSize = 14
        placeholder.Font = Enum.Font.Gotham
        placeholder.Parent = f
        
        return f
    end,
    buildPlaceholderFrame = function(parent, name)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundTransparency = 1
        f.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -40, 0, 60)
        label.Position = UDim2.new(0, 20, 0.4, 0)
        label.BackgroundTransparency = 1
        label.Text = "🚧 " .. name .. "\nEm breve..."
        label.TextColor3 = Color3.fromRGB(130, 130, 140)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextWrapped = true
        label.Parent = f
        
        return f
    end
}

lib.init({ apiBase = API_BASE, version = VERSION })

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

-- Verificar usuário
local userData = safeRequest("GET", "/user/" .. LocalPlayer.UserId)

if not userData or not userData.userid then
    userData = {
        userid = LocalPlayer.UserId,
        username = LocalPlayer.Name,
        rank = "User",
        vip = false,
        banned = false
    }
    lib.log("Usando dados de usuário simulados")
end

if userData.banned then
    warn("[288] Você está banido do 288 Panel.")
    return
end

-- ==================== INICIAR ====================
task.spawn(startSession)

task.spawn(function()
    while task.wait(HEARTBEAT_INTERVAL) do
        heartbeat()
    end
end)

-- ==================== UI ====================
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end
task.wait(1)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "288Panel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- MainFrame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

lib.applyCorner(MainFrame, 12)
lib.applyStroke(MainFrame, Color3.fromRGB(80, 80, 120), 1)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "288 PANEL"
TitleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
TitleLabel.TextSize = 24
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = Header

local RankLabel = Instance.new("TextLabel")
RankLabel.Size = UDim2.new(0, 80, 0, 24)
RankLabel.Position = UDim2.new(1, -90, 0.5, -12)
RankLabel.BackgroundColor3 = lib.getRankColor(userData.rank)
RankLabel.TextColor3 = Color3.new(1, 1, 1)
RankLabel.Text = userData.rank or "User"
RankLabel.TextScaled = true
RankLabel.Font = Enum.Font.GothamBold
RankLabel.Parent = Header
lib.applyCorner(RankLabel, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
lib.applyCorner(CloseBtn, 6)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -70)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame
lib.applyCorner(ContentFrame, 8)

-- Home content
local homeFrame = lib.buildHomeFrame(ContentFrame, userData, API_BASE)
homeFrame.Visible = true

-- ==================== INSERT TOGGLE ====================
ScreenGui.Enabled = true

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

lib.log("✅ Painel carregado — INSERT para abrir/fechar")
