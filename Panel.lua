--[[ 
    288 Panel - Versão Completa
    Design personalizado com Home e Sidebar
    API integrada com Cloudflare
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ==================== CONFIGURAÇÃO ====================
local API_BASE = "https://seems-seventh-brook-nickname.trycloudflare.com"
local VERSION = "1.0.0"
local HEARTBEAT_INTERVAL = 60

-- ==================== FUNÇÕES HTTP ====================
function httpPost(url, data)
    local jsonString = "{}"
    if data then
        local success, result = pcall(function()
            return HttpService:JSONEncode(data)
        end)
        if success then jsonString = result end
    end
    
    local success, result = pcall(function()
        return game:HttpPost(url, tostring(jsonString), false, "application/json")
    end)
    
    if success and result and result ~= "" and result ~= "nil" then
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(result)
        end)
        if ok then return decoded end
    end
    return nil
end

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

function safeRequest(method, endpoint, data)
    local url = API_BASE .. endpoint
    
    if method == "POST" then
        return httpPost(url, data or {})
    elseif method == "GET" then
        return httpGet(url)
    end
    return nil
end

-- ==================== SESSÃO ====================
local sessionId = nil
local userData = nil

local function startSession()
    local res = safeRequest("POST", "/session/start", {
        userid = LocalPlayer.UserId,
        username = LocalPlayer.Name,
        version = VERSION,
        game = tostring(game.PlaceId),
        device = UserInputService.TouchEnabled and "Mobile" or "PC"
    })
    
    if res and res.sessionId then
        sessionId = res.sessionId
        print("[288] Sessão iniciada: " .. sessionId)
    else
        sessionId = "local_" .. tostring(os.time()) .. "_" .. tostring(LocalPlayer.UserId)
        print("[288] Sessão local: " .. sessionId)
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

-- Buscar dados do usuário
local userResponse = safeRequest("GET", "/user/" .. LocalPlayer.UserId)
if userResponse and userResponse.userid then
    userData = userResponse
else
    userData = {
        userid = LocalPlayer.UserId,
        username = LocalPlayer.Name,
        rank = "User",
        vip = false,
        banned = false
    }
end

if userData.banned then
    warn("[288] Você está banido.")
    return
end

-- Iniciar sessão
task.spawn(startSession)

task.spawn(function()
    while task.wait(HEARTBEAT_INTERVAL) do
        heartbeat()
    end
end)

-- ==================== UI PRINCIPAL ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "288Panel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 720, 0, 500)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner pra MainFrame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- ==================== HEADER ====================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 120, 1, 0)
VersionLabel.Position = UDim2.new(0, 15, 0, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v" .. VERSION
VersionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
VersionLabel.TextScaled = true
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.25, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "288 Panel"
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = Header

-- Rank Badge
local RankBadge = Instance.new("TextLabel")
RankBadge.Size = UDim2.new(0, 100, 0, 28)
RankBadge.Position = UDim2.new(1, -115, 0.5, -14)
RankBadge.BackgroundColor3 = userData.rank == "Owner" and Color3.fromRGB(255, 50, 50) or 
                             userData.rank == "VIP" and Color3.fromRGB(180, 0, 255) or
                             Color3.fromRGB(80, 80, 90)
RankBadge.TextColor3 = Color3.new(1, 1, 1)
RankBadge.Text = userData.rank or "User"
RankBadge.TextScaled = true
RankBadge.Font = Enum.Font.GothamBold
RankBadge.Parent = Header

local RankCorner = Instance.new("UICorner")
RankCorner.CornerRadius = UDim.new(0, 6)
RankCorner.Parent = RankBadge

-- Hotkey Label (B)
local HotkeyLabel = Instance.new("TextLabel")
HotkeyLabel.Size = UDim2.new(0, 50, 0, 28)
HotkeyLabel.Position = UDim2.new(0, 15, 0.5, -14)
HotkeyLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
HotkeyLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
HotkeyLabel.Text = "[B]"
HotkeyLabel.TextScaled = true
HotkeyLabel.Font = Enum.Font.GothamBold
HotkeyLabel.Parent = Header

local HotkeyCorner = Instance.new("UICorner")
HotkeyCorner.CornerRadius = UDim.new(0, 6)
HotkeyCorner.Parent = HotkeyLabel

-- Efeito Rainbow no título
task.spawn(function()
    local colors = {
        Color3.fromRGB(255, 60, 60),
        Color3.fromRGB(255, 140, 0),
        Color3.fromRGB(255, 240, 0),
        Color3.fromRGB(0, 255, 100),
        Color3.fromRGB(0, 200, 255),
        Color3.fromRGB(160, 0, 255)
    }
    local i = 1
    while TitleLabel and TitleLabel.Parent do
        pcall(function() TitleLabel.TextColor3 = colors[i] end)
        i = (i % #colors) + 1
        task.wait(0.15)
    end
end)

-- Botão Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextScaled = true
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    pcall(function()
        safeRequest("POST", "/session/end", { sessionId = sessionId })
    end)
    ScreenGui:Destroy()
end)

-- ==================== SIDEBAR ====================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 0)
SidebarCorner.Parent = Sidebar

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 2)
ListLayout.Parent = Sidebar

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 8)
Padding.PaddingLeft = UDim.new(0, 4)
Padding.PaddingRight = UDim.new(0, 4)
Padding.Parent = Sidebar

-- ==================== CONTENT FRAME ====================
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -160, 1, -60)
ContentFrame.Position = UDim2.new(0, 160, 0, 60)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentFrame

-- ==================== HOME FRAME PERSONALIZADA ====================
local HomeFrame = Instance.new("Frame")
HomeFrame.Size = UDim2.new(1, 0, 1, 0)
HomeFrame.BackgroundTransparency = 1
HomeFrame.Visible = true
HomeFrame.Parent = ContentFrame

-- Avatar
local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 100, 0, 100)
Avatar.Position = UDim2.new(0.5, -50, 0, 20)
Avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Avatar.Parent = HomeFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 50)
AvatarCorner.Parent = Avatar

-- Avatar Stroke (borda colorida)
local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = userData.rank == "Owner" and Color3.fromRGB(255, 50, 50) or 
                     userData.rank == "VIP" and Color3.fromRGB(180, 0, 255) or
                     Color3.fromRGB(80, 80, 120)
AvatarStroke.Thickness = 2
AvatarStroke.Parent = Avatar

-- Carregar thumbnail
task.spawn(function()
    local success, img = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    if success and img then
        Avatar.Image = img
    end
end)

-- Boas-vindas
local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(1, 0, 0, 50)
WelcomeText.Position = UDim2.new(0, 0, 0, 135)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "Olá, " .. LocalPlayer.DisplayName .. "!"
WelcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeText.TextScaled = true
WelcomeText.Font = Enum.Font.GothamBold
WelcomeText.Parent = HomeFrame

-- Info em tempo real (com [B] atualizado)
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, -40, 0, 100)
InfoText.Position = UDim2.new(0, 20, 0, 195)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Carregando informações..."
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.TextSize = 14
InfoText.TextWrapped = true
InfoText.Font = Enum.Font.Gotham
InfoText.Parent = HomeFrame

-- Atualizar informações
task.spawn(function()
    while HomeFrame and HomeFrame.Parent do
        local ping = math.floor(LocalPlayer:GetPing() * 100) / 100 or 0
        local stats = safeRequest("GET", "/stats")
        local online = (stats and stats.online) or "?"
        local total = (stats and stats.totalUsers) or "?"
        
        InfoText.Text = string.format(
            "📊 Informações do Servidor\n\n━━━━━━━━━━━━━━━━━━━\n🔘 Ping: %dms\n👥 Online: %s\n📈 Total de Usuários: %s\n━━━━━━━━━━━━━━━━━━━\n\n💡 Pressione [B] para abrir/fechar",
            ping, tostring(online), tostring(total)
        )
        task.wait(3)
    end
end)

-- Anúncios
task.spawn(function()
    local announcements = safeRequest("GET", "/announcements")
    if announcements and #announcements > 0 then
        local AnnounceFrame = Instance.new("Frame")
        AnnounceFrame.Size = UDim2.new(1, -40, 0, 60)
        AnnounceFrame.Position = UDim2.new(0, 20, 1, -70)
        AnnounceFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        AnnounceFrame.Parent = HomeFrame
        
        local AnnounceCorner = Instance.new("UICorner")
        AnnounceCorner.CornerRadius = UDim.new(0, 8)
        AnnounceCorner.Parent = AnnounceFrame
        
        local AnnounceText = Instance.new("TextLabel")
        AnnounceText.Size = UDim2.new(1, -16, 1, 0)
        AnnounceText.Position = UDim2.new(0, 8, 0, 0)
        AnnounceText.BackgroundTransparency = 1
        AnnounceText.Text = "📢 " .. announcements[1].message
        AnnounceText.TextColor3 = Color3.fromRGB(255, 220, 100)
        AnnounceText.TextSize = 13
        AnnounceText.TextWrapped = true
        AnnounceText.Font = Enum.Font.Gotham
        AnnounceText.Parent = AnnounceFrame
    end
end)

-- ==================== CATEGORY FRAMES ====================
local function CreateCategoryFrame(name)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = ContentFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 50)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "📁 " .. name
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    
    local placeholder = Instance.new("TextLabel")
    placeholder.Size = UDim2.new(1, -40, 0, 40)
    placeholder.Position = UDim2.new(0, 20, 0, 90)
    placeholder.BackgroundTransparency = 1
    placeholder.Text = "🚧 Módulos em desenvolvimento...\n\nEm breve!"
    placeholder.TextColor3 = Color3.fromRGB(150, 150, 160)
    placeholder.TextSize = 16
    placeholder.Font = Enum.Font.Gotham
    placeholder.TextWrapped = true
    placeholder.Parent = frame
    
    return frame
end

-- Criar frames das categorias
local categoryFrames = {
    Home = HomeFrame,
    VIP = CreateCategoryFrame("VIP"),
    Emphasis = CreateCategoryFrame("Emphasis"),
    Character = CreateCategoryFrame("Character"),
    Target = CreateCategoryFrame("Target"),
    More = CreateCategoryFrame("More"),
    Misc = CreateCategoryFrame("Misc")
}

-- Bloquear VIP se não tiver
if not userData.vip then
    categoryFrames.VIP:Destroy()
    categoryFrames.VIP = CreateCategoryFrame("VIP [BLOQUEADO]")
    categoryFrames.VIP.Parent = ContentFrame
end

-- ==================== SIDEBAR BUTTONS ====================
local activeButton = nil

local function CreateTabButton(name, categoryKey, isLocked)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 48)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    Btn.Text = name
    Btn.TextColor3 = isLocked and Color3.fromRGB(110, 110, 110) or Color3.fromRGB(230, 230, 230)
    Btn.TextScaled = true
    Btn.Font = Enum.Font.Gotham
    Btn.Parent = Sidebar
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn
    
    if isLocked then 
        Btn.Text = name .. " 🔒"
    end
    
    Btn.MouseButton1Click:Connect(function()
        if isLocked then
            -- Criar notificação
            local notif = Instance.new("Frame")
            notif.Size = UDim2.new(0, 250, 0, 40)
            notif.Position = UDim2.new(0.5, -125, 1, -60)
            notif.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
            notif.Parent = ScreenGui
            local notifCorner = Instance.new("UICorner")
            notifCorner.CornerRadius = UDim.new(0, 8)
            notifCorner.Parent = notif
            local notifText = Instance.new("TextLabel")
            notifText.Size = UDim2.new(1, 0, 1, 0)
            notifText.BackgroundTransparency = 1
            notifText.Text = "🔒 Acesso VIP necessário!"
            notifText.TextColor3 = Color3.new(1, 1, 1)
            notifText.TextScaled = true
            notifText.Font = Enum.Font.Gotham
            notifText.Parent = notif
            task.delay(2, function() if notif then notif:Destroy() end end)
            return
        end
        
        if activeButton then
            activeButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        end
        activeButton = Btn
        Btn.BackgroundColor3 = Color3.fromRGB(48, 48, 58)
        
        for key, frame in pairs(categoryFrames) do
            if frame then
                frame.Visible = (key == categoryKey)
            end
        end
    end)
    
    return Btn
end

-- Criar botões
CreateTabButton("🏠 Home", "Home")
CreateTabButton("👑 VIP", "VIP", not userData.vip)
CreateTabButton("⭐ Emphasis", "Emphasis")
CreateTabButton("👤 Character", "Character")
CreateTabButton("🎯 Target", "Target")
CreateTabButton("⚔️ More", "More")
CreateTabButton("🛠️ Misc", "Misc")

-- Abrir Home por padrão
activeButton = Sidebar:FindFirstChildOfClass("TextButton")
if activeButton then
    activeButton.BackgroundColor3 = Color3.fromRGB(48, 48, 58)
end

-- ==================== TOGGLE COM TECLA B ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.B then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- ==================== FINALIZAR ====================
print("[288] ✅ Painel carregado com sucesso!")
print("[288] 💡 Pressione [B] para abrir/fechar")
print("[288] 🎨 Design 288 Panel - Todos os direitos reservados")
