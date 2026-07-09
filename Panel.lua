--[[
    288 Panel v4.6.4
    UI completa — scripts carregados via GitHub
]]

-- ==================== SERVIÇOS ====================
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer

-- ==================== DEVICE ====================
local function getDevice()
    local ok, mobile = pcall(function()
        return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    end)
    return (ok and mobile) and "mobile" or "desktop"
end
local DEVICE      = getDevice()
local DEVICE_ICON = DEVICE == "mobile" and "📱" or "🖥️"

-- ==================== CONFIG ====================
local API_BASE   = "https://SUA-API-AQUI.railway.app"
local GITHUB_RAW = "https://raw.githubusercontent.com/Bondzinn/bondsp/refs/heads/main"
local VERSION    = "v4.6.4"

-- ==================== TEMA ====================
local THEMES = {
    dark = {
        main     = Color3.fromRGB(20,  20,  20),
        header   = Color3.fromRGB(15,  15,  15),
        sidebar  = Color3.fromRGB(14,  14,  14),
        content  = Color3.fromRGB(25,  25,  25),
        btn      = Color3.fromRGB(38,  38,  38),
        btnHover = Color3.fromRGB(55,  55,  55),
        btnOn    = Color3.fromRGB(65,  65,  65),
        text     = Color3.fromRGB(220, 220, 220),
        textDim  = Color3.fromRGB(160, 160, 160),
        sep      = Color3.fromRGB(35,  35,  35),
        stroke   = Color3.fromRGB(60,  60,  60),
    },
    light = {
        main     = Color3.fromRGB(235, 235, 235),
        header   = Color3.fromRGB(210, 210, 210),
        sidebar  = Color3.fromRGB(200, 200, 200),
        content  = Color3.fromRGB(245, 245, 245),
        btn      = Color3.fromRGB(190, 190, 190),
        btnHover = Color3.fromRGB(170, 170, 170),
        btnOn    = Color3.fromRGB(150, 150, 150),
        text     = Color3.fromRGB(30,  30,  30),
        textDim  = Color3.fromRGB(80,  80,  80),
        sep      = Color3.fromRGB(180, 180, 180),
        stroke   = Color3.fromRGB(140, 140, 140),
    },
}
local currentTheme = "dark"

local themeTargets = {}

local function registerTheme(obj, prop, darkKey, lightKey)
    table.insert(themeTargets, { obj=obj, prop=prop, dk=darkKey, lk=lightKey or darkKey })
end

local function applyTheme(name)
    currentTheme = name
    local T = THEMES[name]
    for _, e in ipairs(themeTargets) do
        local key = (name == "dark") and e.dk or e.lk
        e.obj[e.prop] = T[key]
    end
end

-- ==================== HELPERS HTTP ====================
local function apiGet(endpoint)
    local ok, res = pcall(function() return game:HttpGet(API_BASE .. endpoint) end)
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

local function safeLoadstring(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and res and res ~= "" then
        local fn, err = loadstring(res)
        if fn then return fn end
        warn("[288] compile err: " .. tostring(err))
    else
        warn("[288] fetch err: " .. url)
    end
    return nil
end

local function loadModule(path)
    local fn = safeLoadstring(GITHUB_RAW .. "/" .. path)
    if fn then
        local ok, err = pcall(fn)
        if not ok then warn("[288] module err " .. path .. ": " .. tostring(err)) end
    end
end

-- ==================== ROLES ====================
local ROLE_COLORS_MAP = {
    ["User"]       = Color3.fromRGB(170, 170, 170),
    ["VIP"]        = Color3.fromRGB(170, 0,   255),
    ["Helper"]     = Color3.fromRGB(0,   187, 255),
    ["Supporter"]  = Color3.fromRGB(0,   204, 170),
    ["Designer"]   = Color3.fromRGB(255, 105, 180),
    ["Marketing"]  = Color3.fromRGB(255, 136, 0  ),
    ["Admin"]      = Color3.fromRGB(255, 51,  51 ),
    ["Supervisor"] = Color3.fromRGB(255, 102, 0  ),
    ["Manager"]    = Color3.fromRGB(204, 0,   255),
    ["Co-Owner"]   = Color3.fromRGB(0,   221, 255),
    ["Owner"]      = Color3.fromRGB(30,  30,  30 ),
}

local OWNER_SHINE = {
    Color3.fromRGB(26, 26, 26), Color3.fromRGB(50, 50, 50),
    Color3.fromRGB(80, 80, 80), Color3.fromRGB(110,110,110),
    Color3.fromRGB(150,150,150),Color3.fromRGB(200,200,200),
    Color3.fromRGB(240,240,240),Color3.fromRGB(200,200,200),
    Color3.fromRGB(150,150,150),Color3.fromRGB(110,110,110),
    Color3.fromRGB(80, 80, 80), Color3.fromRGB(50, 50, 50),
}

-- ==================== GUI ROOT ====================
if LocalPlayer.PlayerGui:FindFirstChild("288Panel") then
    LocalPlayer.PlayerGui["288Panel"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "288Panel"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent         = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== MAIN FRAME ====================
local MainFrame = Instance.new("Frame")
MainFrame.Name             = "MainFrame"
MainFrame.Size             = UDim2.new(0, 500, 0, 380)
MainFrame.Position         = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel  = 0
MainFrame.Active           = true
MainFrame.Draggable        = true
MainFrame.ClipsDescendants = true
MainFrame.Parent           = ScreenGui
registerTheme(MainFrame, "BackgroundColor3", "main")

local MainStroke = Instance.new("UIStroke")
MainStroke.Color     = Color3.fromRGB(60, 60, 60)
MainStroke.Thickness = 1
MainStroke.Parent    = MainFrame

local BgLabel = Instance.new("ImageLabel")
BgLabel.Size             = UDim2.new(1, 0, 1, 0)
BgLabel.BackgroundTransparency = 1
BgLabel.Image            = "rbxassetid://13286350915"
BgLabel.ImageTransparency = 0.82
BgLabel.ScaleType        = Enum.ScaleType.Crop
BgLabel.ZIndex           = 0
BgLabel.Parent           = MainFrame

-- ==================== HEADER ====================
local Header = Instance.new("Frame")
Header.Name             = "Header"
Header.Size             = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Header.BorderSizePixel  = 0
Header.ZIndex           = 2
Header.Parent           = MainFrame
registerTheme(Header, "BackgroundColor3", "header")

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size             = UDim2.new(0, 70, 1, 0)
VersionLabel.Position         = UDim2.new(0, 8, 0, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text             = VERSION
VersionLabel.TextColor3       = Color3.fromRGB(180, 180, 180)
VersionLabel.TextSize         = 13
VersionLabel.Font             = Enum.Font.Gotham
VersionLabel.TextXAlignment   = Enum.TextXAlignment.Left
VersionLabel.ZIndex           = 3
VersionLabel.Parent           = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size             = UDim2.new(0.5, 0, 1, 0)
TitleLabel.Position         = UDim2.new(0.25, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text             = "288 Panel"
TitleLabel.TextSize         = 16
TitleLabel.Font             = Enum.Font.GothamBold
TitleLabel.TextXAlignment   = Enum.TextXAlignment.Center
TitleLabel.TextColor3       = Color3.fromRGB(255, 255, 255)
TitleLabel.ZIndex           = 3
TitleLabel.Parent           = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size             = UDim2.new(0, 28, 0, 28)
CloseBtn.Position         = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
CloseBtn.Text             = "✕"
CloseBtn.TextColor3       = Color3.new(1,1,1)
CloseBtn.TextSize         = 13
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.BorderSizePixel  = 0
CloseBtn.ZIndex           = 4
CloseBtn.Parent           = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ==================== SIDEBAR ====================
local Sidebar = Instance.new("Frame")
Sidebar.Name             = "Sidebar"
Sidebar.Size             = UDim2.new(0, 108, 1, -42)
Sidebar.Position         = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
Sidebar.BorderSizePixel  = 0
Sidebar.ZIndex           = 2
Sidebar.Parent           = MainFrame
registerTheme(Sidebar, "BackgroundColor3", "sidebar")

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding   = UDim.new(0, 0)
SidebarLayout.Parent    = Sidebar

-- ==================== CONTENT ====================
local ContentFrame = Instance.new("Frame")
ContentFrame.Name                  = "Content"
ContentFrame.Size                  = UDim2.new(1, -108, 1, -42)
ContentFrame.Position              = UDim2.new(0, 108, 0, 42)
ContentFrame.BackgroundColor3      = Color3.fromRGB(25, 25, 25)
ContentFrame.BackgroundTransparency= 0.15
ContentFrame.BorderSizePixel       = 0
ContentFrame.ZIndex                = 1
ContentFrame.Parent                = MainFrame
registerTheme(ContentFrame, "BackgroundColor3", "content")

-- ==================== TABS ====================
local Tabs       = {}
local CurrentTab = nil

local TABS_DEF = {
    { name = "Home",       layoutOrder = 1 },
    { name = "VIP",        layoutOrder = 2 },
    { name = "Emphasis",   layoutOrder = 3 },
    { name = "Character",  layoutOrder = 4 },
    { name = "Target",     layoutOrder = 5 },
    { name = "More",       layoutOrder = 6 },
    { name = "Misc",       layoutOrder = 7 },
    { name = "Servers",    layoutOrder = 8 },
    { name = "About",      layoutOrder = 9 },
}

local function setTab(name)
    if CurrentTab == name then return end
    CurrentTab = name
    local T = THEMES[currentTheme]
    for _, t in pairs(Tabs) do
        local active = (t.name == name)
        t.frame.Visible       = active
        t.btn.BackgroundColor3= active and Color3.fromRGB(45,45,45) or T.sidebar
        t.btn.TextColor3      = active and Color3.fromRGB(255,255,255) or T.textDim
    end
end

for _, def in ipairs(TABS_DEF) do
    local btn = Instance.new("TextButton")
    btn.Name             = def.name .. "Btn"
    btn.Size             = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel  = 0
    btn.Text             = def.name
    btn.TextColor3       = Color3.fromRGB(190, 190, 190)
    btn.TextSize         = 13
    btn.Font             = Enum.Font.Gotham
    btn.LayoutOrder      = def.layoutOrder
    btn.ZIndex           = 3
    btn.Parent           = Sidebar
    registerTheme(btn, "BackgroundColor3", "sidebar")
    registerTheme(btn, "TextColor3", "textDim", "textDim")

    local sep = Instance.new("Frame")
    sep.Size             = UDim2.new(1, 0, 0, 1)
    sep.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    sep.BorderSizePixel  = 0
    sep.ZIndex           = 3
    sep.Parent           = btn
    registerTheme(sep, "BackgroundColor3", "sep")

    local frame = Instance.new("ScrollingFrame")
    frame.Name               = def.name .. "Frame"
    frame.Size               = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible            = false
    frame.ZIndex             = 2
    frame.BorderSizePixel    = 0
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = Color3.fromRGB(80,80,80)
    frame.CanvasSize         = UDim2.new(0,0,0,0)
    frame.Parent             = ContentFrame

    Tabs[def.name] = { name = def.name, btn = btn, frame = frame }
    btn.MouseButton1Click:Connect(function() setTab(def.name) end)
end

local function refreshCanvas(scrollFrame, extraPadding)
    local maxY = 0
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("GuiObject") and child.Position.Y.Scale == 0 then
            local bottom = child.Position.Y.Offset + child.Size.Y.Offset
            if bottom > maxY then maxY = bottom end
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, maxY + (extraPadding or 12))
end

-- ==================== CONSTANTES GLOBAIS ====================
-- Largura total disponível no ContentFrame = 500 - 108 = 392px
local BTN_W = 150           -- Largura padrão para botões e inputs
local BTN_H = 34            -- Altura padrão para botões e inputs
local GAP = 8               -- Espaçamento entre elementos (horizontal e vertical)
local DOT_SIZE = 14         -- Tamanho do dot

-- Distribuição: 392 = padding_esquerdo + BTN_W + gap + DOT + gap + BTN_W + padding_direito
-- padding_esquerdo = padding_direito = (392 - 150 - 8 - 14 - 8 - 150) / 2 = 31
local PAD = 31              -- Padding igual nas bordas
local COL1 = PAD            -- Coluna 1 (esquerda)
local COL2 = COL1 + BTN_W + GAP + DOT_SIZE + GAP  -- Coluna 2 (direita)

-- Posições do DOT para cada coluna
local DOT1_X = COL1 + BTN_W + GAP
local DOT2_X = COL2 + BTN_W + GAP

-- ==================== UI HELPERS ====================
local function makeButton(parent, text, x, y, w, h, vipOnly)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, w or BTN_W, 0, h or BTN_H)
    btn.Position         = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    btn.BorderSizePixel  = 0
    btn.Text             = text
    btn.TextColor3       = Color3.fromRGB(220, 220, 220)
    btn.TextSize         = 12
    btn.Font             = Enum.Font.Gotham
    btn.TextXAlignment   = Enum.TextXAlignment.Center
    btn.ZIndex           = 4
    btn.Parent           = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    registerTheme(btn, "BackgroundColor3", "btn")
    registerTheme(btn, "TextColor3", "text")
    if vipOnly then
        local star = Instance.new("TextLabel")
        star.Size             = UDim2.new(0, 14, 0, 14)
        star.Position         = UDim2.new(1, -2, 0, -2)
        star.BackgroundTransparency = 1
        star.Text             = "✦"
        star.TextColor3       = Color3.fromRGB(220, 50, 50)
        star.TextSize         = 11
        star.Font             = Enum.Font.GothamBold
        star.ZIndex           = 5
        star.Parent           = btn
    end
    return btn
end

local function makeSectionLabel(parent, text, x, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size             = UDim2.new(1, -x*2, 0, 20)
    lbl.Position         = UDim2.new(0, x, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text             = text
    lbl.TextColor3       = Color3.fromRGB(160, 160, 160)
    lbl.TextSize         = 12
    lbl.Font             = Enum.Font.Gotham
    lbl.TextXAlignment   = Enum.TextXAlignment.Left
    lbl.ZIndex           = 4
    lbl.Parent           = parent
    registerTheme(lbl, "TextColor3", "textDim")
    return lbl
end

local function makeInput(parent, placeholder, x, y, w, h)
    local box = Instance.new("TextBox")
    box.Size             = UDim2.new(0, w or BTN_W, 0, h or BTN_H)
    box.Position         = UDim2.new(0, x, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    box.BorderSizePixel  = 0
    box.Text             = ""
    box.PlaceholderText  = placeholder
    box.PlaceholderColor3= Color3.fromRGB(120, 120, 120)
    box.TextColor3       = Color3.fromRGB(230, 230, 230)
    box.TextSize         = 12
    box.Font             = Enum.Font.Gotham
    box.TextXAlignment   = Enum.TextXAlignment.Center
    box.ZIndex           = 4
    box.Parent           = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    registerTheme(box, "BackgroundColor3", "btn")
    registerTheme(box, "TextColor3", "text")
    return box
end

local toggleStates = {}
local function makeToggleButton(parent, text, x, y, w, h, vipOnly)
    local btn = makeButton(parent, text, x, y, w, h, vipOnly)
    toggleStates[btn] = false
    btn.MouseButton1Click:Connect(function()
        toggleStates[btn] = not toggleStates[btn]
        btn.BackgroundColor3 = toggleStates[btn]
            and THEMES[currentTheme].btnOn
            or  THEMES[currentTheme].btn
    end)
    return btn
end

local function makeStatusDot(parent, x, y, size)
    size = size or DOT_SIZE
    local dot = Instance.new("Frame")
    dot.Size             = UDim2.new(0, size, 0, size)
    dot.Position         = UDim2.new(0, x, 0, y)
    dot.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 5
    dot.Parent           = parent
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local ring = Instance.new("UIStroke")
    ring.Color     = Color3.fromRGB(0, 0, 0)
    ring.Thickness = 1
    ring.Transparency = 0.5
    ring.Parent    = dot

    local api = {}
    function api.setActive(active)
        dot.BackgroundColor3 = active
            and Color3.fromRGB(80, 220, 100)
            or  Color3.fromRGB(90, 90, 90)
    end
    api.instance = dot
    return api
end

local function makeMouseDot(parent, x, y, size)
    size = size or DOT_SIZE
    local dot = Instance.new("TextLabel")
    dot.Size = UDim2.new(0, size, 0, size)
    dot.Position = UDim2.new(0, x, 0, y)
    dot.BackgroundTransparency = 1
    dot.Text = "🖱"
    dot.TextColor3 = Color3.fromRGB(140, 140, 140)
    dot.TextSize = 12
    dot.Font = Enum.Font.Gotham
    dot.ZIndex = 5
    dot.Parent = parent
    return dot
end

local function createBillboard(character, rank)
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if hrp:FindFirstChild("288TagGui") then
        hrp:FindFirstChild("288TagGui"):Destroy()
    end

    local color = ROLE_COLORS_MAP[rank] or ROLE_COLORS_MAP["User"]

    local bb = Instance.new("BillboardGui")
    bb.Name          = "288TagGui"
    bb.Size          = UDim2.new(0, 120, 0, 30)
    bb.StudsOffset   = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop   = false
    bb.ResetOnSpawn  = false
    bb.Parent        = hrp

    local bg = Instance.new("Frame")
    bg.Size             = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    bg.BackgroundTransparency = 0.3
    bg.BorderSizePixel  = 0
    bg.Parent           = bb
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color     = color
    stroke.Thickness = 1.2
    stroke.Parent    = bg

    local lbl = Instance.new("TextLabel")
    lbl.Size             = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text             = rank .. " " .. DEVICE_ICON
    lbl.TextColor3       = color
    lbl.TextSize         = 13
    lbl.Font             = Enum.Font.GothamBold
    lbl.TextXAlignment   = Enum.TextXAlignment.Center
    lbl.Parent           = bg

    if rank == "Owner" then
        task.spawn(function()
            local i = 1
            while bb.Parent do
                local c = OWNER_SHINE[i]
                stroke.Color  = c
                lbl.TextColor3 = c
                i = (i % #OWNER_SHINE) + 1
                task.wait(0.07)
            end
        end)
    end

    return bb
end

local function setupOwnTag(rank)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    createBillboard(char, rank)
    LocalPlayer.CharacterAdded:Connect(function(c)
        task.wait(1)
        createBillboard(c, _currentRank)
    end)
end

local function monitorOtherPlayers()
    local function hookPlayer(p)
        if p == LocalPlayer then return end
        local function hookChar(char)
            task.spawn(function()
                local tagVal = char:WaitForChild("288Tag", 10)
                if tagVal and tagVal:IsA("StringValue") then
                    createBillboard(char, tagVal.Value)
                    tagVal.Changed:Connect(function(v)
                        createBillboard(char, v)
                    end)
                end
            end)
        end
        if p.Character then hookChar(p.Character) end
        p.CharacterAdded:Connect(hookChar)
    end

    for _, p in ipairs(Players:GetPlayers()) do hookPlayer(p) end
    Players.PlayerAdded:Connect(hookPlayer)
end

local function broadcastOwnTag(rank)
    local char = LocalPlayer.Character
    if not char then return end
    local v = char:FindFirstChild("288Tag")
    if not v then
        v = Instance.new("StringValue")
        v.Name   = "288Tag"
        v.Parent = char
    end
    v.Value = rank
end

task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    task.wait(1)
    setupOwnTag("User")
    broadcastOwnTag("User")
    monitorOtherPlayers()
end)

-- ==================== HOME TAB ====================
do
    local f = Tabs["Home"].frame

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size             = UDim2.new(0, 90, 0, 90)
    avatarImg.Position         = UDim2.new(0, PAD, 0, 8)
    avatarImg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    avatarImg.BorderSizePixel  = 0
    avatarImg.Image            = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
    avatarImg.ZIndex           = 4
    avatarImg.Parent           = f
    Instance.new("UIStroke", avatarImg).Color = Color3.fromRGB(70, 70, 70)

    local greetLabel = Instance.new("TextLabel")
    greetLabel.Size             = UDim2.new(1, -115, 0, 30)
    greetLabel.Position         = UDim2.new(0, 108, 0, 12)
    greetLabel.BackgroundTransparency = 1
    greetLabel.Text             = "Olá " .. LocalPlayer.DisplayName .. "."
    greetLabel.TextColor3       = Color3.fromRGB(230, 230, 230)
    greetLabel.TextSize         = 14
    greetLabel.Font             = Enum.Font.GothamBold
    greetLabel.TextXAlignment   = Enum.TextXAlignment.Left
    greetLabel.ZIndex           = 4
    greetLabel.Parent           = f
    registerTheme(greetLabel, "TextColor3", "text")

    local hintLabel = Instance.new("TextLabel")
    hintLabel.Size             = UDim2.new(1, -115, 0, 40)
    hintLabel.Position         = UDim2.new(0, 108, 0, 40)
    hintLabel.BackgroundTransparency = 1
    hintLabel.Text             = "Pressione " .. "<b>[B]</b>" .. " para\nabrir/fechar o painel"
    hintLabel.TextColor3       = Color3.fromRGB(200, 200, 200)
    hintLabel.TextSize         = 12
    hintLabel.Font             = Enum.Font.Gotham
    hintLabel.TextXAlignment   = Enum.TextXAlignment.Left
    hintLabel.TextWrapped      = true
    hintLabel.RichText         = true
    hintLabel.ZIndex           = 4
    hintLabel.Parent           = f
    registerTheme(hintLabel, "TextColor3", "textDim")

    local pingLabel = Instance.new("TextLabel")
    pingLabel.Size             = UDim2.new(1, -20, 0, 22)
    pingLabel.Position         = UDim2.new(0, PAD, 0, 108)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text             = "Ping: "
    pingLabel.TextColor3       = Color3.fromRGB(230, 230, 230)
    pingLabel.TextSize         = 13
    pingLabel.Font             = Enum.Font.Gotham
    pingLabel.TextXAlignment   = Enum.TextXAlignment.Left
    pingLabel.ZIndex           = 4
    pingLabel.Parent           = f
    registerTheme(pingLabel, "TextColor3", "text")

    local pingVal = Instance.new("TextLabel")
    pingVal.Size             = UDim2.new(0, 70, 1, 0)
    pingVal.Position         = UDim2.new(0, 42, 0, 0)
    pingVal.BackgroundTransparency = 1
    pingVal.Text             = "--ms"
    pingVal.TextColor3       = Color3.fromRGB(80, 220, 80)
    pingVal.TextSize         = 13
    pingVal.Font             = Enum.Font.GothamBold
    pingVal.TextXAlignment   = Enum.TextXAlignment.Left
    pingVal.ZIndex           = 5
    pingVal.Parent           = pingLabel

    local onlineLabel = Instance.new("TextLabel")
    onlineLabel.Size             = UDim2.new(1, -20, 0, 20)
    onlineLabel.Position         = UDim2.new(0, PAD, 0, 136)
    onlineLabel.BackgroundTransparency = 1
    onlineLabel.Text             = "Online: --"
    onlineLabel.TextColor3       = Color3.fromRGB(200, 200, 200)
    onlineLabel.TextSize         = 12
    onlineLabel.Font             = Enum.Font.Gotham
    onlineLabel.TextXAlignment   = Enum.TextXAlignment.Left
    onlineLabel.ZIndex           = 4
    onlineLabel.Parent           = f
    registerTheme(onlineLabel, "TextColor3", "textDim")

    local usersLabel = Instance.new("TextLabel")
    usersLabel.Size             = UDim2.new(1, -20, 0, 20)
    usersLabel.Position         = UDim2.new(0, PAD, 0, 158)
    usersLabel.BackgroundTransparency = 1
    usersLabel.Text             = "Users: --"
    usersLabel.TextColor3       = Color3.fromRGB(200, 200, 200)
    usersLabel.TextSize         = 12
    usersLabel.Font             = Enum.Font.Gotham
    usersLabel.TextXAlignment   = Enum.TextXAlignment.Left
    usersLabel.ZIndex           = 4
    usersLabel.Parent           = f
    registerTheme(usersLabel, "TextColor3", "textDim")

    local dateLabel = Instance.new("TextLabel")
    dateLabel.Size             = UDim2.new(1, -20, 0, 20)
    dateLabel.Position         = UDim2.new(0, PAD, 0, 184)
    dateLabel.BackgroundTransparency = 1
    dateLabel.Text             = "Date: --"
    dateLabel.TextColor3       = Color3.fromRGB(80, 180, 255)
    dateLabel.TextSize         = 12
    dateLabel.Font             = Enum.Font.Gotham
    dateLabel.TextXAlignment   = Enum.TextXAlignment.Left
    dateLabel.ZIndex           = 4
    dateLabel.Parent           = f

    task.spawn(function()
        while task.wait(3) do
            if not ScreenGui.Parent then break end
            local ping = LocalPlayer:GetPing() or 0
            pingVal.Text = math.floor(ping) .. "ms"
            pingVal.TextColor3 = ping < 80 and Color3.fromRGB(80,220,80)
                or ping < 150 and Color3.fromRGB(255,200,50)
                or Color3.fromRGB(220,60,60)

            local stats = apiGet("/stats")
            if stats then
                onlineLabel.Text = "Online: " .. tostring(stats.online or stats.activeSessions or "--")
                usersLabel.Text  = "Users: "  .. tostring(stats.totalUsers or "--")
            end

            local t = os.date("*t")
            dateLabel.Text = string.format("Date: %02d/%02d/%04d %02d:%02d",
                t.day, t.month, t.year, t.hour, t.min)
        end
    end)
    refreshCanvas(f)
end

-- ==================== VIP TAB ====================
do
    local f = Tabs["VIP"].frame
    local y = 10
    local vipButtons = {
        {"Fling", 1}, {"AntiFling", 2, true},
        {"AntiForce", 3}, {"AntiChatSpy", 4, true},
        {"AutoSacrifice", 5}, {"EscapeHandcuffs", 6},
        {"AutoParry", 7}, {"ButterflyFarm", 8},
        {"EggCollect", 9},
    }
    for _, v in ipairs(vipButtons) do
        local col = (v[2] % 2 == 1) and COL1 or COL2
        local row = math.floor((v[2] - 1) / 2)
        local yPos = y + row * (BTN_H + GAP)
        local btn = makeButton(f, v[1], col, yPos, BTN_W, BTN_H, v[3])
        btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
        btn.TextColor3       = Color3.fromRGB(120,120,120)
        btn.TextTransparency = 0.3
    end
    local overlay = Instance.new("Frame")
    overlay.Size             = UDim2.new(1,0,1,0)
    overlay.BackgroundColor3 = Color3.fromRGB(10,10,10)
    overlay.BackgroundTransparency = 0.35
    overlay.BorderSizePixel  = 0
    overlay.ZIndex           = 6
    overlay.Parent           = f
    local vipTitle = Instance.new("TextLabel")
    vipTitle.Size             = UDim2.new(1,0,0,40)
    vipTitle.Position         = UDim2.new(0,0,0.35,0)
    vipTitle.BackgroundTransparency = 1
    vipTitle.Text             = "ADQUIRIR VIP"
    vipTitle.TextColor3       = Color3.fromRGB(255,200,0)
    vipTitle.TextSize         = 22
    vipTitle.Font             = Enum.Font.GothamBold
    vipTitle.TextXAlignment   = Enum.TextXAlignment.Center
    vipTitle.ZIndex           = 7
    vipTitle.Parent           = overlay
    local vipLink = Instance.new("TextLabel")
    vipLink.Size             = UDim2.new(1,0,0,24)
    vipLink.Position         = UDim2.new(0,0,0.35,44)
    vipLink.BackgroundTransparency = 1
    vipLink.Text             = "ACESSE: https://discord.gg/ksxs"
    vipLink.TextColor3       = Color3.fromRGB(200,200,200)
    vipLink.TextSize         = 13
    vipLink.Font             = Enum.Font.Gotham
    vipLink.TextXAlignment   = Enum.TextXAlignment.Center
    vipLink.ZIndex           = 7
    vipLink.Parent           = overlay
    refreshCanvas(f)
end

-- ==================== EMPHASIS TAB ====================
do
    local f    = Tabs["Emphasis"].frame
    local y = 10
    local emphasisBtns = {
        {name="Invisible", order=1}, {name="ClickTP", order=2},
        {name="NoClip", order=3}, {name="JerkOff", order=4},
        {name="Impulse", order=5}, {name="FaceBang", order=6},
        {name="Spin", order=7}, {name="AnimSpeed", order=8},
        {name="feFlip", order=9}, {name="Flashback", order=10},
        {name="AntiVoid", order=11},
    }
    for _, v in ipairs(emphasisBtns) do
        local col = (v.order % 2 == 1) and COL1 or COL2
        local row = math.floor((v.order - 1) / 2)
        local yPos = y + row * (BTN_H + GAP)
        local btn = makeToggleButton(f, v.name, col, yPos, BTN_W, BTN_H)
        btn.TextSize = 13
        local dotX = (v.order % 2 == 1) and DOT1_X or DOT2_X
        makeStatusDot(f, dotX, yPos + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
    end
    refreshCanvas(f)
end

-- ==================== CHARACTER TAB ====================
do
    local f = Tabs["Character"].frame
    local y = 10

    local DEFAULT_WS = 16
    local DEFAULT_JP = 50

    local wsBtn   = makeButton(f,"Walk Speed",COL1,y,BTN_W,BTN_H)
    local wsDot   = makeStatusDot(f, DOT1_X, y + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
    local wsInput = makeInput(f,"[0-n]",DOT1_X + DOT_SIZE + GAP, y, BTN_W, BTN_H)
    local wsActive = false
    wsBtn.MouseButton1Click:Connect(function()
        wsActive = not wsActive
        wsDot.setActive(wsActive)
        wsBtn.BackgroundColor3 = wsActive and THEMES[currentTheme].btnOn or THEMES[currentTheme].btn
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h.WalkSpeed = wsActive and (tonumber(wsInput.Text) or DEFAULT_WS) or DEFAULT_WS
        end
    end)
    wsInput:GetPropertyChangedSignal("Text"):Connect(function()
        if not wsActive then return end
        local val = tonumber(wsInput.Text)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if val and h then h.WalkSpeed = val end
    end)

    y = y + BTN_H + GAP

    local jpBtn   = makeButton(f,"Jump Power",COL1,y,BTN_W,BTN_H)
    local jpDot   = makeStatusDot(f, DOT1_X, y + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
    local jpInput = makeInput(f,"[0-n]",DOT1_X + DOT_SIZE + GAP, y, BTN_W, BTN_H)
    local jpActive = false
    jpBtn.MouseButton1Click:Connect(function()
        jpActive = not jpActive
        jpDot.setActive(jpActive)
        jpBtn.BackgroundColor3 = jpActive and THEMES[currentTheme].btnOn or THEMES[currentTheme].btn
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h.JumpPower = jpActive and (tonumber(jpInput.Text) or DEFAULT_JP) or DEFAULT_JP
        end
    end)
    jpInput:GetPropertyChangedSignal("Text"):Connect(function()
        if not jpActive then return end
        local val = tonumber(jpInput.Text)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if val and h then h.JumpPower = val end
    end)

    y = y + BTN_H + GAP

    local flyBtn   = makeButton(f,"Fly",COL1,y,BTN_W,BTN_H)
    local flyDot   = makeStatusDot(f, DOT1_X, y + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
    local flyInput = makeInput(f,"[0-n]",DOT1_X + DOT_SIZE + GAP, y, BTN_W, BTN_H)
    local flyActive = false

    local function setFly(state)
        flyActive = state
        flyDot.setActive(flyActive)
        flyBtn.BackgroundColor3 = flyActive and THEMES[currentTheme].btnOn or THEMES[currentTheme].btn
        if flyActive then
            loadModule("modules/Emphasis/Fly.lua")
        else
            loadModule("modules/Emphasis/FlyOff.lua")
        end
    end

    flyBtn.MouseButton1Click:Connect(function() setFly(not flyActive) end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.F and CurrentTab == "Character" then
            setFly(not flyActive)
        end
    end)

    y = y + BTN_H + GAP

    local respawnBtn = makeButton(f,"Respawn",COL1,y,BTN_W,BTN_H)
    local ckBtn      = makeButton(f,"Checkpoint",COL2,y,BTN_W,BTN_H,true)
    local ckDot      = makeStatusDot(f, DOT2_X, y + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
    local ckActive    = false
    respawnBtn.MouseButton1Click:Connect(function()
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
    end)
    ckBtn.MouseButton1Click:Connect(function()
        ckActive = not ckActive
        ckDot.setActive(ckActive)
        ckBtn.BackgroundColor3 = ckActive and THEMES[currentTheme].btnOn or THEMES[currentTheme].btn
        loadModule(ckActive and "modules/Character/Checkpoint.lua" or "modules/Character/CheckpointOff.lua")
    end)

    refreshCanvas(f)
end

-- ==================== TARGET TAB ====================
do
    local f = Tabs["Target"].frame

    local CF_X = 108; local CF_Y = 42
    local IN_Y = 6
    local IN_W = BTN_W; local IN_H = BTN_H

    -- Avatar do target (canto esquerdo)
    local targetAvatar = Instance.new("ImageLabel")
    targetAvatar.Size             = UDim2.new(0, 95, 0, 95)
    targetAvatar.Position         = UDim2.new(0, PAD, 0, IN_Y)
    targetAvatar.BackgroundColor3 = Color3.fromRGB(30,30,30)
    targetAvatar.BorderSizePixel  = 0
    targetAvatar.Image            = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    targetAvatar.ImageColor3      = Color3.fromRGB(90,90,90)
    targetAvatar.ScaleType        = Enum.ScaleType.Fit
    targetAvatar.ZIndex           = 4
    targetAvatar.Parent           = f
    local avStroke = Instance.new("UIStroke")
    avStroke.Color=Color3.fromRGB(65,65,65); avStroke.Thickness=1; avStroke.Parent=targetAvatar

    -- Input e botão 👆 no canto direito
    local inputStartX = PAD + 95 + GAP
    local availableWidth = 392 - inputStartX - PAD  -- espaço disponível para input + botão
    local inputWidth = availableWidth - BTN_H - GAP  -- BTN_H é o tamanho do botão 👆
    
    local usernameInput = Instance.new("TextBox")
    usernameInput.Size             = UDim2.new(0, inputWidth, 0, IN_H)
    usernameInput.Position         = UDim2.new(0, inputStartX, 0, IN_Y)
    usernameInput.BackgroundColor3 = Color3.fromRGB(38,38,38)
    usernameInput.BorderSizePixel  = 0
    usernameInput.Text             = ""
    usernameInput.PlaceholderText  = "@username ou displayname..."
    usernameInput.PlaceholderColor3= Color3.fromRGB(105,105,105)
    usernameInput.TextColor3       = Color3.fromRGB(230,230,230)
    usernameInput.TextSize         = 12
    usernameInput.Font             = Enum.Font.Gotham
    usernameInput.ClearTextOnFocus = false
    usernameInput.ZIndex           = 4
    usernameInput.Parent           = f
    Instance.new("UICorner",usernameInput).CornerRadius=UDim.new(0,5)
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color=Color3.fromRGB(60,60,60); inputStroke.Thickness=1; inputStroke.Parent=usernameInput

    -- Botão 👆
    local searchBtn = Instance.new("TextButton")
    searchBtn.Size             = UDim2.new(0, BTN_H, 0, BTN_H)
    searchBtn.Position         = UDim2.new(0, inputStartX + inputWidth + GAP, 0, IN_Y)
    searchBtn.BackgroundColor3 = Color3.fromRGB(42,42,42)
    searchBtn.BorderSizePixel  = 0
    searchBtn.Text             = "👆"
    searchBtn.TextSize         = 18
    searchBtn.Font             = Enum.Font.Gotham
    searchBtn.ZIndex           = 4
    searchBtn.Parent           = f
    Instance.new("UICorner",searchBtn).CornerRadius=UDim.new(0,6)
    Instance.new("UIStroke",searchBtn).Color=Color3.fromRGB(65,65,65)

    -- Dica inicial
    local hintLbl = Instance.new("TextLabel")
    hintLbl.Size             = UDim2.new(0, 175, 0, 32)
    hintLbl.Position         = UDim2.new(0, inputStartX, 0, 76)
    hintLbl.BackgroundTransparency = 1
    hintLbl.Text             = "Digite um nome acima\npara buscar um jogador"
    hintLbl.TextColor3       = Color3.fromRGB(120,120,120)
    hintLbl.TextSize         = 11
    hintLbl.Font             = Enum.Font.Gotham
    hintLbl.TextXAlignment   = Enum.TextXAlignment.Left
    hintLbl.TextWrapped      = true
    hintLbl.ZIndex           = 4
    hintLbl.Parent           = f
    registerTheme(hintLbl,"TextColor3","textDim")

    -- Info labels
    local function makeInfo(text, yp)
        local l=Instance.new("TextLabel")
        l.Size=UDim2.new(0, 175, 0, 17)
        l.Position=UDim2.new(0, inputStartX, 0, yp)
        l.BackgroundTransparency=1
        l.Text=text
        l.TextColor3=Color3.fromRGB(185,185,185)
        l.TextSize=11
        l.Font=Enum.Font.Gotham
        l.TextXAlignment=Enum.TextXAlignment.Left
        l.ZIndex=4
        l.Parent=f
        registerTheme(l,"TextColor3","textDim")
        return l
    end
    local userIdLbl = makeInfo("UserID:",  40)
    local displayLbl= makeInfo("Display:", 58)
    local nameLbl2  = makeInfo("Name:",    76)
    userIdLbl.Visible  = false
    displayLbl.Visible = false
    nameLbl2.Visible   = false

    -- Dropdown
    local ITEM_H   = 40
    local ITEM_GAP = 1
    local MAX_VIS  = 4

    local suggestFrame = Instance.new("ScrollingFrame")
    suggestFrame.Size                 = UDim2.new(0, inputWidth, 0, 0)
    suggestFrame.BackgroundColor3     = Color3.fromRGB(24,24,24)
    suggestFrame.BorderSizePixel      = 0
    suggestFrame.ScrollBarThickness   = 3
    suggestFrame.ScrollBarImageColor3 = Color3.fromRGB(75,75,75)
    suggestFrame.CanvasSize           = UDim2.new(0,0,0,0)
    suggestFrame.ZIndex               = 50
    suggestFrame.Visible              = false
    suggestFrame.ClipsDescendants     = true
    suggestFrame.Parent               = ScreenGui
    Instance.new("UICorner",suggestFrame).CornerRadius=UDim.new(0,6)
    local dropStroke=Instance.new("UIStroke")
    dropStroke.Color=Color3.fromRGB(60,60,60); dropStroke.Thickness=1; dropStroke.Parent=suggestFrame

    local suggestLayout=Instance.new("UIListLayout")
    suggestLayout.SortOrder=Enum.SortOrder.LayoutOrder
    suggestLayout.Padding=UDim.new(0,ITEM_GAP)
    suggestLayout.Parent=suggestFrame

    local function updateDropPos()
        local mfp = MainFrame.AbsolutePosition
        suggestFrame.Position = UDim2.new(0,
            mfp.X + CF_X + inputStartX,
            0,
            mfp.Y + CF_Y + IN_Y + IN_H + 2)
    end
    MainFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        if suggestFrame.Visible then updateDropPos() end
    end)

    local avatarCache = {}

    -- Botões de ação
    local TARGET_BTNS = {
        {name="View", order=1}, {name="Focus", order=2, vip=true},
        {name="Follow", order=3, vip=true}, {name="Stand", order=4},
        {name="Bang", order=5, vip=true}, {name="Drag", order=6},
        {name="Headsit", order=7, vip=true}, {name="Doggy", order=8, vip=true},
        {name="Backpack", order=9, vip=true},
    }
    local GRID_Y = 108
    local targetUser = nil

    for _, v in ipairs(TARGET_BTNS) do
        local col = (v.order % 2 == 1) and COL1 or COL2
        local row = math.floor((v.order - 1) / 2)
        local yPos = GRID_Y + row * (BTN_H + GAP)
        local btn = makeButton(f, v.name, col, yPos, BTN_W, BTN_H, v.vip)
        btn.TextSize = 13
        local dotX = (v.order % 2 == 1) and DOT1_X or DOT2_X
        local dot = makeStatusDot(f, dotX, yPos + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
        local active = false
        btn.MouseButton1Click:Connect(function()
            if not targetUser then return end
            active = not active
            dot.setActive(active)
            btn.BackgroundColor3 = active and THEMES[currentTheme].btnOn or THEMES[currentTheme].btn
            local safe = v.name:gsub(" ","")
            loadModule(active and ("modules/Target/"..safe..".lua") or ("modules/Target/"..safe.."Off.lua"))
        end)
    end

    local function applyTarget(player)
        targetUser   = player
        userIdLbl.Text  = "UserID: "  .. tostring(player.UserId)
        displayLbl.Text = "Display: " .. tostring(player.DisplayName)
        nameLbl2.Text   = "Name: "    .. tostring(player.Name)
        userIdLbl.Visible  = true
        displayLbl.Visible = true
        nameLbl2.Visible   = true
        hintLbl.Visible     = false
        targetAvatar.ImageColor3 = Color3.fromRGB(255,255,255)

        if avatarCache[player.UserId] then
            targetAvatar.Image = avatarCache[player.UserId]
        else
            task.spawn(function()
                local ok, img = pcall(function()
                    return Players:GetUserThumbnailAsync(
                        player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
                end)
                if ok and targetAvatar.Parent then
                    avatarCache[player.UserId] = img
                    targetAvatar.Image = img
                end
            end)
        end

        suggestFrame.Visible = false
        inputStroke.Color    = Color3.fromRGB(80,180,80)
        usernameInput.Text   = player.Name
    end

    local function showDropdown(matches)
        updateDropPos()
        for _, c in pairs(suggestFrame:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end

        for i, p in ipairs(matches) do
            local row = Instance.new("Frame")
            row.Name             = "Row"..i
            row.Size             = UDim2.new(1,0,0,ITEM_H)
            row.BackgroundColor3 = Color3.fromRGB(30,30,30)
            row.BorderSizePixel  = 0
            row.LayoutOrder      = i
            row.ZIndex           = 51
            row.Parent           = suggestFrame

            local ava = Instance.new("ImageLabel")
            ava.Size=UDim2.new(0,30,0,30)
            ava.Position=UDim2.new(0,5,0.5,-15)
            ava.BackgroundColor3=Color3.fromRGB(38,38,38)
            ava.BorderSizePixel=0
            ava.ZIndex=52
            ava.Parent=row
            Instance.new("UICorner",ava).CornerRadius=UDim.new(0,4)

            if avatarCache[p.UserId] then
                ava.Image = avatarCache[p.UserId]
            else
                task.spawn(function()
                    local ok, img = pcall(function()
                        return Players:GetUserThumbnailAsync(
                            p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                    end)
                    if ok and ava.Parent then
                        avatarCache[p.UserId] = img
                        ava.Image = img
                    end
                end)
            end

            local uLbl=Instance.new("TextLabel")
            uLbl.Size=UDim2.new(1,-42,0,19)
            uLbl.Position=UDim2.new(0,40,0,3)
            uLbl.BackgroundTransparency=1
            uLbl.Text=p.Name
            uLbl.TextColor3=Color3.fromRGB(230,230,230)
            uLbl.TextSize=12
            uLbl.Font=Enum.Font.GothamBold
            uLbl.TextXAlignment=Enum.TextXAlignment.Left
            uLbl.TextTruncate=Enum.TextTruncate.AtEnd
            uLbl.ZIndex=52
            uLbl.Parent=row

            local dLbl=Instance.new("TextLabel")
            dLbl.Size=UDim2.new(1,-42,0,16)
            dLbl.Position=UDim2.new(0,40,0,22)
            dLbl.BackgroundTransparency=1
            dLbl.Text=p.DisplayName
            dLbl.TextColor3=Color3.fromRGB(130,130,130)
            dLbl.TextSize=10
            dLbl.Font=Enum.Font.Gotham
            dLbl.TextXAlignment=Enum.TextXAlignment.Left
            dLbl.TextTruncate=Enum.TextTruncate.AtEnd
            dLbl.ZIndex=52
            dLbl.Parent=row

            row.MouseEnter:Connect(function() row.BackgroundColor3=Color3.fromRGB(44,44,44) end)
            row.MouseLeave:Connect(function() row.BackgroundColor3=Color3.fromRGB(30,30,30) end)

            local hitBox=Instance.new("TextButton")
            hitBox.Size=UDim2.new(1,0,1,0)
            hitBox.BackgroundTransparency=1
            hitBox.Text=""
            hitBox.ZIndex=53
            hitBox.Parent=row
            hitBox.MouseButton1Click:Connect(function() applyTarget(p) end)
        end

        local vis = math.min(#matches, MAX_VIS)
        suggestFrame.CanvasSize = UDim2.new(0,0,0, #matches*(ITEM_H+ITEM_GAP))
        suggestFrame.Size       = UDim2.new(0,inputWidth,0, vis*(ITEM_H+ITEM_GAP))
        suggestFrame.Visible    = true
    end

    local function searchPlayers(query)
        if query == "" then
            suggestFrame.Visible = false
            inputStroke.Color    = Color3.fromRGB(60,60,60)
            return
        end
        local q = query:lower()
        local matches = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            if p.Name:lower():find(q,1,true)
            or p.DisplayName:lower():find(q,1,true) then
                table.insert(matches, p)
            end
        end
        if #matches == 0 then
            suggestFrame.Visible = false
        else
            showDropdown(matches)
        end
    end

    usernameInput:GetPropertyChangedSignal("Text"):Connect(function()
        inputStroke.Color = Color3.fromRGB(60,60,60)
        searchPlayers(usernameInput.Text)
    end)

    searchBtn.MouseButton1Click:Connect(function()
        local q = usernameInput.Text
        if q=="" then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p==LocalPlayer then continue end
            if p.Name:lower()==q:lower() or p.DisplayName:lower()==q:lower() then
                applyTarget(p); return
            end
        end
        searchPlayers(q)
    end)

    usernameInput.FocusLost:Connect(function()
        task.wait(0.18)
        suggestFrame.Visible = false
    end)

    for _, t in pairs(Tabs) do
        t.btn.MouseButton1Click:Connect(function()
            if t.name ~= "Target" then
                suggestFrame.Visible = false
            else
                updateDropPos()
            end
        end)
    end

    refreshCanvas(f)
end

-- ==================== MORE TAB ====================
do
    local f = Tabs["More"].frame
    local y = 8
    
    makeSectionLabel(f,"Casual",PAD,y)
    y = y + 20 + GAP
    
    local antiBanState = false
    local antiBanBtn = makeToggleButton(f,"AntiBanVC",COL1,y,BTN_W,BTN_H)
    local antiBanDot = makeStatusDot(f, DOT1_X, y + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
    local antiBanStatusLbl = Instance.new("TextLabel")
    antiBanStatusLbl.Size=UDim2.new(0,30,0,22)
    antiBanStatusLbl.Position=UDim2.new(0, DOT1_X + DOT_SIZE + GAP, 0, y+6)
    antiBanStatusLbl.BackgroundTransparency=1
    antiBanStatusLbl.Text="[O]"
    antiBanStatusLbl.TextColor3=Color3.fromRGB(120,120,120)
    antiBanStatusLbl.TextSize=12
    antiBanStatusLbl.Font=Enum.Font.Gotham
    antiBanStatusLbl.ZIndex=4
    antiBanStatusLbl.Parent=f
    antiBanBtn.MouseButton1Click:Connect(function()
        antiBanState = not antiBanState
        antiBanDot.setActive(antiBanState)
        antiBanStatusLbl.Text      = antiBanState and "[I]" or "[O]"
        antiBanStatusLbl.TextColor3= antiBanState and Color3.fromRGB(80,220,80) or Color3.fromRGB(120,120,120)
        antiBanBtn.BackgroundColor3 = antiBanState and THEMES[currentTheme].btnOn or THEMES[currentTheme].btn
        loadModule("modules/More/AntiBanVC.lua")
    end)
    y = y + BTN_H + GAP
    
    local pianoBtn = makeButton(f,"PianoAuto",COL1,y,BTN_W,BTN_H)
    pianoBtn.MouseButton1Click:Connect(function() loadModule("modules/More/PianoAuto.lua") end)
    y = y + BTN_H + GAP + 4

    makeSectionLabel(f,"FPS",PAD,y)
    y = y + 20 + GAP

    local espBtn  = makeButton(f,"ESP",COL1,y,BTN_W,BTN_H)
    local espDot  = makeStatusDot(f, DOT1_X, y+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    local espActive = false
    local function setEsp(state)
        espActive = state
        espDot.setActive(espActive)
        espBtn.BackgroundColor3 = espActive and THEMES[currentTheme].btnOn or THEMES[currentTheme].btn
        loadModule(espActive and "modules/More/ESP.lua" or "modules/More/ESPOff.lua")
    end
    espBtn.MouseButton1Click:Connect(function() setEsp(not espActive) end)
    y = y + BTN_H + GAP

    local aimBtn  = makeButton(f,"Aimbot",COL1,y,BTN_W,BTN_H)
    local aimDot  = makeStatusDot(f, DOT1_X, y+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    local aimActive = false
    local function setAimbot(state)
        aimActive = state
        aimDot.setActive(aimActive)
        aimBtn.BackgroundColor3 = aimActive and THEMES[currentTheme].btnOn or THEMES[currentTheme].btn
        loadModule(aimActive and "modules/More/Aimbot.lua" or "modules/More/AimbotOff.lua")
    end
    aimBtn.MouseButton1Click:Connect(function() setAimbot(not aimActive) end)
    y = y + BTN_H + GAP

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if CurrentTab ~= "More" then return end
        if input.KeyCode == Enum.KeyCode.E then
            setEsp(not espActive)
        elseif input.KeyCode == Enum.KeyCode.F then
            setAimbot(not aimActive)
        end
    end)
    refreshCanvas(f)
end

-- ==================== MISC TAB ====================
do
    local f = Tabs["Misc"].frame
    local y = 10

    -- Linha 1
    local antiAfkBtn = makeButton(f,"Anti AFK",COL1,y,BTN_W,BTN_H,true)
    local antiAfkDot = makeStatusDot(f, DOT1_X, y+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    local antiAfkActive = false
    local antiAfkConn = nil
    local function setAntiAfk(state)
        antiAfkActive = state
        antiAfkDot.setActive(antiAfkActive)
        antiAfkBtn.BackgroundColor3 = antiAfkActive and THEMES[currentTheme].btnOn or THEMES[currentTheme].btn
        if antiAfkActive and not antiAfkConn then
            antiAfkConn = LocalPlayer.Idled:Connect(function()
                local vu = game:GetService("VirtualUser")
                pcall(function() vu:CaptureController() end)
                pcall(function() vu:ClickButton2(Vector2.new()) end)
            end)
        elseif not antiAfkActive and antiAfkConn then
            antiAfkConn:Disconnect()
            antiAfkConn = nil
        end
    end
    antiAfkBtn.MouseButton1Click:Connect(function() setAntiAfk(not antiAfkActive) end)

    local tpBtn = makeButton(f,"TpToOwner",COL2,y,BTN_W,BTN_H)
    makeMouseDot(f, DOT2_X, y+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    tpBtn.MouseButton1Click:Connect(function() loadModule("modules/Misc/TpToOwner.lua") end)
    y = y + BTN_H + GAP

    -- Linha 2
    local shadersBtn = makeButton(f,"Shaders",COL1,y,BTN_W,BTN_H,true)
    local shadersDot = makeStatusDot(f, DOT1_X, y+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    local shadersActive = false
    shadersBtn.MouseButton1Click:Connect(function()
        shadersActive = not shadersActive
        shadersDot.setActive(shadersActive)
        shadersBtn.BackgroundColor3 = shadersActive and THEMES[currentTheme].btnOn or THEMES[currentTheme].btn
        loadModule(shadersActive and "modules/Misc/Shaders.lua" or "modules/Misc/ShadersOff.lua")
    end)

    local dayNightBtn = makeButton(f,"Day/Night",COL2,y,BTN_W,BTN_H,true)
    local dayNightDot = makeStatusDot(f, DOT2_X, y+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    local dayNightActive = false
    dayNightBtn.MouseButton1Click:Connect(function()
        dayNightActive = not dayNightActive
        dayNightDot.setActive(dayNightActive)
        dayNightBtn.BackgroundColor3 = dayNightActive and THEMES[currentTheme].btnOn or THEMES[currentTheme].btn
        loadModule(dayNightActive and "modules/Misc/DayNight.lua" or "modules/Misc/DayNightOff.lua")
    end)
    y = y + BTN_H + GAP

    -- Linha 3
    local resetBtn = makeButton(f,"Reset Lighting",COL1,y,BTN_W,BTN_H)
    makeMouseDot(f, DOT1_X, y+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    resetBtn.MouseButton1Click:Connect(function() loadModule("modules/Misc/ResetLighting.lua") end)

    local destroyBtn = makeButton(f,"Destroy GUI",COL2,y,BTN_W,BTN_H)
    makeMouseDot(f, DOT2_X, y+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    destroyBtn.MouseButton1Click:Connect(function() loadModule("modules/Misc/DestroyGUI.lua") end)
    y = y + BTN_H + GAP

    -- Linha 4
    local freeEmoteBtn = makeButton(f,"Free Emote",COL1,y,BTN_W,BTN_H)
    makeMouseDot(f, DOT1_X, y+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    freeEmoteBtn.MouseButton1Click:Connect(function() loadModule("modules/Misc/FreeEmote.lua") end)

    local clearBtn = makeButton(f,"Clear Chat",COL2,y,BTN_W,BTN_H)
    makeMouseDot(f, DOT2_X, y+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    clearBtn.MouseButton1Click:Connect(function() loadModule("modules/Misc/ClearChat.lua") end)
    y = y + BTN_H + GAP

    -- Linha 5
    local rejoinBtn = makeButton(f,"Rejoin",COL1,y,BTN_W,BTN_H)
    makeMouseDot(f, DOT1_X, y+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    rejoinBtn.MouseButton1Click:Connect(function()
        local TeleportService = game:GetService("TeleportService")
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end)

    local premBtn = makeButton(f,"Infinite Premium",COL2,y,BTN_W,BTN_H)
    makeMouseDot(f, DOT2_X, y+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    premBtn.MouseButton1Click:Connect(function() loadModule("modules/Misc/InfinitePremium.lua") end)
    y = y + BTN_H + GAP

    refreshCanvas(f)
end

-- ==================== SERVERS TAB ====================
do
    local f = Tabs["Servers"].frame
    f.ScrollingEnabled = false
    local http_request = http and http.request or syn and syn.request or request
    local HttpService = game:GetService("HttpService")
    
    makeSectionLabel(f, "Available Servers:", PAD, 8)
    
    local refreshBtn = makeButton(f, "↻ Atualizar", COL2 + BTN_W + GAP, 4, BTN_W, BTN_H)

    local serverList = Instance.new("ScrollingFrame")
    serverList.Size = UDim2.new(1, -PAD*2, 1, -44)
    serverList.Position = UDim2.new(0, PAD, 0, 44)
    serverList.BackgroundTransparency = 1
    serverList.ScrollBarThickness = 4
    serverList.BorderSizePixel = 0
    serverList.ZIndex = 4
    serverList.Parent = f

    local CARD_W = BTN_W
    local CARD_H = BTN_H
    local GAP_Y = GAP
    local CARD_COL1 = 0
    local CARD_COL2 = CARD_W + GAP

    local function makeServerCard(server, layoutOrder)
        local card = Instance.new("TextButton")
        card.Name = "Card" .. layoutOrder
        card.Size = UDim2.new(0, CARD_W, 0, CARD_H)
        card.Position = UDim2.new(0, (layoutOrder % 2 == 1) and CARD_COL1 or CARD_COL2, 0, math.floor((layoutOrder - 1) / 2) * (CARD_H + GAP_Y))
        card.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        card.AutoButtonColor = false
        card.BorderSizePixel = 0
        card.Text = ""
        card.ZIndex = 5
        card.Parent = serverList
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        
        local cardStroke = Instance.new("UIStroke")
        cardStroke.Color = Color3.fromRGB(55, 55, 55)
        cardStroke.Thickness = 1
        cardStroke.Parent = card

        local infoLbl = Instance.new("TextLabel")
        infoLbl.Size = UDim2.new(1, -40, 1, 0)
        infoLbl.Position = UDim2.new(0, 14, 0, 0)
        infoLbl.BackgroundTransparency = 1
        infoLbl.RichText = true
        infoLbl.Text = string.format("%d/%d <font color=\"#%s\">・%dms</font>", 
            server.players, server.maxPlayers, (server.ping < 80 and "50DC64" or "FFB432"), server.ping)
        infoLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
        infoLbl.TextSize = 12
        infoLbl.Font = Enum.Font.Gotham
        infoLbl.TextXAlignment = Enum.TextXAlignment.Left
        infoLbl.ZIndex = 6
        infoLbl.Parent = card

        card.MouseButton1Click:Connect(function()
            pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, game.Players.LocalPlayer)
            end)
        end)
        return card
    end

    local function loadServers()
        for _, c in pairs(serverList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        
        local response = http_request({
            Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=10",
            Method = "GET"
        })

        if response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data and data.data then
                for i, s in ipairs(data.data) do
                    local serverData = {
                        id = s.id,
                        players = s.playing,
                        maxPlayers = s.maxPlayers,
                        ping = s.ping or 0
                    }
                    makeServerCard(serverData, i)
                end
                local rows = math.ceil(#data.data / 2)
                serverList.CanvasSize = UDim2.new(0, 0, 0, rows * (CARD_H + GAP_Y))
            end
        else
            warn("Falha ao buscar servidores: " .. response.StatusCode)
        end
    end

    refreshBtn.MouseButton1Click:Connect(loadServers)
    task.spawn(loadServers)
end

-- ==================== ABOUT TAB ====================
do
    local f = Tabs["About"].frame
    f.ScrollingEnabled = false

    local devLbl = Instance.new("TextLabel")
    devLbl.Size=UDim2.new(1,-20,0,28)
    devLbl.Position=UDim2.new(0,PAD,0,20)
    devLbl.BackgroundTransparency=1
    devLbl.Text="Developed by "
    devLbl.TextColor3=Color3.fromRGB(200,200,200)
    devLbl.TextSize=14
    devLbl.Font=Enum.Font.Gotham
    devLbl.TextXAlignment=Enum.TextXAlignment.Left
    devLbl.ZIndex=4
    devLbl.Parent=f
    registerTheme(devLbl,"TextColor3","textDim")

    local bondLbl = Instance.new("TextLabel")
    bondLbl.Size=UDim2.new(0,40,0,28)
    bondLbl.Position=UDim2.new(0,PAD+107,0,20)
    bondLbl.BackgroundTransparency=1
    bondLbl.Text="288"
    bondLbl.TextColor3=Color3.fromRGB(80,160,255)
    bondLbl.TextSize=14
    bondLbl.Font=Enum.Font.GothamBold
    bondLbl.TextXAlignment=Enum.TextXAlignment.Left
    bondLbl.ZIndex=5
    bondLbl.Parent=f

    local verLbl = Instance.new("TextLabel")
    verLbl.Size=UDim2.new(1,-20,0,28)
    verLbl.Position=UDim2.new(0,PAD,0,60)
    verLbl.BackgroundTransparency=1
    verLbl.Text="Version: "
    verLbl.TextColor3=Color3.fromRGB(200,200,200)
    verLbl.TextSize=14
    verLbl.Font=Enum.Font.Gotham
    verLbl.TextXAlignment=Enum.TextXAlignment.Left
    verLbl.ZIndex=4
    verLbl.Parent=f
    registerTheme(verLbl,"TextColor3","textDim")

    local verVal = Instance.new("TextLabel")
    verVal.Size=UDim2.new(0,60,0,28)
    verVal.Position=UDim2.new(0,PAD+74,0,60)
    verVal.BackgroundTransparency=1
    verVal.Text=VERSION
    verVal.TextColor3=Color3.fromRGB(220,50,50)
    verVal.TextSize=14
    verVal.Font=Enum.Font.GothamBold
    verVal.TextXAlignment=Enum.TextXAlignment.Left
    verVal.ZIndex=5
    verVal.Parent=f

    local donLbl = Instance.new("TextLabel")
    donLbl.Size=UDim2.new(1,-20,0,22)
    donLbl.Position=UDim2.new(0,PAD,0,100)
    donLbl.BackgroundTransparency=1
    donLbl.Text="Donate:"
    donLbl.TextColor3=Color3.fromRGB(180,180,180)
    donLbl.TextSize=12
    donLbl.Font=Enum.Font.Gotham
    donLbl.TextXAlignment=Enum.TextXAlignment.Left
    donLbl.ZIndex=4
    donLbl.Parent=f
    registerTheme(donLbl,"TextColor3","textDim")

    local donLink = Instance.new("TextLabel")
    donLink.Size=UDim2.new(0,160,0,22)
    donLink.Position=UDim2.new(0,PAD+64,0,100)
    donLink.BackgroundTransparency=1
    donLink.Text="ajudar projeto"
    donLink.TextColor3=Color3.fromRGB(80,140,255)
    donLink.TextSize=12
    donLink.Font=Enum.Font.Gotham
    donLink.TextXAlignment=Enum.TextXAlignment.Left
    donLink.ZIndex=5
    donLink.Parent=f

    local supLbl = donLbl:Clone()
    supLbl.Position=UDim2.new(0,PAD,0,126)
    supLbl.Text="Support:"
    supLbl.Parent=f
    
    local supLink= donLink:Clone()
    supLink.Position=UDim2.new(0,PAD+68,0,126)
    supLink.Text="acessar\nsuporte"
    supLink.Size=UDim2.new(0,160,0,36)
    supLink.Parent=f

    local themeBtn = Instance.new("TextButton")
    themeBtn.Size             = UDim2.new(0,34,0,34)
    themeBtn.Position         = UDim2.new(1,-44,1,-44)
    themeBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    themeBtn.BorderSizePixel  = 0
    themeBtn.Text             = "🌙"
    themeBtn.TextColor3       = Color3.fromRGB(230,230,230)
    themeBtn.TextSize         = 16
    themeBtn.Font             = Enum.Font.GothamBold
    themeBtn.AutoButtonColor  = false
    themeBtn.ZIndex           = 4
    themeBtn.Parent           = f
    Instance.new("UICorner",themeBtn).CornerRadius=UDim.new(1,0)
    local themeBtnStroke = Instance.new("UIStroke")
    themeBtnStroke.Color=Color3.fromRGB(70,70,70)
    themeBtnStroke.Thickness=1
    themeBtnStroke.Parent=themeBtn
    registerTheme(themeBtn,"BackgroundColor3","btn")

    local function refreshThemeIcon()
        themeBtn.Text = (currentTheme == "dark") and "🌙" or "☀"
    end
    refreshThemeIcon()

    themeBtn.MouseButton1Click:Connect(function()
        local newTheme = currentTheme == "dark" and "light" or "dark"
        applyTheme(newTheme)
        refreshThemeIcon()
        task.spawn(function()
            apiPost("/user/preference", {
                userid = LocalPlayer.UserId,
                theme  = newTheme,
            })
        end)
    end)
end

-- ==================== START STATE ====================
setTab("Home")

-- ==================== SESSION START ====================
local _sessionId = nil

task.spawn(function()
    local res = apiPost("/session/start", {
        userid   = LocalPlayer.UserId,
        username = LocalPlayer.Name,
        version  = VERSION,
        game     = tostring(game.PlaceId),
        device   = DEVICE,
    })
    if not res then return end
    if res.banned then ScreenGui:Destroy(); return end

    _sessionId = res.sessionId
    local rank = (res.user and res.user.rank) or "User"

    broadcastOwnTag(rank)
    local char = LocalPlayer.Character
    if char then createBillboard(char, rank) end

    if res.user and res.user.theme then
        local savedTheme = res.user.theme
        if savedTheme == "light" or savedTheme == "dark" then
            applyTheme(savedTheme)
            local aboutFrame = Tabs["About"].frame
            for _, ch in pairs(aboutFrame:GetChildren()) do
                if ch:IsA("TextButton") then
                    ch.Text = savedTheme=="dark" and "🌙" or "☀"
                end
            end
        end
    end
end)

-- ==================== HEARTBEAT ====================
task.spawn(function()
    while task.wait(30) do
        if not ScreenGui.Parent then break end
        if not _sessionId then continue end
        local res = apiPost("/session/heartbeat", {
            sessionId = _sessionId,
            userid    = LocalPlayer.UserId,
        })
        if res and res.kick then ScreenGui:Destroy(); break end
    end
end)

-- ==================== KEYBIND [B] ====================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.B then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("✅ 288 Panel ["..VERSION.."] — pressione B para abrir/fechar | Device: "..DEVICE)
