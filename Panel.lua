-- 288Panel protected build (offline source obfuscator)\n--[[
    288 Panel v1.0.0
    UI completa â€” scripts carregados via GitHub
]]

-- ==================== SERVIÃ‡OS ====================
local _lllIIIlIlI          = game:GetService("Players")
local _IIIIllIllI = game:GetService("UserInputService")
local _IllIllIIII       = game:GetService("RunService")
local _lllIllIlIl     = game:GetService("TweenService")
local _IIlIlIllll      = game:GetService("HttpService")
local _IllIlIlllI       = game:GetService("StarterGui")
local _lIllIlllII       = game:GetService("GuiService")
local _IlllllllII      = _lllIIIlIlI.LocalPlayer

-- ==================== DEVICE ====================
local function _IIllIlIllI()
    local _lllIllIllI, _lIIlIIlIII = pcall(function()
        if _IIIIllIllI.GamepadEnabled
            and not _IIIIllIllI.KeyboardEnabled
            and not _IIIIllIllI.TouchEnabled then
            return "console"
        end
        if _IIIIllIllI.TouchEnabled and not _IIIIllIllI.KeyboardEnabled then
            return "mobile"
        end
        return "desktop"
    end)
    return _lllIllIllI and _lIIlIIlIII or "desktop"
end

local _llllIlllIl = _IIllIlIllI()
local _IlIIIlIIII = {
    desktop = "PC",
    mobile = "MOBILE",
    _lllllIllll = "CONSOLE",
}
local _IIIllllIIl = _IlIIIlIIII[_llllIlllIl] or _IlIIIlIIII.desktop

-- Detecta nomes por API pÃºblica e tenta fallbacks sem depender de um executor especÃ­fico.
local function _IlIIIIIlII()
    -- 1. Tentativa padrÃ£o por funÃ§Ãµes nativas padrÃ£o UNC
    local _IIIlIIIIll = identifyexecutor or getexecutorname or get_executor_name
    if type(_IIIlIIIIll) == "function" then
        local _lllIllIllI, _IlIlIlllll, _lllIlIllII = pcall(_IIIlIIIIll)
        if _lllIllIllI and type(_IlIlIlllll) == "string" then
            if type(_lllIlIllII) == "string" and _lllIlIllII ~= "" then
                return (_IlIlIlllll .. " " .. _lllIlIllII):sub(1, 48)
            end
            return _IlIlIlllll:sub(1, 48)
        end
    end

    -- 2. DetecÃ§Ã£o direta e segura por variÃ¡veis globais exclusivas (Evita loops em tabelas)
    if type(getgenv) == "function" then
        local _llIIIlllIl = getgenv()
        if _llIIIlllIl.POTASSIUM_LOADED or _llIIIlllIl.Potassium then return "Potassium" end
        if _llIIIlllIl.NEXOMIA_LOADED or _llIIIlllIl.Nexomia then return "Nexomia" end
    end

    if _G.Potassium then return "Potassium" end
    if _G.Nexomia then return "Nexomia" end

    return "Desconhecido"
end

local _lIIIIIllll = _IlIIIIIlII()
-- Invisible word joiner prevents Roblox/game localization tables from matching
-- English UI strings while leaving their visual appearance unchanged.
local _lIIlllIIIl = utf8.char(0x2060)
local function _IlIlllIlII(_IlIlIlIlll)
    return tostring(_IlIlIlIlll or "") .. _lIIlllIIIl
end

-- ==================== CONFIG ====================
local _IlIIIlllIl = (getgenv and getgenv()) or _G
local _lIIIIlllll = _IlIIIlllIl.__288PanelConfig or {}
-- A API substitui este placeholder pela origem usada para baixar /api/loader.
-- PANEL_CONFIG.API_BASE continua disponÃ­vel como sobrescrita manual opcional.
-- A origem fixa permite executar este mesmo arquivo pelo GitHub raw. O loader
-- da API continua substituindo o placeholder pela origem atual em producao.
local _IllIlIlIlI   = _lIIIIlllll.API_BASE or "__288_API_BASE__"
if _IllIlIlIlI == "__288_API_BASE__" then _IllIlIlIlI = "https://288panel.online" end
local _llllIlIIll = _lIIIIlllll.GITHUB_RAW or _IllIlIlIlI
-- FaÃƒÂ§a upload de public/assets/panel-background.png no Roblox e informe o asset ID aqui
-- via getgenv().__288PanelConfig.BACKGROUND_IMAGE = "rbxassetid://SEU_ID".
local function _lIllIIIlII(_IlIlIlIlll)
    local _IIlIIlIIII = tostring(_IlIlIlIlll or "")
    local _lllIIllllI = _IIlIIlIIII:match("(%d+)")
    return _lllIIllllI and ("rbxassetid://" .. _lllIIllllI) or ""
end

-- Aceita o ID puro, rbxassetid://ID ou a URL da Creator Store.
local _IllIIlIIll = _lIllIIIlII(
    _lIIIIlllll.BACKGROUND_IMAGE or "124602977093923"
)
local _IlIlllllll = _lIIIIlllll.BACKGROUND_IMAGE_URL
    or (_IllIlIlIlI .. "/assets/panel-background.png")
local _IlIlllIIII = _lIIIIlllll.LOGO_IMAGE_URL or (_IllIlIlIlI .. "/assets/logo.png")
local _lllIIIIlII = _lIIIIlllll.LOADING_LOGO_URL or (_IllIlIlIlI .. "/assets/logo-spritesheet.png")
local _IIIIlIIlIl    = tostring(_lIIIIlllll.VERSION or "v1.0.0")

-- Estado global da sessÃ£o/painel
local _lIlIllIllI = nil
local _lIIIIlIIlI = "User"
local _IIIIlIllIl = nil
local _IllIlIIlIl = false
local _IlllIIIlIl = true
local _lIlIllllII = false
local _llIlIIllIl = {}
local _IllllIlIII = {}
local _llIlllIlll = nil
local _IlIIIllllI = nil
local _lllIllllII = nil
local _IIIlIllIlI = nil
local _IlIllIlllI = {}
local _lIIIIIlIlI = {}
local _lIlllIlIlI = nil

-- ==================== PANEL CORE / STATE ====================
local Panel = {
    State = {apiOnline=false, sessionConnected=false, modulesAvailable=true, offlineMode=false, lastApiLatencyMs=nil},
    Runtime = {modules={}},
    Logs = {}, LogListeners = {},
    Settings = {uiSounds=true, notificationMusic=true, notificationVolume=0.80, loadingMusic=true, loadingVolume=0.12, rememberPosition=false, rememberTab=true, notificationLimit=3, _llIIlllIIl={panel="B", ClickTP="LeftControl", Invisible="K", NoClip="N", JerkOff="R", Impulse="M", FaceBang="Z", Spin="T", AnimSpeed="Q", AnimSpeed2="E", feFlip="X", feFlip2="C", Flashback="V", AntiVoid="J", ESP="E", Aimbot="F", AimbotAim="MouseButton1", Fly="F", WalkSpeed="", JumpPower=""}},
}
Panel.ExecutorName = _lIIIIIllll
_IlIIIlllIl.__288Panel = Panel
local _IlIIIlIlll = "288/panel_preferences.json"
local _lIIlIIlllI
local _IlIlIlllIl
local _IllIIlIlIl
local _IllIIlllII
local _llIlIllIII = 0

local function _lIlIlIIIII()
    if type(makefolder) == "function" then
        local _lllIllIllI, _IIlIIIIIIl = pcall(function() return isfolder and isfolder("288") end)
        if _lllIllIllI and not _IIlIIIIIIl then
            pcall(makefolder, "288")
        end
    end
end

local function _IIIllIIllI(_lllIlIIIlI,_IIlllIIIIl)if type(_lllIlIIIlI)~="table" or type(_IIlllIIIIl)~="table" then return _lllIlIIIlI end for k,_lIlIIIIIIl in pairs(_IIlllIIIIl) do if type(_lIlIIIIIIl)=="table" and type(_lllIlIIIlI[k])=="table" then _IIIllIIllI(_lllIlIIIlI[k],_lIlIIIIIIl) else _lllIlIIIlI[k]=_lIlIIIIIIl end end return _lllIlIIIlI end
local function _IlIIIlIlIl() if not (isfile and readfile) then return end local _IIlIIllIII,_IIlIIIIIIl=pcall(isfile,_IlIIIlIlll) if not _IIlIIllIII or not _IIlIIIIIIl then return end local _lIIIlllIlI,_IIlIIlIIII=pcall(readfile,_IlIIIlIlll) if not _lIIIlllIlI or type(_IIlIIlIIII)~="string" then return end local _lllIllIIII,_lIIllIIIll=pcall(function() return _IIlIlIllll:JSONDecode(_IIlIIlIIII) end) if _lllIllIIII and type(_lIIllIIIll)=="table" then if type(_lIIllIIIll.settings)=="table" then _IIIllIIllI(Panel.Settings,_lIIllIIIll.settings) end Panel.Preferences=_lIIllIIIll end end

local function _lIlllIllIl()
    if type(writefile) ~= "function" then return false end
    _lIlIlIIIII()
    local _lIIlIIIIlI = Panel.Preferences or {}
    _lIIlIIIIlI.settings = Panel.Settings
    _lIIlIIIIlI.theme = tostring(_lIIlIIlllI or "dark")

    local _IlIIIllIIl, _IIlIIlIIII = pcall(function() return _IIlIlIllll:JSONEncode(_lIIlIIIIlI) end)
    if not _IlIIIllIIl then return false end

    -- Encapsula writefile em pcall para evitar travar o script se o executor bloquear o disco
    local _IIllIIllII = pcall(writefile, _IlIIIlIlll, _IIlIIlIIII)
    return _IIllIIllII
end

local function _lIlIllIlIl(_IllIIIIlll,_IIlllIIIIl,_IlIIlIIIlI)
    local _lIIlllIIlI = "--:--:--"
    pcall(function() _lIIlllIIlI = os.date("%H:%M:%S") end)
    local _lIIIlllIll={time=_lIIlllIIlI,_IllIIIIlll=tostring(_IllIIIIlll or "INFO"):upper(),_IIlllIIIIl=tostring(_IIlllIIIIl or "PANEL"),_IlIIlIIIlI=tostring(_IlIIlIIIlI or "")}
    table.insert(Panel.Logs,_lIIIlllIll)
    while #Panel.Logs>250 do table.remove(Panel.Logs,1) end
    for _llIIIIIIII,_IlIIIIlIIl in ipairs(Panel.LogListeners) do pcall(_IlIIIIlIIl,_lIIIlllIll) end
    return _lIIIlllIll
end
Panel.Log=_lIlIllIlIl
local function _lIIIIIIIlI() local _IIlllIIIlI={} for _llIIIIIIII,_lIIlllllll in ipairs(Panel.Logs) do _IIlllIIIlI[#_IIlllIIIlI+1]=string.format("[%s] [%s] [%s] %s",_lIIlllllll.time,_lIIlllllll.level,_lIIlllllll.source,_lIIlllllll.message) end return table.concat(_IIlllIIIlI,"\n") end
Panel.GetLogsText=_lIIIIIIIlI
function Panel:RegisterModuleCleanup(_IlIlIlllll,_IlIIIIlIIl) _IlIlIlllll=tostring(_IlIlIlllll or "Unknown") local _lIlIlllIII=self.Runtime.modules[_IlIlIlllll] or {_IlIlIlllll=_IlIlIlllll,_lllIIlllIl="OFF"} self.Runtime.modules[_IlIlIlllll]=_lIlIlllIII _lIlIlllIII.cleanups=_lIlIlllIII.cleanups or {} if type(_IlIIIIlIIl)=="function" then table.insert(_lIlIlllIII.cleanups,_IlIIIIlIIl) end end
function Panel:CleanupModule(_IlIlIlllll) local _lIlIlllIII=self.Runtime.modules[tostring(_IlIlIlllll)] if not _lIlIlllIII then return end for _llIIIIIIII,_IlIIIIlIIl in ipairs(_lIlIlllIII.cleanups or {}) do pcall(_IlIIIIlIIl) end _lIlIlllIII.cleanups={} _lIlIlllIII.status="OFF" _lIlIllIlIl("info","MODULE",tostring(_IlIlIlllll).." cleaned") end
pcall(_IlIIIlIlIl)
-- A posicao e sempre efemera: cada execucao comeca centralizada.
Panel.Settings.rememberPosition = false
Panel.Preferences = Panel.Preferences or {}
Panel.Preferences.position = nil
pcall(_lIlIllIlIl,"info","BOOT","Panel core initialized")

-- Mantido em paridade 1:1 com api/config/roles.js (ROLES).
-- Qualquer rank ausente aqui cai silenciosamente na cor de User,
-- entao toda vez que um rank for adicionado/alterado no roles.js
-- ele precisa ser espelhado aqui tambem.
local _lllIlllIlI = {
    User = Color3.fromRGB(255, 255, 255),
    VIP = Color3.fromRGB(255, 240, 0),
    Friend = Color3.fromRGB(167, 243, 208),
    Partner = Color3.fromRGB(139, 92, 246),
    Sponsor = Color3.fromRGB(245, 158, 11),
    Influencer = Color3.fromRGB(255, 0, 170),
    Celebrity = Color3.fromRGB(244, 114, 182),
    ["Contributor #1"] = Color3.fromRGB(234, 179, 8),
    Helper = Color3.fromRGB(0, 187, 255),
    Supporter = Color3.fromRGB(0, 204, 170),
    Designer = Color3.fromRGB(255, 105, 180),
    Marketing = Color3.fromRGB(0, 177, 21),
    Admin = Color3.fromRGB(255, 51, 51),
    Supervisor = Color3.fromRGB(255, 102, 0),
    Network = Color3.fromRGB(167, 139, 250),
    Developer = Color3.fromRGB(96, 165, 250),
    Manager = Color3.fromRGB(204, 0, 255),
    ["Co-Owner"] = Color3.fromRGB(0, 221, 255),
    Owner = Color3.fromRGB(0, 0, 1),
}

local function _lIIIlIIIII(_IlIlIlIlll)
    local _lIIIllIIII = tostring(_IlIlIlIlll or ""):gsub("#", "")
    if #_lIIIllIIII ~= 6 then return nil end
    local _lllIllIllI, _llIIlIlIII, _lIlIIIllII, _lIlIlIlIII = pcall(function()
        return tonumber(_lIIIllIIII:sub(1, 2), 16), tonumber(_lIIIllIIII:sub(3, 4), 16), tonumber(_lIIIllIIII:sub(5, 6), 16)
    end)
    if not _lllIllIllI or _llIIlIlIII == nil or _lIlIIIllII == nil or _lIlIlIlIII == nil then return nil end
    return Color3.fromRGB(_llIIlIlIII, _lIlIIIllII, _lIlIlIlIII)
end

local function _IlIlIlllII(_IIlIIlIlll, _IlIlIllIII)
    local _llIIIlllll = tostring(_IIlIIlIlll or "User")
    local _IIIlIlllII = _IlIlIllIII and tostring(_IlIlIllIII.name or "") or ""
    local _IlIIlllllI = _IlIlIllIII and _IlIlIllIII.color and _lIIIlIIIII(_IlIlIllIII.color)
    local _llIIIlIIll = _IIIlIlllII ~= "" and _IIIlIlllII or _llIIIlllll
    local _IlIlllIIlI = _IlIIlllllI or _lllIlllIlI[_llIIIlllll] or _lllIlllIlI.User
    return _llIIIlIIll, _IlIlllIIlI
end

-- ==================== TAG CUSTOMIZATION TABLES ====================
-- Tamanho da fonte por rank (nil = usa padrao)
local _IIllllllIl = {
    User = 14,
    VIP = 16,
    Friend = 14,
    Partner = 16,
    Sponsor = 16,
    Influencer = 18,
    Celebrity = 18,
    ["Contributor #1"] = 16,
    Helper = 16,
    Supporter = 16,
    Designer = 16,
    Marketing = 16,
    Admin = 18,
    Supervisor = 18,
    Network = 18,
    Developer = 18,
    Manager = 20,
    ["Co-Owner"] = 20,
    Owner = 26,
}

-- Espessura do contorno por rank (0 = sem contorno)
local _lllIIIlllI = {
    User = 1,
    VIP = 2,
    Friend = 1,
    Partner = 2,
    Sponsor = 2,
    Influencer = 2,
    Celebrity = 2,
    ["Contributor #1"] = 2,
    Helper = 2,
    Supporter = 2,
    Designer = 2,
    Marketing = 2,
    Admin = 2,
    Supervisor = 2,
    Network = 2,
    Developer = 2,
    Manager = 3,
    ["Co-Owner"] = 3,
    Owner = 1,
}

-- Cor do contorno por rank (nil = preto padrao)
local _lIlIIllIlI = {
    User = Color3.fromRGB(0, 0, 0),
    VIP = Color3.fromRGB(80, 60, 0),
    Friend = Color3.fromRGB(0, 60, 40),
    Partner = Color3.fromRGB(40, 0, 70),
    Sponsor = Color3.fromRGB(80, 40, 0),
    Influencer = Color3.fromRGB(80, 0, 60),
    Celebrity = Color3.fromRGB(80, 20, 50),
    ["Contributor #1"] = Color3.fromRGB(80, 60, 0),
    Helper = Color3.fromRGB(0, 50, 80),
    Supporter = Color3.fromRGB(0, 70, 60),
    Designer = Color3.fromRGB(80, 20, 50),
    Marketing = Color3.fromRGB(0, 60, 10),
    Admin = Color3.fromRGB(80, 0, 0),
    Supervisor = Color3.fromRGB(80, 30, 0),
    Network = Color3.fromRGB(50, 40, 80),
    Developer = Color3.fromRGB(20, 40, 80),
    Manager = Color3.fromRGB(60, 0, 80),
    ["Co-Owner"] = Color3.fromRGB(0, 60, 80),
    Owner = Color3.fromRGB(0, 0, 0),
}

-- ==================== TAG STYLE FUNCTIONS ====================
local function _llllIllllI(_IIlIIlIlll)
    return _IIllllllIl[_IIlIIlIlll] or 14 -- padrao 14 se nao definido
end

local function _llIIIlIIIl(_IIlIIlIlll)
    return _lllIIIlllI[_IIlIIlIlll] or 1
end

local function _lIllIllIlI(_IIlIIlIlll)
    return _lIlIIllIlI[_IIlIIlIlll] or Color3.fromRGB(0, 0, 0)
end

-- Aplica todo o estilo da tag em um TextLabel
-- rank: string do rank
-- customTag: tabela opcional {name=..., color=...}
-- textLabel: Instancia TextLabel
local function _IIlIIIIlII(_IllIIllIII, _IIlIIlIlll, _IlIlIllIII)
    if not _IllIIllIII then return end
    local _llIIIlllll = tostring(_IIlIIlIlll or "User")
    local _llIIIlIIll, _IlIlllIIlI = _IlIlIlllII(_llIIIlllll, _IlIlIllIII)

    _IllIIllIII.Text = _llIIIlIIll
    _IllIIllIII.TextColor3 = _IlIlllIIlI
    _IllIIllIII.Font = _lIIllllIlI(_llIIIlllll)
    _IllIIllIII.TextSize = _llllIllllI(_llIIIlllll)

    -- Contorno via UIStroke
    local _lllllIIlIl = _IllIIllIII:FindFirstChildOfClass("UIStroke")
    if not _lllllIIlIl then
        _lllllIIlIl = Instance.new("UIStroke")
        _lllllIIlIl.Name = "TagStroke"
        _lllllIIlIl.Parent = _IllIIllIII
    end

    local _lIllIIlIII = _llIIIlIIIl(_llIIIlllll)
    if _lIllIIlIII > 0 then
        _lllllIIlIl.Thickness = _lIllIIlIII
        _lllllIIlIl.Color = _lIllIllIlI(_llIIIlllll)
        _lllllIIlIl.Enabled = true
        _lllllIIlIl.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    else
        _lllllIIlIl.Enabled = false
    end

    return _lllllIIlIl
end

-- ==================== DYNAMIC ADJUSTMENT API ====================
-- Permite alterar em tempo real via Panel
function Panel:SetTagFontSize(_IIlIIlIlll, _IIIIIlIIII)
    _IIlIIlIlll = tostring(_IIlIIlIlll or "User")
    _IIllllllIl[_IIlIIlIlll] = tonumber(_IIIIIlIIII)
end

function Panel:SetTagStrokeThickness(_IIlIIlIlll, _lIllIIlIII)
    _IIlIIlIlll = tostring(_IIlIIlIlll or "User")
    _lllIIIlllI[_IIlIIlIlll] = tonumber(_lIllIIlIII) or 0
end

function Panel:SetTagStrokeColor(_IIlIIlIlll, _IlIlllIIlI)
    _IIlIIlIlll = tostring(_IIlIIlIlll or "User")
    if typeof(_IlIlllIIlI) == "Color3" then
        _lIlIIllIlI[_IIlIIlIlll] = _IlIlllIIlI
    end
end

function Panel:GetTagFontSize(_IIlIIlIlll) return _llllIllllI(tostring(_IIlIIlIlll or "User")) end
function Panel:GetTagStrokeThickness(_IIlIIlIlll) return _llIIIlIIIl(tostring(_IIlIIlIlll or "User")) end
function Panel:GetTagStrokeColor(_IIlIIlIlll) return _lIllIllIlI(tostring(_IIlIIlIlll or "User")) end

-- ==================== FONT TABLES ====================
local _lIIlIllIIl = {
    Owner = true,
}
local _IlIIIlIIIl = Enum.Font.GothamBold -- User/VIP padrao

local _IlllIIllIl = {
    Owner = Enum.Font.Creepster,
    ["Co-Owner"] = Enum.Font.SciFi,
    Manager = Enum.Font.GothamBlack,
    Developer = Enum.Font.Code,
    Network = Enum.Font.RobotoMono,
    Supervisor = Enum.Font.FredokaOne,
    Admin = Enum.Font.GothamBold,
}

local function _lIIllllIlI(_IIlIIlIlll)
    return _IlllIIllIl[_IIlIIlIlll] or _IlIIIlIIIl
end

local _lIIlIllllI = {
    VIP = true, Marketing = true, Admin = true, Supervisor = true, Manager = true,
    ["Co-Owner"] = true, Owner = true,
}

local _lllllIIlll = {
    Owner = true, ["Co-Owner"] = true, Manager = true, Developer = true,
    Network = true, Supervisor = true, Admin = true, Marketing = true,
    Designer = true, Supporter = true, Helper = true,
}
local _llIIlIlllI = {
    Owner = true, ["Co-Owner"] = true, Manager = true, Developer = true,
    Network = true, Supervisor = true, Admin = true,
}
local _lllIIllIIl = {
    Owner = true, ["Co-Owner"] = true, Manager = true, Developer = true,
    Network = true, Supervisor = true, Admin = true, Marketing = true,
}
local _llIIIIllll = { Owner = true, ["Co-Owner"] = true, Manager = true, Developer = true, Network = true, Supervisor = true }
local _IIIIlIIlll = {"Owner", "Co-Owner", "Manager", "Developer", "Network", "Supervisor", "Admin", "Marketing", "Designer", "Supporter", "Helper", "Contributor #1", "Celebrity", "Influencer", "Sponsor", "Partner", "Friend", "VIP", "User"}
local function _llllIIlIlI()
    local _IllllIIllI = tostring(_lIIIIlIIlI or "")
    local _lIIIIlIIll = table.find(_IIIIlIIlll, _IllllIIllI)
    if not _lIIIIlIIll or not _llIIIIllll[_IllllIIllI] then return {} end
    local _lIIlllIlll = {}
    for _lllllIlIIl, _IIlIIlIlll in ipairs(_IIIIlIIlll) do
        if _lllllIlIIl > _lIIIIlIIll or (_IllllIIllI == "Owner" and _lllllIlIIl == _lIIIIlIIll) then
            table.insert(_lIIlllIlll, {_IlIlIlllll=_IIlIIlIlll, _IlIlllIIlI=_lllIlllIlI[_IIlIIlIlll], _IllIIIIlll=#_IIIIlIIlll - _lllllIlIIl})
        end
    end
    return _lIIlllIlll
end
local function _IIlllIlIlI()
    -- Never blur Lighting: that affects the whole game world. The VIP lock
    -- overlay already covers the tab content locally inside the panel.
    if _IlIIIllllI then
        pcall(function() _IlIIIllllI:Destroy() end)
        _IlIIIllllI = nil
    end
    local _IIIllIllIl = game:GetService("Lighting"):FindFirstChild("288PanelVipBlur")
    if _IIIllIllIl then pcall(function() _IIIllIllIl:Destroy() end) end
end

local function _IIIIllIIIl(_IIlIIlIlll, _lllIlIlIIl)
    _IllIlIIlIl = _lIIlIllllI[_IIlIIlIlll] == true
    _IlIIIlllIl.__288HasVipAccess = _IllIlIIlIl
    if _llIlllIlll then _llIlllIlll.Visible = not _IllIlIIlIl end
    if _lllIllllII then _lllIllllII.Visible = _IllIlIIlIl end
    for _llIIIIIIII, _lllllllIll in ipairs(_IlIllIlllI) do
        if _lllllllIll and _lllllllIll.Parent then
            local _IlIllIIllI = _IllIlIIlIl or _lllllllIll:GetAttribute("288RedirectToVip") == true
            _lllllllIll.Active = _IlIllIIllI
            _lllllllIll.Selectable = _IlIllIIllI
            pcall(function() _lllllllIll.Interactable = _IlIllIIllI end)
        end
    end
    if not _IllIlIIlIl and _IIIlIllIlI then _IIIlIllIlI.Visible = false end
    _IIlllIlIlI()
end

local function _llllllIIlI(_IlIlIlllll, _IlIIIIlIIl)
    _IllllIlIII[_IlIlIlllll] = _IlIIIIlIIl
end

local function _IIIIIIlIlI(_llIIllIIll, _IlIIIIlIIl)
    local _lIIIIIlIII = _llIIllIIll:Connect(_IlIIIIlIIl)
    table.insert(_llIlIIllIl, _lIIIIIlIII)
    return _lIIIIIlIII
end

-- ==================== LOCALIZATION MANAGER (DISABLED) ====================
-- The LocalizationManager is disabled because it conflicts with Roblox's
-- internal CoreGui localization system, causing the error:
--   "attempt to call a nil value" in CoreGui.RobloxGui.Modules.Common.Locales.en-us
local _IIIllIIIII = {
    boundObjects = setmetatable({}, {__mode = "k"}),
    updating = setmetatable({}, {__mode = "k"}),
    boundRoots = setmetatable({}, {__mode = "k"}),
    translator = function(_IIlllIIIIl)
        return tostring(_IIlllIIIIl or ""):gsub(_lIIlllIIIl, "")
    end,
    _IIlIlIIIIl = false, -- DISABLED to prevent CoreGui localization crash
}

local function _llIlIllllI(_lIIllIIlll)
    return _lIIllIIlll and (
        _lIIllIIlll:IsA("TextLabel")
        or _lIIllIIlll:IsA("TextButton")
        or _lIIllIIlll:IsA("TextBox")
    )
end

function _IIIllIIIII:Refresh(_lIIllIIlll)
    if not self.active or not _llIlIllllI(_lIIllIIlll) or self.updating[_lIIllIIlll] then return end
    self.updating[_lIIllIIlll] = true
    _lIIllIIlll.AutoLocalize = false

    local _lIIlIIIIIl = tostring(_lIIllIIlll.Text or "")
    local _IIllIIIlII = self.translator(_lIIlIIIIIl)
    if _IIllIIIlII ~= _lIIlIIIIIl then _lIIllIIlll.Text = _IIllIIIlII end

    if _lIIllIIlll:IsA("TextBox") then
        local _llIlllIlIl = tostring(_lIIllIIlll.PlaceholderText or "")
        local _lllIIlIIIl = self.translator(_llIlllIlIl)
        if _lllIIlIIIl ~= _llIlllIlIl then _lIIllIIlll.PlaceholderText = _lllIIlIIIl end
    end
    self.updating[_lIIllIIlll] = nil
end

function _IIIllIIIII:BindObject(_lIIllIIlll)
    if not self.active or not _llIlIllllI(_lIIllIIlll) then return end
    _lIIllIIlll.AutoLocalize = false
    if self.boundObjects[_lIIllIIlll] then
        self:Refresh(_lIIllIIlll)
        return
    end

    self.boundObjects[_lIIllIIlll] = true
    self:Refresh(_lIIllIIlll)
    _IIIIIIlIlI(_lIIllIIlll:GetPropertyChangedSignal("Text"), function()
        if self.active and _lIIllIIlll.Parent then self:Refresh(_lIIllIIlll) end
    end)
    if _lIIllIIlll:IsA("TextBox") then
        _IIIIIIlIlI(_lIIllIIlll:GetPropertyChangedSignal("PlaceholderText"), function()
            if self.active and _lIIllIIlll.Parent then self:Refresh(_lIIllIIlll) end
        end)
    end
end

function _IIIllIIIII:Process(_lIIllIIlll)
    if not self.active or not _lIIllIIlll then return end
    if _lIIllIIlll:IsA("GuiBase2d") then _lIIllIIlll.AutoLocalize = false end
    if _llIlIllllI(_lIIllIIlll) then self:BindObject(_lIIllIIlll) end
end

function _IIIllIIIII:BindRoot(_lIllIlIIII)
    if not self.active or not _lIllIlIIII then return end
    self:Process(_lIllIlIIII)
    if self.boundRoots[_lIllIlIIII] then return end
    self.boundRoots[_lIllIlIIII] = true

    for _llIIIIIIII, descendant in ipairs(_lIllIlIIII:GetDescendants()) do self:Process(descendant) end
    _IIIIIIlIlI(_lIllIlIIII.DescendantAdded, function(descendant)
        task.defer(function()
            if self.active and _lIllIlIIII.Parent and descendant.Parent then self:Process(descendant) end
        end)
    end)
end

function _IIIllIIIII:SetTranslator(translator)
    if type(translator) ~= "function" then return end
    self.translator = translator
    for _lIIllIIlll in pairs(self.boundObjects) do
        if _lIIllIIlll.Parent then self:Refresh(_lIIllIIlll) end
    end
end

function _IIIllIIIII:Destroy()
    self.active = false
    table.clear(self.boundObjects)
    table.clear(self.updating)
    table.clear(self.boundRoots)
end

_llllllIIlI("LocalizationManager", function()
    _IIIllIIIII:Destroy()
end)

-- ==================== TEMA ====================
local _lIIlIlIlIl = Color3.fromRGB(238, 126, 255)
local _lIIIlllIIl = "http://www.roblox.com/asset/?id=11353098054"
local _lIllIIlllI = Color3.fromRGB(255, 0, 0)
local _IlIlIlIlII = Color3.fromRGB(0, 255, 0)
local _IllIIlIIII = Color3.fromRGB(10, 11, 16)
local _llIIIIIlIl = Color3.fromRGB(24, 22, 31)
local _lIIlIIlIlI = Color3.fromRGB(31, 27, 40)
local _llIIllllll = Color3.fromRGB(91, 72, 108)
local _llIIIIIIIl = Color3.fromRGB(248, 246, 252)
local _lIIIlIlIIl = Color3.fromRGB(166, 158, 177)
local _IllIIlIlII = nil

local _IllllIIlII = {
    dark = {
        _lIllllIIIl    = "Dark",
        accent   = _lIIlIlIlIl,
        main     = _IllIIlIIII,
        header   = Color3.fromRGB(13, 12, 19),
        sidebar  = Color3.fromRGB(14, 13, 20),
        _lIIlllllIl  = Color3.fromRGB(16, 15, 23),
        _IlIIlIlIIl      = _llIIIIIlIl,
        surface2 = _lIIlIIlIlI,
        btnHover = Color3.fromRGB(46, 36, 56),
        btnOn    = Color3.fromRGB(67, 42, 73),
        _llIlllIIII     = _llIIIIIIIl,
        textDim  = _lIIIlIlIIl,
        _IIIIlIIIII      = Color3.fromRGB(47, 40, 55),
        _lllllIIlIl   = _llIIllllll,
    },
    light = {
        _lIllllIIIl    = "Light",
        accent   = Color3.fromRGB(181, 72, 190),
        main     = Color3.fromRGB(232, 231, 235),
        header   = Color3.fromRGB(246, 244, 248),
        sidebar  = Color3.fromRGB(238, 236, 241),
        _lIIlllllIl  = Color3.fromRGB(248, 247, 250),
        _IlIIlIlIIl      = Color3.fromRGB(229, 225, 232),
        surface2 = Color3.fromRGB(219, 214, 224),
        btnHover = Color3.fromRGB(238, 222, 237),
        btnOn    = Color3.fromRGB(244, 208, 242),
        _llIlllIIII     = Color3.fromRGB(28, 27, 31),
        textDim  = Color3.fromRGB(91, 89, 98),
        _IIIIlIIIII      = Color3.fromRGB(208, 204, 212),
        _lllllIIlIl   = Color3.fromRGB(184, 177, 190),
    },
    ocean = {
        _lIllllIIIl="Ocean", accent=Color3.fromRGB(75,190,255), main=Color3.fromRGB(7,18,29),
        header=Color3.fromRGB(8,24,38), sidebar=Color3.fromRGB(8,22,35), _lIIlllllIl=Color3.fromRGB(9,27,42),
        _IlIIlIlIIl=Color3.fromRGB(14,39,58), surface2=Color3.fromRGB(17,47,69), btnHover=Color3.fromRGB(20,57,82), btnOn=Color3.fromRGB(20,75,105),
        _llIlllIIII=Color3.fromRGB(238,249,255), textDim=Color3.fromRGB(145,181,201), _IIIIlIIIII=Color3.fromRGB(28,61,80), _lllllIIlIl=Color3.fromRGB(47,102,132),
    },
    crimson = {
        _lIllllIIIl="Crimson", accent=Color3.fromRGB(255,84,111), main=Color3.fromRGB(24,8,13),
        header=Color3.fromRGB(31,10,16), sidebar=Color3.fromRGB(28,9,15), _lIIlllllIl=Color3.fromRGB(34,12,19),
        _IlIIlIlIIl=Color3.fromRGB(52,18,27), surface2=Color3.fromRGB(63,21,32), btnHover=Color3.fromRGB(76,25,37), btnOn=Color3.fromRGB(99,30,45),
        _llIlllIIII=Color3.fromRGB(255,242,245), textDim=Color3.fromRGB(201,149,160), _IIIIlIIIII=Color3.fromRGB(72,31,40), _lllllIIlIl=Color3.fromRGB(126,49,65),
    },
    forest = {
        _lIllllIIIl="Forest", accent=Color3.fromRGB(91,222,142), main=Color3.fromRGB(7,20,15),
        header=Color3.fromRGB(9,27,20), sidebar=Color3.fromRGB(8,24,18), _lIIlllllIl=Color3.fromRGB(11,31,23),
        _IlIIlIlIIl=Color3.fromRGB(18,46,35), surface2=Color3.fromRGB(21,55,41), btnHover=Color3.fromRGB(25,66,49), btnOn=Color3.fromRGB(31,86,62),
        _llIlllIIII=Color3.fromRGB(239,255,246), textDim=Color3.fromRGB(149,195,169), _IIIIlIIIII=Color3.fromRGB(31,68,51), _lllllIIlIl=Color3.fromRGB(51,112,81),
    },
    sunset = {
        _lIllllIIIl="Sunset", accent=Color3.fromRGB(255,151,82), main=Color3.fromRGB(25,13,18),
        header=Color3.fromRGB(34,16,22), sidebar=Color3.fromRGB(30,14,20), _lIIlllllIl=Color3.fromRGB(39,18,25),
        _IlIIlIlIIl=Color3.fromRGB(57,27,35), surface2=Color3.fromRGB(68,31,40), btnHover=Color3.fromRGB(82,38,47), btnOn=Color3.fromRGB(104,48,55),
        _llIlllIIII=Color3.fromRGB(255,247,240), textDim=Color3.fromRGB(207,169,158), _IIIIlIIIII=Color3.fromRGB(77,39,46), _lllllIIlIl=Color3.fromRGB(130,67,73),
    },
    aurora = {
        _lIllllIIIl="Aurora", accent=Color3.fromRGB(185,103,255), main=Color3.fromRGB(18,10,30),
        header=Color3.fromRGB(25,13,40), sidebar=Color3.fromRGB(22,11,36), _lIIlllllIl=Color3.fromRGB(29,15,46),
        _IlIIlIlIIl=Color3.fromRGB(43,24,65), surface2=Color3.fromRGB(52,28,78), btnHover=Color3.fromRGB(62,34,91), btnOn=Color3.fromRGB(80,42,116),
        _llIlllIIII=Color3.fromRGB(250,243,255), textDim=Color3.fromRGB(190,158,213), _IIIIlIIIII=Color3.fromRGB(61,38,82), _lllllIIlIl=Color3.fromRGB(103,62,139),
    },
    roseglass = {
        _lIllllIIIl="Rose Glass", accent=Color3.fromRGB(255,105,210), main=Color3.fromRGB(22,10,28),
        header=Color3.fromRGB(38,16,44), sidebar=Color3.fromRGB(30,13,38), _lIIlllllIl=Color3.fromRGB(32,14,42),
        _IlIIlIlIIl=Color3.fromRGB(55,27,65), surface2=Color3.fromRGB(68,31,80), btnHover=Color3.fromRGB(82,38,96), btnOn=Color3.fromRGB(106,43,119),
        _llIlllIIII=Color3.fromRGB(255,242,253), textDim=Color3.fromRGB(213,164,211), _IIIIlIIIII=Color3.fromRGB(77,39,88), _lllllIIlIl=Color3.fromRGB(132,61,145),
        _IlllllIlIl={Color3.fromRGB(255,58,190), Color3.fromRGB(180,62,255), Color3.fromRGB(72,104,255)}, gradientRotation=24, _IIlllllIIl=true, gradientTransparency=0.08,
        animatedHues={0.92, 0.78, 0.62}, animationSpeed=0.045, rotationSpeed=8,
    },
    midnightwave = {
        _lIllllIIIl="Midnight Wave", accent=Color3.fromRGB(86,217,255), main=Color3.fromRGB(7,10,27),
        header=Color3.fromRGB(10,20,42), sidebar=Color3.fromRGB(8,16,35), _lIIlllllIl=Color3.fromRGB(10,17,39),
        _IlIIlIlIIl=Color3.fromRGB(18,34,58), surface2=Color3.fromRGB(22,43,70), btnHover=Color3.fromRGB(27,54,86), btnOn=Color3.fromRGB(31,69,105),
        _llIlllIIII=Color3.fromRGB(240,250,255), textDim=Color3.fromRGB(151,187,210), _IIIIlIIIII=Color3.fromRGB(29,58,83), _lllllIIlIl=Color3.fromRGB(50,103,139),
        _IlllllIlIl={Color3.fromRGB(8,20,76), Color3.fromRGB(20,104,184), Color3.fromRGB(14,214,206)}, gradientRotation=38, _IIlllllIIl=true, gradientTransparency=0.08,
        animatedHues={0.66, 0.56, 0.48}, animationSpeed=0.038, rotationSpeed=7,
    },
    prismflow = {
        _lIllllIIIl="Prism Flow", accent=Color3.fromRGB(244,112,255), main=Color3.fromRGB(13,8,24),
        header=Color3.fromRGB(24,12,39), sidebar=Color3.fromRGB(19,10,33), _lIIlllllIl=Color3.fromRGB(23,12,38),
        _IlIIlIlIIl=Color3.fromRGB(40,23,59), surface2=Color3.fromRGB(49,27,72), btnHover=Color3.fromRGB(60,34,87), btnOn=Color3.fromRGB(77,40,107),
        _llIlllIIII=Color3.fromRGB(252,244,255), textDim=Color3.fromRGB(193,163,213), _IIIIlIIIII=Color3.fromRGB(57,35,78), _lllllIIlIl=Color3.fromRGB(100,61,134),
        _IlllllIlIl={Color3.fromRGB(255,84,180), Color3.fromRGB(145,80,255), Color3.fromRGB(62,190,255)}, gradientRotation=35, _IIlllllIIl=true, gradientTransparency=0.06,
        animatedHues={0.94, 0.72, 0.52}, animationSpeed=0.085, rotationSpeed=18,
    },
    gold = {
        _lIllllIIIl="Gold", accent=Color3.fromRGB(255,202,79), main=Color3.fromRGB(24,19,8),
        header=Color3.fromRGB(32,25,10), sidebar=Color3.fromRGB(29,22,9), _lIIlllllIl=Color3.fromRGB(37,29,12),
        _IlIIlIlIIl=Color3.fromRGB(55,43,18), surface2=Color3.fromRGB(66,51,20), btnHover=Color3.fromRGB(78,61,24), btnOn=Color3.fromRGB(101,78,29),
        _llIlllIIII=Color3.fromRGB(255,251,235), textDim=Color3.fromRGB(207,190,143), _IIIIlIIIII=Color3.fromRGB(74,59,28), _lllllIIlIl=Color3.fromRGB(126,99,40),
    },
}
local function _llIIIIlIIl(_IlIlIlIlll)
    local _lIlIlIlIll = tostring(_IlIlIlIlll or ""):lower():gsub("[%s_%-]+", "")
    return _IllllIIlII[_lIlIlIlIll] and _lIlIlIlIll or nil
end

_lIIlIIlllI = _llIIIIlIIl(Panel.Preferences and Panel.Preferences.theme) or "dark"

local _IlIlIllIll = {}

local function _lIIlIlIllI(_lIIllIIlll, _lIllIlIIll, _IlIIlllIIl, _IlIlIIlIII)
    table.insert(_IlIlIllIll, { _lIIllIIlll=_lIIllIIlll, _lIllIlIIll=_lIllIlIIll, dk=_IlIIlllIIl, lk=_IlIlIIlIII or _IlIIlllIIl })
end

local _IllIIlllll = 0

local function _llIllIIlII(_IIIIIllllI, _lIIlIllIlI)
    _lIIlIllIlI = tonumber(_lIIlIllIlI) or 0
    if _IIIIIllllI.animated and type(_IIIIIllllI.animatedHues) == "table" then
        local _lllIlIIlll = _IIIIIllllI.animatedHues
        local function _IllIllIIll(_lllllIlIIl)
            local _IlllIllIlI = tonumber(_lllIlIIlll[_lllllIlIIl]) or 0
            return Color3.fromHSV((_IlllIllIlI + _lIIlIllIlI) % 1, 0.66, 1)
        end
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, _IllIllIIll(1)),
            ColorSequenceKeypoint.new(0.5, _IllIllIIll(2)),
            ColorSequenceKeypoint.new(1, _IllIllIIll(3)),
        })
    end
    if type(_IIIIIllllI.gradient) == "table" and #_IIIIIllllI.gradient >= 2 then
        local _IIllllIlll = _IIIIIllllI.gradient[2] or _IIIIIllllI.gradient[1]
        local _IIIlllIIII = _IIIIIllllI.gradient[3] or _IIIIIllllI.gradient[#_IIIIIllllI.gradient]
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, _IIIIIllllI.gradient[1]),
            ColorSequenceKeypoint.new(0.52, _IIllllIlll),
            ColorSequenceKeypoint.new(1, _IIIlllIIII),
        })
    end
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, _IIIIIllllI.header),
        ColorSequenceKeypoint.new(0.55, _IIIIIllllI.content),
        ColorSequenceKeypoint.new(1, _IIIIIllllI.main),
    })
end

-- Gradientes visiveis sao aplicados diretamente nas superficies principais.
-- Isso evita que o efeito fique escondido atras de Header/Sidebar/Content.
local _IIIIlllIIl = "288ThemeSurfaceGradient"

local function _IIlIlIlIlI()
    local _lllIlIIlII = {}
    local function _lIIIlIlIll(_lIIllIIlll)
        if _lIIllIIlll and _lIIllIIlll.Parent and _lIIllIIlll:IsA("GuiObject") then
            table.insert(_lllIlIIlII, _lIIllIIlll)
        end
    end
    _lIIIlIlIll(MainFrame)
    _lIIIlIlIll(Header)
    _lIIIlIlIll(Sidebar)
    _lIIIlIlIll(ContentFrame)
    return _lllIlIIlII
end

local function _lllllIIIIl(_lIIllIIlll)
    if not _lIIllIIlll or not _lIIllIIlll.Parent then return nil end
    local _IlllllIlIl = _lIIllIIlll:FindFirstChild(_IIIIlllIIl)
    if _IlllllIlIl and not _IlllllIlIl:IsA("UIGradient") then
        pcall(function() _IlllllIlIl:Destroy() end)
        _IlllllIlIl = nil
    end
    if not _IlllllIlIl then
        _IlllllIlIl = Instance.new("UIGradient")
        _IlllllIlIl.Name = _IIIIlllIIl
        _IlllllIlIl.Enabled = false
        _IlllllIlIl.Parent = _lIIllIIlll
    end
    return _IlllllIlIl
end

local function _IlIllIllII(_IIIIIllllI, _lIIlIllIlI, _IIlIllIIIl)
    _lIIlIllIlI = tonumber(_lIIlIllIlI) or 0
    _IIlIllIIIl = tonumber(_IIlIllIIIl) or 0

    -- O gradiente pertence somente ao fundo. Header, Sidebar e ContentFrame
    -- mantÃªm as mesmas superfÃ­cies sÃ³lidas/translÃºcidas dos temas clÃ¡ssicos.
    for _llIIIIIIII, _lIIllIIlll in ipairs({MainFrame, Header, Sidebar, ContentFrame}) do
        if _lIIllIIlll then
            local _IIlllIlIll = _lIIllIIlll:FindFirstChild(_IIIIlllIIl)
            if _IIlllIlIll then _IIlllIlIll:Destroy() end
        end
    end

    if bgGradient and bgGradient.Parent then
        bgGradient.Enabled = true
        bgGradient.Color = _llIllIIlII(_IIIIIllllI, _lIIlIllIlI)
        bgGradient.Transparency = NumberSequence.new(math.clamp(tonumber(_IIIIIllllI.gradientTransparency) or 0, 0, 1))
        bgGradient.Rotation = ((tonumber(_IIIIIllllI.gradientRotation) or 35)
            + _IIlIllIIIl * (_IIIIIllllI.animated and (tonumber(_IIIIIllllI.rotationSpeed) or 18) or 0)) % 360
        if _IIIIIllllI.animated then
            bgGradient.Offset = Vector2.new(
                math.sin(_IIlIllIIIl * 1.05) * 0.28,
                math.cos(_IIlIllIIIl * 0.78) * 0.14
            )
        else
            bgGradient.Offset = Vector2.new(0, 0)
        end
    end

    if BgTint and BgTint.Parent then
        BgTint.BackgroundColor3 = _IIIIIllllI.main
        BgTint.BackgroundTransparency = (type(_IIIIIllllI.gradient) == "table" or _IIIIIllllI.animated) and 0.46 or 0.68
    end
end
local function _lIIIIllIII(_IlIlIlllll, _lIIlllIlll)
    _lIIlllIlll = type(_lIIlllIlll) == "table" and _lIIlllIlll or {}
    _IlIlIlllll = _llIIIIlIIl(_IlIlIlllll)
    if not _IlIlIlllll then return false end
    if _lIIlllIlll.userInitiated then
        _llIlIllIII += 1
    end
    local _IlIIIIIIIl = _IllllIIlII[_lIIlIIlllI] or _IllllIIlII.dark
    local _IIIIIllllI = _IllllIIlII[_IlIlIlllll]
    local _lIIIIlIllI = _lIIlIlIlIl

    -- Mantem tambem as variaveis-base sincronizadas. Qualquer componente criado
    -- depois da troca ja nasce usando a paleta ativa, em vez da paleta Dark.
    _lIIlIlIlIl = _IIIIIllllI.accent or _lIIlIlIlIl
    _IllIIlIIII = _IIIIIllllI.main or _IllIIlIIII
    _llIIIIIlIl = _IIIIIllllI.btn or _llIIIIIlIl
    _lIIlIIlIlI = _IIIIIllllI.surface2 or _lIIlIIlIlI
    _llIIllllll = _IIIIIllllI.stroke or _llIIllllll
    _llIIIIIIIl = _IIIIIllllI.text or _llIIIIIIIl
    _lIIIlIlIIl = _IIIIIllllI.textDim or _lIIIlIlIIl
    _lIIlIIlllI = _IlIlIlllll

    local _IIIIIlllII = {
        "BackgroundColor3", "TextColor3", "ImageColor3",
        "BorderColor3", "ScrollBarImageColor3", "Color"
    }

    local function _IIIIIIlIIl(_lIllIlIIII)
        if not _lIllIlIIII or not _lIllIlIIII.Parent then return end
        local _IIlIIIllll = {_lIllIlIIII}
        for _llIIIIIIII, descendant in ipairs(_lIllIlIIII:GetDescendants()) do
            table.insert(_IIlIIIllll, descendant)
        end

        for _llIIIIIIII, _lIIllIIlll in ipairs(_IIlIIIllll) do
            if not _lIIllIIlll:GetAttribute("PreserveThemeColor") then
                for _llIIIIIIII, _lIllIlIIll in ipairs(_IIIIIlllII) do
                    pcall(function()
                        local _llIIlIIlll = _lIIllIIlll[_lIllIlIIll]
                        if typeof(_llIIlIIlll) ~= "Color3" then return end

                        -- Accent atual/anterior.
                        if _llIIlIIlll == _lIIIIlIllI or _llIIlIIlll == _IlIIIIIIIl.accent then
                            _lIIllIIlll[_lIllIlIIll] = _IIIIIllllI.accent
                            return
                        end

                        -- Converte qualquer cor exata da paleta anterior.
                        for _IllllllIll, oldPaletteColor in pairs(_IlIIIIIIIl) do
                            if typeof(oldPaletteColor) == "Color3"
                                and _llIIlIIlll == oldPaletteColor
                                and typeof(_IIIIIllllI[_IllllllIll]) == "Color3" then
                                _lIIllIIlll[_lIllIlIIll] = _IIIIIllllI[_IllllllIll]
                                return
                            end
                        end

                        -- Converte tambem cores da paleta Dark original. Isso cobre
                        -- elementos criados com constantes antigas ou ainda nao
                        -- registrados individualmente.
                        for _IllllllIll, darkColor in pairs(_IllllIIlII.dark) do
                            if typeof(darkColor) == "Color3"
                                and _llIIlIIlll == darkColor
                                and typeof(_IIIIIllllI[_IllllllIll]) == "Color3" then
                                _lIIllIIlll[_lIllIlIIll] = _IIIIIllllI[_IllllllIll]
                                return
                            end
                        end
                    end)
                end

                if _lIIllIIlll:IsA("UIGradient") and _lIIllIIlll.Name == "PanelThemeGradient" then
                    pcall(function()
                        _lIIllIIlll.Color = _llIllIIlII(_IIIIIllllI, 0)
                        _lIIllIIlll.Rotation = tonumber(_IIIIIllllI.gradientRotation) or 35
                    end)
                end
            end
        end
    end

    -- O tema agora percorre toda a UI do Panel, inclusive notificacoes/modais.
    _IIIIIIlIIl(_IllIIlIlII)
    if _lIlllIlIlI and _lIlllIlIlI ~= _IllIIlIlII then _IIIIIIlIIl(_lIlllIlIlI) end
    if NotificationGui then _IIIIIIlIIl(NotificationGui) end

    -- Componentes registrados continuam tendo prioridade e recebem a cor exata
    -- da role correspondente.
    for i = #_IlIlIllIll, 1, -1 do
        local _lIIlllllll = _IlIlIllIll[i]
        if not _lIIlllllll.obj or _lIIlllllll.obj.Parent == nil then
            table.remove(_IlIlIllIll, i)
        else
            local _IllllllIll = _lIIlllllll.dk
            if _IIIIIllllI[_IllllllIll] ~= nil then
                pcall(function() _lIIlllllll.obj[_lIIlllllll.prop] = _IIIIIllllI[_IllllllIll] end)
            end
        end
    end

    if bgGradient and bgGradient.Parent then
        pcall(function()
            bgGradient.Color = _llIllIIlII(_IIIIIllllI, 0)
            bgGradient.Transparency = NumberSequence.new(math.clamp(tonumber(_IIIIIllllI.gradientTransparency) or 0, 0, 1))
            bgGradient.Rotation = tonumber(_IIIIIllllI.gradientRotation) or 35
            bgGradient.Offset = Vector2.new(0, 0)
        end)
    end

    -- Aplica o degradÃª nas superficies que realmente ficam visiveis.
    pcall(function() _IlIllIllII(_IIIIIllllI, 0, 0) end)

    -- A tipografia usa o mesmo acabamento dos temas clÃ¡ssicos.
    for _llIIIIIIII, _lIllIlIIII in ipairs({_IllIIlIlII, _lIlllIlIlI, NotificationGui}) do
        if _lIllIlIIII and _lIllIlIIII.Parent then
            for _llIIIIIIII, _lIIllIIlll in ipairs(_lIllIlIIII:GetDescendants()) do
                if _llIlIllllI(_lIIllIIlll) and not _lIIllIIlll:GetAttribute("PreserveThemeColor") then
                    pcall(function()
                        _lIIllIIlll.TextStrokeTransparency = 1
                    end)
                end
            end
        end
    end
    -- Atualiza elementos conhecidos que usam cor direta e nao devem depender
    -- de comparacao de paleta.
    pcall(function() if MainStroke then MainStroke.Color = _IIIIIllllI.accent end end)
    pcall(function() if loadingStroke then loadingStroke.Color = _IIIIIllllI.accent end end)
    pcall(function() if loadingFill then loadingFill.BackgroundColor3 = _IIIIIllllI.accent end end)
    pcall(function() if loadingPercent then loadingPercent.TextColor3 = _IIIIIllllI.accent end end)

    -- Uma nova geracao encerra instantaneamente qualquer tema animado anterior.
    _IllIIlllll += 1
    local _llIlIIlllI = _IllIIlllll
    if _IIIIIllllI.animated then
        task.spawn(function()
            local _lIIIIlIlIl = os.clock()
            while _llIlIIlllI == _IllIIlllll and _lIIlIIlllI == _IlIlIlllll do
                if not bgGradient or not bgGradient.Parent then
                    task.wait(0.08)
                    continue
                end
                local _IIlIllIIIl = os.clock() - _lIIIIlIlIl
                local _lIIlIllIlI = _IIlIllIIIl * (tonumber(_IIIIIllllI.animationSpeed) or 0.085)
                pcall(function()
                    bgGradient.Color = _llIllIIlII(_IIIIIllllI, _lIIlIllIlI)
                    bgGradient.Rotation = ((tonumber(_IIIIIllllI.gradientRotation) or 35) + _IIlIllIIIl * (tonumber(_IIIIIllllI.rotationSpeed) or 18)) % 360
                    bgGradient.Offset = Vector2.new(
                        math.sin(_IIlIllIIIl * 1.05) * 0.28,
                        math.cos(_IIlIllIIIl * 0.78) * 0.14
                    )
                    _IlIllIllII(_IIIIIllllI, _lIIlIllIlI, _IIlIllIIIl)
                end)
                task.wait(0.033)
            end
        end)
    end

    Panel.Preferences = Panel.Preferences or {}
    Panel.Preferences.theme = _IlIlIlllll
    task.defer(_lIlllIllIl)
    if _lIIlllIlll.persistRemote and _IlIlIlllIl then
        task.spawn(_IlIlIlllIl, _IlIlIlllll)
    end
    return true
end

-- ==================== THEME GRADIENT SAFETY ====================
local function _lIIlIlllII()
    if not MainFrame or not MainFrame.Parent then return end
    local _IIlIIllllI = {}
    _IIlIIllllI[MainFrame] = true
    if Header then _IIlIIllllI[Header] = true end
    if Sidebar then _IIlIIllllI[Sidebar] = true end
    if ContentFrame then _IIlIIllllI[ContentFrame] = true end
    if BgTint then _IIlIIllllI[BgTint] = true end

    for _llIIIIIIII, _lIIllIIlll in ipairs(MainFrame:GetDescendants()) do
        if not _IIlIIllllI[_lIIllIIlll] then
            for _llIIIIIIII, child in ipairs(_lIIllIIlll:GetChildren()) do
                if child:IsA("UIGradient") and (
                    child.Name == "ThemeGradient" or
                    child.Name == "PanelThemeGradient" or
                    child.Name == "AnimatedThemeGradient" or
                    child.Name == "ThemeSurfaceGradient"
                ) then
                    child:Destroy()
                end
            end
        end
    end
end

local function _lllIIIlIII()
    if not MainFrame or not MainFrame.Parent then return end
    for _llIIIIIIII, _lIIllIIlll in ipairs(MainFrame:GetDescendants()) do
        if _lIIllIIlll:IsA("TextButton") or _lIIllIIlll:IsA("TextBox") then
            if not _lIIllIIlll:GetAttribute("PreserveTransparency") and _lIIllIIlll.BackgroundTransparency > 0.45 then
                _lIIllIIlll.BackgroundTransparency = 0.12
            end
            _lIIllIIlll.TextTransparency = 0
        elseif _lIIllIIlll:IsA("TextLabel") then
            _lIIllIIlll.TextTransparency = 0
        elseif _lIIllIIlll:IsA("ImageLabel") or _lIIllIIlll:IsA("ImageButton") then
            if _lIIllIIlll.Name:lower():find("avatar") or _lIIllIIlll.Name:lower():find("headshot") or _lIIllIIlll.Name:lower():find("thumbnail") then
                _lIIllIIlll.ImageTransparency = 0
            end
        end
    end
end

local function _lIIlIIIlIl()
    pcall(_lIIlIlllII)
    pcall(_lllIIIlIII)
    if Header and Header.Parent then Header.ZIndex = math.max(Header.ZIndex or 1, 2) end
    if Sidebar and Sidebar.Parent then Sidebar.ZIndex = math.max(Sidebar.ZIndex or 1, 2) end
    if ContentFrame and ContentFrame.Parent then ContentFrame.ZIndex = math.max(ContentFrame.ZIndex or 1, 2) end
    if BgLabel and BgLabel.Parent then BgLabel.ZIndex = 1 end
    if BgTint and BgTint.Parent then BgTint.ZIndex = 1 end
end

-- ==================== VECTOR ICONS ====================
-- Roblox nÃ£o renderiza SVG inline. Estes Ã­cones sÃ£o desenhados com Frames/UIStroke,
-- mantendo aparÃªncia vetorial sem depender de emoji ou fonte externa.
local _lIIlIlIlII = {}

local function _IIlIllIlll(_lIlIIlIlll, _IllIIllllI, _lllIlIlllI, _lIllIIllll, _lIIIIllllI, _IlIlllIIlI, _IlllIIIlll, _lIIIIlIlII)
    local _llIIlIllIl = Instance.new("Frame")
    _llIIlIllIl.AnchorPoint = Vector2.new(0.5, 0.5)
    _llIIlIllIl.Position = UDim2.new(0, _IllIIllllI, 0, _lllIlIlllI)
    _llIIlIllIl.Size = UDim2.new(0, _lIllIIllll, 0, _lIIIIllllI)
    _llIIlIllIl.BackgroundColor3 = _IlIlllIIlI or _lIIlIlIlIl
    _llIIlIllIl.BorderSizePixel = 0
    _llIIlIllIl.Rotation = _IlllIIIlll or 0
    _llIIlIllIl.ZIndex = (_lIlIIlIlll.ZIndex or 1) + 1
    _llIIlIllIl.Parent = _lIlIIlIlll
    if _lIIIIlIlII then
        local _lIIlIIllll = Instance.new("UICorner")
        _lIIlIIllll.CornerRadius = UDim.new(1, 0)
        _lIIlIIllll.Parent = _llIIlIllIl
    end
    return _llIIlIllIl
end

local function _llIIIllIll(_lIlIIlIlll, _IllIIllllI, _lllIlIlllI, _lIllIIllll, _lIIIIllllI, _IlIlllIIlI, _lIIIIlIlII)
    local _IllllIllll = Instance.new("Frame")
    _IllllIllll.AnchorPoint = Vector2.new(0.5, 0.5)
    _IllllIllll.Position = UDim2.new(0, _IllIIllllI, 0, _lllIlIlllI)
    _IllllIllll.Size = UDim2.new(0, _lIllIIllll, 0, _lIIIIllllI)
    _IllllIllll.BackgroundTransparency = 1
    _IllllIllll.BorderSizePixel = 0
    _IllllIllll.ZIndex = (_lIlIIlIlll.ZIndex or 1) + 1
    _IllllIllll.Parent = _lIlIIlIlll

    local _IlllIllIII = Instance.new("UICorner")
    _IlllIllIII.CornerRadius = UDim.new(0, _lIIIIlIlII or 3)
    _IlllIllIII.Parent = _IllllIllll

    local _lllllIIlIl = Instance.new("UIStroke")
    _lllllIIlIl.Color = _IlIlllIIlI or _lIIlIlIlIl
    _lllllIIlIl.Thickness = 1.5
    _lllllIIlIl.Parent = _IllllIllll
    return _IllllIllll
end

local function _llllIIlllI(_lIlIIlIlll, _llIIIlIlll, _IllIIllllI, _lllIlIlllI, _IIIIIlIIII, _IlIlllIIlI)
    _IIIIIlIIII = _IIIIIlIIII or 18
    _IlIlllIIlI = _IlIlllIIlI or _lIIlIlIlIl

    local _lIIIlIllII = Instance.new("Frame")
    _lIIIlIllII.Name = "VectorIcon_" .. tostring(_llIIIlIlll)
    _lIIIlIllII.Size = UDim2.new(0, _IIIIIlIIII, 0, _IIIIIlIIII)
    _lIIIlIllII.Position = UDim2.new(0, _IllIIllllI or 0, 0, _lllIlIlllI or 0)
    _lIIIlIllII.BackgroundTransparency = 1
    _lIIIlIllII.BorderSizePixel = 0
    _lIIIlIllII.ZIndex = (_lIlIIlIlll.ZIndex or 1) + 2
    _lIIIlIllII.Parent = _lIlIIlIlll

    local _lIIlIIllll = _IIIIIlIIII / 2

    if _llIIIlIlll == "desktop" then
        _llIIIllIll(_lIIIlIllII, _lIIlIIllll, _lIIlIIllll - 2, _IIIIIlIIII * 0.78, _IIIIIlIIII * 0.52, _IlIlllIIlI, 2)
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll, _IIIIIlIIII * 0.76, 2, _IIIIIlIIII * 0.20, _IlIlllIIlI, 0, true)
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll, _IIIIIlIIII * 0.88, _IIIIIlIIII * 0.38, 2, _IlIlllIIlI, 0, true)

    elseif _llIIIlIlll == "mobile" then
        _llIIIllIll(_lIIIlIllII, _lIIlIIllll, _lIIlIIllll, _IIIIIlIIII * 0.48, _IIIIIlIIII * 0.82, _IlIlllIIlI, 3)
        local _IlIllIlIIl = Instance.new("Frame")
        _IlIllIlIIl.Size = UDim2.new(0, 2.5, 0, 2.5)
        _IlIllIlIIl.Position = UDim2.new(0.5, -1.25, 0.78, -1.25)
        _IlIllIlIIl.BackgroundColor3 = _IlIlllIIlI
        _IlIllIlIIl.BorderSizePixel = 0
        _IlIllIlIIl.ZIndex = _lIIIlIllII.ZIndex + 2
        _IlIllIlIIl.Parent = _lIIIlIllII
        Instance.new("UICorner", _IlIllIlIIl).CornerRadius = UDim.new(1, 0)

    elseif _llIIIlIlll == "console" then
        _llIIIllIll(_lIIIlIllII, _lIIlIIllll, _lIIlIIllll + 1, _IIIIIlIIII * 0.82, _IIIIIlIIII * 0.48, _IlIlllIIlI, 5)
        _IIlIllIlll(_lIIIlIllII, _IIIIIlIIII * 0.32, _lIIlIIllll + 1, _IIIIIlIIII * 0.22, 2, _IlIlllIIlI, 0, true)
        _IIlIllIlll(_lIIIlIllII, _IIIIIlIIII * 0.32, _lIIlIIllll + 1, 2, _IIIIIlIIII * 0.22, _IlIlllIIlI, 0, true)
        for _llIIIIIIII, px in ipairs({0.66, 0.77}) do
            local _IIllIllIlI = Instance.new("Frame")
            _IIllIllIlI.Size = UDim2.new(0, 3, 0, 3)
            _IIllIllIlI.Position = UDim2.new(px, -1.5, 0.5, -0.5)
            _IIllIllIlI.BackgroundColor3 = _IlIlllIIlI
            _IIllIllIlI.BorderSizePixel = 0
            _IIllIllIlI.ZIndex = _lIIIlIllII.ZIndex + 2
            _IIllIllIlI.Parent = _lIIIlIllII
            Instance.new("UICorner", _IIllIllIlI).CornerRadius = UDim.new(1, 0)
        end

    elseif _llIIIlIlll == "close" then
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll, _lIIlIIllll, _IIIIIlIIII * 0.58, 2, _IlIlllIIlI, 45, true)
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll, _lIIlIIllll, _IIIIIlIIII * 0.58, 2, _IlIlllIIlI, -45, true)

    elseif _llIIIlIlll == "search" then
        local _lllIllIIll = _llIIIllIll(_lIIIlIllII, _IIIIIlIIII * 0.43, _IIIIIlIIII * 0.42, _IIIIIlIIII * 0.48, _IIIIIlIIII * 0.48, _IlIlllIIlI, _IIIIIlIIII)
        _lllIllIIll:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(1, 0)
        _IIlIllIlll(_lIIIlIllII, _IIIIIlIIII * 0.70, _IIIIIlIIII * 0.70, _IIIIIlIIII * 0.34, 2, _IlIlllIIlI, 45, true)

    elseif _llIIIlIlll == "eye" or _llIIIlIlll == "eyeOff" then
        -- Eye compacto e centralizado: contorno em formato de olho + pupila limpa.
        local _IlIIIlIllI = _IIIIIlIIII * 0.78
        local _IlIllllIII = _IIIIIlIIII * 0.44
        local _lIIIllIlII = _IlIIIlIllI * 0.5
        local _lllIlIIllI = _IlIllllIII * 0.5

        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll - _lIIIllIlII * 0.52, _lIIlIIllll - _lllIlIIllI * 0.42, _IlIIIlIllI * 0.54, 1.55, _IlIlllIIlI, -22, true)
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll + _lIIIllIlII * 0.52, _lIIlIIllll - _lllIlIIllI * 0.42, _IlIIIlIllI * 0.54, 1.55, _IlIlllIIlI, 22, true)
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll - _lIIIllIlII * 0.52, _lIIlIIllll + _lllIlIIllI * 0.42, _IlIIIlIllI * 0.54, 1.55, _IlIlllIIlI, 22, true)
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll + _lIIIllIlII * 0.52, _lIIlIIllll + _lllIlIIllI * 0.42, _IlIIIlIllI * 0.54, 1.55, _IlIlllIIlI, -22, true)

        local _IIIlIlIlll = Instance.new("Frame")
        _IIIlIlIlll.Size = UDim2.new(0, _IIIIIlIIII * 0.25, 0, _IIIIIlIIII * 0.25)
        _IIIlIlIlll.Position = UDim2.new(0.5, -_IIIIIlIIII * 0.125, 0.5, -_IIIIIlIIII * 0.125)
        _IIIlIlIlll.BackgroundColor3 = _IlIlllIIlI
        _IIIlIlIlll.BorderSizePixel = 0
        _IIIlIlIlll.ZIndex = _lIIIlIllII.ZIndex + 2
        _IIIlIlIlll.Parent = _lIIIlIllII
        Instance.new("UICorner", _IIIlIlIlll).CornerRadius = UDim.new(1, 0)

        if _llIIIlIlll == "eyeOff" then
            -- Corte diagonal com uma pequena margem alÃ©m do olho.
            _IIlIllIlll(_lIIIlIllII, _lIIlIIllll, _lIIlIIllll, _IIIIIlIIII * 0.92, 2.1, _IlIlllIIlI, 45, true)
        end

    elseif _llIIIlIlll == "mouse" then
        -- Usa o asset oficial solicitado para toda representaÃ§Ã£o visual de mouse.
        local _IIllllIIIl = Instance.new("ImageLabel")
        _IIllllIIIl.Name = "MouseAssetIcon"
        _IIllllIIIl.AnchorPoint = Vector2.new(0.5, 0.5)
        _IIllllIIIl.Position = UDim2.new(0.5, 0, 0.5, 0)
        _IIllllIIIl.Size = UDim2.new(1, 0, 1, 0)
        _IIllllIIIl.BackgroundTransparency = 1
        _IIllllIIIl.BorderSizePixel = 0
        _IIllllIIIl.Image = "rbxassetid://10088146939"
        _IIllllIIIl.ImageColor3 = _IlIlllIIlI
        _IIllllIIIl.ScaleType = Enum.ScaleType.Fit
        _IIllllIIIl.ZIndex = _lIIIlIllII.ZIndex + 2
        _IIllllIIIl:SetAttribute("PreserveThemeColor", true)
        _IIllllIIIl.Parent = _lIIIlIllII

    elseif _llIIIlIlll == "theme" or _llIIIlIlll == "sun" then
        -- Sol menor e mais equilibrado para o botÃ£o circular de 34px.
        local _lIIlIllIII = Instance.new("Frame")
        _lIIlIllIII.Size = UDim2.new(0, _IIIIIlIIII * 0.34, 0, _IIIIIlIIII * 0.34)
        _lIIlIllIII.Position = UDim2.new(0.5, -_IIIIIlIIII * 0.17, 0.5, -_IIIIIlIIII * 0.17)
        _lIIlIllIII.BackgroundColor3 = _IlIlllIIlI
        _lIIlIllIII.BorderSizePixel = 0
        _lIIlIllIII.ZIndex = _lIIIlIllII.ZIndex + 2
        _lIIlIllIII.Parent = _lIIIlIllII
        Instance.new("UICorner", _lIIlIllIII).CornerRadius = UDim.new(1, 0)

        for i = 0, 7 do
            local _IlIIlIIlIl = i * 45
            local _llIlIIIIlI = math.rad(_IlIIlIIlIl)
            local _IllIIllllI = _lIIlIIllll + math.cos(_llIlIIIIlI) * _IIIIIlIIII * 0.37
            local _lllIlIlllI = _lIIlIIllll + math.sin(_llIlIIIIlI) * _IIIIIlIIII * 0.37
            _IIlIllIlll(_lIIIlIllII, _IllIIllllI, _lllIlIlllI, _IIIIIlIIII * 0.17, 1.45, _IlIlllIIlI, _IlIIlIIlIl, true)
        end

    elseif _llIIIlIlll == "moon" then
        -- Lua crescente desenhada sem depender da cor de fundo do botÃ£o.
        local _lllIIlIlll = Instance.new("Frame")
        _lllIIlIlll.Size = UDim2.new(0, _IIIIIlIIII * 0.62, 0, _IIIIIlIIII * 0.62)
        _lllIIlIlll.Position = UDim2.new(0, _IIIIIlIIII * 0.16, 0, _IIIIIlIIII * 0.17)
        _lllIIlIlll.BackgroundColor3 = _IlIlllIIlI
        _lllIIlIlll.BorderSizePixel = 0
        _lllIIlIlll.ZIndex = _lIIIlIllII.ZIndex + 2
        _lllIIlIlll.Parent = _lIIIlIllII
        Instance.new("UICorner", _lllIIlIlll).CornerRadius = UDim.new(1, 0)

        local _IlllIIIIII = Instance.new("Frame")
        _IlllIIIIII.Size = UDim2.new(0, _IIIIIlIIII * 0.54, 0, _IIIIIlIIII * 0.54)
        _IlllIIIIII.Position = UDim2.new(0, _IIIIIlIIII * 0.34, 0, _IIIIIlIIII * 0.06)
        _IlllIIIIII.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
        _IlllIIIIII.BackgroundTransparency = 0
        _IlllIIIIII.BorderSizePixel = 0
        _IlllIIIIII.ZIndex = _lIIIlIllII.ZIndex + 3
        _IlllIIIIII.Parent = _lIIIlIllII
        Instance.new("UICorner", _IlllIIIIII).CornerRadius = UDim.new(1, 0)

    elseif _llIIIlIlll == "brush" then
        -- Pincel legÃ­vel em 18px: cabo diagonal + virola + ponta.
        _IIlIllIlll(_lIIIlIllII, _IIIIIlIIII * 0.61, _IIIIIlIIII * 0.39, _IIIIIlIIII * 0.64, 2.4, _IlIlllIIlI, -45, true)

        local _lIIIlIlllI = Instance.new("Frame")
        _lIIIlIlllI.Size = UDim2.new(0, _IIIIIlIIII * 0.25, 0, _IIIIIlIIII * 0.19)
        _lIIIlIlllI.Position = UDim2.new(0, _IIIIIlIIII * 0.31, 0, _IIIIIlIIII * 0.57)
        _lIIIlIlllI.BackgroundColor3 = _IlIlllIIlI
        _lIIIlIlllI.BorderSizePixel = 0
        _lIIIlIlllI.Rotation = -45
        _lIIIlIlllI.ZIndex = _lIIIlIllII.ZIndex + 2
        _lIIIlIlllI.Parent = _lIIIlIllII
        Instance.new("UICorner", _lIIIlIlllI).CornerRadius = UDim.new(0, 2)

        local _lIlllIIIIl = Instance.new("Frame")
        _lIlllIIIIl.Size = UDim2.new(0, _IIIIIlIIII * 0.25, 0, _IIIIIlIIII * 0.28)
        _lIlllIIIIl.Position = UDim2.new(0, _IIIIIlIIII * 0.19, 0, _IIIIIlIIII * 0.67)
        _lIlllIIIIl.BackgroundColor3 = _IlIlllIIlI
        _lIlllIIIIl.BorderSizePixel = 0
        _lIlllIIIIl.Rotation = 45
        _lIlllIIIIl.ZIndex = _lIIIlIllII.ZIndex + 2
        _lIlllIIIIl.Parent = _lIIIlIllII
        Instance.new("UICorner", _lIlllIIIIl).CornerRadius = UDim.new(0, 3)

    elseif _llIIIlIlll == "home" then
        _IIlIllIlll(_lIIIlIllII, _IIIIIlIIII * 0.35, _IIIIIlIIII * 0.38, _IIIIIlIIII * 0.55, 1.8, _IlIlllIIlI, -42, true)
        _IIlIllIlll(_lIIIlIllII, _IIIIIlIIII * 0.65, _IIIIIlIIII * 0.38, _IIIIIlIIII * 0.55, 1.8, _IlIlllIIlI, 42, true)
        _llIIIllIll(_lIIIlIllII, _lIIlIIllll, _IIIIIlIIII * 0.64, _IIIIIlIIII * 0.58, _IIIIIlIIII * 0.48, _IlIlllIIlI, 3)

    elseif _llIIIlIlll == "info" then
        local _lllIllIIll = _llIIIllIll(_lIIIlIllII, _lIIlIIllll, _lIIlIIllll, _IIIIIlIIII * 0.76, _IIIIIlIIII * 0.76, _IlIlllIIlI, _IIIIIlIIII)
        _lllIllIIll:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(1, 0)
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll, _IIIIIlIIII * 0.58, 2, _IIIIIlIIII * 0.28, _IlIlllIIlI, 0, true)
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll, _IIIIIlIIII * 0.29, 2.5, 2.5, _IlIlllIIlI, 0, true)

    elseif _llIIIlIlll == "star" then
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll, _lIIlIIllll, _IIIIIlIIII * 0.62, 1.5, _IlIlllIIlI, 0, true)
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll, _lIIlIIllll, _IIIIIlIIII * 0.62, 1.5, _IlIlllIIlI, 90, true)
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll, _lIIlIIllll, _IIIIIlIIII * 0.45, 1.2, _IlIlllIIlI, 45, true)
        _IIlIllIlll(_lIIIlIllII, _lIIlIIllll, _lIIlIIllll, _IIIIIlIIII * 0.45, 1.2, _IlIlllIIlI, -45, true)

    elseif _llIIIlIlll == "status" then
        local _IlIllIlIIl = Instance.new("Frame")
        _IlIllIlIIl.Size = UDim2.new(0, _IIIIIlIIII * 0.38, 0, _IIIIIlIIII * 0.38)
        _IlIllIlIIl.Position = UDim2.new(0.5, -_IIIIIlIIII*0.19, 0.5, -_IIIIIlIIII*0.19)
        _IlIllIlIIl.BackgroundColor3 = _IlIlllIIlI
        _IlIllIlIIl.BorderSizePixel = 0
        _IlIllIlIIl.ZIndex = _lIIIlIllII.ZIndex + 2
        _IlIllIlIIl.Parent = _lIIIlIllII
        Instance.new("UICorner", _IlIllIlIIl).CornerRadius = UDim.new(1,0)

    else
        -- generic minimalist diamond
        local _IIllIllIlI = _llIIIllIll(_lIIIlIllII, _lIIlIIllll, _lIIlIIllll, _IIIIIlIIII * 0.58, _IIIIIlIIII * 0.58, _IlIlllIIlI, 2)
        _IIllIllIlI.Rotation = 45
    end

    return _lIIIlIllII
end

-- Ãcones compactos especÃ­ficos dos botÃµes circulares.
-- Eles nÃ£o reutilizam o makeVectorIcon porque os Ã­cones de 18px ficavam
-- finos e distorcidos dentro dos botÃµes de 34px.
local function _IlIlIlIlIl(_lIlIIlIlll, _IlIlIlllll)
    local _lIIIlIllII = Instance.new("Frame")
    _lIIIlIllII.Name = _IlIlIlllll
    _lIIIlIllII.Size = UDim2.new(0, 22, 0, 22)
    _lIIIlIllII.Position = UDim2.new(0.5, -11, 0.5, -11)
    _lIIIlIllII.BackgroundTransparency = 1
    _lIIIlIllII.BorderSizePixel = 0
    _lIIIlIllII.ZIndex = (_lIlIIlIlll.ZIndex or 1) + 3
    _lIIIlIllII.Parent = _lIlIIlIlll
    return _lIIIlIllII
end

local function _lllIlIIIll(_lIlIIlIlll, _IIIIllIIll, _IlIlllIIlI)
    _IlIlllIIlI = _IlIlllIIlI or _lIIlIlIlIl
    local _lIIIlIllII = _IlIlIlIlIl(_lIlIIlIlll, "CleanEyeIcon")

    -- Corpo do olho: oval forte e limpo.
    local _lIlIIlIIlI = Instance.new("Frame")
    _lIlIIlIIlI.AnchorPoint = Vector2.new(0.5, 0.5)
    _lIlIIlIIlI.Position = UDim2.new(0.5, 0, 0.5, 0)
    _lIlIIlIIlI.Size = UDim2.new(0, 18, 0, 11)
    _lIlIIlIIlI.BackgroundTransparency = 1
    _lIlIIlIIlI.BorderSizePixel = 0
    _lIlIIlIIlI.ZIndex = _lIIIlIllII.ZIndex + 1
    _lIlIIlIIlI.Parent = _lIIIlIllII
    Instance.new("UICorner", _lIlIIlIIlI).CornerRadius = UDim.new(1, 0)

    local _IIIIlIIlII = Instance.new("UIStroke")
    _IIIIlIIlII.Color = _IlIlllIIlI
    _IIIIlIIlII.Thickness = 1.8
    _IIIIlIIlII.Transparency = 0
    _IIIIlIIlII.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    _IIIIlIIlII.Parent = _lIlIIlIIlI

    local _IIIlIlIlll = Instance.new("Frame")
    _IIIlIlIlll.AnchorPoint = Vector2.new(0.5, 0.5)
    _IIIlIlIlll.Position = UDim2.new(0.5, 0, 0.5, 0)
    _IIIlIlIlll.Size = UDim2.new(0, 5, 0, 5)
    _IIIlIlIlll.BackgroundColor3 = _IlIlllIIlI
    _IIIlIlIlll.BorderSizePixel = 0
    _IIIlIlIlll.ZIndex = _lIIIlIllII.ZIndex + 2
    _IIIlIlIlll.Parent = _lIIIlIllII
    Instance.new("UICorner", _IIIlIlIlll).CornerRadius = UDim.new(1, 0)

    -- Pequeno brilho evita o aspecto de "bolinha chapada".
    local _lIIIlIIlll = Instance.new("Frame")
    _lIIIlIIlll.Size = UDim2.new(0, 1.5, 0, 1.5)
    _lIIIlIIlll.Position = UDim2.new(0.5, -0.2, 0.5, -2.0)
    _lIIIlIIlll.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
    _lIIIlIIlll.BorderSizePixel = 0
    _lIIIlIIlll.ZIndex = _lIIIlIllII.ZIndex + 3
    _lIIIlIIlll.Parent = _lIIIlIllII
    Instance.new("UICorner", _lIIIlIIlll).CornerRadius = UDim.new(1, 0)

    if not _IIIIllIIll then
        local _IIlIIIlIlI = _IIlIllIlll(_lIIIlIllII, 11, 11, 23, 2.2, _IlIlllIIlI, -45, true)
        _IIlIIIlIlI.ZIndex = _lIIIlIllII.ZIndex + 4
    end

    return _lIIIlIllII
end

local function _lIIllllIll(_lIlIIlIlll, _IlIlllIIlI)
    _IlIlllIIlI = _IlIlllIIlI or _lIIlIlIlIl
    local _lIIIlIllII = _IlIlIlIlIl(_lIlIIlIlll, "CleanSunIcon")

    local _lIIlIllIII = Instance.new("Frame")
    _lIIlIllIII.AnchorPoint = Vector2.new(0.5, 0.5)
    _lIIlIllIII.Position = UDim2.new(0.5, 0, 0.5, 0)
    _lIIlIllIII.Size = UDim2.new(0, 8, 0, 8)
    _lIIlIllIII.BackgroundTransparency = 1
    _lIIlIllIII.BorderSizePixel = 0
    _lIIlIllIII.ZIndex = _lIIIlIllII.ZIndex + 1
    _lIIlIllIII.Parent = _lIIIlIllII
    Instance.new("UICorner", _lIIlIllIII).CornerRadius = UDim.new(1, 0)

    local _IllllIlllI = Instance.new("UIStroke")
    _IllllIlllI.Color = _IlIlllIIlI
    _IllllIlllI.Thickness = 1.8
    _IllllIlllI.Parent = _lIIlIllIII

    -- 8 raios curtos, afastados do nÃºcleo.
    for i = 0, 7 do
        local _IlIIlIIlIl = i * 45
        local _IIIlIllIll = math.rad(_IlIIlIIlIl)
        local _IllIIllllI = 11 + math.cos(_IIIlIllIll) * 8.0
        local _lllIlIlllI = 11 + math.sin(_IIIlIllIll) * 8.0
        _IIlIllIlll(_lIIIlIllII, _IllIIllllI, _lllIlIlllI, 4.2, 1.55, _IlIlllIIlI, _IlIIlIIlIl, true)
    end

    return _lIIIlIllII
end

local function _IIllIIllll(_lIlIIlIlll, _IlIlllIIlI)
    _IlIlllIIlI = _IlIlllIIlI or _lIIlIlIlIl
    local _lIIIlIllII = _IlIlIlIlIl(_lIlIIlIlll, "CleanMoonIcon")

    -- Crescente maior e deslocado para ficar imediatamente reconhecÃ­vel.
    local _lllIIlIlll = Instance.new("Frame")
    _lllIIlIlll.Size = UDim2.new(0, 14, 0, 14)
    _lllIIlIlll.Position = UDim2.new(0, 3.5, 0, 4)
    _lllIIlIlll.BackgroundColor3 = _IlIlllIIlI
    _lllIIlIlll.BorderSizePixel = 0
    _lllIIlIlll.ZIndex = _lIIIlIllII.ZIndex + 1
    _lllIIlIlll.Parent = _lIIIlIllII
    Instance.new("UICorner", _lllIIlIlll).CornerRadius = UDim.new(1, 0)

    local _IIIIlllllI = Instance.new("Frame")
    _IIIIlllllI.Size = UDim2.new(0, 12, 0, 12)
    _IIIIlllllI.Position = UDim2.new(0, 8.5, 0, 1.8)
    _IIIIlllllI.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
    _IIIIlllllI.BorderSizePixel = 0
    _IIIIlllllI.ZIndex = _lIIIlIllII.ZIndex + 2
    _IIIIlllllI.Parent = _lIIIlIllII
    Instance.new("UICorner", _IIIIlllllI).CornerRadius = UDim.new(1, 0)

    return _lIIIlIllII
end

local function _IIlIIIIIII(_lIlIIlIlll, _IlIlllIIlI)
    _IlIlllIIlI = _IlIlllIIlI or _lIIlIlIlIl
    local _lIIIlIllII = _IlIlIlIlIl(_lIlIIlIlll, "CleanBrushIcon")

    -- Cabo: mais grosso e curto para nÃ£o parecer apenas uma barra.
    local _IIIllIlllI = _IIlIllIlll(_lIIIlIllII, 13.8, 7.8, 12, 3.0, _IlIlllIIlI, -48, true)
    _IIIllIlllI.ZIndex = _lIIIlIllII.ZIndex + 1

    -- Virola metÃ¡lica estilizada.
    local _lIIIlIlllI = Instance.new("Frame")
    _lIIIlIlllI.AnchorPoint = Vector2.new(0.5, 0.5)
    _lIIIlIlllI.Position = UDim2.new(0, 8.0, 0, 13.3)
    _lIIIlIlllI.Size = UDim2.new(0, 7.5, 0, 5.0)
    _lIIIlIlllI.BackgroundColor3 = _IlIlllIIlI
    _lIIIlIlllI.BorderSizePixel = 0
    _lIIIlIlllI.Rotation = -48
    _lIIIlIlllI.ZIndex = _lIIIlIllII.ZIndex + 2
    _lIIIlIlllI.Parent = _lIIIlIllII
    Instance.new("UICorner", _lIIIlIlllI).CornerRadius = UDim.new(0, 2)

    -- Cerdas; um pouco mais largas que a virola.
    local _llllIIIlll = Instance.new("Frame")
    _llllIIIlll.AnchorPoint = Vector2.new(0.5, 0.5)
    _llllIIIlll.Position = UDim2.new(0, 5.2, 0, 16.5)
    _llllIIIlll.Size = UDim2.new(0, 7.8, 0, 5.8)
    _llllIIIlll.BackgroundColor3 = _IlIlllIIlI
    _llllIIIlll.BorderSizePixel = 0
    _llllIIIlll.Rotation = -48
    _llllIIIlll.ZIndex = _lIIIlIllII.ZIndex + 1
    _llllIIIlll.Parent = _lIIIlIllII
    Instance.new("UICorner", _llllIIIlll).CornerRadius = UDim.new(0, 2.5)

    -- Recorte mÃ­nimo na ponta para sugerir cerdas.
    local _lllIlIllIl = Instance.new("Frame")
    _lllIlIllIl.AnchorPoint = Vector2.new(0.5, 0.5)
    _lllIlIllIl.Position = UDim2.new(0, 3.0, 0, 18.2)
    _lllIlIllIl.Size = UDim2.new(0, 2.0, 0, 3.0)
    _lllIlIllIl.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
    _lllIlIllIl.BorderSizePixel = 0
    _lllIlIllIl.Rotation = -48
    _lllIlIllIl.ZIndex = _lIIIlIllII.ZIndex + 3
    _lllIlIllIl.Parent = _lIIIlIllII

    return _lIIIlIllII
end

local function _IllIIIIIII(_lIIlIIlIII)
    if _lIIlIIlIII == "mobile" then return "mobile" end
    if _lIIlIIlIII == "console" then return "console" end
    return "desktop"
end

local _lIIlIllIll={fast=0.12,normal=0.20,slow=0.35}
Panel.UI_TWEEN=_lIIlIllIll

local function _llIlIIIlII(_lIIlIIllII, _IIIlIIlIlI)
    if not _lIIlIIllII or not _lIIlIIllII:IsA("GuiButton") then return end
    _lIIlIIllII.AutoButtonColor = false
    local _IlllIllIlI = _lIIlIIllII.BackgroundColor3

    _IIIIIIlIlI(_lIIlIIllII.MouseEnter, function()
        if _lIIlIIllII:GetAttribute("HoverDisabled") then return end
        _lllIllIlIl:Create(_lIIlIIllII, TweenInfo.new(_lIIlIllIll.fast, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btnHover
        }):Play()
        if _IIIlIIlIlI ~= false then
            _lllIllIlIl:Create(_lIIlIIllII, TweenInfo.new(_lIIlIllIll.fast), {TextColor3 = _lIIlIlIlIl}):Play()
        end
    end)

    _IIIIIIlIlI(_lIIlIIllII.MouseLeave, function()
        if _lIIlIIllII:GetAttribute("HoverDisabled") then return end
        local _lllIlIIIlI = _lIIlIlIlII and _lIIlIlIlII[_lIIlIIllII] and _IllllIIlII[_lIIlIIlllI].btnOn
            or _IllllIIlII[_lIIlIIlllI].btn
        _lllIllIlIl:Create(_lIIlIIllII, TweenInfo.new(_lIIlIllIll.fast, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = _lllIlIIIlI
        }):Play()
        if _IIIlIIlIlI ~= false then
            _lllIllIlIl:Create(_lIIlIIllII, TweenInfo.new(0.16), {TextColor3 = _IllllIIlII[_lIIlIIlllI].text}):Play()
        end
    end)
end

-- ==================== HELPERS HTTP ====================
local function _IIlllIllII()
    -- Prioridade mÃ¡xima para a funÃ§Ã£o padrÃ£o UNC (usada no Potassium)
    if type(request) == "function" then return request end
    if type(http_request) == "function" then return http_request end

    -- Fallbacks clÃ¡ssicos seguros
    if type(getgenv) == "function" and type(getgenv().request) == "function" then
        return getgenv().request
    end
    if type(http) == "table" and type(http.request) == "function" then
        return http.request
    end
    if type(syn) == "table" and type(syn.request) == "function" then
        return syn.request
    end
    return nil
end

local _lIllIIlIlI = _IIlllIllII()

local function _lIIIIllIlI(_IIlIIlIIII)
    if type(_IIlIIlIIII) == "table" then return _IIlIIlIIII end
    if type(_IIlIIlIIII) ~= "string" or _IIlIIlIIII == "" then return nil end
    local _lllIllIllI, _lIIllIIIll = pcall(function() return _IIlIlIllll:JSONDecode(_IIlIIlIIII) end)
    return _lllIllIllI and _lIIllIIIll or nil
end

local function _lIlllllIII(_lIllllIIIl,_lIIIIIllII,_IlIIIIlIIl) _lIIIIIllII=math.max(1,tonumber(_lIIIIIllII) or 2) local _IIlIlIIIII for _IlIllllIll=1,_lIIIIIllII do local _IllllIllIl=os.clock() local _lllIllIllI,_lllIlIIlII=pcall(_IlIIIIlIIl,_IlIllllIll) if _lllIllIllI and _lllIlIIlII~=nil and _lllIlIIlII~=false then Panel.State.lastApiLatencyMs=math.floor((os.clock()-_IllllIllIl)*1000+0.5) return _lllIlIIlII end _IIlIlIIIII=_lllIllIllI and "empty response" or tostring(_lllIlIIlII) if _IlIllllIll<_lIIIIIllII then task.wait(0.18*_IlIllllIll) end end _lIlIllIlIl("warning",_lIllllIIIl or "NETWORK",_IIlIlIIIII or "request failed") return nil end

local function _llllIlllII(_lIlIIIIIII)
    local _lIIIIIlllI = tostring(_lIlIIIIIII):find("?", 1, true) and "&" or "?"
    local _lllIIlllII = _IllIlIlIlI .. _lIlIIIIIII .. _lIIIIIlllI .. "_=" .. tostring(os.time())

    if _lIllIIlIlI then
        local _lllIllIllI, _llllllllII = pcall(_lIllIIlIlI, { Url = _lllIIlllII, Method = "GET" })
        if _lllIllIllI and _llllllllII then
            if type(_llllllllII) == "string" then
                local _lIIllIIIll = _lIIIIllIlI(_llllllllII)
                if _lIIllIIIll then return _lIIllIIIll end
            elseif type(_llllllllII) == "table" then
                local _lllIIlllIl = tonumber(_llllllllII.StatusCode or _llllllllII.Status or _llllllllII.status_code)
                local _lllIllIlII = _llllllllII.Body or _llllllllII.body or _llllllllII.ResponseBody
                if not _lllIIlllIl or _lllIIlllIl == 0 or (_lllIIlllIl >= 200 and _lllIIlllIl < 300) then
                    local _lIIllIIIll = _lIIIIllIlI(_lllIllIlII)
                    if _lIIllIIIll then return _lIIllIIIll end
                end
            end
        end
    end

    local _lllIllIllI, _IIlIIlIIII = pcall(function() return game:HttpGet(_lllIIlllII) end)
    local _lIIllIIIll = _lllIllIllI and _lIIIIllIlI(_IIlIIlIIII) or nil
    if _lIIllIIIll then return _lIIllIIIll end

    -- Alguns ambientes ou proxies bloqueiam query de cache-buster.
    local _IlIIIlIIll, _IlIlllIllI = pcall(function() return game:HttpGet(_IllIlIlIlI .. _lIlIIIIIII) end)
    return _IlIIIlIIll and _lIIIIllIlI(_IlIlllIllI) or nil
end

local function _IIIIIlIlII(_lIlIIIIIII, _IlIIIIIIll)
    local _llllIIIlIl = _IIlIlIllll:JSONEncode(_IlIIIIIIll or {})
    if _lIllIIlIlI then
        local _lllIllIllI, _llllllllII = pcall(_lIllIIlIlI, {
            Url = _IllIlIlIlI .. _lIlIIIIIII,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = _llllIIIlIl,
        })
        if _lllIllIllI and _llllllllII then
            if type(_llllllllII) == "string" then
                local _lIIllIIIll = _lIIIIllIlI(_llllllllII)
                if _lIIllIIIll then return _lIIllIIIll end
            elseif type(_llllllllII) == "table" then
                local _lllIIlllIl = tonumber(_llllllllII.StatusCode or _llllllllII.Status or _llllllllII.status_code)
                local _lllIllIlII = _llllllllII.Body or _llllllllII.body or _llllllllII.ResponseBody
                if not _lllIIlllIl or _lllIIlllIl == 0 or (_lllIIlllIl >= 200 and _lllIIlllIl < 300) then
                    local _lIIllIIIll = _lIIIIllIlI(_lllIllIlII)
                    if _lIIllIIIll then return _lIIllIIIll end
                end
            end
        end
    end

    local _lllIllIllI, _IIlIIlIIII = pcall(function()
        return _IIlIlIllll:PostAsync(
            _IllIlIlIlI .. _lIlIIIIIII,
            _llllIIIlIl,
            Enum.HttpContentType.ApplicationJson
        )
    end)
    return _lllIllIllI and _lIIIIllIlI(_IIlIIlIIII) or nil
end

Panel.ApiGet = _llllIlllII
Panel.ApiPost = _IIIIIlIlII
Panel.GetSessionId = function() return _lIlIllIllI end
Panel.ApiBase = _IllIlIlIlI

_IlIlIlllIl = function(_IlIlIlllll)
    _IlIlIlllll = _llIIIIlIIl(_IlIlIlllll)
    if not _IlIlIlllll then
        _lIlIllIlIl("warning", "THEME", "Invalid theme ignored")
        return false
    end

    local _lllIlllIll = _lIlllllIII("THEME", 3, function()
        local _llllllllII = _IIIIIlIlII("/user/preference", {
            userid = _IlllllllII.UserId,
            theme = _IlIlIlllll,
        })
        if type(_llllllllII) == "table"
            and _llllllllII.success == true
            and _llIIIIlIIl(_llllllllII.theme) == _IlIlIlllll then
            return _llllllllII
        end
        return nil
    end)

    if _lllIlllIll then
        _lIlIllIlIl("success", "THEME", "Theme persisted: " .. _IlIlIlllll)
        return true
    end
    _lIlIllIlIl("warning", "THEME", "Could not persist theme: " .. _IlIlIlllll)
    return false
end

_IllIIlIlIl = function(_IlIlIlIlll)
    _IlIlIlIlll = math.clamp(tonumber(_IlIlIlIlll) or 0.8, 0, 1)
    local _lllIlllIll = _lIlllllIII("VOLUME", 3, function()
        local _llllllllII = _IIIIIlIlII("/user/preference", {
            userid = _IlllllllII.UserId,
            notificationVolume = _IlIlIlIlll,
        })
        local _lIIlIIIllI = type(_llllllllII) == "table" and tonumber(_llllllllII.notificationVolume) or nil
        if _llllllllII and _llllllllII.success == true
            and _lIIlIIIllI
            and math.abs(_lIIlIIIllI - _IlIlIlIlll) < 0.001 then
            return _llllllllII
        end
        return nil
    end)
    if _lllIlllIll then
        _lIlIllIlIl("success", "VOLUME", "Notification volume persisted")
        return true
    end
    _lIlIllIlIl("warning", "VOLUME", "Could not persist notification volume")
    return false
end
Panel.SetTheme = function(_llIIIIIIII, _IlIlIlllll)
    return _lIIIIllIII(_IlIlIlllll, {
        userInitiated = true,
        persistRemote = true,
    })
end
local function _lIIIIllIIl(_IIlllIIIIl, _IlIIlIIIlI, _llllIIlIIl)
    task.spawn(function()
        pcall(function()
            _IIIIIlIlII("/telemetry/error", {
                _IIlllIIIIl = tostring(_IIlllIIIIl or "panel"),
                _IlIIlIIIlI = tostring(_IlIIlIIIlI or "Unknown error"),
                _llllIIlIIl = _llllIIlIIl and tostring(_llllIIlIIl) or nil,
                _IlllIIlIII = tostring(_IlllllllII.UserId),
                _IlIIlIllIl = tostring(game.PlaceId),
                panelVersion = _IIIIlIIlIl,
            })
        end)
    end)
end

local _lllIlIIIIl = _llllIlllII("/config/public") or {}
do
    local _llllIlIIII = tostring(_lllIlIIIIl.panelVersion or _IIIIlIIlIl):gsub("^v", "")
    _IIIIlIIlIl = "v" .. _llllIlIIII
end
local _lllllllIIl = tostring(_lllIlIIIIl.discordInvite or "https://discord.gg/9XZB7z53wW")

-- Envia a execuÃ§Ã£o durante o bootstrap e aguarda a API antes de criar qualquer UI.
do
    local _llIllllIIl = "Unknown Game"
    pcall(function()
        _llIllllIIl = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
    local _llllllIlIl
    pcall(function()
        _llllllIlIl = _lllIIIlIlI:GetUserThumbnailAsync(
            _IlllllllII.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size420x420
        )
    end)
    local _llllllllII = _IIIIIlIlII("/telemetry/execute", {
        _llIlIIIlll = _IlllllllII.Name,
        _IlllIIlIII = tostring(_IlllllllII.UserId),
        _llIllllIIl = _llIllllIIl,
        _IlIIlIllIl = tostring(game.PlaceId),
        _llllllIlIl = _llllllIlIl,
        executor = _lIIIIIllll,
        panelVersion = _IIIIlIIlIl,
    })
    _lIlIllIlIl("info", "EXECUTOR", "Executor detected: " .. _lIIIIIllll)
    if not _llllllllII or _llllllllII.success ~= true then
        warn("[288] Falha ao enviar webhook de execuÃ§Ã£o durante o loading.")
    end
end
local _IIlllIIlII = "288/discord_dismissed"
local _lIlIllIlll = "288/anti_afk_enabled"

local function _IllIllllII(_lIlIlIIllI)
    if not (isfile and readfile) then return false end
    local _IIlIIllIII, _IIlIIIIIIl = pcall(isfile, _lIlIlIIllI)
    if not _IIlIIllIII or not _IIlIIIIIIl then return false end
    local _lIIIlllIlI, _IlIlIlIlll = pcall(readfile, _lIlIlIIllI)
    return _lIIIlllIlI and tostring(_IlIlIlIlll):match("^%s*1%s*$") ~= nil
end

local function _llIlIlIIIl(_lIlIlIIllI, _lIlIlIIIll)
    if not writefile then return false end
    local _lllIllIllI = pcall(function()
        if makefolder and (not isfolder or not isfolder("288")) then makefolder("288") end
        writefile(_lIlIlIIllI, _lIlIlIIIll and "1" or "0")
    end)
    return _lllIllIllI
end

local function _IlIIllIllI()
    if not (isfile and readfile) then return false end
    local _lllIllIllI, _IIlIIIIIIl = pcall(isfile, _IIlllIIlII)
    return _lllIllIllI and _IIlIIIIIIl == true
end

local function _llIIIIIIlI()
    if not writefile then return end
    pcall(function()
        if makefolder and isfolder and not isfolder("288") then makefolder("288") end
        writefile(_IIlllIIlII, "1")
    end)
end

local function _IlIIllIIII(_IlIIlIIIlI, _IllIlllllI)
    local _llllIIllII = Instance.new("ScreenGui")
    _llllIIllII.Name = "288EntryDialog"
    _llllIIllII.ResetOnSpawn = false
    _llllIIllII.IgnoreGuiInset = true
    _llllIIllII.DisplayOrder = 999999
    _llllIIllII.AutoLocalize = false
    _llllIIllII.Parent = _IlllllllII:WaitForChild("PlayerGui")

    local _llllIIIIIl = Instance.new("Frame")
    _llllIIIIIl.Size = UDim2.fromScale(1, 1)
    _llllIIIIIl.BackgroundColor3 = Color3.new(0, 0, 0)
    _llllIIIIIl.BackgroundTransparency = 0.28
    _llllIIIIIl.BorderSizePixel = 0
    _llllIIIIIl.Parent = _llllIIllII

    local _lIlIIIIlll = Instance.new("Frame")
    _lIlIIIIlll.Size = UDim2.fromOffset(440, 220)
    _lIlIIIIlll.AnchorPoint = Vector2.new(0.5, 0.5)
    _lIlIIIIlll.Position = UDim2.fromScale(0.5, 0.5)
    _lIlIIIIlll.BackgroundColor3 = Color3.fromRGB(24, 22, 31)
    _lIlIIIIlll.BorderSizePixel = 0
    _lIlIIIIlll.Parent = _llllIIIIIl
    Instance.new("UICorner", _lIlIIIIlll).CornerRadius = UDim.new(0, 12)
    local _lllllIIlIl = Instance.new("UIStroke", _lIlIIIIlll)
    _lllllIIlIl.Color = _lIIlIlIlIl
    _lllllIIlIl.Transparency = 0.25

    local _llIIlllIll = Instance.new("TextLabel")
    _llIIlllIll.Size = UDim2.new(1, -32, 0, 38)
    _llIIlllIll.Position = UDim2.fromOffset(16, 12)
    _llIIlllIll.BackgroundTransparency = 1
    _llIIlllIll.Text = "288 Panel"
    _llIIlllIll.TextColor3 = _lIIlIlIlIl
    _llIIlllIll.Font = Enum.Font.GothamBold
    _llIIlllIll.TextSize = 20
    _llIIlllIll.Parent = _lIlIIIIlll

    local _IlIIIIIIll = Instance.new("TextLabel")
    _IlIIIIIIll.Size = UDim2.new(1, -40, 1, -112)
    _IlIIIIIIll.Position = UDim2.fromOffset(20, 48)
    _IlIIIIIIll.BackgroundTransparency = 1
    _IlIIIIIIll.Text = tostring(_IlIIlIIIlI)
    _IlIIIIIIll.TextWrapped = true
    _IlIIIIIIll.TextColor3 = Color3.fromRGB(245, 242, 249)
    _IlIIIIIIll.Font = Enum.Font.GothamMedium
    _IlIIIIIIll.TextSize = 15
    _IlIIIIIIll.Parent = _lIlIIIIlll

    local _lllIIllIll = Instance.new("BindableEvent")
    local _lllIlIIlII
    local _lIlIIlIIIl = math.floor((400 - (#_IllIlllllI - 1) * 10) / #_IllIlllllI)
    for _lllllIlIIl, definition in ipairs(_IllIlllllI) do
        local _lIIlIIllII = Instance.new("TextButton")
        _lIIlIIllII.Size = UDim2.fromOffset(_lIlIIlIIIl, 38)
        _lIIlIIllII.Position = UDim2.new(0, 20 + (_lllllIlIIl - 1) * (_lIlIIlIIIl + 10), 1, -54)
        _lIIlIIllII.BackgroundColor3 = _lllllIlIIl == 1 and Color3.fromRGB(67, 42, 73) or Color3.fromRGB(31, 27, 40)
        _lIIlIIllII.TextColor3 = Color3.fromRGB(248, 246, 252)
        _lIIlIIllII.Text = definition.title
        _lIIlIIllII.Font = Enum.Font.GothamBold
        _lIIlIIllII.TextSize = 13
        _lIIlIIllII.Parent = _lIlIIIIlll
        Instance.new("UICorner", _lIIlIIllII).CornerRadius = UDim.new(0, 8)
        _lIIlIIllII.MouseButton1Click:Connect(function()
            _lllIlIIlII = definition.value
            if definition.callback then pcall(definition.callback) end
            _lllIIllIll:Fire()
        end)
    end
    _lllIIllIll.Event:Wait()
    _lllIIllIll:Destroy()
    _llllIIllII:Destroy()
    return _lllIlIIlII
end

local function _lIlIllllll()
    local _llIIIllIIl = 0
    local _llIlIllIIl = tonumber(_IlllllllII.AccountAge) or 0
    if _llIlIllIIl > 1095 then _llIIIllIIl += 3 elseif _llIlIllIIl > 365 then _llIIIllIIl += 2 elseif _llIlIllIIl > 30 then _llIIIllIIl += 1 end
    if _IlllllllII.MembershipType == Enum.MembershipType.Premium then _llIIIllIIl += 3 end
    pcall(function()
        local _IIlIIlIIII = game:HttpGet("https://friends.roblox.com/v1/users/" .. _IlllllllII.UserId .. "/friends/count")
        local _IllllIlIll = tonumber((_IIlIlIllll:JSONDecode(_IIlIIlIIII) or {}).count) or 0
        if _IllllIlIll > 50 then _llIIIllIIl += 2 elseif _IllllIlIll > 10 then _llIIIllIIl += 1 end
    end)
    return _llIIIllIIl >= 4
end

local function _IIlIlIlIll()
    if _lIlIllllll() then
        local _lllIIlllll = _IlIIllIIII(
            "Detectamos que esta pode ser sua conta principal. O uso de scripts pode colocar a conta em risco. Deseja continuar mesmo assim?",
            {{_llIIlllIll = "Continuar", _IlIlIlIlll = true}, {_llIIlllIll = "Parar script", _IlIlIlIlll = false}}
        )
        if not _lllIIlllll then return false end
    end

    local _IIIIIllIll = _llllIlllII("/session/access/" .. tostring(_IlllllllII.UserId))
    if _IIIIIllIll and _IIIIIllIll.allowed == true then return true end
    if not _IIIIIllIll then
        _IlIIllIIII(
            "NÃ£o foi possÃ­vel verificar o vÃ­nculo Discord. Verifique sua conexÃ£o e execute o script novamente.",
            {{_llIIlllIll = "Fechar", _IlIlIlIlll = false}}
        )
        return false
    end
    local _lllIlIIlII = _IIIIIlIlII("/link/start", { userid = _IlllllllII.UserId })
    if not _lllIlIIlII then
        _IlIIllIIII(
            "NÃ£o foi possÃ­vel conectar Ã  API para iniciar o vÃ­nculo Discord. Verifique sua conexÃ£o e execute o script novamente.",
            {{_llIIlllIll = "Fechar", _IlIlIlIlll = false}}
        )
        return false
    end
    if _lllIlIIlII.linked == true then return true end
    if type(_lllIlIIlII.command) ~= "string" or type(_lllIlIIlII.requestToken) ~= "string" then
        _IlIIllIIII(
            "A API nÃ£o conseguiu gerar o cÃ³digo de vÃ­nculo. Tente executar o script novamente.",
            {{_llIIlllIll = "Fechar", _IlIlIlIlll = false}}
        )
        return false
    end

    local _llllllllll = _lllIlIIlII.command
    if type(setclipboard) == "function" then pcall(setclipboard, _llllllllll) end
    local _lllIllllll = false
    local _llIlllIIIl = false
    local _lllIIllIll = Instance.new("BindableEvent")
    local _IIlIIlIIIl = tonumber(_lllIlIIlII.expiresAt) or 0
    task.spawn(function()
        while not _llIlllIIIl and os.time() * 1000 < _IIlIIlIIIl do
            local _IIIIlIIIIl = _IIIIIlIlII("/link/status", { userid = _IlllllllII.UserId, requestToken = _lllIlIIlII.requestToken })
            if _IIIIlIIIIl and _IIIIlIIIIl.linked == true then _lllIllllll = true _lllIIllIll:Fire() return end
            if _IIIIlIIIIl and _IIIIlIIIIl.expired then break end
            task.wait(2)
        end
        _lllIIllIll:Fire()
    end)
    local _lIIllllIII = Instance.new("ScreenGui")
    _lIIllllIII.Name = "288DiscordLinkDialog"
    _lIIllllIII.ResetOnSpawn = false
    _lIIllllIII.IgnoreGuiInset = true
    _lIIllllIII.DisplayOrder = 999999
    _lIIllllIII.Parent = _IlllllllII:WaitForChild("PlayerGui")
    local _llllIIIIIl = Instance.new("Frame", _lIIllllIII)
    _llllIIIIIl.Size = UDim2.fromScale(1, 1)
    _llllIIIIIl.BackgroundColor3 = Color3.new(0, 0, 0)
    _llllIIIIIl.BackgroundTransparency = 0.28
    local _lIlIIIIlll = Instance.new("Frame", _llllIIIIIl)
    _lIlIIIIlll.Size = UDim2.fromOffset(440, 220)
    _lIlIIIIlll.AnchorPoint = Vector2.new(0.5, 0.5)
    _lIlIIIIlll.Position = UDim2.fromScale(0.5, 0.5)
    _lIlIIIIlll.BackgroundColor3 = Color3.fromRGB(24, 22, 31)
    Instance.new("UICorner", _lIlIIIIlll).CornerRadius = UDim.new(0, 12)
    local _lIllllIIIl = Instance.new("TextLabel", _lIlIIIIlll)
    _lIllllIIIl.Size = UDim2.new(1, -40, 1, -80)
    _lIllllIIIl.Position = UDim2.fromOffset(20, 16)
    _lIllllIIIl.BackgroundTransparency = 1
    _lIllllIIIl.Text = "Para liberar o painel, envie no Discord:\n\n" .. _llllllllll .. "\n\nO acesso serÃ¡ liberado automaticamente apÃ³s a confirmaÃ§Ã£o."
    _lIllllIIIl.TextWrapped = true
    _lIllllIIIl.TextColor3 = Color3.fromRGB(245, 242, 249)
    _lIllllIIIl.Font = Enum.Font.GothamMedium
    _lIllllIIIl.TextSize = 15
    local _IIlllllIII = Instance.new("TextButton", _lIlIIIIlll)
    _IIlllllIII.Size = UDim2.fromOffset(190, 38)
    _IIlllllIII.Position = UDim2.new(0, 20, 1, -54)
    _IIlllllIII.Text = "Copiar comando"
    _IIlllllIII.MouseButton1Click:Connect(function() if type(setclipboard) == "function" then pcall(setclipboard, _llllllllll) end end)
    local _llIlllIlII = Instance.new("TextButton", _lIlIIIIlll)
    _llIlllIlII.Size = UDim2.fromOffset(190, 38)
    _llIlllIlII.Position = UDim2.new(1, -210, 1, -54)
    _llIlllIlII.Text = "Parar script"
    _llIlllIlII.MouseButton1Click:Connect(function() _llIlllIIIl = true _lllIIllIll:Fire() end)
    _lllIIllIll.Event:Wait()
    _lllIIllIll:Destroy()
    if _lIIllllIII.Parent then _lIIllllIII:Destroy() end
    return _lllIllllll
end
if not _IIlIlIlIll() then return end
local function _lIIIIIIlII()
    if _lIlIllllII then return end
    _lIlIllllII = true
    _IIlllIlIlI()

    if loadingSound then
        pcall(function() loadingSound:Stop() end)
        pcall(function() loadingSound:Destroy() end)
        loadingSound = nil
    end

    for _IlIlIlllll, _IlIIIIlIIl in pairs(_IllllIlIII) do
        local _lllIllIllI, _lIIIIlllII = pcall(_IlIIIIlIIl)
        if not _lllIllIllI then warn("[288] cleanup error [" .. tostring(_IlIlIlllll) .. "]: " .. tostring(_lIIIIlllII)) end
        _IllllIlIII[_IlIlIlllll] = nil
    end

    for _IlIlIlllll in pairs(Panel.Runtime.modules) do
        pcall(function() Panel:CleanupModule(_IlIlIlllll) end)
    end

    -- A TAG existe apenas no cliente e no personagem que executou o painel.
    local _IIIllIllII = _IlllllllII.Character
    if _IIIllIllII then
        local _IllIllllll = _IIIllIllII:FindFirstChild("288TagGui", true)
        if _IllIllllll then _IllIllllll:Destroy() end
        local _IIlIllIlII = _IIIllIllII:FindFirstChild("288TagSupport")
        if _IIlIllIlII then _IIlIllIlII:Destroy() end
        for _llIIIIIIII, valueName in ipairs({"288Tag", "288Device", "288TagVisible"}) do
            local _IlIlIlIlll = _IIIllIllII:FindFirstChild(valueName)
            if _IlIlIlIlll then _IlIlIlIlll:Destroy() end
        end
    end
    _IlllIIIlIl = false

    if _lIlIllIllI then
        local _lIIIlIIIlI = _lIlIllIllI
        _lIlIllIllI = nil
        task.spawn(function()
            pcall(function() _IIIIIlIlII("/session/end", { sessionId = _lIIIlIIIlI, userid = _IlllllllII.UserId }) end)
        end)
    end

    for i = #_llIlIIllIl, 1, -1 do
        local _lIIIIIlIII = _llIlIIllIl[i]
        pcall(function()
            if _lIIIIIlIII and _lIIIIIlIII.Connected then _lIIIIIlIII:Disconnect() end
        end)
        _llIlIIllIl[i] = nil
    end

    pcall(function()
        _IllIlIlllI:SetCore("SendNotification", {
            Title = "288 Panel",
            Text = "Script encerrado. Todos os recursos foram desativados.",
            Duration = 5,
        })
    end)

    local _IlllIIlllI = _IlllllllII:FindFirstChildOfClass("PlayerGui")
    local _IIlIlIlIII = _IlllIIlllI and _IlllIIlllI:FindFirstChild("288Panel")
    if _IIlIlIlIII then _IIlIlIlIII:Destroy() end

    _IlIIIlllIl.__288LoadModule=nil _IlIIIlllIl.__288ModuleNotify=nil
    if NotificationGui and NotificationGui.Parent then pcall(function() NotificationGui:Destroy() end) end
    _lIlllIllIl() _lIlIllIlIl("info","CLEANUP","Panel shutdown completed")

    if _IlIIIlllIl.__288PanelCleanup == _lIIIIIIlII then
        _IlIIIlllIl.__288PanelCleanup = nil
    end
    if _IlIIIlllIl.__288Panel == Panel then _IlIIIlllIl.__288Panel = nil end
end

-- Se o script for executado novamente, limpa a instÃ¢ncia anterior antes de criar outra.
if _IlIIIlllIl.__288PanelCleanup then
    pcall(_IlIIIlllIl.__288PanelCleanup)
end
_IlIIIlllIl.__288PanelCleanup = _lIIIIIIlII

local _IlllIIlllI = _IlllllllII:WaitForChild("PlayerGui")
local _IllIIIlIIl = _IlllIIlllI:FindFirstChild("288Panel")
if _IllIIIlIIl then _IllIIIlIIl:Destroy() end

_lIlIllIlIl("info","BOOT","Creating ScreenGui")
_lIlllIlIlI = Instance.new("ScreenGui")
_lIlllIlIlI.Name = "288Panel"
_lIlllIlIlI.AutoLocalize = false
_lIlllIlIlI.ResetOnSpawn = false
_lIlllIlIlI.IgnoreGuiInset = true
_lIlllIlIlI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_lIlllIlIlI.DisplayOrder = 20
_lIlllIlIlI.Parent = _IlllIIlllI

-- ==================== MODULE LOADER ====================
-- Estes mÃ³dulos sÃ£o scripts standalone (incluindo MoonSec), portanto o fluxo Ã©:
-- HttpGet -> loadstring -> execuÃ§Ã£o do chunk. NÃ£o esperamos retorno/funÃ§Ã£o de mÃ³dulo.

MORE_MODULE_URLS = {
    ESP = _IllIlIlIlI .. "/api/module/modules/More/ESP",
    Aimbot = _IllIlIlIlI .. "/api/module/modules/More/Aimbot",
    PianoAuto = _IllIlIlIlI .. "/api/module/modules/More/PianoAuto",

    AnimSpeed = _IllIlIlIlI .. "/api/module/modules/Emphasis/AnimSpeed",
    AntiVoid = _IllIlIlIlI .. "/api/module/modules/Emphasis/AntiVoid",
    ClickTP = _IllIlIlIlI .. "/api/module/modules/Emphasis/ClickTP",
    FaceBang = _IllIlIlIlI .. "/api/module/modules/Emphasis/FaceBang",
    Flashback = _IllIlIlIlI .. "/api/module/modules/Emphasis/Flashback",
    Impulse = _IllIlIlIlI .. "/api/module/modules/Emphasis/Impulse",
    Invisible = _IllIlIlIlI .. "/api/module/modules/Emphasis/Invisible",
    JerkOff = _IllIlIlIlI .. "/api/module/modules/Emphasis/JerkOff",
    Jerk = _IllIlIlIlI .. "/api/module/modules/Emphasis/JerkOff",
    NoClip = _IllIlIlIlI .. "/api/module/modules/Emphasis/NoClip",
    Spin = _IllIlIlIlI .. "/api/module/modules/Emphasis/Spin",
    feFlip = _IllIlIlIlI .. "/api/module/modules/Emphasis/feFlip",
}

USE_LOCAL_SPECIAL_MODULES = true

function fetchModuleSourceUncached(_lllIIlllII)
    local _lIIIIIlllI = _lllIIlllII:find("?", 1, true) and "&" or "?"
    local _IIlIIIIllI = _lllIIlllII .. _lIIIIIlllI .. "_=" .. tostring(os.time())

    if _lIllIIlIlI then
        local _IIIlllllll, _llllllllII = pcall(_lIllIIlIlI, { Url = _IIlIIIIllI, Method = "GET" })
        if _IIIlllllll and _llllllllII then
            if type(_llllllllII) == "string" and #_llllllllII > 0 then
                return _llllllllII
            elseif type(_llllllllII) == "table" then
                local _lllIIlllIl = tonumber(_llllllllII.StatusCode or _llllllllII.Status or _llllllllII.status_code) or 0
                local _IlIIIIIIll = _llllllllII.Body or _llllllllII.body or _llllllllII.ResponseBody
                if (_lllIIlllIl == 0 or (_lllIIlllIl >= 200 and _lllIIlllIl < 300)) and type(_IlIIIIIIll) == "string" and #_IlIIIIIIll > 0 then
                    return _IlIIIIIIll
                end
            end
        end
    end

    local _lIlIIlIIII, _IIlllIIIIl = pcall(function() return game:HttpGet(_IIlIIIIllI) end)
    if _lIlIIlIIII and type(_IIlllIIIIl) == "string" and #_IIlllIIIIl > 0 then return _IIlllIIIIl end
    local _IlIIIlIIll, _llllIIllIl = pcall(function() return game:HttpGet(_lllIIlllII) end)
    return _IlIIIlIIll and type(_llllIIllIl) == "string" and #_llllIIllIl > 0 and _llllIIllIl or nil
end

moduleSourceCache = {}
moduleFetchInProgress = {}

function fetchModuleSource(_lllIIlllII)
    local _IlIIIIIIlI = moduleSourceCache[_lllIIlllII]
    if _IlIIIIIIlI then return _IlIIIIIIlI end

    local _IlIIlIlllI = moduleFetchInProgress[_lllIIlllII]
    if _IlIIlIlllI then
        local _lIIllIIIIl = os.clock() + 2
        while moduleFetchInProgress[_lllIIlllII] and os.clock() < _lIIllIIIIl do
            _IllIllIIII.Heartbeat:Wait()
        end
        return moduleSourceCache[_lllIIlllII]
    end

    moduleFetchInProgress[_lllIIlllII] = true
    local _IIlllIIIIl = _lIlllllIII("MODULE HTTP", 2, function()
        return fetchModuleSourceUncached(_lllIIlllII)
    end)
    moduleFetchInProgress[_lllIIlllII] = nil
    if _IIlllIIIIl then moduleSourceCache[_lllIIlllII] = _IIlllIIIIl end
    return _IIlllIIIIl
end
-- ==================== PANEL NOTIFICATIONS + SOUND ====================
local _lllIIlIlII = "rbxassetid://110139386841910"
local _lIIllIlllI = game:GetService("SoundService")
local _IIIlIllIIl = {queue = {}, _IIlIlIIIIl = 0, sequence = 0, cards = {}}
Panel.Notifications = _IIIlIllIIl

local _lllIlIlIlI = {
    _IlIlIIlIll = {_IlIlllIIlI = Color3.fromRGB(92, 154, 255), _IlIIlIlIlI = "i"},
    success = {_IlIlllIIlI = Color3.fromRGB(55, 210, 125), _IlIIlIlIlI = utf8.char(0x2713)},
    warning = {_IlIlllIIlI = Color3.fromRGB(255, 190, 70), _IlIIlIlIlI = "!"},
    error = {_IlIlllIIlI = Color3.fromRGB(245, 80, 95), _IlIIlIlIlI = utf8.char(0x00D7)},
}

local function _IlIIIIIlll()
    if Panel.Settings.uiSounds == false or Panel.Settings.notificationMusic == false then return end
    task.spawn(function()
        local _lllIllIllI, _lIlIIlIllI = pcall(function()
            local _llIlIIllll = Instance.new("Sound")
            _llIlIIllll.Name = "288PanelNotificationSound"
            _llIlIIllll.SoundId = _lllIIlIlII
            _llIlIIllll.Volume = math.clamp(tonumber(Panel.Settings.notificationVolume) or 0.8, 0, 1)
            _llIlIIllll.Looped = false
            _llIlIIllll.Parent = _lIIllIlllI
            return _llIlIIllll
        end)
        if not _lllIllIllI or not _lIlIIlIllI then return end
        local _IlIlllIlll
        _IlIlllIlll = _lIlIIlIllI.Ended:Connect(function()
            if _IlIlllIlll then _IlIlllIlll:Disconnect() end
            if _lIlIIlIllI and _lIlIIlIllI.Parent then _lIlIIlIllI:Destroy() end
        end)
        pcall(function() _lIlIIlIllI:Play() end)
        task.delay(12, function()
            if _lIlIIlIllI and _lIlIIlIllI.Parent then _lIlIIlIllI:Destroy() end
        end)
    end)
end

NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "288PanelNotifications"
NotificationGui.AutoLocalize = false
NotificationGui.ResetOnSpawn = false
NotificationGui.IgnoreGuiInset = true
NotificationGui.DisplayOrder = 1000000
NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotificationGui.Parent = _IlllIIlllI

local _IIIlIllIII = Instance.new("Frame")
_IIIlIllIII.Name = "NotificationStack"
_IIIlIllIII.AnchorPoint = Vector2.new(1, 1)
_IIIlIllIII.Position = UDim2.new(1, -18, 1, -18)
_IIIlIllIII.Size = UDim2.new(1, -24, 1, -44)
_IIIlIllIII.BackgroundTransparency = 1
_IIIlIllIII.BorderSizePixel = 0
_IIIlIllIII.ZIndex = 1000
_IIIlIllIII.Parent = NotificationGui

local _lIlIIIlIIl = Instance.new("UIListLayout")
_lIlIIIlIIl.FillDirection = Enum.FillDirection.Vertical
_lIlIIIlIIl.HorizontalAlignment = Enum.HorizontalAlignment.Right
_lIlIIIlIIl.VerticalAlignment = Enum.VerticalAlignment.Bottom
_lIlIIIlIIl.Padding = UDim.new(0, 9)
_lIlIIIlIIl.SortOrder = Enum.SortOrder.LayoutOrder
_lIlIIIlIIl.Parent = _IIIlIllIII

local function _IIllIlIlll()
    local _IllIIlIllI = workspace.CurrentCamera
    local _IIllIIlIlI = _IllIIlIllI and _IllIIlIllI.ViewportSize.X or 800
    return math.floor(math.clamp(_IIllIIlIlI - 20, 240, 270))
end

local function _lIlllIIlII(_IllIIIIlIl, _IlIlIIlIll, _lllllIIIII)
    if not _IllIIIIlIl or not _IllIIIIlIl.Parent then return false end
    local _IIllIIlIIl = _lllIllIlIl:Create(_IllIIIIlIl, _IlIlIIlIll, _lllllIIIII)
    _IIllIIlIIl:Play()
    _IIllIIlIIl.Completed:Wait()
    return _IllIIIIlIl.Parent ~= nil
end

function _IIIlIllIIl:_dismiss(_lIlIIIIlll, immediate)
    if not _lIlIIIIlll or _lIlIIIIlll:GetAttribute("288Closing") then return end
    _lIlIIIIlll:SetAttribute("288Closing", true)
    local _IlIlIlIllI = _lIlIIIIlll:GetAttribute("288ToastToken")
    if not immediate and _lIlIIIIlll.Parent then
        _lIlllIIlII(_lIlIIIIlll, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(_lIlIIIIlll.Size.X.Scale, _lIlIIIIlll.Size.X.Offset, 0, 64),
        })
        if _lIlIIIIlll.Parent then
            _lIlllIIlII(_lIlIIIIlll, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                GroupTransparency = 1,
                Size = UDim2.new(_lIlIIIIlll.Size.X.Scale, _lIlIIIIlll.Size.X.Offset, 0, 0),
            })
        end
    end
    if _lIlIIIIlll and _lIlIIIIlll.Parent then _lIlIIIIlll:Destroy() end
    if self.cards[_IlIlIlIllI] then
        self.cards[_IlIlIlIllI] = nil
        self.active = math.max(0, self.active - 1)
        task.defer(function() self:_process() end)
    end
end

function _IIIlIllIIl:_create(_IlIIllIIIl)
    self.sequence += 1
    local _IlIlIlIllI = self.sequence
    local _IlllIllIll = _IllllIIlII[_lIIlIIlllI] or _IllllIIlII.dark
    local _IIIlIIllII = tostring(_IlIIllIIIl.kind or "info"):lower()
    local _IIllllIIII = _lllIlIlIlI[_IIIlIIllII] or _lllIlIlIlI.info
    local _lIlIIlIIIl = _IIllIlIlll()
    local _lllIllllIl = _lIIlIIlllI == "light"
    local _IllIlIllIl = _IlllIllIll.surface2 or _IlllIllIll.btnHover or Color3.fromRGB(72, 80, 101)
    local _llIllllIII = _IlllIllIll.btnHover or _IlllIllIll.btn or _IllIlIllIl
    local _lIIlIIIIII = _IlllIllIll.text or Color3.fromRGB(245, 247, 252)
    local _IIIllllIII = _IlllIllIll.textDim or Color3.fromRGB(190, 198, 216)

    local _lIlIIIIlll = Instance.new("CanvasGroup")
    _lIlIIIIlll.Name = "PanelNotification"
    _lIlIIIIlll.Size = UDim2.fromOffset(_lIlIIlIIIl, 0)
    _lIlIIIIlll.BackgroundColor3 = _IllIlIllIl
    _lIlIIIIlll.BackgroundTransparency = 0
    _lIlIIIIlll.BorderSizePixel = 0
    _lIlIIIIlll.GroupTransparency = 1
    _lIlIIIIlll.ClipsDescendants = true
    _lIIlIlIllI(_lIlIIIIlll, "BackgroundColor3", "surface2")
    _lIlIIIIlll.LayoutOrder = _IlIlIlIllI
    _lIlIIIIlll.ZIndex = 1001
    _lIlIIIIlll:SetAttribute("288ToastToken", _IlIlIlIllI)
    _lIlIIIIlll:SetAttribute("288ToastTitle", tostring(_IlIIllIIIl.title or "288 Panel"))
    _lIlIIIIlll:SetAttribute("288ToastMessage", tostring(_IlIIllIIIl.message or ""))
    _lIlIIIIlll:SetAttribute("288ToastKind", _IIIlIIllII)
    _lIlIIIIlll.Parent = _IIIlIllIII
    self.cards[_IlIlIlIllI] = _lIlIIIIlll

    local _IlllIllIII = Instance.new("UICorner")
    _IlllIllIII.CornerRadius = UDim.new(0, 3)
    _IlllIllIII.Parent = _lIlIIIIlll

    local _lllllIIlIl = Instance.new("UIStroke")
    _lllllIIlIl.Color = _IlllIllIll.stroke or _IIllllIIII.color
    _lllllIIlIl.Transparency = 0.08
    _lllllIIlIl.Thickness = 2
    _lllllIIlIl.Parent = _lIlIIIIlll
    _lIIlIlIllI(_lllllIIlIl, "Color", "stroke")

    local _IlllllIlIl = Instance.new("UIGradient")
    _IlllllIlIl.Name = "ToastGradient"
    _IlllllIlIl:SetAttribute("PreserveThemeColor", false)
    _IlllllIlIl.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, _IllIlIllIl),
        ColorSequenceKeypoint.new(1, _llIllllIII),
    })
    _IlllllIlIl.Rotation = 12
    _IlllllIlIl.Enabled = false
    _IlllllIlIl.Parent = _lIlIIIIlll

    local _IlIlIIIlII = Instance.new("Frame")
    _IlIlIIIlII.Name = "IconBox"
    _IlIlIIIlII:SetAttribute("PreserveThemeColor", false)
    _IlIlIIIlII.Size = UDim2.fromOffset(54, 54)
    _IlIlIIIlII.BackgroundColor3 = _IIllllIIII.color
    _IlIlIIIlII.BackgroundTransparency = 0.08
    _IlIlIIIlII.BorderSizePixel = 0
    _IlIlIIIlII.ZIndex = 1002
    _IlIlIIIlII.Visible = false
    _IlIlIIIlII.Parent = _lIlIIIIlll

    local _lIllIllIll = Instance.new("UICorner")
    _lIllIllIll.CornerRadius = UDim.new(0, 13)
    _lIllIllIll.Parent = _IlIlIIIlII

    local _IlIIlIlIlI = Instance.new("TextLabel")
    _IlIIlIlIlI.Name = "TypeIcon"
    _IlIIlIlIlI.Size = UDim2.fromScale(1, 1)
    _IlIIlIlIlI.BackgroundTransparency = 1
    _IlIIlIlIlI.Text = _IIllllIIII.icon
    _IlIIlIlIlI.TextColor3 = Color3.fromRGB(255, 255, 255)
    _IlIIlIlIlI.TextSize = 22
    _IlIIlIlIlI.Font = Enum.Font.GothamBold
    _IlIIlIlIlI.AutoLocalize = false
    _IlIIlIlIlI.ZIndex = 1003
    _IlIIlIlIlI.Parent = _IlIlIIIlII

    local _lIIlllllIl = Instance.new("Frame")
    _lIIlllllIl.Name = "Content"
    _lIIlllllIl.Position = UDim2.fromOffset(10, 0)
    _lIIlllllIl.Size = UDim2.new(1, -18, 1, 0)
    _lIIlllllIl.BackgroundTransparency = 1
    _lIIlllllIl.ZIndex = 1002
    _lIIlllllIl.Parent = _lIlIIIIlll

    local _IIllIllIll = Instance.new("TextButton")
    _IIllIllIll.Name = "Close"
    _IIllIllIll.AnchorPoint = Vector2.new(1, 0)
    _IIllIllIll.Position = UDim2.new(1, -5, 0, 5)
    _IIllIllIll.Size = UDim2.fromOffset(28, 28)
    _IIllIllIll.BackgroundTransparency = 1
    _IIllIllIll.Text = utf8.char(0x00D7)
    _IIllIllIll.TextColor3 = _IIIllllIII
    _lIIlIlIllI(_IIllIllIll, "TextColor3", "textDim")
    _IIllIllIll.TextSize = 18
    _IIllIllIll.Font = Enum.Font.GothamMedium
    _IIllIllIll.AutoLocalize = false
    _IIllIllIll.ZIndex = 1004
    _IIllIllIll.Parent = _lIIlllllIl

    local _lIIllIllll = Instance.new("TextLabel")
    _lIIllIllll.Name = "Title"
    _lIIlIlIllI(_lIIllIllll, "TextColor3", "text")
    _lIIllIllll.Position = UDim2.fromOffset(0, 7)
    _lIIllIllll.Size = UDim2.new(1, -30, 0, 18)
    _lIIllIllll.BackgroundTransparency = 1
    _lIIllIllll.Text = tostring(_IlIIllIIIl.title or "288 Panel")
    _lIIllIllll.TextColor3 = _lIIlIIIIII
    _lIIllIllll.TextSize = 12
    _lIIllIllll.Font = Enum.Font.GothamBold
    _lIIllIllll.TextXAlignment = Enum.TextXAlignment.Left
    _lIIllIllll.TextTruncate = Enum.TextTruncate.AtEnd
    _lIIllIllll.AutoLocalize = false
    _lIIllIllll.ZIndex = 1003
    _lIIllIllll.Parent = _lIIlllllIl

    local _llIlIlllIl = Instance.new("TextLabel")
    _llIlIlllIl.Name = "Message"
    _lIIlIlIllI(_llIlIlllIl, "TextColor3", "textDim")
    _llIlIlllIl.Position = UDim2.fromOffset(0, 28)
    _llIlIlllIl.Size = UDim2.new(1, -4, 0, 18)
    _llIlIlllIl.BackgroundTransparency = 1
    _llIlIlllIl.Text = tostring(_IlIIllIIIl.message or "")
    _llIlIlllIl.TextColor3 = _IIIllllIII
    _llIlIlllIl.TextSize = 11
    _llIlIlllIl.Font = Enum.Font.Gotham
    _llIlIlllIl.TextWrapped = false
    _llIlIlllIl.TextTruncate = Enum.TextTruncate.AtEnd
    _llIlIlllIl.TextXAlignment = Enum.TextXAlignment.Left
    _llIlIlllIl.AutoLocalize = false
    _llIlIlllIl.ZIndex = 1003
    _llIlIlllIl.Parent = _lIIlllllIl

    local _llIIIlIIII = Instance.new("Frame")
    _llIIIlIIII.Name = "ProgressTrack"
    _llIIIlIIII.AnchorPoint = Vector2.new(0, 1)
    _llIIIlIIII.Position = UDim2.new(0, 3, 1, -2)
    _llIIIlIIII.Size = UDim2.new(1, -6, 0, 3)
    _llIIIlIIII.BackgroundColor3 = _IlllIllIll.stroke or Color3.fromRGB(45, 52, 68)
    _lIIlIlIllI(_llIIIlIIII, "BackgroundColor3", "stroke")
    _llIIIlIIII.BackgroundTransparency = 0.65
    _llIIIlIIII.BorderSizePixel = 0
    _llIIIlIIII.ZIndex = 1002
    _llIIIlIIII.Parent = _lIlIIIIlll
    Instance.new("UICorner", _llIIIlIIII).CornerRadius = UDim.new(1, 0)

    local _lIlllllIlI = Instance.new("Frame")
    _lIlllllIlI.Name = "DurationBar"
    _lIlllllIlI.Size = UDim2.fromScale(1, 1)
    _lIlllllIlI.BackgroundColor3 = _IlllIllIll.accent or _IIllllIIII.color
    _lIIlIlIllI(_lIlllllIlI, "BackgroundColor3", "accent")
    _lIlllllIlI.BorderSizePixel = 0
    _lIlllllIlI.ZIndex = 1003
    _lIlllllIlI.Parent = _llIIIlIIII
    Instance.new("UICorner", _lIlllllIlI).CornerRadius = UDim.new(1, 0)

    _IIllIllIll.MouseButton1Click:Connect(function()
        task.spawn(function() self:_dismiss(_lIlIIIIlll, false) end)
    end)

    _IlIIIIIlll()
    _lIlllIIlII(_lIlIIIIlll, TweenInfo.new(0.20, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(_lIlIIlIIIl, 64),
        GroupTransparency = 0,
    })
    if not _lIlIIIIlll.Parent or _lIlIIIIlll:GetAttribute("288Closing") then return end
    _lIlllIIlII(_lIlIIIIlll, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(_lIlIIlIIIl, 64),
    })
    if not _lIlIIIIlll.Parent or _lIlIIIIlll:GetAttribute("288Closing") then return end

    local _llllIllIIl = math.clamp(tonumber(_IlIIllIIIl.duration) or 4, 1.5, 15)
    local _IIIIIIIlII = _lllIllIlIl:Create(_lIlllllIlI, TweenInfo.new(_llllIllIIl, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0),
    })
    _IIIIIIIlII:Play()
    task.delay(_llllIllIIl, function()
        if _lIlIIIIlll and _lIlIIIIlll.Parent and not _lIlIIIIlll:GetAttribute("288Closing") then
            self:_dismiss(_lIlIIIIlll, false)
        end
    end)
end

function _IIIlIllIIl:_process()
    local _IIIllIIlIl = math.clamp(tonumber(Panel.Settings.notificationLimit) or 3, 1, 5)
    while self.active < _IIIllIIlIl and #self.queue > 0 do
        local _IlIIllIIIl = table.remove(self.queue, 1)
        self.active += 1
        task.spawn(function()
            local _lllIllIllI, _lIIIIlllII = pcall(function() self:_create(_IlIIllIIIl) end)
            if not _lllIllIllI then
                self.active = math.max(0, self.active - 1)
                _lIlIllIlIl("error", "NOTIFY", tostring(_lIIIIlllII))
                task.defer(function() self:_process() end)
            end
        end)
    end
end

function _IIIlIllIIl:Show(_llIIlllIll, _IlIIlIIIlI, _llIIIlIlll, _lIlIlIllIl)
    _llIIlllIll = tostring(_llIIlllIll or "288 Panel")
    _IlIIlIIIlI = tostring(_IlIIlIIIlI or "")
    _llIIIlIlll = tostring(_llIIIlIlll or "info"):lower()
    if not _lllIlIlIlI[_llIIIlIlll] then _llIIIlIlll = "info" end
    _lIlIllIlIl(_llIIIlIlll == "error" and "error" or "info", "NOTIFY", _llIIlllIll .. " | " .. _IlIIlIIIlI)

    if not NotificationGui or not NotificationGui.Parent then
        pcall(function()
            _IllIlIlllI:SetCore("SendNotification", {Title = _llIIlllIll, Text = _IlIIlIIIlI, Duration = tonumber(_lIlIlIllIl) or 4})
        end)
        return
    end

    -- Evita tempestades de notificacoes identicas disparadas por eventos repetidos.
    for _llIIIIIIII, _lIlIIIIlll in pairs(self.cards) do
        if _lIlIIIIlll and _lIlIIIIlll.Parent
            and _lIlIIIIlll:GetAttribute("288ToastTitle") == _llIIlllIll
            and _lIlIIIIlll:GetAttribute("288ToastMessage") == _IlIIlIIIlI
            and _lIlIIIIlll:GetAttribute("288ToastKind") == _llIIIlIlll then
            return
        end
    end
    for _llIIIIIIII, queued in ipairs(self.queue) do
        if queued.title == _llIIlllIll and queued.message == _IlIIlIIIlI and queued.kind == _llIIIlIlll then return end
    end
    if #self.queue >= 20 then table.remove(self.queue, 1) end
    table.insert(self.queue, {_llIIlllIll = _llIIlllIll, _IlIIlIIIlI = _IlIIlIIIlI, _llIIIlIlll = _llIIIlIlll, _lIlIlIllIl = _lIlIlIllIl})
    local _lllIllIllI, _lIIIIlllII = pcall(function() self:_process() end)
    if not _lllIllIllI then
        _lIlIllIlIl("error", "NOTIFY", tostring(_lIIIIlllII))
        pcall(function()
            _IllIlIlllI:SetCore("SendNotification", {Title = _llIIlllIll, Text = _IlIIlIIIlI, Duration = tonumber(_lIlIlIllIl) or 4})
        end)
    end
end

function _IIIlIllIIl:Clear()
    table.clear(self.queue)
    for _llIIIIIIII, _lIlIIIIlll in pairs(self.cards) do
        task.spawn(function() self:_dismiss(_lIlIIIIlll, true) end)
    end
end

notifyPanel = function(_llIIlllIll, _IlIIlIIIlI, _llIIIlIlll, _lIlIlIllIl)
    return _IIIlIllIIl:Show(_llIIlllIll, _IlIIlIIIlI, _llIIIlIlll, _lIlIlIllIl)
end
reconstructedModules = {}
reconstructedConfig = {
    AnimSpeed = { _IlIllIlIlI = {"Q", "E"}, passive = true },
    AntiVoid = { _IlIllIlIlI = {"J"}, passive = true },
    ClickTP = { _IlIllIlIlI = {}, passive = true },
    FaceBang = { _IlIllIlIlI = {"Z"}, passive = true },
    feFlip = { _IlIllIlIlI = {"X", "C"}, passive = true },
    Flashback = { _IlIllIlIlI = {"V"}, passive = true },
    Impulse = { _IlIllIlIlI = {"M"}, passive = true },
    Invisible = { _IlIllIlIlI = {"K"}, passive = true },
    JerkOff = { _IlIllIlIlI = {"R"}, passive = true },
    NoClip = { _IlIllIlIlI = {"N"}, passive = true },
    Spin = { _IlIllIlIlI = {"T"}, passive = true },
    Aimbot = { _IlIllIlIlI = {"F"} },
    ESP = { _IlIllIlIlI = {"E"} },
}

function initializeReconstructedModule(_IlIlIlllll, initializer)
    if _IlIlIlllll == "ClickTP" then
        local _lIlIlllIII = reconstructedModules.ClickTP
        local _IllIIIlllI = (getgenv and getgenv()) or _IlIIIlllIl
        if _lIlIlllIII and _lIlIlllIII.active then
            if _IllIIIlllI.TeleportConnection then
                pcall(function() _IllIIIlllI.TeleportConnection:Disconnect() end)
                _IllIIIlllI.TeleportConnection = nil
            end
            _lIlIlllIII.active = false
            return true
        end
        local _llIIlIIIII = Panel.Settings.keybinds and Panel.Settings.keybinds.ClickTP or "LeftControl"
        local _lllIllIllI, _lIIIIlllII = pcall(initializer, _IlllllllII, _IIIIllIllI, function(_llIIlllIll, _IlIIlIIIlI, _lIlIlIllIl)
            notifyPanel(tostring(_llIIlllIll), tostring(_IlIIlIIIlI), "info", tonumber(_lIlIlIllIl) or 4)
        end, _llIIlIIIII)
        if _lllIllIllI then reconstructedModules.ClickTP = { callbacks = {}, _IIlIlIIIIl = true } end
        return _lllIllIllI, _lIIIIlllII
    end

    local _IlIIlIIlll = reconstructedConfig[_IlIlIlllll]
    if not _IlIIlIIlll then
        return pcall(initializer)
    end

    local _lIlIlllIII = reconstructedModules[_IlIlIlllll]
    if _lIlIlllIII then
        if not _IlIIlIIlll.passive and _lIlIlllIII.primary then _lIlIlllIII.primary() end
        return true
    end

    _lIlIlllIII = { callbacks = {} }
    reconstructedModules[_IlIlIlllll] = _lIlIlllIII
    local function _IIIlllIlll(_llIIlllIll, _IlIIlIIIlI, _lIlIlIllIl)
        notifyPanel(tostring(_llIIlllIll), tostring(_IlIIlIIIlI), "info", tonumber(_lIlIlIllIl) or 4)
    end
    local function _llllIllIII(_IlIIIIlIIl)
        if type(_IlIIIIlIIl) == "function" then
            table.insert(_lIlIlllIII.callbacks, _IlIIIIlIIl)
            _lIlIlllIII.primary = _lIlIlllIII.primary or _IlIIIIlIIl
        end
        return nil
    end
    local _IlIllIlIlI = table.clone(_IlIIlIIlll.keys or {})
    local _IlllIIllll = Panel.Settings.keybinds or {}
    local _IIllIIIIlI = {AnimSpeed="AnimSpeed", AntiVoid="AntiVoid", ClickTP="ClickTP", FaceBang="FaceBang", feFlip="feFlip", Flashback="Flashback", Impulse="Impulse", Invisible="Invisible", JerkOff="JerkOff", NoClip="NoClip", Spin="Spin", Aimbot="Aimbot", ESP="ESP"}
    local _IlIIlIIIll = _IlllIIllll[_IIllIIIIlI[_IlIlIlllll] or _IlIlIlllll]
    if _IlIIlIIIll and _IlIIlIIIll ~= "" then _IlIllIlIlI[1] = _IlIIlIIIll end
    if _IlIlIlllll == "AnimSpeed" and _IlllIIllll.AnimSpeed2 then _IlIllIlIlI[2] = _IlllIIllll.AnimSpeed2 end
    if _IlIlIlllll == "feFlip" and _IlllIIllll.feFlip2 then _IlIllIlIlI[2] = _IlllIIllll.feFlip2 end
    local _lllIllIllI, _lIIIIlllII
    if _IlIlIlllll == "ClickTP" then
        _lllIllIllI, _lIIIIlllII = pcall(initializer, _IlllllllII, _IIIIllIllI, _IIIlllIlll, _IlIllIlIlI[1] or "LeftControl")
    elseif _IlIlIlllll == "AnimSpeed" then
        _lllIllIllI, _lIIIIlllII = pcall(initializer, _IlllllllII, _IllIllIIII, _IIIIllIllI, _IIIlllIlll, _llllIllIII, _IlIllIlIlI[1], _IlIllIlIlI[2], 0, 0)
    elseif _IlIlIlllll == "Flashback" then
        _lllIllIllI, _lIIIIlllII = pcall(initializer, _IlllllllII, _IllIllIIII, _IIIIllIllI, _IIIlllIlll, _llllIllIII, _IlIllIlIlI[1], 0, 0)
    elseif _IlIlIlllll == "Aimbot" or _IlIlIlllll == "ESP" then
        _lllIllIllI, _lIIIIlllII = pcall(initializer, _IlllllllII, _IllIllIIII, _IIIIllIllI, _IIIlllIlll, _llllIllIII, _IlIllIlIlI[1], 0, 0)
    elseif _IlIlIlllll == "feFlip" then
        _lllIllIllI, _lIIIIlllII = pcall(initializer, _IlllllllII, _IIIlllIlll, _llllIllIII, _IlIllIlIlI[1], _IlIllIlIlI[2], 0, 0)
    elseif _IlIlIlllll == "AntiVoid" then
        _lllIllIllI, _lIIIIlllII = pcall(initializer, _IlllllllII, _IllIllIIII, _IIIIllIllI, _IIIlllIlll, _llllIllIII, _IlIllIlIlI[1] or "J", 0, 0)
    elseif _IlIlIlllll == "Invisible" or _IlIlIlllll == "NoClip" then
        _lllIllIllI, _lIIIIlllII = pcall(initializer, _IlllllllII, _IllIllIIII, _IIIIllIllI, _IIIlllIlll, _llllIllIII, _IlIllIlIlI[1], 0, 0)
    else
        _lllIllIllI, _lIIIIlllII = pcall(initializer, _IlllllllII, _IIIIllIllI, _IIIlllIlll, _llllIllIII, _IlIllIlIlI[1], 0, 0)
    end
    if not _lllIllIllI then
        reconstructedModules[_IlIlIlllll] = nil
        return false, tostring(_lIIIIlllII)
    end
    if _IlIIlIIlll.activateOnInit and _lIlIlllIII.primary then _lIlIlllIII.primary() end
    return true
end

function executeModuleSource(_IIlllIIIIl, _IIIIlIIIll)
    local _IlIlIlllll = tostring(_IIIIlIIIll or "")
    if type(_IIlllIIIIl) ~= "string" or _IIlllIIIIl == "" then return false, "fonte vazia" end
    _IIlllIIIIl = _IIlllIIIIl:gsub("^\239\187\191", "")
    local _IllIIIIIll = _IIlllIIIIl:match("^%s*(.-)%s*$") or _IIlllIIIIl
    if _IllIIIIIll:sub(1, 1) == "<" or _IllIIIIIll:match('^%{"error"') then
        return false, "resposta remota nao contem Lua"
    end

    _IlIIIlllIl.__288ModuleNotify = function(_llIIlllIll, _IlIIlIIIlI, _lIlIlIllIl)
        notifyPanel(tostring(_llIIlllIll), tostring(_IlIIlIIIlI), "info", tonumber(_lIlIlIllIl) or 5)
    end

    local _IIlllIllIl = loadstring
    if type(_IIlllIllIl) ~= "function" then
        local _lllIllIllI, _lIIllIIlII = pcall(function() return _IlIIIlllIl.loadstring or _IlIIIlllIl.load end)
        if _lllIllIllI and type(_lIIllIIlII) == "function" then _IIlllIllIl = _lIIllIIlII end
    end
    if type(_IIlllIllIl) ~= "function" then return false, "compile: loadstring indisponÃ­vel neste ambiente" end
    local _lIIIIIIIIl, _IIIlllIlII = _IIlllIllIl(_IIlllIIIIl)
    if not _lIIIIIIIIl then return false, "compile: " .. tostring(_IIIlllIlII) end
    local _lIlIlIlllI, _lllIlIIlII = pcall(_lIIIIIIIIl)
    if not _lIlIlIlllI then return false, "runtime: " .. tostring(_lllIlIIlII) end
    if type(_lllIlIIlII) == "function" then
        local _IlIlIlIIII, _IllIIllIlI = initializeReconstructedModule(tostring(_IIIIlIIIll), _lllIlIIlII)
        if not _IlIlIlIIII then return false, "initialize: " .. tostring(_IllIIllIlI) end
    end
    return true
end

function executeRemoteScript(_lllIIlllII, _lIllllIIIl)
    local _IIlllIIIIl = fetchModuleSource(_lllIIlllII)
    if not _IIlllIIIIl then
        warn("[288] fetch error [" .. tostring(_lIllllIIIl) .. "]: " .. tostring(_lllIIlllII))
        _lIIIIllIIl("module-fetch", "Falha ao baixar mÃ³dulo", tostring(_lIllllIIIl) .. " | " .. tostring(_lllIIlllII))
        return false
    end
    local _lllIllIllI, _lIIIIlllII = executeModuleSource(_IIlllIIIIl, _lIllllIIIl)
    if not _lllIllIllI then
        warn("[288] module error [" .. tostring(_lIllllIIIl) .. "]: " .. tostring(_lIIIIlllII))
        _lIIIIllIIl("module-execute", "Falha ao compilar/executar mÃ³dulo", tostring(_lIllllIIIl) .. " | " .. tostring(_lIIIIlllII))
    end
    return _lllIllIllI
end

function normalizeModuleName(_lIlIlIIllI)
    local _IlIlIlllll = tostring(_lIlIlIIllI):match("([^/]+)$") or tostring(_lIlIlIIllI)
    _IlIlIlllll = _IlIlIlllll:gsub("%.lua$", "")
    _IlIlIlllll = _IlIlIlllll:gsub("Off$", "")

    if _IlIlIlllll == "AnimeSpeed" then
        return "AnimSpeed"
    elseif _IlIlIlllll == "Jerk" then
        return "JerkOff"
    end

    return _IlIlIlllll
end

function runEmbeddedESP()
    local _IllllllIll = "__288EmbeddedESP"
    if _IlIIIlllIl[_IllllllIll] then
        _IlIIIlllIl[_IllllllIll].connection:Disconnect()
        _IlIIIlllIl[_IllllllIll].added:Disconnect()
        _IlIIIlllIl[_IllllllIll].removing:Disconnect()
        for _llIIIIIIII, _IIIIllllIl in pairs(_IlIIIlllIl[_IllllllIll].visuals) do
            for _llIIIIIIII, drawing in pairs(_IIIIllllIl) do pcall(function() drawing:Remove() end) end
        end
        _IlIIIlllIl[_IllllllIll] = nil
        return true
    end
    if not Drawing or type(Drawing.new) ~= "function" then
        warn("[288 ESP] Drawing API is unavailable in this executor.")
        return false
    end

    local _llIlIIlIlI = {visuals = {}}
    local _lllIIlIIII, _IlIllIlIII = 500, 300
    local function _llIIlIllIl(_lIlIIlIIIl)
        local _IllIIIIlIl = Drawing.new("Line")
        _IllIIIIlIl.Visible, _IllIIIIlIl.Thickness = false, _lIlIIlIIIl or 1
        return _IllIIIIlIl
    end
    local function _llIlllIIII(_IIIIIlIIII)
        local _IllIIIIlIl = Drawing.new("Text")
        _IllIIIIlIl.Visible, _IllIIIIlIl.Center, _IllIIIIlIl.Outline = false, true, true
        _IllIIIIlIl.Size, _IllIIIIlIl.Font = _IIIIIlIIII or 12, 2
        return _IllIIIIlIl
    end
    local function _lIIIlIlIll(_IIllIlIlII)
        if _IIllIlIlII == _IlllllllII or _llIlIIlIlI.visuals[_IIllIlIlII] then return end
        _llIlIIlIlI.visuals[_IIllIlIlII] = {
            _lIllIlIIlI=_llIIlIllIl(2), _IlIIIIlIll=_llIIlIllIl(2), _IllIllllIl=_llIIlIllIl(2), _IllIIIIIlI=_llIIlIllIl(2),
            hpBack=_llIIlIllIl(4), hp=_llIIlIllIl(2), _IlIlIlllll=_llIlllIIII(13), _IlIlIIlIll=_llIlllIIII(12),
        }
    end
    local function _IlllIlIllI(_IIllIlIlII)
        local _IIIIllllIl = _llIlIIlIlI.visuals[_IIllIlIlII]
        if not _IIIIllllIl then return end
        for _llIIIIIIII, drawing in pairs(_IIIIllllIl) do pcall(function() drawing:Remove() end) end
        _llIlIIlIlI.visuals[_IIllIlIlII] = nil
    end
    local function _lIllllIllI(_IIIIllllIl)
        for _llIIIIIIII, drawing in pairs(_IIIIllllIl) do drawing.Visible = false end
    end
    local function _IlIlllIIll(_IIllIlIlII)
        if _IlllllllII.Team and _IIllIlIlII.Team then
            return _IIllIlIlII.Team == _IlllllllII.Team and Color3.fromRGB(70,225,120) or Color3.fromRGB(255,70,90)
        end
        return Color3.fromRGB(255,195,70)
    end

    for _llIIIIIIII, _IIllIlIlII in ipairs(_lllIIIlIlI:GetPlayers()) do _lIIIlIlIll(_IIllIlIlII) end
    _llIlIIlIlI.added = _lllIIIlIlI.PlayerAdded:Connect(_lIIIlIlIll)
    _llIlIIlIlI.removing = _lllIIIlIlI.PlayerRemoving:Connect(_IlllIlIllI)
    _llIlIIlIlI.connection = _IllIllIIII.RenderStepped:Connect(function()
        local _IllIIlIllI = workspace.CurrentCamera
        local _llllIIlIII = _IlllllllII.Character and _IlllllllII.Character:FindFirstChild("HumanoidRootPart")
        if not _IllIIlIllI then return end
        local _lIlllIIIII = {}
        for _IIllIlIlII, _IIIIllllIl in pairs(_llIlIIlIlI.visuals) do
            _lIllllIllI(_IIIIllllIl)
            local _IIIllIllII = _IIllIlIlII.Character
            local _lIIIIIIIII = _IIIllIllII and _IIIllIllII:FindFirstChildOfClass("Humanoid")
            local _lIllIlIIII = _IIIllIllII and _IIIllIllII:FindFirstChild("HumanoidRootPart")
            local _IIIIlIlIIl = _IIIllIllII and _IIIllIllII:FindFirstChild("Head")
            if not _lIIIIIIIII or _lIIIIIIIII.Health <= 0 or not _lIllIlIIII or not _IIIIlIlIIl then continue end
            local _llllllIIIl = _llllIIlIII and (_llllIIlIII.Position-_lIllIlIIII.Position).Magnitude or math.huge
            if _llllllIIIl <= _lllIIlIIII then
                table.insert(_lIlllIIIII, {_IIllIlIlII=_IIllIlIlII, _IIIIllllIl=_IIIIllllIl, _lIIIIIIIII=_lIIIIIIIII, _lIllIlIIII=_lIllIlIIII, _IIIIlIlIIl=_IIIIlIlIIl, _llllllIIIl=_llllllIIIl})
            end
        end
        table.sort(_lIlllIIIII, function(_llIlIIIIlI, b) return _llIlIIIIlI.distance < b.distance end)
        for _lllllIlIIl = 1, #_lIlllIIIII do
            local _IlIIllIIIl = _lIlllIIIII[_lllllIlIIl]
            local _IIllIlIlII, _IIIIllllIl = _IlIIllIIIl.player, _IlIIllIIIl.visual
            local _lIIIIIIIII, _lIllIlIIII, _IIIIlIlIIl, _llllllIIIl = _IlIIllIIIl.humanoid, _IlIIllIIIl.root, _IlIIllIIIl.head, _IlIIllIIIl.distance
            local _IIllIIIIIl, _IIIIllIIll = _IllIIlIllI:WorldToViewportPoint(_lIllIlIIII.Position)
            local _lIllIlIIlI = _IllIIlIllI:WorldToViewportPoint(_IIIIlIlIIl.Position + Vector3.new(0, .75, 0))
            local _IlIIIIlIll = _IllIIlIllI:WorldToViewportPoint(_lIllIlIIII.Position - Vector3.new(0, 3, 0))
            if not _IIIIllIIll or _IIllIIIIIl.Z <= 0 then _lIllllIllI(_IIIIllllIl) continue end
            local _IIlIIIIlll = math.max(18, math.abs(_IlIIIIlIll.Y-_lIllIlIIlI.Y))
            local _lIlIIlIIIl, _IllIllllIl, _IllIIIIIlI = _IIlIIIIlll*.52, _IIllIIIIIl.X-_IIlIIIIlll*.26, _IIllIIIIIl.X+_IIlIIIIlll*.26
            local _IlIlllIIlI, _lllllIllII = _IlIlllIIll(_IIllIlIlII), math.clamp(_lIIIIIIIII.Health/math.max(_lIIIIIIIII.MaxHealth,1),0,1)
            _IIIIllllIl.top.From,_IIIIllllIl.top.To=Vector2.new(_IllIllllIl,_lIllIlIIlI.Y),Vector2.new(_IllIIIIIlI,_lIllIlIIlI.Y)
            _IIIIllllIl.bottom.From,_IIIIllllIl.bottom.To=Vector2.new(_IllIllllIl,_IlIIIIlIll.Y),Vector2.new(_IllIIIIIlI,_IlIIIIlIll.Y)
            _IIIIllllIl.left.From,_IIIIllllIl.left.To=Vector2.new(_IllIllllIl,_lIllIlIIlI.Y),Vector2.new(_IllIllllIl,_IlIIIIlIll.Y)
            _IIIIllllIl.right.From,_IIIIllllIl.right.To=Vector2.new(_IllIIIIIlI,_lIllIlIIlI.Y),Vector2.new(_IllIIIIIlI,_IlIIIIlIll.Y)
            for _llIIIIIIII, boxLine in ipairs({_IIIIllllIl.top,_IIIIllllIl.bottom,_IIIIllllIl.left,_IIIIllllIl.right}) do boxLine.Color,boxLine.Visible=_IlIlllIIlI,true end
            _IIIIllllIl.hpBack.From,_IIIIllllIl.hpBack.To=Vector2.new(_IllIllllIl-6,_lIllIlIIlI.Y),Vector2.new(_IllIllllIl-6,_IlIIIIlIll.Y)
            _IIIIllllIl.hpBack.Color,_IIIIllllIl.hpBack.Visible=Color3.fromRGB(35,35,40),true
            _IIIIllllIl.hp.From,_IIIIllllIl.hp.To=Vector2.new(_IllIllllIl-6,_IlIIIIlIll.Y),Vector2.new(_IllIllllIl-6,_IlIIIIlIll.Y-_IIlIIIIlll*_lllllIllII)
            _IIIIllllIl.hp.Color,_IIIIllllIl.hp.Visible=Color3.fromHSV(_lllllIllII*.33,.9,1),true
            _IIIIllllIl.name.Text,_IIIIllllIl.name.Position,_IIIIllllIl.name.Color=_IIllIlIlII.DisplayName,Vector2.new(_IIllIIIIIl.X,_lIllIlIIlI.Y-17),_IlIlllIIlI
            _IIIIllllIl.name.Visible=true
            _IIIIllllIl.info.Text=string.format("%d HP | %d studs",math.floor(_lIIIIIIIII.Health+.5),math.floor(_llllllIIIl+.5))
            _IIIIllllIl.info.Position,_IIIIllllIl.info.Color=Vector2.new(_IIllIIIIIl.X,_IlIIIIlIll.Y+3),Color3.new(1,1,1)
            _IIIIllllIl.info.Visible=_llllllIIIl <= _IlIllIlIII
        end
    end)
    _IlIIIlllIl[_IllllllIll] = _llIlIIlIlI
    return true
end

function loadModuleUnsafe(_lIlIlIIllI)
    local _IlIlIlllll = normalizeModuleName(_lIlIlIIllI)
    local _llIllllIlI = MORE_MODULE_URLS[_IlIlIlllll]

    if USE_LOCAL_SPECIAL_MODULES and type(readfile) == "function" then
        local _llllIlIIlI = tostring(_lIlIlIIllI):gsub("^/+", "")
        local _llllIIIlII = {_llllIlIIlI, _llllIlIIlI:gsub("%.lua$", "")}
        if not _llllIlIIlI:match("%.lua$") then table.insert(_llllIIIlII, _llllIlIIlI .. ".lua") end
        local _lllIlIIIII = {}
        for _llIIIIIIII, localPath in ipairs(_llllIIIlII) do
            if not _lllIlIIIII[localPath] then
                _lllIlIIIII[localPath] = true
                local _lIIIlllIlI, _IIlllIIIIl = pcall(readfile, localPath)
                if _lIIIlllIlI and type(_IIlllIIIIl) == "string" and _IIlllIIIIl ~= "" then
                    local _lIlIlIlllI, _IlIlIIlllI = executeModuleSource(_IIlllIIIIl, normalizeModuleName(localPath))
                    if _lIlIlIlllI then return true end
                    warn("[288] local module failed [" .. localPath .. "]: " .. tostring(_IlIlIIlllI))
                end
            end
        end
    end

    -- Emphasis/More: try API first, then GitHub raw. This avoids a stale/broken
    -- API copy preventing the corrected repository module from loading.
    if _llIllllIlI then
        local _IIlIlIllII = tostring(_lIlIlIIllI):gsub("^/+", ""):gsub("%.lua$", "")
        if executeRemoteScript(_IllIlIlIlI .. "/api/module/" .. _IIlIlIllII, _IlIlIlllll) then
            return true
        end
        return executeRemoteScript(_llIllllIlI, _IlIlIlllll)
    end

    -- Os arquivos do repositÃ³rio nÃ£o possuem extensÃ£o: usa o caminho exatamente como recebido.
    local _llllIlIIlI = tostring(_lIlIlIIllI):gsub("^/+", "")
    local _llIlIIlIII = _llllIlIIlI:gsub("%.lua$", "")
    -- A API usa arquivos sem extensao. Tenta primeiro o caminho correto para
    -- evitar requisicoes 404/403 extras; GitHub fica somente como fallback.
    local _lIlllIIIII = {
        _IllIlIlIlI .. "/api/module/" .. _llIlIIlIII,
        _llllIlIIll .. "/" .. _llIlIIlIII,
    }

    local _lIIlIIllIl = {}
    for _llIIIIIIII, _lllIIlllII in ipairs(_lIlllIIIII) do
        if not _lIIlIIllIl[_lllIIlllII] then
            _lIIlIIllIl[_lllIIlllII] = true

            local _IlIlIIlIlI = nil
            local _lIIIIIllII = _lllIIlllII:sub(1, #_IllIlIlIlI) == _IllIlIlIlI and 2 or 1
            for _IlIllllIll = 1, _lIIIIIllII do
                local _IIlllIIIIl = fetchModuleSource(_lllIIlllII)
                if _IIlllIIIIl then
                    local _lIlIlIlllI, _IlIlIIlllI = executeModuleSource(_IIlllIIIIl, _IlIlIlllll)
                    if _lIlIlIlllI then return true end
                    _IlIlIIlIlI = _IlIlIIlllI
                else
                    _IlIlIIlIlI = "download vazio"
                end
                if _IlIllllIll < _lIIIIIllII then task.wait(0.25 * _IlIllllIll) end
            end
            warn("[288] candidate failed [" .. tostring(_lllIIlllII) .. "]: " .. tostring(_IlIlIIlIlI))
        end
    end

    warn("[288] module not found: " .. tostring(_lIlIlIIllI))
    return false
end

crashGuardSeconds = {
    PianoAuto = 0.75,
    Bring = 0.75,
    Respawn = 1.0,
}
crashGuardLastUse = {}
crashGuardRunning = {}

function loadModule(_lIlIlIIllI)
    local _llllIlIIlI=tostring(_lIlIlIIllI or ""):gsub("\\", "/"):gsub("^/+", ""):lower()
    if _llllIlIIlI:match("^modules/vip/") and not _IllIlIIlIl then return false end
    local _IlIlIlllll=normalizeModuleName(_lIlIlIIllI) local _lIlIlllIII=Panel.Runtime.modules[_IlIlIlllll] or {_IlIlIlllll=_IlIlIlllll,_lIlIlIIllI=tostring(_lIlIlIIllI),_lllIIlllIl="OFF",loads=0} Panel.Runtime.modules[_IlIlIlllll]=_lIlIlllIII
    local _lIllllllIl=crashGuardSeconds[_IlIlIlllll] if _lIllllllIl then local _IIlIlIllIl=os.clock() if crashGuardRunning[_IlIlIlllll] or _IIlIlIllIl-(crashGuardLastUse[_IlIlIlllll] or -math.huge)<_lIllllllIl then _lIlIlllIII.status="COOLDOWN" _lIlIllIlIl("warning","MODULE",_IlIlIlllll.." blocked by crash guard") return false end crashGuardRunning[_IlIlIlllll]=true end
    _lIlIlllIII.status="LOADING" _lIlIlllIII.lastAttempt=os.clock() _lIlIllIlIl("info","MODULE","Loading "..name) local _lllIllIllI,_lllIlIIlII=pcall(loadModuleUnsafe,_lIlIlIIllI) if _lIllllllIl then crashGuardRunning[_IlIlIlllll]=nil crashGuardLastUse[_IlIlIlllll]=os.clock() end
    if not _lllIllIllI or _lllIlIIlII==false then _lIlIlllIII.status="ERROR" _lIlIlllIII.error=tostring(_lllIllIllI and "module returned false" or _lllIlIIlII) _lIlIlllIII.lastErrorAt=os.clock() warn("[288] module loader error ["..tostring(_IlIlIlllll).."]: "..runtime.error) _lIlIllIlIl("error","MODULE",_IlIlIlllll.." | "..runtime.error) _lIIIIllIIl("module-loader","Erro no carregador",tostring(_IlIlIlllll).." | "..runtime.error) return false end
    _lIlIlllIII.status="ON" _lIlIlllIII.error=nil _lIlIlllIII.loadedAt=os.clock() _lIlIlllIII.loads=(_lIlIlllIII.loads or 0)+1 _lIlIllIlIl("success","MODULE",_IlIlIlllll.." loaded") return _lllIlIIlII
end
_IlIIIlllIl.__288LoadModule = loadModule
function runPanelModule(_IlIlIlllll)
    return loadModule("modules/More/" .. tostring(_IlIlIlllll))
end

-- Modulos sao carregados sob demanda para nao disputar o limite HTTP do jogo.
commonModulePreloadRemaining = 0

-- ==================== LOADING UI ====================
MainFrame = nil
FloatingToggle = nil
loadingFinished = false
loadingFinishing = false
loadingLogoReady = false
loadingStartedAt = os.clock()

LoadingRoot = Instance.new("Frame")
LoadingRoot.Name = "LoadingScreen"
LoadingRoot.Size = UDim2.new(1, 0, 1, 0)
LoadingRoot.BackgroundTransparency = 1
LoadingRoot.BorderSizePixel = 0
LoadingRoot.ZIndex = 200
LoadingRoot.Parent = _lIlllIlIlI

-- Musica exclusiva do loading. Toca enquanto os assets/modulos sao preparados
-- e e interrompida assim que o loading termina, antes do menu principal abrir.
local _lIllIIIIll = "rbxassetid://123103100146834"
loadingSound = Instance.new("Sound")
loadingSound.Name = "288PanelLoadingSound"
loadingSound.SoundId = _lIllIIIIll
loadingSound.Volume = math.clamp(tonumber(Panel.Settings.loadingVolume) or 0.12, 0, 1)
loadingSound.Looped = true
loadingSound.Parent = game:GetService("SoundService")

task.spawn(function()
    pcall(function()
        game:GetService("ContentProvider"):PreloadAsync({loadingSound})
    end)
    if Panel.Settings.loadingMusic~=false and LoadingRoot and LoadingRoot.Parent and not loadingFinished then pcall(function() loadingSound:Play() end) end
end)

LoadingCard = Instance.new("CanvasGroup")
LoadingCard.Name = "LoadingCard"
LoadingCard.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingCard.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadingCard.Size = UDim2.new(0, 390, 0, 226)
LoadingCard.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
LoadingCard.BorderSizePixel = 0
LoadingCard.ZIndex = 201
LoadingCard.Parent = LoadingRoot
Instance.new("UICorner", LoadingCard).CornerRadius = UDim.new(0, 20)
loadingStroke = Instance.new("UIStroke")
loadingStroke.Color = _lIIlIlIlIl
loadingStroke.Transparency = 0.32
loadingStroke.Thickness = 1.2
loadingStroke.Parent = LoadingCard

loadingIcon = Instance.new("ImageLabel")
loadingIcon.Name = "PanelLogo"
loadingIcon.Size = UDim2.new(0, 40, 0, 40)
loadingIcon.Position = UDim2.new(0, 22, 0, 20)
loadingIcon.BackgroundColor3 = _lIIlIIlIlI
loadingIcon.BorderSizePixel = 0
loadingIcon.ScaleType = Enum.ScaleType.Fit
loadingIcon.ZIndex = 202
loadingIcon.Parent = LoadingCard
Instance.new("UICorner", loadingIcon).CornerRadius = UDim.new(0, 12)

-- Os assets visuais sÃ£o baixados e registrados enquanto apenas o loading estÃ¡ aberto.
-- O download real acontece depois que os textos/barra do loading jÃ¡ existem, para
-- que o usuÃ¡rio veja exatamente qual recurso estÃ¡ sendo buscado.
preloadedHeaderLogoAsset = nil
preloadedLoadingLogoAsset = nil
preloadedBackgroundAsset = nil
function preloadPanelAsset(_lllIIlllII, _IIllllllll)
    local _lIlIlIllll=getcustomasset or getsynasset or getexecutorasset
    if type(_lIlIlIllll)~="function" or type(writefile)~="function" then return nil end
    if isfile then
        local _IIlIIllIII,_IIlIIIIIIl=pcall(isfile,_IIllllllll)
        if _IIlIIllIII and _IIlIIIIIIl then
            local _lIIIllIllI,_llIIllllIl=pcall(_lIlIlIllll,_IIllllllll)
            if _lIIIllIllI and type(_llIIllllIl)=="string" then _lIlIllIlIl("info","CACHE",_IIllllllll.." reused") return _llIIllllIl end
        end
    end
    local _lIIIIIlllI=tostring(_lllIIlllII):find("?",1,true) and "&" or "?"
    local _IIlIIIIllI = tostring(_lllIIlllII) .. _lIIIIIlllI .. "v=" .. tostring(os.time())
    local _lIIlllIIll = nil

    if _lIllIIlIlI then
        local _IIIlllllll, _llllllllII = pcall(_lIllIIlIlI, { Url = _IIlIIIIllI, Method = "GET" })
        if _IIIlllllll and _llllllllII then
            if type(_llllllllII) == "string" then
                _lIIlllIIll = _llllllllII
            elseif type(_llllllllII) == "table" then
                _lIIlllIIll = _llllllllII.Body or _llllllllII.body or _llllllllII.ResponseBody
            end
        end
    end

    if type(_lIIlllIIll) ~= "string" or #_lIIlllIIll < 100 then
        local _IlllIIlIll, _IlIIIIIIll = pcall(function() return game:HttpGet(_IIlIIIIllI) end)
        if _IlllIIlIll then _lIIlllIIll = _IlIIIIIIll end
    end
    if type(_lIIlllIIll) ~= "string" or #_lIIlllIIll < 100 then return nil end
    if not pcall(writefile, _IIllllllll, _lIIlllIIll) then return nil end
    local _IlIIlIlIII, _lIIIllllll = pcall(_lIlIlIllll, _IIllllllll)
    return _IlIIlIlIII and type(_lIIIllllll) == "string" and _lIIIllllll or nil
end
Panel.LoadAsset = preloadPanelAsset

loadingTitle = Instance.new("TextLabel")
loadingTitle.Size = UDim2.new(1, -92, 0, 28)
loadingTitle.Position = UDim2.new(0, 76, 0, 20)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Text = "288 PANEL"
loadingTitle.TextColor3 = _llIIIIIIIl
loadingTitle.TextSize = 17
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.TextXAlignment = Enum.TextXAlignment.Left
loadingTitle.ZIndex = 202
loadingTitle.Parent = LoadingCard

loadingSubtitle = Instance.new("TextLabel")
loadingSubtitle.Size = UDim2.new(1, -92, 0, 20)
loadingSubtitle.Position = UDim2.new(0, 76, 0, 45)
loadingSubtitle.BackgroundTransparency = 1
loadingSubtitle.Text = "STARTING FEATURES"
loadingSubtitle.TextColor3 = _lIIIlIlIIl
loadingSubtitle.TextSize = 10
loadingSubtitle.Font = Enum.Font.GothamMedium
loadingSubtitle.TextXAlignment = Enum.TextXAlignment.Left
loadingSubtitle.ZIndex = 202
loadingSubtitle.Parent = LoadingCard

loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(1, -44, 0, 8)
loadingBar.Position = UDim2.new(0, 22, 0, 94)
loadingBar.BackgroundColor3 = Color3.fromRGB(34, 31, 42)
loadingBar.BorderSizePixel = 0
loadingBar.ClipsDescendants = true
loadingBar.ZIndex = 202
loadingBar.Parent = LoadingCard
Instance.new("UICorner", loadingBar).CornerRadius = UDim.new(1, 0)

loadingFill = Instance.new("Frame")
loadingFill.Size = UDim2.new(0, 0, 1, 0)
loadingFill.BackgroundColor3 = _lIIlIlIlIl
loadingFill.BorderSizePixel = 0
loadingFill.ZIndex = 203
loadingFill.Parent = loadingBar
Instance.new("UICorner", loadingFill).CornerRadius = UDim.new(1, 0)

loadingStatus = Instance.new("TextLabel")
loadingStatus.Size = UDim2.new(1, -88, 0, 24)
loadingStatus.Position = UDim2.new(0, 22, 0, 116)
loadingStatus.BackgroundTransparency = 1
loadingStatus.Text = "Preparing interface..."
loadingStatus.TextColor3 = _lIIIlIlIIl
loadingStatus.TextSize = 11
loadingStatus.Font = Enum.Font.Gotham
loadingStatus.TextXAlignment = Enum.TextXAlignment.Left
loadingStatus.ZIndex = 202
loadingStatus.Parent = LoadingCard

loadingPercent = Instance.new("TextLabel")
loadingPercent.Size = UDim2.new(0, 56, 0, 24)
loadingPercent.Position = UDim2.new(1, -78, 0, 116)
loadingPercent.BackgroundTransparency = 1
loadingPercent.Text = "0%"
loadingPercent.TextColor3 = _lIIlIlIlIl
loadingPercent.TextSize = 11
loadingPercent.Font = Enum.Font.GothamBold
loadingPercent.TextXAlignment = Enum.TextXAlignment.Right
loadingPercent.ZIndex = 203
loadingPercent.Parent = LoadingCard
local _IIIlIlllIl={}
for i=1,3 do local _llIIlIllIl=Instance.new("TextLabel") _llIIlIllIl.Name="LoadingHistory"..tostring(i) _llIIlIllIl.Size=UDim2.new(1,-44,0,18) _llIIlIllIl.Position=UDim2.new(0,22,0,145+(i-1)*19) _llIIlIllIl.BackgroundTransparency=1 _llIIlIllIl.Text="" _llIIlIllIl.TextColor3=Color3.fromRGB(120,210,145) _llIIlIllIl.TextTransparency=0.12+(i-1)*0.18 _llIIlIllIl.TextSize=10 _llIIlIllIl.Font=Enum.Font.Gotham _llIIlIllIl.TextXAlignment=Enum.TextXAlignment.Left _llIIlIllIl.TextTruncate=Enum.TextTruncate.AtEnd _llIIlIllIl.ZIndex=202 _llIIlIllIl.Parent=LoadingCard _IIIlIlllIl[i]=_llIIlIllIl end
local _IllllIIlll={history={}} Panel.Loading=_IllllIIlll
function _IllllIIlll:_renderHistory() local _llIIlIIIlI=#self.history for i=1,3 do local _IlIIllIIIl=self.history[_llIIlIIIlI-i+1] local _lIllllIIIl=_IIIlIlllIl[i] if _lIllllIIIl then _lIllllIIIl.Text=_IlIIllIIIl and ((_IlIIllIIIl.ok and "âœ“ " or "! ")..item.name) or "" _lIllllIIIl.TextColor3=_IlIIllIIIl and (_IlIIllIIIl.ok and Color3.fromRGB(120,210,145) or Color3.fromRGB(255,150,90)) or _lIIIlIlIIl end end end
function _IllllIIlll:Complete(_IlIlIlllll,_lllIllIllI) table.insert(self.history,{_IlIlIlllll=tostring(_IlIlIlllll),_lllIllIllI=_lllIllIllI~=false}) while #self.history>12 do table.remove(self.history,1) end self:_renderHistory() end

function setLoadingProgress(_IlIIIllIlI, _lllIIlllIl)
    if loadingFinished or not LoadingRoot.Parent then return end
    _IlIIIllIlI = math.clamp(tonumber(_IlIIIllIlI) or 0, 0, 100)
    loadingStatus.Text = _lllIIlllIl or loadingStatus.Text
    loadingPercent.Text = tostring(math.floor(_IlIIIllIlI)) .. "%"
    _lllIllIlIl:Create(loadingFill, TweenInfo.new(0.24, Enum.EasingStyle.Quad), {
        Size = UDim2.new(_IlIIIllIlI / 100, 0, 1, 0),
    }):Play()
end

-- MantÃ©m cada item na tela tempo suficiente para ser lido, mas o callback Ã© o
-- download/preparo real. Se a rede levar mais tempo, a etapa acompanha o tempo real.
local function _IIlIlIIlll(_IlIIIllIlI, _lllIIlllIl, _IlIIIIlIIl, _IlIlllIlIl)
    if loadingFinished or not LoadingRoot.Parent then return nil end
    setLoadingProgress(_IlIIIllIlI, _lllIIlllIl)
    local _IllllIllIl = os.clock()
    local _lllIlIIlII = nil
    local _lIIIlIIIIl=true
    if type(_IlIIIIlIIl)=="function" then local _lllIllIllI,_IlIlIlIlll=pcall(_IlIIIIlIIl) _lIIIlIIIIl=_lllIllIllI and _IlIlIlIlll~=false if _lllIllIllI then _lllIlIIlII=_IlIlIlIlll else _lIlIllIlIl("error","LOADING",tostring(_lllIIlllIl).." | "..tostring(_IlIlIlIlll)) end end
    _IllllIIlll:Complete(_lllIIlllIl,_lIIIlIIIIl) _lIlIllIlIl(_lIIIlIIIIl and "info" or "warning","LOADING",tostring(_lllIIlllIl))
    local _lIlIIIIlIl=math.clamp(tonumber(_IlIlllIlIl) or 1.25,1,2)
    local _IIIllIlIII = _lIlIIIIlIl - (os.clock() - _IllllIllIl)
    if _IIIllIlIII > 0 then task.wait(_IIIllIlIII) end
    return _lllIlIIlII
end

-- Downloads visuais reais do bootstrap. Cada troca permanece entre 1 e 2 segundos
-- quando o download termina rÃ¡pido; conexÃµes lentas continuam mostrando a etapa atual.
_IIlIlIIlll(8, "Downloading loading animation...", function()
    preloadedLoadingLogoAsset = preloadPanelAsset(_lllIIIIlII, "288-panel-logo-spritesheet.png")
    if preloadedLoadingLogoAsset then
        loadingIcon.ImageRectSize = Vector2.new(96, 96)
        loadingIcon.Image = preloadedLoadingLogoAsset
        local _lIlIIlllII = os.clock() + 4
        while loadingIcon.Parent and not loadingIcon.IsLoaded and os.clock() < _lIlIIlllII do
            _IllIllIIII.RenderStepped:Wait()
        end
        loadingLogoReady = loadingIcon.IsLoaded
        task.spawn(function()
            local _lIIllIIIlI = 0
            while loadingIcon.Parent do
                loadingIcon.ImageRectOffset = Vector2.new((_lIIllIIIlI % 8) * 96, math.floor(_lIIllIIIlI / 8) * 96)
                _lIIllIIIlI = (_lIIllIIIlI + 1) % 40
                task.wait(0.06)
            end
        end)
    end
    return preloadedLoadingLogoAsset
end, 1.15)

_IIlIlIIlll(16, "Downloading panel logo...", function()
    preloadedHeaderLogoAsset = preloadPanelAsset(_IlIlllIIII, "288-panel-logo.png")
    return preloadedHeaderLogoAsset
end, 1.15)

_IIlIlIIlll(24, "Downloading background...", function()
    preloadedBackgroundAsset = preloadPanelAsset(_IlIlllllll, "288-panel-background.png")
    return preloadedBackgroundAsset
end, 1.35)

_IIlIlIIlll(31, "Preparing interface assets...", nil, 1.05)

function finishLoading(_lllIIlllIl)
    if loadingFinished or loadingFinishing then return end
    loadingFinishing = true

    local _lIIllIllII = os.clock() + 5
    while LoadingRoot.Parent and not loadingLogoReady and os.clock() < _lIIllIllII do
        task.wait(0.05)
    end
    local _IIlllIlIII = os.clock() + 10
    while commonModulePreloadRemaining > 0 and os.clock() < _IIlllIlIII do
        task.wait(0.05)
    end

    local _IIIllIlIII = 2.6 - (os.clock() - loadingStartedAt)
    if _IIIllIlIII > 0 then task.wait(_IIIllIlIII) end
    if not LoadingRoot.Parent then return end

    loadingFinished = true

    if loadingSound then
        pcall(function() loadingSound:Stop() end)
        pcall(function() loadingSound:Destroy() end)
        loadingSound = nil
    end

    loadingStatus.Text = _lllIIlllIl or "Tudo pronto!"
    loadingPercent.Text = "100%"
    loadingFill.Size = UDim2.new(1, 0, 1, 0)

    task.wait(0.22)
    if not LoadingRoot.Parent then return end
    local _IIlIIllIlI = _lllIllIlIl:Create(LoadingRoot, TweenInfo.new(0.25), {BackgroundTransparency = 1})
    local _lIllIIIlll = _lllIllIlIl:Create(LoadingCard, TweenInfo.new(0.25), {GroupTransparency = 1})
    _IIlIIllIlI:Play()
    _lIllIIIlll:Play()
    _lIllIIIlll.Completed:Wait()
    if LoadingRoot.Parent then LoadingRoot:Destroy() end

    -- A janela principal sÃ³ aparece dois segundos completos apÃ³s o loading sair.
    task.wait(2)
    if MainFrame and MainFrame.Parent and _lIlllIlIlI.Parent then
        MainFrame.Visible = true
        if FloatingToggle then FloatingToggle.Visible = true end
    end
end

setLoadingProgress(36, "Building interface components...")

-- Remove qualquer blur deixado por versÃµes anteriores do painel.
do
    local _lIlllllllI = game:GetService("Lighting")
    local _IIIllIllIl = _lIlllllllI:FindFirstChild("288PanelBlur")
    if _IIIllIllIl then
        pcall(function() _IIIllIllIl:Destroy() end)
    end
    local _llIlIIIIIl = _lIlllllllI:FindFirstChild("288PanelVipBlur")
    if _llIlIIIIIl then
        pcall(function() _llIlIIIIIl:Destroy() end)
    end
end

-- ==================== MAIN FRAME ====================
-- CanvasGroup + UICorner aplica a mascara tambem aos filhos. Em um Frame comum,
-- Header/Sidebar/Content continuam desenhando por cima dos cantos arredondados.
MainFrame = Instance.new("CanvasGroup")
MainFrame.Name             = "MainFrame"
MainFrame.Size             = UDim2.new(0, 620, 0, 430)
MainFrame.AnchorPoint      = Vector2.new(0.5, 0.5)
MainFrame.Position         = UDim2.fromScale(0.5, 0.5)
MainFrame.BackgroundColor3 = _IllIIlIIII
MainFrame.BackgroundTransparency = 0.02
MainFrame.BorderSizePixel  = 0
MainFrame.ZIndex           = 0
MainFrame.Active           = true
MainFrame.Draggable        = true
MainFrame.ClipsDescendants = true
MainFrame.GroupTransparency = 0
MainFrame.Visible          = false
MainFrame.Parent           = _lIlllIlIlI
_IllIIlIlII = MainFrame
_lIIlIlIllI(MainFrame,"BackgroundColor3","main")
MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

-- Dashboard 620x430 com escala responsiva para telas menores.
MainScale = Instance.new("UIScale")
MainScale.Name = "ResponsiveScale"
MainScale.Scale = 1
MainScale.Parent = MainFrame
clampingMainFrame = false
local _lIllllIIll, _llIIllIlll = 620, 430
local _IIlllIIlll = _llllIlllIl == "mobile" and 8 or 14

function clampMainFrameToWindow()
    if clampingMainFrame or not MainFrame or not MainFrame.Parent then return end
    local _IllIIlIllI = workspace.CurrentCamera
    if not _IllIIlIllI then return end
    local _IlIlIIIlll = _IllIIlIllI.ViewportSize
    local _lIlIIIlIll, _IlllIIIlII = _lIllIlllII:GetGuiInset()
    local _llllIlIlll = MainScale and MainScale.Scale or 1
    local _llIlIlIIII = _lIllllIIll * _llllIlIlll * 0.5
    local _lIlIIlllll = _llIIllIlll * _llllIlIlll * 0.5
    local _lllIIIllll = _IIlllIIlll + _llIlIlIIII
    local _IIIlllIIlI = _IlIlIIIlll.X - _IIlllIIlll - _llIlIlIIII
    local _IlllllIlll = _lIlIIIlIll.Y + _IIlllIIlll + _lIlIIlllll
    local _lIIIllIIll = _IlIlIIIlll.Y - _IlllIIIlII.Y - _IIlllIIlll - _lIlIIlllll
    local _IlllIlIlll = MainFrame.Position
    local _IllllIIlIl = _IlIlIIIlll.X * _IlllIlIlll.X.Scale + _IlllIlIlll.X.Offset
    local _IlIlIIlIIl = _IlIlIIIlll.Y * _IlllIlIlll.Y.Scale + _IlllIlIlll.Y.Offset
    local _llIIlIIlII = _lllIIIllll > _IIIlllIIlI and _IlIlIIIlll.X * 0.5 or math.clamp(_IllllIIlIl, _lllIIIllll, _IIIlllIIlI)
    local _lIIlIIlIIl = _IlllllIlll > _lIIIllIIll and (_lIlIIIlIll.Y + _IlIlIIIlll.Y - _IlllIIIlII.Y) * 0.5 or math.clamp(_IlIlIIlIIl, _IlllllIlll, _lIIIllIIll)
    if math.abs(_llIIlIIlII - _IllllIIlIl) > 0.5 or math.abs(_lIIlIIlIIl - _IlIlIIlIIl) > 0.5 then
        clampingMainFrame = true
        MainFrame.Position = UDim2.new(0, _llIIlIIlII, 0, _lIIlIIlIIl)
        clampingMainFrame = false
    end
end

_IIIIIIlIlI(MainFrame:GetPropertyChangedSignal("Position"), clampMainFrameToWindow)
_IIIIIIlIlI(MainFrame:GetPropertyChangedSignal("Visible"), _IIlllIlIlI)
_IIIIIIlIlI(MainScale:GetPropertyChangedSignal("Scale"), function()
    task.defer(clampMainFrameToWindow)
end)

function updateResponsiveScale()
    local _IllIIlIllI = workspace.CurrentCamera
    if not _IllIIlIllI then return end
    local _IlIlIIIlll = _IllIIlIllI.ViewportSize
    local _lIlIIIlIll, _IlllIIIlII = _lIllIlllII:GetGuiInset()
    local _IIlIllllll = math.max(1, _IlIlIIIlll.X - _IIlllIIlll * 2)
    local _IIlIIlIlIl = math.max(1, _IlIlIIIlll.Y - _lIlIIIlIll.Y - _IlllIIIlII.Y - _IIlllIIlll * 2)
    MainScale.Scale = math.clamp(math.min(_IIlIllllll / _lIllllIIll, _IIlIIlIlIl / _llIIllIlll, 1), 0.25, 1)
    task.defer(clampMainFrameToWindow)
end

updateResponsiveScale()
if workspace.CurrentCamera then
    _IIIIIIlIlI(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), updateResponsiveScale)
end
MainStroke = Instance.new("UIStroke")
MainStroke.Color     = _lIIlIlIlIl
MainStroke.Transparency = 0.42
MainStroke.Thickness = 1.25
MainStroke.Parent    = MainFrame

local _IllllIlIlI = Instance.new("Frame")
_IllllIlIlI.Name = "PanelBorderReflection"
_IllllIlIlI.BackgroundTransparency = 1
_IllllIlIlI.BorderSizePixel = 0
_IllllIlIlI.Size = UDim2.fromScale(1, 1)
_IllllIlIlI.ZIndex = 20
_IllllIlIlI.Parent = MainFrame
Instance.new("UICorner", _IllllIlIlI).CornerRadius = UDim.new(0, 18)
local _IllIlIlIIl = Instance.new("UIStroke")
_IllIlIlIIl.Name = "ReflectionStroke"
_IllIlIlIIl.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_IllIlIlIIl.Thickness = 2
_IllIlIlIIl.Color = Color3.fromRGB(255, 255, 255)
_IllIlIlIIl.Transparency = 0.88
_IllIlIlIIl.Parent = _IllllIlIlI
local _IlIlIllIlI = Instance.new("UIGradient")
_IlIlIllIlI.Rotation = 45
_IlIlIllIlI.Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))
_IlIlIllIlI.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.42, 1),
    NumberSequenceKeypoint.new(0.49, 0.08),
    NumberSequenceKeypoint.new(0.51, 0.08),
    NumberSequenceKeypoint.new(0.58, 1),
    NumberSequenceKeypoint.new(1, 1),
})
_IlIlIllIlI.Offset = Vector2.new(-1, -1)
_IlIlIllIlI.Parent = _IllIlIlIIl
task.spawn(function()
    while _IllllIlIlI.Parent and not _lIlIllllII do
        _IlIlIllIlI.Offset = Vector2.new(-1, -1)
        local _lIIlIlIIIl = _lllIllIlIl:Create(_IlIlIllIlI, TweenInfo.new(4, Enum.EasingStyle.Linear), {
            Offset = Vector2.new(1, 1),
        })
        _lIIlIlIIIl:Play()
        _lIIlIlIIIl.Completed:Wait()
        if not _IllllIlIlI.Parent or _lIlIllllII then break end
        task.wait(3)
    end
end)

BgLabel = Instance.new("ImageLabel")
BgLabel.Size             = UDim2.new(1, 0, 1, 0)
BgLabel.BackgroundTransparency = 1
BgLabel.Name             = "PanelBackgroundImage"
BgLabel.Image            = preloadedBackgroundAsset or _IllIIlIIll
BgLabel.ImageTransparency = 0.28
BgLabel.ScaleType        = Enum.ScaleType.Crop
-- O MainFrame ocupa o ZIndex 0; o fundo precisa ficar acima dele para ser visivel.
BgLabel.ZIndex           = 1
BgLabel.Parent           = MainFrame

-- Alguns assets da Creator Store nao sao entregues para todas as experiencias.
-- O background da API jÃ¡ Ã© tentado durante o loading. Esta funÃ§Ã£o permanece apenas
-- como fallback caso aquele download nÃ£o tenha sido possÃ­vel.
function loadBackgroundFromApi()
    if not BgLabel.Parent or BgLabel.IsLoaded or preloadedBackgroundAsset then return end

    local _lIlIlIllll = getcustomasset or getsynasset or getexecutorasset
    if type(_lIlIlIllll) ~= "function" or type(writefile) ~= "function" then
        warn("[288] O executor nao oferece writefile + getcustomasset para carregar o background da API.")
        return
    end

    local _llIlIlllII = _IlIlllllll .. "?v=" .. tostring(os.time())
    local _lIIlllIIll = nil

    if _lIllIIlIlI then
        local _IIIlllllll, _llllllllII = pcall(_lIllIIlIlI, {
            Url = _llIlIlllII,
            Method = "GET",
        })
        if _IIIlllllll then
            if type(_llllllllII) == "string" then
                _lIIlllIIll = _llllllllII
            elseif type(_llllllllII) == "table" then
                _lIIlllIIll = _llllllllII.Body or _llllllllII.body or _llllllllII.ResponseBody
            end
        end
    end

    if type(_lIIlllIIll) ~= "string" or #_lIIlllIIll < 1000 then
        local _lIlIIIllIl, _IlIIIIIIll = pcall(function()
            return game:HttpGet(_llIlIlllII)
        end)
        if _lIlIIIllIl then _lIIlllIIll = _IlIIIIIIll end
    end

    if type(_lIIlllIIll) ~= "string" or #_lIIlllIIll < 1000 then
        warn("[288] A API nao retornou um PNG valido para o background.")
        return
    end

    -- Sobrescreve sempre para nao reutilizar um download antigo/404 em cache.
    local _IIllllllll = "288-panel-background.png"
    local _IIllIIllII, _lIllllIIII = pcall(writefile, _IIllllllll, _lIIlllIIll)
    if not _IIllIIllII then
        warn("[288] Falha ao salvar o background: " .. tostring(_lIllllIIII))
        return
    end

    local _IlIIlIlIII, _IlIllIIIIl = pcall(_lIlIlIllll, _IIllllllll)
    if not _IlIIlIlIII or type(_IlIllIIIIl) ~= "string" then
        warn("[288] Falha ao registrar o background local: " .. tostring(_IlIllIIIIl))
        return
    end

    if BgLabel.Parent then
        BgLabel.Image = _IlIllIIIIl
        BgLabel.ImageTransparency = 0.18
    end
end

task.delay(0.25, loadBackgroundFromApi)

BgTint = Instance.new("Frame")
BgTint.Name = "GlassTint"
BgTint.Size = UDim2.new(1,0,1,0)
BgTint.BackgroundColor3 = _IllIIlIIII
BgTint.BackgroundTransparency = 0.68
BgTint.BorderSizePixel = 0
BgTint.ZIndex = 1
BgTint.Parent = MainFrame

bgGradient = Instance.new("UIGradient")
bgGradient.Name = "PanelThemeGradient"
bgGradient.Rotation = 35
do
    local _lIlIIllllI = _IllllIIlII[_lIIlIIlllI] or _IllllIIlII.dark
    bgGradient.Color = _llIllIIlII(_lIlIIllllI, 0)
    bgGradient.Rotation = tonumber(_lIlIIllllI.gradientRotation) or 35
end
bgGradient.Parent = BgTint

-- Se o tema salvo for animado, inicia o fluxo assim que o gradiente existir.
if (_IllllIIlII[_lIIlIIlllI] or {}).animated then
    task.defer(function()
        if bgGradient and bgGradient.Parent then _lIIIIllIII(_lIIlIIlllI) end
    end)
end

-- ==================== HEADER ====================
Header = Instance.new("Frame")
Header.Name             = "Header"
Header.Size             = UDim2.new(1, 0, 0, 54)
Header.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
Header.BackgroundTransparency = 0.34
Header.BorderSizePixel  = 0
Header.ZIndex           = 2
Header.Parent           = MainFrame
_lIIlIlIllI(Header, "BackgroundColor3", "header")

VersionLabel = Instance.new("TextLabel")
VersionLabel.Size             = UDim2.new(0, 54, 0, 20)
VersionLabel.Position         = UDim2.new(1, -116, 0.5, -10)
VersionLabel.TextTruncate     = Enum.TextTruncate.AtEnd
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text             = _IIIIlIIlIl
VersionLabel.TextColor3       = _lIIlIlIlIl
VersionLabel.TextSize         = 10
VersionLabel.Font             = Enum.Font.GothamBold
VersionLabel.TextXAlignment   = Enum.TextXAlignment.Center
VersionLabel.ZIndex           = 3
VersionLabel.Parent           = Header
VersionLabel.BackgroundColor3 = Color3.fromRGB(47, 31, 52)
VersionLabel.BackgroundTransparency = 0.28
Instance.new("UICorner", VersionLabel).CornerRadius = UDim.new(1, 0)

HeaderGlow = Instance.new("Frame")
HeaderGlow.Name = "HeaderAccentGlow"
HeaderGlow.Size = UDim2.new(0, 160, 0, 1)
HeaderGlow.Position = UDim2.new(0, 18, 1, -1)
HeaderGlow.BackgroundColor3 = _lIIlIlIlIl
HeaderGlow.BackgroundTransparency = 0.18
HeaderGlow.BorderSizePixel = 0
HeaderGlow.ZIndex = 3
HeaderGlow.Parent = Header
HeaderGlowGradient = Instance.new("UIGradient")
HeaderGlowGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(1, 1),
})
HeaderGlowGradient.Parent = HeaderGlow

HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Name = "PanelLogo"
HeaderLogo.Size = UDim2.fromOffset(34, 34)
HeaderLogo.Position = UDim2.new(0, 16, 0.5, -17)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.ScaleType = Enum.ScaleType.Fit
HeaderLogo.ZIndex = 3
HeaderLogo.Parent = Header
if preloadedHeaderLogoAsset then HeaderLogo.Image = preloadedHeaderLogoAsset end

FloatingToggle = Instance.new("ImageButton")
FloatingToggle.Name = "PanelFloatingToggle"
FloatingToggle.Size = UDim2.fromOffset(50, 50)
FloatingToggle.AnchorPoint = Vector2.new(0, 0.5)
FloatingToggle.Position = UDim2.new(0, 12, 0.5, 0)
FloatingToggle.BackgroundColor3 = _lIIlIIlIlI
FloatingToggle.BackgroundTransparency = 0.08
FloatingToggle.BorderSizePixel = 0
FloatingToggle.AutoButtonColor = false
FloatingToggle.ScaleType = Enum.ScaleType.Fit
FloatingToggle.ZIndex = 500
FloatingToggle.Visible = false
FloatingToggle.Parent = _lIlllIlIlI
if preloadedHeaderLogoAsset then FloatingToggle.Image = preloadedHeaderLogoAsset end
Instance.new("UICorner", FloatingToggle).CornerRadius = UDim.new(1, 0)
floatingStroke = Instance.new("UIStroke")
floatingStroke.Color = _lIIlIlIlIl
floatingStroke.Transparency = 0.18
floatingStroke.Thickness = 1.5
floatingStroke.Parent = FloatingToggle
floatingPadding = Instance.new("UIPadding")
floatingPadding.PaddingTop = UDim.new(0, 5)
floatingPadding.PaddingBottom = UDim.new(0, 5)
floatingPadding.PaddingLeft = UDim.new(0, 5)
floatingPadding.PaddingRight = UDim.new(0, 5)
floatingPadding.Parent = FloatingToggle
_llIlIIIlII(FloatingToggle, false)
FloatingToggle.MouseButton1Click:Connect(function()
    if not loadingFinished or not MainFrame then return end
    MainFrame.Visible = not MainFrame.Visible
    if not MainFrame.Visible then _IIlllIlIlI() end
    floatingStroke.Transparency = MainFrame.Visible and 0.05 or 0.42
end)

TitleLabel = Instance.new("TextLabel")
TitleLabel.Size             = UDim2.new(0, 150, 1, 0)
TitleLabel.Position         = UDim2.new(0, 58, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text             = "288 Panel"
TitleLabel.TextSize         = 15
TitleLabel.Font             = Enum.Font.GothamBold
TitleLabel.TextXAlignment   = Enum.TextXAlignment.Left
TitleLabel.TextColor3       = _llIIIIIIIl
TitleLabel.ZIndex           = 3
TitleLabel.Parent           = Header

CloseBtn = Instance.new("TextButton")
CloseBtn.Size             = UDim2.new(0, 30, 0, 30)
CloseBtn.AnchorPoint      = Vector2.new(1, 0.5)
CloseBtn.Position         = UDim2.new(1, -12, 0.5, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(48, 30, 50)
CloseBtn.Text             = ""
CloseBtn.TextColor3       = _lIIlIlIlIl
CloseBtn.TextSize         = 13
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.BorderSizePixel  = 0
CloseBtn.ZIndex           = 4
CloseBtn.Parent           = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 7)
closeStroke = Instance.new("UIStroke")
closeStroke.Color = _lIIlIlIlIl
closeStroke.Transparency = 0.55
closeStroke.Thickness = 1
closeStroke.Parent = CloseBtn
_llllIIlllI(CloseBtn, "close", 7, 7, 16, _lIIlIlIlIl)
_llIlIIIlII(CloseBtn, false)
CloseBtn.MouseButton1Click:Connect(function()
    _IIlllIlIlI()
    _lIIIIIIlII()
    _lIlllIlIlI:Destroy()
end)

local _IllIIlllIl = Instance.new("TextButton")
_IllIIlllIl.Name = "MinimizeButton"
_IllIIlllIl.Size = UDim2.fromOffset(30, 30)
_IllIIlllIl.AnchorPoint = Vector2.new(1, 0.5)
_IllIIlllIl.Position = UDim2.new(1, -50, 0.5, 0)
_IllIIlllIl.BackgroundColor3 = Color3.fromRGB(37, 31, 45)
_IllIIlllIl.Text = "â€“"
_IllIIlllIl.TextColor3 = _lIIlIlIlIl
_IllIIlllIl.TextSize = 20
_IllIIlllIl.Font = Enum.Font.GothamMedium
_IllIIlllIl.BorderSizePixel = 0
_IllIIlllIl.ZIndex = 4
_IllIIlllIl.Parent = Header
Instance.new("UICorner", _IllIIlllIl).CornerRadius = UDim.new(0, 7)
_llIlIIIlII(_IllIIlllIl, false)
_IllIIlllIl.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingToggle.Visible = true
    floatingStroke.Transparency = 0.42
    _IIlllIlIlI()
end)

-- ==================== SIDEBAR ====================
Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name             = "Sidebar"
Sidebar.Size             = UDim2.new(0, 132, 1, -54)
Sidebar.Position         = UDim2.new(0, 0, 0, 54)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
Sidebar.BackgroundTransparency = 0.38
Sidebar.BorderSizePixel  = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
Sidebar.ScrollBarThickness = 3
Sidebar.ScrollBarImageColor3 = _lIIlIlIlIl
Sidebar.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
Sidebar.ClipsDescendants = true
Sidebar.ZIndex           = 2
Sidebar.Parent           = MainFrame
_lIIlIlIllI(Sidebar, "BackgroundColor3", "sidebar")

SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding   = UDim.new(0, 2)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Parent    = Sidebar

SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 7)
SidebarPadding.PaddingBottom = UDim.new(0, 7)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

-- ==================== CONTENT ====================
ContentFrame = Instance.new("Frame")
ContentFrame.Name                  = "Content"
ContentFrame.Size                  = UDim2.new(1, -132, 1, -54)
ContentFrame.Position              = UDim2.new(0, 132, 0, 54)
ContentFrame.BackgroundColor3      = Color3.fromRGB(18, 19, 22)
ContentFrame.BackgroundTransparency= 0.42
ContentFrame.BorderSizePixel       = 0
ContentFrame.ZIndex                = 2
ContentFrame.Parent                = MainFrame
_lIIlIlIllI(ContentFrame, "BackgroundColor3", "content")

-- Se o tema atual usa degradÃª, agora que as superficies principais existem
-- reaplicamos uma vez para que todas recebam seus UIGradients.
task.defer(function()
    local _lIIlllllII = _IllllIIlII[_lIIlIIlllI]
    if _lIIlllllII and (_lIIlllllII.animated or type(_lIIlllllII.gradient) == "table") then
        pcall(function() _lIIIIllIII(_lIIlIIlllI) end)
    end
end)

-- ==================== TABS ====================
Tabs       = {}
CurrentTab = nil

TABS_DEF = {
    { _IlIlIlllll = "Home",       _lIIIIIIllI = 1 },
    { _IlIlIlllll = "VIP",        _lIIIIIIllI = 2 },
    { _IlIlIlllll = "Emphasis",   _lIIIIIIllI = 3 },
    { _IlIlIlllll = "Character",  _lIIIIIIllI = 4 },
    { _IlIlIlllll = "Target",     _lIIIIIIllI = 5 },
    { _IlIlIlllll = "More",       _lIIIIIIllI = 6 },
    { _IlIlIlllll = "Misc",       _lIIIIIIllI = 7 },
    { _IlIlIlllll = "Config",     _lIIIIIIllI = 13 },
    { _IlIlIlllll = "Staff",      _lIIIIIIllI = 9 },
    { _IlIlIlllll = "Logs",       _lIIIIIIllI = 10 },
    { _IlIlIlllll = "Servers",    _lIIIIIIllI = 11 },
    { _IlIlIlllll = "About",      _lIIIIIIllI = 12 },
}

DETECTED_GAME = nil
if game.PlaceId == 142823291 then
    DETECTED_GAME = {_IllllllIll = "MM2", _IlIlIlllll = "Murder Mystery 2"}
    table.insert(TABS_DEF, {_IlIlIlllll = DETECTED_GAME.name, _lIIIIIIllI = 8})
elseif game.PlaceId == 17274762379 then
    DETECTED_GAME = {_IllllllIll = "MushYO", _IlIlIlllll = "MushYO"}
    table.insert(TABS_DEF, {_IlIlIlllll = DETECTED_GAME.name, _lIIIIIIllI = 8})
elseif game.PlaceId == 103727985432337 then
    DETECTED_GAME = {_IllllllIll = "ParkVoice", _IlIlIlllll = "Park Voice"}
    table.insert(TABS_DEF, {_IlIlIlllll = DETECTED_GAME.name, _lIIIIIIllI = 8})
elseif game.PlaceId == 121692407072104 then
    DETECTED_GAME = {_IllllllIll = "RoVibes", _IlIlIlllll = "Ro-vibes"}
    table.insert(TABS_DEF, {_IlIlIlllll = DETECTED_GAME.name, _lIIIIIIllI = 8})
elseif game.PlaceId == 16480898254 then
    DETECTED_GAME = {_IllllllIll = "EatTheEarth", _IlIlIlllll = "Eat The Earth"}
    table.insert(TABS_DEF, {_IlIlIlllll = DETECTED_GAME.name, _lIIIIIIllI = 8})
end

function setTab(_IlIlIlllll)
    if _IlIlIlllll == "Logs" and tostring(_lIIIIlIIlI) ~= "Owner" then
        _IlIlIlllll = "Home"
    elseif _IlIlIlllll == "Staff" and not _lllllIIlll[tostring(_lIIIIlIIlI)] then
        _IlIlIlllll = "Home"
    end
    CurrentTab=_IlIlIlllll
    if Panel.Settings.rememberTab~=false then Panel.Preferences=Panel.Preferences or {} Panel.Preferences.lastTab=_IlIlIlllll task.defer(_lIlllIllIl) end
    local _IIIIIllllI=_IllllIIlII[_lIIlIIlllI]
    for _llIIIIIIII, _llIlIlIIlI in pairs(Tabs) do
        local _IIlIlIIIIl = (_llIlIlIIlI.name == _IlIlIlllll)
        _llIlIlIIlI.frame.Visible       = _IIlIlIIIIl
        _llIlIlIIlI.btn.BackgroundColor3= _IIlIlIIIIl and _IIIIIllllI.btnOn or _IIIIIllllI.sidebar
        _llIlIlIIlI.btn.BackgroundTransparency = _IIlIlIIIIl and 0.08 or 0.42
        _llIlIlIIlI.btn.TextColor3      = _IIlIlIIIIl and _lIIlIlIlIl or _IIIIIllllI.textDim
        if _llIlIlIIlI.accentBar then
            _llIlIlIIlI.accentBar.Visible = _IIlIlIIIIl
            _llIlIlIIlI.accentBar.BackgroundColor3 = _lIIlIlIlIl
        end
    end
    _IIlllIlIlI()
end

function requireVipAccess()
    if _IllIlIIlIl then return true end
    setTab("VIP")
    return false
end

for _llIIIIIIII, def in ipairs(TABS_DEF) do
    local _IlIIlIlIIl = Instance.new("TextButton")
    _IlIIlIlIIl.AutoLocalize     = false
    _IlIIlIlIIl.Name             = def.name .. "Btn"
    _IlIIlIlIIl.Size             = UDim2.new(1, 0, 0, 25)
    _IlIIlIlIIl.BackgroundColor3 = Color3.fromRGB(16, 17, 20)
    _IlIIlIlIIl.BackgroundTransparency = 0.42
    _IlIIlIlIIl.BorderSizePixel  = 0
    _IlIIlIlIIl.Text             = _IlIlllIlII(def.name)
    _IlIIlIlIIl.TextColor3       = _lIIIlIlIIl
    _IlIIlIlIIl.TextSize         = 11
    _IlIIlIlIIl.Font             = Enum.Font.GothamMedium
    _IlIIlIlIIl.LayoutOrder      = def.layoutOrder
    _IlIIlIlIIl.ZIndex           = 3
    _IlIIlIlIIl.Parent           = Sidebar
    Instance.new("UICorner", _IlIIlIlIIl).CornerRadius = UDim.new(0, 9)

    local _IllIIlIIIl = Instance.new("UIStroke")
    _IllIIlIIIl.Color = _llIIllllll
    _IllIIlIIIl.Transparency = 0.72
    _IllIIlIIIl.Thickness = 1
    _IllIIlIIIl.Parent = _IlIIlIlIIl

    local _IlIIlIllII = Instance.new("Frame")
    _IlIIlIllII.Name = "ActiveAccent"
    _IlIIlIllII.Size = UDim2.new(0, 3, 0, 14)
    _IlIIlIllII.Position = UDim2.new(1, -6, 0.5, -7)
    _IlIIlIllII.BackgroundColor3 = _lIIlIlIlIl
    _IlIIlIllII.BorderSizePixel = 0
    _IlIIlIllII.Visible = false
    _IlIIlIllII.ZIndex = _IlIIlIlIIl.ZIndex + 1
    _IlIIlIllII.Parent = _IlIIlIlIIl
    Instance.new("UICorner", _IlIIlIllII).CornerRadius = UDim.new(1,0)

    _lIIlIlIllI(_IlIIlIlIIl, "BackgroundColor3", "sidebar")
    _lIIlIlIllI(_IlIIlIlIIl, "TextColor3", "textDim", "textDim")

    local _IIIIlIIIII = Instance.new("Frame")
    _IIIIlIIIII.Size             = UDim2.new(1, 0, 0, 1)
    _IIIIlIIIII.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    _IIIIlIIIII.BorderSizePixel  = 0
    _IIIIlIIIII.ZIndex           = 3
    _IIIIlIIIII.Parent           = _IlIIlIlIIl
    _IIIIlIIIII.Visible          = false
    _lIIlIlIllI(_IIIIlIIIII, "BackgroundColor3", "sep")

    local _lIIllIIIlI = Instance.new("ScrollingFrame")
    _lIIllIIIlI.Name               = def.name .. "Frame"
    _lIIllIIIlI.Size               = UDim2.new(1, 0, 1, 0)
    _lIIllIIIlI.BackgroundTransparency = 1
    _lIIllIIIlI.Visible            = false
    _lIIllIIIlI.ZIndex             = 2
    _lIIllIIIlI.BorderSizePixel    = 0
    _lIIllIIIlI.ScrollBarThickness = 4
    _lIIllIIIlI.ScrollBarImageColor3 = _lIIlIlIlIl
    _lIIllIIIlI.ScrollingDirection = Enum.ScrollingDirection.Y
    _lIIllIIIlI.AutomaticCanvasSize = Enum.AutomaticSize.Y
    _lIIllIIIlI.ClipsDescendants = true
    _lIIllIIIlI.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    _lIIllIIIlI.CanvasSize         = UDim2.new(0,0,0,0)
    _lIIllIIIlI.Parent             = ContentFrame

    Tabs[def.name] = { _IlIlIlllll = def.name, _IlIIlIlIIl = _IlIIlIlIIl, _lIIllIIIlI = _lIIllIIIlI, accentBar = _IlIIlIllII }
    -- Hover exclusivo da navegacao: preserva o estado ativo e evita conflito
    -- com o hover generico de botoes/toggles.
    _IIIIIIlIlI(_IlIIlIlIIl.MouseEnter, function()
        if CurrentTab == def.name then return end
        _lllIllIlIl:Create(_IlIIlIlIIl, TweenInfo.new(0.14), {
            BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btnHover,
            TextColor3 = _lIIlIlIlIl,
        }):Play()
    end)
    _IIIIIIlIlI(_IlIIlIlIIl.MouseLeave, function()
        local _IIlIlIIIIl = CurrentTab == def.name
        _lllIllIlIl:Create(_IlIIlIlIIl, TweenInfo.new(0.14), {
            BackgroundColor3 = _IIlIlIIIIl and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].sidebar,
            TextColor3 = _IIlIlIIIIl and _lIIlIlIlIl or _IllllIIlII[_lIIlIIlllI].textDim,
        }):Play()
    end)
    _IlIIlIlIIl.MouseButton1Click:Connect(function() setTab(def.name) end)
end

-- Staff tools are visible to staff ranks; diagnostics remain Owner-only.
function updateOwnerOnlyTabs()
    local _IlIIlllIII = Tabs and Tabs["Logs"]
    local _IIIIlllIII = Tabs and Tabs["Staff"]
    if not _IlIIlllIII and not _IIIIlllIII then return end

    local _llIIIlIIlI = tostring(_lIIIIlIIlI or "") == "Owner"
    local _llIlllIllI = _lllllIIlll[tostring(_lIIIIlIIlI or "")] == true
    if _IlIIlllIII then
        _IlIIlllIII.btn.Visible = _llIIIlIIlI
        _IlIIlllIII.frame.Visible = _llIIIlIIlI and CurrentTab == "Logs"
    end
    if _IIIIlllIII then
        _IIIIlllIII.btn.Visible = _llIlllIllI
        _IIIIlllIII.frame.Visible = _llIlllIllI and CurrentTab == "Staff"
    end

    if (not _llIIIlIIlI and CurrentTab == "Logs") or (not _llIlllIllI and CurrentTab == "Staff") then
        setTab("Home")
    end
end

updateOwnerOnlyTabs()
function refreshCanvas(scrollFrame, extraPadding)
    local _lIIIllIIll = 0
    for _llIIIIIIII, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("GuiObject") and child.Position.Y.Scale == 0 then
            local _IlIIIIlIll = child.Position.Y.Offset + child.Size.Y.Offset
            if _IlIIIIlIll > _lIIIllIIll then _lIIIllIIll = _IlIIIIlIll end
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, _lIIIllIIll + (extraPadding or 12))
end

-- ==================== CONSTANTES GLOBAIS ====================
-- Largura total disponÃ­vel no ContentFrame = 620 - 132 = 488px
BTN_W = 190           -- Largura padrÃ£o para botÃµes e inputs
BTN_H = 34            -- Altura padrÃ£o para botÃµes e inputs
GAP = 8               -- EspaÃ§amento entre elementos (horizontal e vertical)
DOT_SIZE = 14         -- Tamanho do dot

-- Duas colunas de 190px com indicadores centrais e margens simÃ©tricas.
PAD = 39              -- Padding igual nas bordas
COL1 = PAD            -- Coluna 1 (esquerda)
COL2 = COL1 + BTN_W + GAP + DOT_SIZE + GAP  -- Coluna 2 (direita)

-- PosiÃ§Ãµes do DOT para cada coluna
DOT1_X = COL1 + BTN_W + GAP
DOT2_X = COL2 + BTN_W + GAP

-- Regra unica de grade usada por todas as abas com botoes de acao:
-- 1/2 na primeira linha, 3/4 na segunda e assim por diante.
function gridSlot(_llIIllIIIl, startY, rowHeight)
    local _lllllIlIIl = math.max(1, tonumber(_llIIllIIIl) or 1)
    local _IIIlIIlIII = _lllllIlIIl % 2 == 1 and COL1 or COL2
    local _lIIllIIIII = math.floor((_lllllIlIIl - 1) / 2)
    return _IIIlIIlIII, (startY or 0) + _lIIllIIIII * (rowHeight or (BTN_H + GAP))
end

-- ==================== UI HELPERS ====================
local function _IIIlllIllI(_lIIlIIllII)
    if not _lIIlIIllII or not _lIIlIIllII:GetAttribute("288MouseAction") then return true end
    local _IlllIlIIIl = Tabs and Tabs["Emphasis"]
    if not _IlllIlIIIl or _lIIlIIllII.Parent ~= _IlllIlIIIl.frame then return true end
    if _lIIlIIllII:GetAttribute("288MouseActionUsed") then return false end

    _lIIlIIllII:SetAttribute("288MouseActionUsed", true)
    _lIIlIIllII.Active = false
    _lIIlIIllII.Selectable = false
    pcall(function() _lIIlIIllII.Interactable = false end)
    _lIIlIIllII.TextColor3 = _lIIIlIlIIl
    _lIIlIIllII.TextTransparency = 0.35
    local _IllIlllIIl = _lIIIIIlIlI[_lIIlIIllII]
    local _llIIIIIllI = _IllIlllIIl and _IllIlllIIl:FindFirstChild("MouseAssetIcon")
    if _llIIIIIllI then _llIIIIIllI.ImageColor3 = _lIIIlIlIIl end
    return true
end

function makeButton(_lIlIIlIlll, _llIlllIIII, _IllIIllllI, _lllIlIlllI, _lIllIIllll, _lIIIIllllI, vipOnly)
    local _IlIIlIlIIl = Instance.new("TextButton")
    _IlIIlIlIIl.AutoLocalize     = false
    _IlIIlIlIIl.Size             = UDim2.new(0, _lIllIIllll or BTN_W, 0, _lIIIIllllI or BTN_H)
    _IlIIlIlIIl.Position         = UDim2.new(0, _IllIIllllI, 0, _lllIlIlllI)
    _IlIIlIlIIl.BackgroundColor3 = _llIIIIIlIl
    _IlIIlIlIIl.BackgroundTransparency = 0.16
    _IlIIlIlIIl.BorderSizePixel  = 0
    _IlIIlIlIIl.Text             = _IlIlllIlII(_llIlllIIII)
    _IlIIlIlIIl.TextColor3       = _llIIIIIIIl
    _IlIIlIlIIl.TextSize         = 12
    _IlIIlIlIIl.Font             = Enum.Font.Gotham
    _IlIIlIlIIl.TextXAlignment   = Enum.TextXAlignment.Center
    _IlIIlIlIIl.ZIndex           = 4
    _IlIIlIlIIl.Parent           = _lIlIIlIlll
    Instance.new("UICorner", _IlIIlIlIIl).CornerRadius = UDim.new(0, 11)

    -- Badge compacta na borda superior dos botoes VIP.
    local function _IlllllIIIl()
        local _lIlIlIIlll = _IlIIlIlIIl:FindFirstChild("VipBadge")
        local _IIIIIllIlI = Tabs["VIP"] and _IlIIlIlIIl.Parent == Tabs["VIP"].frame
        local _lllIllIlll = _IlIIlIlIIl:GetAttribute("288VipOnly") == true and not _IIIIIllIlI
        if not _lllIllIlll then
            if _lIlIlIIlll then _lIlIlIIlll:Destroy() end
            _IlIIlIlIIl.TextXAlignment = Enum.TextXAlignment.Center
            local _IIIlIIlllI = _IlIIlIlIIl:FindFirstChild("VipBadgeTextPadding")
            if _IIIlIIlllI then _IIIlIIlllI:Destroy() end
            return
        end
        if _lIlIlIIlll then return end

        _IlIIlIlIIl.ClipsDescendants = false
        _IlIIlIlIIl.TextXAlignment = Enum.TextXAlignment.Center
        local _IIIlIIlllI = _IlIIlIlIIl:FindFirstChild("VipBadgeTextPadding")
        if not _IIIlIIlllI then
            _IIIlIIlllI = Instance.new("UIPadding")
            _IIIlIIlllI.Name = "VipBadgeTextPadding"
            _IIIlIIlllI.PaddingTop = UDim.new(0, 3)
            _IIIlIIlllI.Parent = _IlIIlIlIIl
        end

        _lIlIlIIlll = Instance.new("Frame")
        _lIlIlIIlll.Name = "VipBadge"
        _lIlIlIIlll.AnchorPoint = Vector2.new(0.5, 1)
        _lIlIlIIlll.Position = UDim2.new(0.5, 0, 0, 2)
        _lIlIlIIlll.Size = UDim2.fromOffset(25, 13)
        _lIlIlIIlll.BackgroundColor3 = Color3.fromRGB(255, 207, 72)
        _lIlIlIIlll.BorderSizePixel = 0
        _lIlIlIIlll.ZIndex = _IlIIlIlIIl.ZIndex + 10
        _lIlIlIIlll.Parent = _IlIIlIlIIl
        Instance.new("UICorner", _lIlIlIIlll).CornerRadius = UDim.new(0, 5)

        local _lIIIlIlIlI = Instance.new("TextLabel")
        _lIIIlIlIlI.Name = "Label"
        _lIIIlIlIlI.Size = UDim2.fromScale(1, 1)
        _lIIIlIlIlI.BackgroundTransparency = 1
        _lIIIlIlIlI.Text = "VIP"
        _lIIIlIlIlI.TextColor3 = Color3.fromRGB(40, 29, 8)
        _lIIIlIlIlI.TextSize = 8
        _lIIIlIlIlI.Font = Enum.Font.GothamBlack
        _lIIIlIlIlI.ZIndex = _lIlIlIIlll.ZIndex + 1
        _lIIIlIlIlI.Parent = _lIlIlIIlll
    end

    _IlIIlIlIIl:GetAttributeChangedSignal("288VipOnly"):Connect(_IlllllIIIl)
    _lIIlIlIllI(_IlIIlIlIIl, "BackgroundColor3", "btn")
    _lIIlIlIllI(_IlIIlIlIIl, "TextColor3", "text")
    local _lIlIlIIIIl = Instance.new("UIStroke")
    _lIlIlIIIIl.Color = _llIIllllll
    _lIlIlIIIIl.Transparency = 0.58
    _lIlIlIIIIl.Thickness = 1
    _lIlIlIIIIl.Parent = _IlIIlIlIIl
    _llIlIIIlII(_IlIIlIlIIl)
    if vipOnly then
        _IlIIlIlIIl:SetAttribute("288VipOnly", true)
        local _IIIIIllIlI = Tabs["VIP"] and _lIlIIlIlll == Tabs["VIP"].frame
        if not _IIIIIllIlI then
            _IlIIlIlIIl:SetAttribute("288RedirectToVip", true)
            table.insert(_IlIllIlllI, _IlIIlIlIIl)
            _IlIIlIlIIl.Active = true
            _IlIIlIlIIl.Selectable = true
            pcall(function() _IlIIlIlIIl.Interactable = true end)
        else
            _IlIIlIlIIl:SetAttribute("288VipOnly", true)
        end
    end
    _IlIIlIlIIl.MouseButton1Click:Connect(function()
        if _IlIIlIlIIl:GetAttribute("288VipOnly") and not _IllIlIIlIl then
            setTab("VIP")
            return
        end
        if _IlIIlIlIIl:GetAttribute("288MouseActionUsed") then return end

        task.defer(function()
            if not _IlIIlIlIIl.Parent or _IlIIlIlIIl:GetAttribute("288SilentNotification") then return end
            if _IlIIlIlIIl:GetAttribute("288VipOnly") and not _IllIlIIlIl then return end
            if _IlIIlIlIIl:GetAttribute("288RequiresTarget")
                and not _lllIIIlIlI:GetPlayerByUserId(tonumber(_IlIIIlllIl.__288TargetUserId) or -1) then
                return
            end
            local _llIlIIlIlI = _lIIlIlIlII and _lIIlIlIlII[_IlIIlIlIIl]
            local _IIllIlllll = _llIlIIlIlI == nil and "Feature enabled."
                or (_llIlIIlIlI and "Feature enabled." or "Feature disabled.")
            notifyPanel(_IlIIlIlIIl.Text, _IIllIlllll, _llIlIIlIlI == false and "warning" or "success")
        end)
    end)
    return _IlIIlIlIIl
end

function makeSectionLabel(_lIlIIlIlll, _llIlllIIII, _IllIIllllI, _lllIlIlllI)
    local _IllIIlIlll = Instance.new("TextLabel")
    _IllIIlIlll.AutoLocalize     = false
    _IllIIlIlll.Size             = UDim2.new(1, -_IllIIllllI*2, 0, 20)
    _IllIIlIlll.Position         = UDim2.new(0, _IllIIllllI, 0, _lllIlIlllI)
    _IllIIlIlll.BackgroundTransparency = 1
    _IllIIlIlll.Text             = _IlIlllIlII(string.upper(_llIlllIIII))
    _IllIIlIlll.TextColor3       = _lIIlIlIlIl
    _IllIIlIlll.TextTransparency = 0.12
    _IllIIlIlll.TextSize         = 10
    _IllIIlIlll.Font             = Enum.Font.GothamBold
    _IllIIlIlll.TextXAlignment   = Enum.TextXAlignment.Left
    _IllIIlIlll.ZIndex           = 4
    _IllIIlIlll.Parent           = _lIlIIlIlll
    _lIIlIlIllI(_IllIIlIlll, "TextColor3", "textDim")
    return _IllIIlIlll
end

function makeInput(_lIlIIlIlll, _llIlllIlIl, _IllIIllllI, _lllIlIlllI, _lIllIIllll, _lIIIIllllI)
    local _IllIIIlIII = Instance.new("TextBox")
    _IllIIIlIII.AutoLocalize     = false
    _IllIIIlIII.Size             = UDim2.new(0, _lIllIIllll or BTN_W, 0, _lIIIIllllI or BTN_H)
    _IllIIIlIII.Position         = UDim2.new(0, _IllIIllllI, 0, _lllIlIlllI)
    _IllIIIlIII.BackgroundColor3 = _lIIlIIlIlI
    _IllIIIlIII.BackgroundTransparency = 0.14
    _IllIIIlIII.BorderSizePixel  = 0
    _IllIIIlIII.Text             = ""
    _IllIIIlIII.PlaceholderText  = _IlIlllIlII(_llIlllIlIl)
    _IllIIIlIII.PlaceholderColor3= _lIIIlIlIIl
    _IllIIIlIII.TextColor3       = _llIIIIIIIl
    _IllIIIlIII.TextSize         = 12
    _IllIIIlIII.Font             = Enum.Font.Gotham
    _IllIIIlIII.TextXAlignment   = Enum.TextXAlignment.Center
    _IllIIIlIII.ZIndex           = 4
    _IllIIIlIII.Parent           = _lIlIIlIlll
    Instance.new("UICorner", _IllIIIlIII).CornerRadius = UDim.new(0, 11)
    _lIIlIlIllI(_IllIIIlIII, "BackgroundColor3", "btn")
    _lIIlIlIllI(_IllIIIlIII, "TextColor3", "text")
    local _IllIIIlIll = Instance.new("UIStroke")
    _IllIIIlIll.Color = _llIIllllll
    _IllIIIlIll.Transparency = 0.40
    _IllIIIlIll.Thickness = 1
    _IllIIIlIll.Parent = _IllIIIlIII
    return _IllIIIlIII
end

_lIIlIlIlII = _lIIlIlIlII or {}
toggleIcons = toggleIcons or {}
function makeToggleButton(_lIlIIlIlll, _llIlllIIII, _IllIIllllI, _lllIlIlllI, _lIllIIllll, _lIIIIllllI, vipOnly)
    local _IlIIlIlIIl = makeButton(_lIlIIlIlll, _llIlllIIII, _IllIIllllI, _lllIlIlllI, _lIllIIllll, _lIIIIllllI, vipOnly)
    _lIIlIlIlII[_IlIIlIlIIl] = false
    local _lIIIIlIIII = Instance.new("ImageLabel")
    _lIIIIlIIII.Name = "ToggleAsset"
    _lIIIIlIIII.Position = UDim2.new(0, _IllIIllllI + (_lIllIIllll or BTN_W) + GAP, 0, _lllIlIlllI + ((_lIIIIllllI or BTN_H) - DOT_SIZE) / 2)
    _lIIIIlIIII.Size = UDim2.fromOffset(DOT_SIZE, DOT_SIZE)
    _lIIIIlIIII.BackgroundTransparency = 1
    _lIIIIlIIII.BorderSizePixel = 0
    _lIIIIlIIII.Image = _lIIIlllIIl
    _lIIIIlIIII.ImageColor3 = _lIllIIlllI
    _lIIIIlIIII.ScaleType = Enum.ScaleType.Fit
    _lIIIIlIIII.ZIndex = _IlIIlIlIIl.ZIndex + 1
    _lIIIIlIIII.Parent = _lIlIIlIlll
    toggleIcons[_IlIIlIlIIl] = _lIIIIlIIII
    _IlIIlIlIIl.MouseButton1Click:Connect(function()
        if _IlIIlIlIIl:GetAttribute("288VipOnly") and not _IllIlIIlIl then return end
        local _IIlIlIIIIl = not _lIIlIlIlII[_IlIIlIlIIl]
        _lIIlIlIlII[_IlIIlIlIIl] = _IIlIlIIIIl
        _IlIIlIlIIl.BackgroundColor3 = _IIlIlIIIIl and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
        _lIIIIlIIII.ImageColor3 = _IIlIlIIIIl and _IlIlIlIlII or _lIllIIlllI
    end)
    return _IlIIlIlIIl
end

function makeStatusDot(_lIlIIlIlll, _IllIIllllI, _lllIlIlllI, _IIIIIlIIII)
    _IIIIIlIIII = _IIIIIlIIII or DOT_SIZE
    local _IlIllIlIIl = Instance.new("ImageLabel")
    _IlIllIlIIl.Name = "ToggleAsset"
    _IlIllIlIIl.Size = UDim2.new(0, _IIIIIlIIII, 0, _IIIIIlIIII)
    _IlIllIlIIl.Position = UDim2.new(0, _IllIIllllI, 0, _lllIlIlllI)
    _IlIllIlIIl.BackgroundTransparency = 1
    _IlIllIlIIl.BorderSizePixel = 0
    _IlIllIlIIl.Image = _lIIIlllIIl
    _IlIllIlIIl.ImageColor3 = _lIllIIlllI
    _IlIllIlIIl.ScaleType = Enum.ScaleType.Fit
    _IlIllIlIIl.ZIndex = 5
    _IlIllIlIIl.Parent = _lIlIIlIlll
    local _lIIIIlllIl = {}
    function _lIIIIlllIl.setActive(_IIlIlIIIIl)
        _IlIllIlIIl.ImageColor3 = _IIlIlIIIIl and _IlIlIlIlII or _lIllIIlllI
    end
    _lIIIIlllIl.instance = _IlIllIlIIl
    return _lIIIIlllIl
end

function makeMouseDot(_lIlIIlIlll, _IllIIllllI, _lllIlIlllI, _IIIIIlIIII, _lIIlIIllII)
    _IIIIIlIIII = _IIIIIlIIII or DOT_SIZE
    local _IllIlllIIl = _llllIIlllI(_lIlIIlIlll, "mouse", _IllIIllllI, _lllIlIlllI, _IIIIIlIIII, _lIIlIlIlIl)
    if _lIIlIIllII then
        _lIIlIIllII:SetAttribute("288MouseAction", true)
        _lIIIIIlIlI[_lIIlIIllII] = _IllIlllIIl
    end
    return _IllIlllIIl
end

TAG_MAX_DISTANCE = 30

function createBillboard(_IIIllIllII, _IIlIIlIlll, _lIIlIIlIII, remoteVisible, _IlIlIllIII)
    if not _IIIllIllII then return end
    if _lIlIllllII then return end

    _IIlIIlIlll = _IIlIIlIlll or "User"
    local _llIIIlIIll, _IlIllllIIl = _IlIlIlllII(_IIlIIlIlll, _IlIlIllIII or _IIIIlIllIl)
    local _lIlIIlllIl = _IIIllIllII:FindFirstChild("288TagGui", true)
    if _lIlIIlllIl then _lIlIIlllIl:Destroy() end
    local _llIllIIllI = _IIIllIllII:FindFirstChild("288TagSupport")
    if _llIllIIllI then _llIllIIllI:Destroy() end

    -- User nÃ£o possui cargo/tag. Ao remover o cargo no Discord, a API muda
    -- o rank para User e esta chamada elimina imediatamente a Billboard antiga.
    -- Todo usuario recebe uma tag ao executar o painel, inclusive rank User.
    if not _IlllIIIlIl then return end
    if remoteVisible == false then return end

    local _IIIIlIlIIl = _IIIllIllII:FindFirstChild("Head") or _IIIllIllII:WaitForChild("Head", 5)
    if not _IIIIlIlIIl or not _IIIIlIlIIl:IsA("BasePart") then return end

    local _IlIlllIIlI = _IlIllllIIl or _lllIlllIlI[_IIlIIlIlll] or _lllIlllIlI.User
    local _IIIIlIlIlI = _IllIIIIIII(_lIIlIIlIII)

    local _lIlIlIlIII = Instance.new("BillboardGui")
    _lIlIlIlIII.Name = "288TagGui"
    _lIlIlIlIII.Size = UDim2.new(0, 220, 0, 30)
    _lIlIlIlIII.AutoLocalize = false

    -- MantÃ©m a tag prÃ³xima da cabeÃ§a.
    -- A elevaÃ§Ã£o extra com o zoom Ã© propositalmente pequena.
    local _llIllIIIIl = (_IIIIlIlIIl.Size.Y * 0.5 + 0.72) * 2

    local _IIlIlllIlI = 0.32
    _lIlIlIlIII.Adornee = _IIIIlIlIIl
    _lIlIlIlIII.StudsOffsetWorldSpace = Vector3.new(0, _llIllIIIIl, 0)

    _lIlIlIlIII.AlwaysOnTop = true
    _lIlIlIlIII.ResetOnSpawn = false
    _lIlIlIlIII.MaxDistance = TAG_MAX_DISTANCE
    _lIlIlIlIII.LightInfluence = 0
    _lIlIlIlIII.Parent = _IIIIlIlIIl

    -- Container central para rank + Ã­cone.
    -- AutomaticSize evita que nomes de ranks maiores puxem o conjunto para um lado.
    local _lIIllIIIII = Instance.new("Frame")
    _lIIllIIIII.Name = "CenteredTagContent"
    _lIIllIIIII.AnchorPoint = Vector2.new(0.5, 0.5)
    _lIIllIIIII.Position = UDim2.new(0.5, 0, 0.5, 0)
    _lIIllIIIII.Size = UDim2.new(0, 0, 0, 26)
    _lIIllIIIII.AutomaticSize = Enum.AutomaticSize.X
    _lIIllIIIII.BackgroundTransparency = 1
    _lIIllIIIII.BorderSizePixel = 0
    _lIIllIIIII.Parent = _lIlIlIlIII

    local _lllIllIIlI = Instance.new("UIListLayout")
    _lllIllIIlI.FillDirection = Enum.FillDirection.Horizontal
    _lllIllIIlI.HorizontalAlignment = Enum.HorizontalAlignment.Center
    _lllIllIIlI.VerticalAlignment = Enum.VerticalAlignment.Center
    _lllIllIIlI.SortOrder = Enum.SortOrder.LayoutOrder
    _lllIllIIlI.Padding = UDim.new(0, 5)
    _lllIllIIlI.Parent = _lIIllIIIII

    local _IllIIlIlll = Instance.new("TextLabel")
    _IllIIlIlll.Name = "TagText"
    _IllIIlIlll.LayoutOrder = 1
    _IllIIlIlll.Size = UDim2.new(0, 0, 0, 26)
    _IllIIlIlll.AutomaticSize = Enum.AutomaticSize.X
    _IllIIlIlll.BackgroundTransparency = 1
    _IllIIlIlll.BorderSizePixel = 0
    _IllIIlIlll.Text = _llIIIlIIll
    _IllIIlIlll.TextColor3 = _IlIlllIIlI
    _IllIIlIlll.TextTransparency = 0
    _IllIIlIlll.AutoLocalize = false

    -- Bold + contorno de contraste para legibilidade em qualquer cenÃ¡rio.
    local _lIllIlllIl = _IlIlllIIlI.R * 0.299 + _IlIlllIIlI.G * 0.587 + _IlIlllIIlI.B * 0.114
    _IllIIlIlll.TextStrokeColor3 = _lIllIlllIl < 0.5
        and Color3.fromRGB(255, 255, 255)
        or Color3.fromRGB(0, 0, 0)
    _IllIIlIlll.TextStrokeTransparency = 0
    _IllIIlIlll.TextSize = 14
    _IllIIlIlll.Font = _lIIllllIlI(_IIlIIlIlll)
    _IllIIlIlll.TextXAlignment = Enum.TextXAlignment.Center
    _IllIIlIlll.TextYAlignment = Enum.TextYAlignment.Center
    _IllIIlIlll.Parent = _lIIllIIIII

    local _IIlllIIllI = Instance.new("Frame")
    _IIlllIIllI.Name = "PlatformIconSlot"
    _IIlllIIllI.LayoutOrder = 2
    _IIlllIIllI.Size = UDim2.new(0, 16, 0, 16)
    _IIlllIIllI.BackgroundTransparency = 1
    _IIlllIIllI.BorderSizePixel = 0
    _IIlllIIllI.Parent = _lIIllIIIII

    local _IlllIIIIlI = Color3.fromRGB(0, 0, 0)
    local _IllllllIlI = _llllIIlllI(_IIlllIIllI, _IIIIlIlIlI, 0, 0, 16, _IlllIIIIlI)
    _IllllllIlI.Name = "PlatformIcon"

    -- CompensaÃ§Ã£o leve conforme a cÃ¢mera se afasta.
    -- A tag sobe no mÃ¡ximo 0.32 stud, entÃ£o nunca "descola" muito da cabeÃ§a.
    task.spawn(function()
        while _lIlIlIlIII.Parent and _IIIIlIlIIl.Parent do
            local _IllIIlIllI = workspace.CurrentCamera
            if _IllIIlIllI then
                local _llllllIIIl = (_IllIIlIllI.CFrame.Position - _IIIIlIlIIl.Position).Magnitude
                local _IIIIllIlll = math.clamp((_llllllIIIl - 8) / 22, 0, 1)
                local _lIIIlIIlII = _IIlIlllIlI * _IIIIllIlll
                _lIlIlIlIII.StudsOffsetWorldSpace = Vector3.new(0, _llIllIIIIl + _lIIIlIIlII, 0)
            end
            _IllIllIIII.RenderStepped:Wait()
        end
    end)

    if _lIIlIllIIl[_IIlIIlIlll] then
        -- Mantem a tag base igual as demais e desenha somente o reflexo por cima.
        local _IIIIlllIlI = Instance.new("TextLabel")
        _IIIIlllIlI.Name = "MirrorReflection"
        _IIIIlllIlI.Size = UDim2.fromScale(1, 1)
        _IIIIlllIlI.Position = UDim2.fromScale(0, 0)
        _IIIIlllIlI.BackgroundTransparency = 1
        _IIIIlllIlI.BorderSizePixel = 0
        _IIIIlllIlI.Text = _llIIIlIIll
        _IIIIlllIlI.TextColor3 = Color3.fromRGB(255, 255, 255)
        _IIIIlllIlI.TextTransparency = 0
        _IIIIlllIlI.TextStrokeTransparency = 1
        _IIIIlllIlI.TextSize = _IllIIlIlll.TextSize
        _IIIIlllIlI.Font = _lIIllllIlI(_IIlIIlIlll)
        _IIIIlllIlI.TextXAlignment = _IllIIlIlll.TextXAlignment
        _IIIIlllIlI.TextYAlignment = _IllIIlIlll.TextYAlignment
        _IIIIlllIlI.AutoLocalize = false
        _IIIIlllIlI.ZIndex = _IllIIlIlll.ZIndex + 1
        _IIIIlllIlI.Parent = _IllIIlIlll

        local _lIIIlIIlll = Instance.new("UIGradient")
        _lIIIlIIlll.Name = "MirrorShine"
        _lIIIlIIlll.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        _lIIIlIIlll.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.38, 1),
            NumberSequenceKeypoint.new(0.47, 0.35),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(0.53, 0.35),
            NumberSequenceKeypoint.new(0.62, 1),
            NumberSequenceKeypoint.new(1, 1),
        })
        _lIIIlIIlll.Offset = Vector2.new(-1.25, 0)
        _lIIIlIIlll.Rotation = 0
        _lIIIlIIlll.Parent = _IIIIlllIlI

        task.spawn(function()
            while _lIlIlIlIII.Parent and _IllIIlIlll.Parent and _IIIIlllIlI.Parent do
                _lIIIlIIlll.Offset = Vector2.new(-1.25, 0)
                local _lIIIIlIIIl = _lllIllIlIl:Create(
                    _lIIIlIIlll,
                    TweenInfo.new(2.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                    {Offset = Vector2.new(1.25, 0)}
                )
                _lIIIIlIIIl:Play()
                _lIIIIlIIIl.Completed:Wait()
                task.wait(1)
            end
        end)
    end
    return _lIlIlIlIII
end

function setupOwnTag(_IIlIIlIlll)
    _lIIIIlIIlI = _IIlIIlIlll or _lIIIIlIIlI or "User"
    local _IllIllIlII = _IlllllllII.Character or _IlllllllII.CharacterAdded:Wait()
    createBillboard(_IllIllIlII, _lIIIIlIIlI, _llllIlllIl)
    _IIIIIIlIlI(_IlllllllII.CharacterAdded, function(_lIIlIIllll)
        task.wait(1)
        if _IlllIIIlIl then
            createBillboard(_lIIlIIllll, _lIIIIlIIlI, _llllIlllIl, true)
        end

        local _lIlIIIlIlI = _lIIlIIllll:FindFirstChild("288Tag") or Instance.new("StringValue")
        _lIlIIIlIlI.Name = "288Tag"
        _lIlIIIlIlI.Value = _lIIIIlIIlI
        _lIlIIIlIlI.Parent = _lIIlIIllll

        local _IIlIIIlIll = _lIIlIIllll:FindFirstChild("288Device") or Instance.new("StringValue")
        _IIlIIIlIll.Name = "288Device"
        _IIlIIIlIll.Value = _llllIlllIl
        _IIlIIIlIll.Parent = _lIIlIIllll

        local _lllllIlllI = _lIIlIIllll:FindFirstChild("288TagVisible") or Instance.new("BoolValue")
        _lllllIlllI.Name = "288TagVisible"
        _lllllIlllI.Value = _IlllIIIlIl
        _lllllIlllI.Parent = _lIIlIIllll
    end)
end

activeServerProfiles = {}

function monitorOtherPlayers()
    local _llIIlIIIIl = {}

    local function _lIIIIIIlIl(_IIIllIllII)
        if not _IIIllIllII then return end
        local _llllIIllII = _IIIllIllII:FindFirstChild("288TagGui", true)
        if _llllIIllII then _llllIIllII:Destroy() end
        local _IllIllIIlI = _IIIllIllII:FindFirstChild("288TagSupport")
        if _IllIllIIlI then _IllIllIIlI:Destroy() end
    end

    local function _IlIlIIllII(_IIlIIIlIIl)
        if not _IIlIIIlIIl or _IIlIIIlIIl == _IlllllllII then return end
        local _IllIllIlII = _IIlIIIlIIl.Character
        if not _IllIllIlII then return end

        if not _IlllIIIlIl then
            _lIIIIIIlIl(_IllIllIlII)
            return
        end

        -- A API Ã© a fonte de verdade para visibilidade/rank/device entre clientes.
        local _IIIllllIlI = activeServerProfiles[tostring(_IIlIIIlIIl.UserId)]
        if _IIIllllIlI then
            local _IIIIllIIll = _IIIllllIlI.tagVisible ~= false
            if _IIIIllIIll then
                createBillboard(
                    _IllIllIlII,
                    _IIIllllIlI.rank or "User",
                    _IIIllllIlI.device or "desktop",
                    true,
                    _IIIllllIlI.customTag
                )
            else
                _lIIIIIIlIl(_IllIllIlII)
            end
            return
        end

        -- Fallback para o modelo antigo caso a API esteja indisponÃ­vel.
        _lIIIIIIlIl(_IllIllIlII)
    end

    local function _lIlIllIlII(_IIlIIIlIIl)
        if not _IIlIIIlIIl or _IIlIIIlIIl == _IlllllllII or _llIIlIIIIl[_IIlIIIlIIl] then return end
        _llIIlIIIIl[_IIlIIIlIIl] = true

        _IIIIIIlIlI(_IIlIIIlIIl.CharacterAdded, function()
            task.wait(1)
            _IlIlIIllII(_IIlIIIlIIl)
        end)

        task.spawn(function()
            while _lIlllIlIlI.Parent and _IIlIIIlIIl.Parent == _lllIIIlIlI do
                _IlIlIIllII(_IIlIIIlIIl)
                task.wait(5)
            end
            _llIIlIIIIl[_IIlIIIlIIl] = nil
        end)
    end

    for _llIIIIIIII, _IIlIIIlIIl in ipairs(_lllIIIlIlI:GetPlayers()) do
        _lIlIllIlII(_IIlIIIlIIl)
    end
    _IIIIIIlIlI(_lllIIIlIlI.PlayerAdded, _lIlIllIlII)

    task.spawn(function()
        while _lIlllIlIlI.Parent and not _lIlIllllII do
            local _lIlIIIIIII = "/session/active?game=" .. _IIlIlIllll:UrlEncode(tostring(game.PlaceId))
                .. "&server=" .. _IIlIlIllll:UrlEncode(tostring(game.JobId))
            local _llllllllII = _llllIlllII(_lIlIIIIIII)
            if _llllllllII and type(_llllllllII.players) == "table" then
                local _IIIIIIlllI = {}
                for _llIIIIIIII, _IIIllllIlI in ipairs(_llllllllII.players) do
                    _IIIIIIlllI[tostring(_IIIllllIlI.userid)] = _IIIllllIlI
                end
                activeServerProfiles = _IIIIIIlllI
                for _llIIIIIIII, _IIllIlIlII in ipairs(_lllIIIlIlI:GetPlayers()) do
                    if _IIllIlIlII ~= _IlllllllII then _IlIlIIllII(_IIllIlIlII) end
                end
            end
            task.wait(5)
        end
    end)
end

function setAllRenderedTagsVisible(_IIIIllIIll)
    _IlllIIIlIl = _IIIIllIIll == true

    if not _IlllIIIlIl then
        for _llIIIIIIII, _IIlIIIlIIl in ipairs(_lllIIIlIlI:GetPlayers()) do
            local _IllIllIlII = _IIlIIIlIIl.Character
            if _IllIllIlII then
                local _llllIIllII = _IllIllIlII:FindFirstChild("288TagGui", true)
                if _llllIIllII then _llllIIllII:Destroy() end
                local _IllIllIIlI = _IllIllIlII:FindFirstChild("288TagSupport")
                if _IllIllIIlI then _IllIllIIlI:Destroy() end
            end
        end
    else
        local _lIlIllIIll = _IlllllllII.Character
        if _lIlIllIIll then
            createBillboard(_lIlIllIIll, _lIIIIlIIlI, _llllIlllIl, true)
        end
    end
end

function broadcastOwnTag(_IIlIIlIlll)
    local _IllIllIlII = _IlllllllII.Character
    if not _IllIllIlII then return end
    local _llIIIlIIll, _llIIIIIIII = _IlIlIlllII(_IIlIIlIlll, _IIIIlIllIl)
    local _lIlIIIIIIl = _IllIllIlII:FindFirstChild("288Tag")
    if not _lIlIIIIIIl then
        _lIlIIIIIIl = Instance.new("StringValue")
        _lIlIIIIIIl.Name   = "288Tag"
        _lIlIIIIIIl.Parent = _IllIllIlII
    end
    _lIlIIIIIIl.Value = _llIIIlIIll

    local _IIllIllIlI = _IllIllIlII:FindFirstChild("288Device")
    if not _IIllIllIlI then
        _IIllIllIlI = Instance.new("StringValue")
        _IIllIllIlI.Name = "288Device"
        _IIllIllIlI.Parent = _IllIllIlII
    end
    _IIllIllIlI.Value = _llllIlllIl

    local _lllllIlllI = _IllIllIlII:FindFirstChild("288TagVisible")
    if not _lllllIlllI then
        _lllllIlllI = Instance.new("BoolValue")
        _lllllIlllI.Name = "288TagVisible"
        _lllllIlllI.Parent = _IllIllIlII
    end
    _lllllIlllI.Value = _IlllIIIlIl
end

task.spawn(function()
    local _IllIllIlII = _IlllllllII.Character or _IlllllllII.CharacterAdded:Wait()
    task.wait(1)
    if _lIlIllllII then return end
    setupOwnTag("User")
    broadcastOwnTag("User")
    monitorOtherPlayers()
end)

-- Sincroniza diretamente o rank local. Isso garante a troca imediata da TAG
-- mesmo quando um executor falha temporariamente ao enviar heartbeat por POST.
task.spawn(function()
    while _lIlllIlIlI.Parent and not _lIlIllllII do
        local _IIIllllIlI = _llllIlllII("/user/" .. tostring(_IlllllllII.UserId))
        if _IIIllllIlI and _IIIllllIlI.rank then
            _lIIIIlIIlI = _IIIllllIlI.rank
            _IIIIllIIIl(_lIIIIlIIlI, _IIIllllIlI.vip)
            if type(updateOwnerOnlyTabs) == "function" then updateOwnerOnlyTabs() end
        end

        -- A manutencao da tag local nao depende da API. Se o jogo destruir a
        -- Billboard ou o suporte, ela volta enquanto o olho estiver aberto.
        local _IIIllIllII = _IlllllllII.Character
        local _IllIllllll = _IIIllIllII and _IIIllIllII:FindFirstChild("288TagGui", true)
        local _lIllIIIIIl = _IllIllllll and _IllIllllll:FindFirstChild("TagText", true)
        local _IllIIIIlII = _lIllIIIIIl and _lIllIIIIIl.Text == _lIIIIlIIlI
        if _IIIllIllII and _IlllIIIlIl and (not _IllIllllll or not _IllIIIIlII) then
            broadcastOwnTag(_lIIIIlIIlI)
            createBillboard(_IIIllIllII, _lIIIIlIIlI, _llllIlllIl, true, _IIIIlIllIl)
        end
        task.wait(1)
    end
end)

-- ==================== HOME TAB ====================
HomeUI = {}
do
    local _IllllIllll = Tabs["Home"].frame

    -- Avatar animado (ViewportFrame) para exibir o personagem em 3D
    local _lllllllllI = Instance.new("Frame")
    _lllllllllI.Name = "ProfileCard"
    _lllllllllI.Size = UDim2.new(1, -32, 0, 112)
    _lllllllllI.Position = UDim2.new(0, 16, 0, 14)
    _lllllllllI.BackgroundColor3 = _llIIIIIlIl
    _lllllllllI.BackgroundTransparency = 0.18
    _lllllllllI.BorderSizePixel = 0
    _lllllllllI.ZIndex = 3
    _lllllllllI.Parent = _IllllIllll
    Instance.new("UICorner", _lllllllllI).CornerRadius = UDim.new(0, 16)
    _llllIIlllI(_lllllllllI, "home", 14, 14, 18, _lIIlIlIlIl)
    local _IllIlllIII = Instance.new("UIStroke")
    _IllIlllIII.Color = _llIIllllll
    _IllIlllIII.Transparency = 0.56
    _IllIlllIII.Thickness = 1
    _IllIlllIII.Parent = _lllllllllI

    local _lIllllIlll = 14
    local _llllIlIlII = 14
    local _lllIlllIII = 84
    local _IlIIIIllll = 84
    local _IIIIlIlllI = 16
    local _IIllIIlIII = _lIllllIlll + _lllIlllIII + _IIIIlIlllI
    local _lIlIlllIll = 148
    local _llIllIIIll = math.max(72, _lllllllllI.AbsoluteSize.X - _IIllIIlIII - _lIlIlllIll)

    local _IIIlIIlIll = Instance.new("ViewportFrame")
    _IIIlIIlIll.Name = "HomeAvatarViewport"
    _IIIlIIlIll.Size = UDim2.new(0, _lllIlllIII, 0, _IlIIIIllll)
    _IIIlIIlIll.Position = UDim2.new(0, _lIllllIlll, 0, _llllIlIlII)
    _IIIlIIlIll.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    _IIIlIIlIll.BorderSizePixel = 0
    _IIIlIIlIll.Ambient = Color3.fromRGB(185, 185, 185)
    _IIIlIIlIll.LightColor = Color3.fromRGB(255, 255, 255)
    _IIIlIIlIll.LightDirection = Vector3.new(-1, -1, -1)
    _IIIlIIlIll.ZIndex = 4
    _IIIlIIlIll.Parent = _lllllllllI
    _lIIlIlIllI(_IIIlIIlIll, "BackgroundColor3", "btn")

    local _IllIlIlIll = Instance.new("UICorner")
    _IllIlIlIll.CornerRadius = UDim.new(0, 14)
    _IllIlIlIll.Parent = _IIIlIIlIll

    local _IllllllIIl = Instance.new("UIStroke")
    _IllllllIIl.Color = _lIIlIlIlIl
    _IllllllIIl.Transparency = 0.48
    _IllllllIIl.Thickness = 1
    _IllllllIIl.Parent = _IIIlIIlIll

    local _IIIllIIlII = Instance.new("WorldModel")
    _IIIllIIlII.Parent = _IIIlIIlIll

    local _IllIlIIIIl = Instance.new("Camera")
    _IllIlIIIIl.FieldOfView = 28
    _IllIlIIIIl.Parent = _IIIlIIlIll
    _IIIlIIlIll.CurrentCamera = _IllIlIIIIl

    local _lllIllIIIl = 0
    local function _lIllllIlIl(_IIIllIllII)
        _lllIllIIIl = _lllIllIIIl + 1
        local _IlIlIlIllI = _lllIllIIIl

        for _llIIIIIIII, child in ipairs(_IIIllIIlII:GetChildren()) do
            child:Destroy()
        end

        if not _IIIllIllII then return end
        local _IIlIllIIll = _IIIllIllII.Archivable
        _IIIllIllII.Archivable = true
        local _lllIllIllI, _IlIlIIIIlI = pcall(function()
            return _IIIllIllII:Clone()
        end)
        _IIIllIllII.Archivable = _IIlIllIIll
        if not _lllIllIllI or not _IlIlIIIIlI then return end

        _IlIlIIIIlI.Name = "AvatarPreview"
        for _llIIIIIIII, _lIIllIIlll in ipairs(_IlIlIIIIlI:GetDescendants()) do
            if _lIIllIIlll:IsA("Script") or _lIIllIIlll:IsA("LocalScript") then
                _lIIllIIlll:Destroy()
            elseif _lIIllIIlll:IsA("BasePart") then
                _lIIllIIlll.Anchored = true
                _lIIllIIlll.CanCollide = false
                _lIIllIIlll.CanTouch = false
                _lIIllIIlll.CanQuery = false
            end
        end

        _IlIlIIIIlI.Parent = _IIIllIIlII
        _IlIlIIIIlI:PivotTo(CFrame.new(0, 0, 0))

        local _IIIIIIIllI, _IIIIIlIIII = _IlIlIIIIlI:GetBoundingBox()
        local _lIIllIlIll = _IIIIIIIllI.Position.Y + _IIIIIlIIII.Y * 0.05
        local _lIIIIlIlII = math.max(_IIIIIlIIII.X, _IIIIIlIIII.Y, _IIIIIlIIII.Z)
        local _llllllIIIl = math.max(4.5, _lIIIIlIlII * 1.65)

        -- Roblox characters face toward -Z by default.
        -- Put the preview camera on the -Z side so the avatar is shown from the front.
        _IllIlIIIIl.CFrame = CFrame.lookAt(
            Vector3.new(0, _lIIllIlIll + 0.15, -_llllllIIIl),
            Vector3.new(0, _lIIllIlIll, 0)
        )

        task.spawn(function()
            local _llIlIlIIlI = 0
            while _IlIlIlIllI == _lllIllIIIl and _IIIlIIlIll.Parent and _IlIlIIIIlI.Parent do
                _llIlIlIIlI = _llIlIlIIlI + _IllIllIIII.RenderStepped:Wait()
                local _IlllIlllII = math.rad(math.sin(_llIlIlIIlI * 0.9) * 8)
                local _llIlIllIll = math.sin(_llIlIlIIlI * 1.8) * 0.045
                local _IIIIIlIIIl = math.rad(math.sin(_llIlIlIIlI * 1.3) * 1.8)
                _IlIlIIIIlI:PivotTo(
                    CFrame.new(0, _llIlIllIll, 0)
                    * CFrame.Angles(0, _IlllIlllII, _IIIIIlIIIl)
                )
            end
        end)
    end

    task.spawn(function()
        local _IllIllIlII = _IlllllllII.Character or _IlllllllII.CharacterAdded:Wait()
        task.wait(0.25)
        _lIllllIlIl(_IllIllIlII)
    end)

    _IIIIIIlIlI(_IlllllllII.CharacterAdded, function(_IllIllIlII)
        task.wait(0.5)
        _lIllllIlIl(_IllIllIlII)
    end)

    local _lllllIIIlI = Instance.new("TextLabel")
    _lllllIIIlI.Size             = UDim2.new(0, _llIllIIIll, 0, 28)
    _lllllIIIlI.Position         = UDim2.new(0, _IIllIIlIII, 0, 27)
    _lllllIIIlI.BackgroundTransparency = 1
    _lllllIIIlI.Text             = "Hello, " .. _IlllllllII.DisplayName .. "."
    _lllllIIIlI.TextColor3       = _llIIIIIIIl
    _lllllIIIlI.TextSize         = 16
    _lllllIIIlI.Font             = Enum.Font.GothamBold
    _lllllIIIlI.TextXAlignment   = Enum.TextXAlignment.Left
    _lllllIIIlI.TextTruncate     = Enum.TextTruncate.AtEnd
    _lllllIIIlI.ZIndex           = 4
    _lllllIIIlI.Parent           = _IllllIllll
    _lIIlIlIllI(_lllllIIIlI, "TextColor3", "text")

    local _IIlIllllII = Instance.new("TextLabel")
    _IIlIllllII.Size             = UDim2.new(0, _llIllIIIll, 0, 38)
    _IIlIllllII.Position         = UDim2.new(0, _IIllIIlIII, 0, 57)
    _IIlIllllII.BackgroundTransparency = 1
    _IIlIllllII.Text             = "Press " .. "<b>[" .. tostring((Panel.Settings.keybinds or {}).panel or "B") .. "]</b>" .. " to\nopen/close the panel"
    _IIlIllllII.TextColor3       = _lIIIlIlIIl
    _IIlIllllII.TextSize         = 12
    _IIlIllllII.Font             = Enum.Font.Gotham
    _IIlIllllII.TextXAlignment   = Enum.TextXAlignment.Left
    _IIlIllllII.TextWrapped      = true
    _IIlIllllII.RichText         = true
    _IIlIllllII.ZIndex           = 4
    _IIlIllllII.Parent           = _IllllIllll
    _lIIlIlIllI(_IIlIllllII, "TextColor3", "textDim")

    -- Controle global de tags: olho aberto = compartilhar/visualizar tags.
    local _IlllIIIIll = Instance.new("TextButton")
    _IlllIIIIll.Name = "TagVisibilityButton"
    _IlllIIIIll.Size = UDim2.new(0, 34, 0, 34)
    _IlllIIIIll.Position = UDim2.new(1, -50, 1, -46)
    _IlllIIIIll.BackgroundColor3 = _lIIlIIlIlI
    _IlllIIIIll.BackgroundTransparency = 1
    _IlllIIIIll.BorderSizePixel = 0
    _IlllIIIIll.Text = ""
    _IlllIIIIll.AutoButtonColor = false
    _IlllIIIIll.ZIndex = 10
    _IlllIIIIll.Parent = _IllllIllll

    local _lIIllllllI = Instance.new("UIStroke")
    _lIIllllllI.Color = _lIIlIlIlIl
    _lIIllllllI.Transparency = 1
    _lIIllllllI.Thickness = 1
    _lIIllllllI.Parent = _IlllIIIIll
    _lIIlIlIllI(_lIIllllllI, "Color", "accent")

    local _lIllIIllII = "rbxassetid://73369893606288"
    local _llllIIIIII  = "rbxassetid://103674160315643"

    local _IIIIllllII = nil
    local function _lllllIlIll()
        if _IIIIllllII then
            _IIIIllllII:Destroy()
            _IIIIllllII = nil
        end

        _IIIIllllII = Instance.new("ImageLabel")
        _IIIIllllII.Name = "TagVisibilityAssetIcon"
        _IIIIllllII.AnchorPoint = Vector2.new(0.5, 0.5)
        _IIIIllllII.Position = UDim2.new(0.5, 0, 0.5, 0)
        _IIIIllllII.Size = UDim2.new(0, 28, 0, 28)
        _IIIIllllII.BackgroundTransparency = 1
        _IIIIllllII.BorderSizePixel = 0
        _IIIIllllII.Image = _IlllIIIlIl and _llllIIIIII or _lIllIIllII
        _IIIIllllII.ImageColor3 = _lIIlIlIlIl
        _IIIIllllII.ScaleType = Enum.ScaleType.Fit
        _IIIIllllII.ZIndex = _IlllIIIIll.ZIndex + 3
        _IIIIllllII.Parent = _IlllIIIIll

        _lIIllllllI.Color = _lIIlIlIlIl
        _IlllIIIIll.BackgroundTransparency = 1
    end

    _lllllIlIll()
    _llIlIIIlII(_IlllIIIIll, false)

    _IlllIIIIll.MouseButton1Click:Connect(function()
        setAllRenderedTagsVisible(not _IlllIIIlIl)
        broadcastOwnTag(_lIIIIlIIlI)
        _lllllIlIll()

        task.spawn(function()
            _IIIIIlIlII("/user/preference", {
                userid = _IlllllllII.UserId,
                tagVisible = _IlllIIIlIl,
            })
        end)
    end)

    local function _IIllIlllII(_lIlIIIIlll)
        _lIlIIIIlll.BackgroundColor3 = _lIIlIIlIlI
        _lIlIIIIlll.BackgroundTransparency = 0.16
        _lIlIIIIlll.BorderSizePixel = 0
        Instance.new("UICorner", _lIlIIIIlll).CornerRadius = UDim.new(0, 14)
        local _lllllIIlIl = Instance.new("UIStroke")
        _lllllIIlIl.Color = _llIIllllll
        _lllllIIlIl.Transparency = 0.62
        _lllllIIlIl.Thickness = 1
        _lllllIIlIl.Parent = _lIlIIIIlll
    end

    local _IlIllIIIlI = Instance.new("Frame")
    _IlIllIIIlI.Name = "HomeStatsRow"
    _IlIllIIIlI.Size = UDim2.new(1, -32, 0, 64)
    _IlIllIIIlI.Position = UDim2.new(0, 16, 0, 140)
    _IlIllIIIlI.BackgroundTransparency = 1
    _IlIllIIIlI.ZIndex = 4
    _IlIllIIIlI.Parent = _IllllIllll

    local _lIIlIlIIll = Instance.new("UIGridLayout")
    _lIIlIlIIll.Name = "StatsGrid"
    _lIIlIlIIll.SortOrder = Enum.SortOrder.LayoutOrder
    _lIIlIlIIll.FillDirection = Enum.FillDirection.Horizontal
    _lIIlIlIIll.FillDirectionMaxCells = 4
    _lIIlIlIIll.CellPadding = UDim2.fromOffset(8, 0)
    _lIIlIlIIll.CellSize = UDim2.new(0.25, -6, 1, 0)
    _lIIlIlIIll.Parent = _IlIllIIIlI

    local function _IIIlIIIlIl(_llIIlllIll, _llIIllIIIl, _llllllllIl, _llIIlIllII, _lIlIIIllll)
        local _lIlIIIIlll = Instance.new("Frame")
        _lIlIIIIlll.Size = UDim2.new(0, 0, 0, 64)
        _lIlIIIIlll.LayoutOrder = _llIIllIIIl
        _lIlIIIIlll.ZIndex = 4
        _lIlIIIIlll.Parent = _IlIllIIIlI
        _IIllIlllII(_lIlIIIIlll)

        local _lIIllIllll = Instance.new("TextLabel")
        _lIIllIllll.Size = UDim2.new(1, -16, 0, 16)
        _lIIllIllll.Position = UDim2.new(0, 8, 0, 7)
        _lIIllIllll.BackgroundTransparency = 1
        _lIIllIllll.Text = _llIIlllIll
        _lIIllIllll.TextColor3 = _lIIIlIlIIl
        _lIIllIllll.TextSize = 10
        _lIIllIllll.Font = Enum.Font.GothamBold
        _lIIllIllll.TextXAlignment = Enum.TextXAlignment.Left
        _lIIllIllll.ZIndex = 5
        _lIIllIllll.Parent = _lIlIIIIlll
        _lIIlIlIllI(_lIIllIllll, "TextColor3", "textDim")

        local _IllIlIIlll = Instance.new("TextLabel")
        _IllIlIIlll.Size = UDim2.new(1, -16, 0, 24)
        _IllIlIIlll.Position = UDim2.new(0, 8, 0, 29)
        _IllIlIIlll.BackgroundTransparency = 1
        _IllIlIIlll.Text = _llIIlIllII or "--"
        _IllIlIIlll.TextColor3 = _llllllllIl or _llIIIIIIIl
        _IllIlIIlll.TextSize = _lIlIIIllll or 18
        _IllIlIIlll.Font = Enum.Font.GothamBold
        _IllIlIIlll.TextXAlignment = Enum.TextXAlignment.Left
        _IllIlIIlll.TextTruncate = Enum.TextTruncate.AtEnd
        _IllIlIIlll.ZIndex = 5
        _IllIlIIlll.Parent = _lIlIIIIlll
        return _IllIlIIlll
    end

    local _IllIIlIIlI = _IIIlIIIlIl("PING", 1, _lIIlIlIlIl)
    local _IlIlIllllI = _IIIlIIIlIl("ONLINE", 2, Color3.fromRGB(80, 220, 100))
    local _IlIIIIlIII = _IIIlIIIlIl("USERS", 3, _llIIIIIIIl)
    local _IlIlIlIIll = _IIIlIIIlIl("EXECUTOR", 4, _llIIIIIIIl, _lIIIIIllll, 13)
    _IllIIlIIlI.Text = "-- ms"

    local _IIIlIIIlII = Instance.new("TextLabel")
    _IIIlIIIlII.Size             = UDim2.new(1, -32, 0, 40)
    _IIIlIIIlII.Position         = UDim2.new(0, 16, 0, 216)
    local _lIIlllIllI = "SESSION"
    local _lIllllIIlI = utf8.char(0x2022)
    _IIIlIIIlII.Text             = _lIIlllIllI .. "  " .. _lIllllIIlI .. "  --"
    _IIIlIIIlII.TextColor3       = _lIIlIlIlIl
    _IIIlIIIlII.TextSize         = 11
    _IIIlIIIlII.Font             = Enum.Font.GothamMedium
    _IIIlIIIlII.TextXAlignment   = Enum.TextXAlignment.Center
    _IIIlIIIlII.ZIndex           = 4
    _IIIlIIIlII.Parent           = _IllllIllll
    _IIllIlllII(_IIIlIIIlII)

    local _IllllIIIII = Instance.new("TextButton")
    _IllllIIIII.Name = "DiscordLinkButton"
    _IllllIIIII.Size = UDim2.new(0, 116, 0, 32)
    _IllllIIIII.Position = UDim2.new(1, -130, 0, 46)
    _IllllIIIII.BackgroundColor3 = _lIIlIlIlIl
    _IllllIIIII.BorderSizePixel = 0
    _IllllIIIII.Text = "Vincular Discord"
    _IllllIIIII.TextColor3 = Color3.fromRGB(255, 255, 255)
    _IllllIIIII.TextSize = 11
    _IllllIIIII.Font = Enum.Font.GothamSemibold
    _IllllIIIII.AutoButtonColor = false
    _IllllIIIII.ZIndex = 8
    _IllllIIIII.Parent = _lllllllllI
    Instance.new("UICorner", _IllllIIIII).CornerRadius = UDim.new(0, 10)
    _llIlIIIlII(_IllllIIIII, true)
    _lIIlIlIllI(_IllllIIIII, "BackgroundColor3", "accent")

    local _lIIllIIlIl = nil
    _IllllIIIII.MouseButton1Click:Connect(function()
        if not _lIlIllIllI then
            notifyPanel("Discord", "Aguarde a sessÃ£o do Panel iniciar.", "warning", 4)
            return
        end
        _IllllIIIII.Text = "Gerando cÃ³digo..."
        local _lllIlIIlII = _IIIIIlIlII("/link/start", { userid = _IlllllllII.UserId, sessionId = _lIlIllIllI })
        if not _lllIlIIlII then
            _IllllIIIII.Text = "Vincular Discord"
            notifyPanel("Discord", "NÃ£o foi possÃ­vel gerar o cÃ³digo de vÃ­nculo.", "error", 5)
            return
        end
        if _lllIlIIlII.linked then
            _IllllIIIII.Text = "Discord jÃ¡ vinculado"
            notifyPanel("Discord", "Esta conta Roblox jÃ¡ possui um Discord vinculado.", "success", 5)
            return
        end
        local _llllllllll = tostring(_lllIlIIlII.command or ("!vincular " .. tostring(_lllIlIIlII.code or "")))
        _lIIllIIlIl = tostring(_lllIlIIlII.requestToken or "")
        _IllllIIIII.Text = _llllllllll
        if setclipboard then pcall(setclipboard, _llllllllll) end
        notifyPanel("Discord", "Comando copiado. Envie no servidor: " .. _llllllllll, "success", 8)

        local _IlIlIlIllI = _lIIllIIlIl
        task.spawn(function()
            while _lIIllIIlIl == _IlIlIlIllI and os.time() * 1000 < tonumber(_lllIlIIlII.expiresAt or 0) do
                task.wait(3)
                local _lllIIlllIl = _IIIIIlIlII("/link/status", { userid = _IlllllllII.UserId, requestToken = _IlIlIlIllI })
                if _lllIIlllIl and _lllIIlllIl.linked then
                    _lIIllIIlIl = nil
                    _IllllIIIII.Text = "Discord vinculado"
                    notifyPanel("Discord", "Conta Discord vinculada com sucesso.", "success", 6)
                    return
                elseif _lllIIlllIl and _lllIIlllIl.expired then
                    break
                end
            end
            if _lIIllIIlIl == _IlIlIlIllI then
                _lIIllIIlIl = nil
                _IllllIIIII.Text = "Gerar novo cÃ³digo"
                notifyPanel("Discord", "O cÃ³digo expirou. Gere um novo para tentar novamente.", "warning", 5)
            end
        end)
    end)

    HomeUI.pingVal = _IllIIlIIlI
    HomeUI.onlineValue = _IlIlIllllI
    HomeUI.executorValue = _IlIlIlIIll
    HomeUI.usersValue = _IlIIIIlIII
    HomeUI.dateLabel = _IIIlIIIlII
    HomeUI.sessionTitle = _lIIlllIllI
    HomeUI.sessionSeparator = _lIllllIIlI

    local function _IIIIlIllII()
        if not _lIlllIlIlI.Parent then return end
        local _llIIllIllI, _IlllllIIlI = pcall(function()
            return _IlllllllII:GetNetworkPing() * 1000
        end)
        _IlllllIIlI = _llIIllIllI and _IlllllIIlI or 0
        _IllIIlIIlI.Text = math.floor(_IlllllIIlI + 0.5) .. " ms"

        -- Cor dinÃ¢mica do ping:
        -- verde = Ã³timo, amarelo = mÃ©dio, laranja = alto, vermelho = ruim
        if _IlllllIIlI < 80 then
            _IllIIlIIlI.TextColor3 = Color3.fromRGB(80, 220, 100)
        elseif _IlllllIIlI < 150 then
            _IllIIlIIlI.TextColor3 = Color3.fromRGB(255, 200, 70)
        elseif _IlllllIIlI < 250 then
            _IllIIlIIlI.TextColor3 = Color3.fromRGB(255, 145, 65)
        else
            _IllIIlIIlI.TextColor3 = Color3.fromRGB(255, 85, 100)
        end
    end

    local function _IIlllllIll()
        if not _lIlllIlIlI.Parent then return end

        local _IlIlIlIIlI = _llllIlllII("/stats")
        if _IlIlIlIIlI then
            _IlIlIllllI.Text = tostring(_IlIlIlIIlI.online or _IlIlIlIIlI.activeSessions or "--")
            _IlIlIllllI.TextColor3 = Color3.fromRGB(80, 220, 100)
            _IlIIIIlIII.Text  = tostring(_IlIlIlIIlI.totalUsers or "--")
        end

        local _llIlIlIIlI = os.date("*t")
        _IIIlIIIlII.Text = string.format(
            _lIIlllIllI .. "  " .. _lIllllIIlI .. "  %02d/%02d/%04d  %02d:%02d",
            _llIlIlIIlI.day, _llIlIlIIlI.month, _llIlIlIIlI.year, _llIlIlIIlI.hour, _llIlIlIIlI.min
        )
    end

    -- Ping visual em tempo real, separado das chamadas HTTP da Home.
    task.spawn(function()
        while _lIlllIlIlI.Parent and not _lIlIllllII do
            _IIIIlIllII()
            task.wait(0.15)
        end
    end)

    -- Stats remotos continuam em intervalo seguro.
    task.spawn(function() _IIlllllIll() while task.wait(30) do if not _lIlllIlIlI.Parent or _lIlIllllII then break end _IIlllllIll() end end)
    -- SYSTEM HEALTH: largura limitada para nunca invadir o botÃ£o Eye do Home.
    -- ContentFrame = 488px; o Eye ocupa a faixa direita inferior. Reservamos essa Ã¡rea.
    local _IIIlIlIIlI = Instance.new("Frame")
    _IIIlIlIIlI.Name = "SystemHealth"
    _IIIlIlIIlI.Size = UDim2.new(1, -88, 0, 70)
    _IIIlIlIIlI.Position = UDim2.new(0, 16, 0, 268)
    _IIIlIlIIlI.BackgroundColor3 = _lIIlIIlIlI
    _IIIlIlIIlI.BackgroundTransparency = 0.12
    _IIIlIlIIlI.BorderSizePixel = 0
    _IIIlIlIIlI.ClipsDescendants = true
    _IIIlIlIIlI.ZIndex = 4
    _IIIlIlIIlI.Parent = _IllllIllll
    Instance.new("UICorner", _IIIlIlIIlI).CornerRadius = UDim.new(0, 14)
    local _llIIlIlIll = Instance.new("UIStroke", _IIIlIlIIlI)
    _llIIlIlIll.Color = _llIIllllll
    _llIIlIlIll.Transparency = 0.58
    _llIIlIlIll.Thickness = 1
    _lIIlIlIllI(_IIIlIlIIlI, "BackgroundColor3", "surface2")

    local _lllIIIlIll = Instance.new("TextLabel", _IIIlIlIIlI)
    _lllIIIlIll.Size = UDim2.new(1, -24, 0, 15)
    _lllIIIlIll.Position = UDim2.new(0, 12, 0, 6)
    _lllIIIlIll.BackgroundTransparency = 1
    _lllIIIlIll.Text = "SYSTEM HEALTH"
    _lllIIIlIll.TextColor3 = _lIIIlIlIIl
    _lllIIIlIll.TextSize = 8
    _lllIIIlIll.Font = Enum.Font.GothamBold
    _lllIIIlIll.TextXAlignment = Enum.TextXAlignment.Left
    _lllIIIlIll.ZIndex = 5
    _lIIlIlIllI(_lllIIIlIll, "TextColor3", "textDim")

    -- Row com padding real. A fÃ³rmula abaixo garante que a Ãºltima cÃ©lula termine
    -- exatamente no limite interno, sem overflow independente da escala do painel.
    local _lIllIIIIlI = Instance.new("Frame", _IIIlIlIIlI)
    _lIllIIIIlI.Name = "HealthItems"
    _lIllIIIIlI.Size = UDim2.new(1, -20, 0, 39)
    _lIllIIIIlI.Position = UDim2.new(0, 10, 0, 24)
    _lIllIIIIlI.BackgroundTransparency = 1
    _lIllIIIIlI.BorderSizePixel = 0
    _lIllIIIIlI.ClipsDescendants = true
    _lIllIIIIlI.ZIndex = 5

    local _lIllIlllll = {}
    local _IlIIIIIlIl = {
        {_IllllllIll="api", _lIllllIIIl="API"},
        {_IllllllIll="session", _lIllllIIIl="SESSION"},
        {_IllllllIll="latency", _lIllllIIIl="LATENCY"},
        {_IllllllIll="modules", _lIllllIIIl="MODULES"},
    }
    local _IllIllIlll = 6
    -- (W - 3*gap)/4 = 25% de W - 4.5px
    local _lIlIlIIlII = -(_IllIllIlll * 3) / 4
    for _lllllIlIIl, def in ipairs(_IlIIIIIlIl) do
        local _IlllIlIIII = Instance.new("Frame", _lIllIIIIlI)
        _IlllIlIIII.Name = def.key .. "Health"
        _IlllIlIIII.Size = UDim2.new(0.25, _lIlIlIIlII, 1, 0)
        -- posiÃ§Ã£o = (i-1)*(W/4 + gap/4), fecha exatamente em W no quarto item
        _IlllIlIIII.Position = UDim2.new((_lllllIlIIl - 1) * 0.25, (_lllllIlIIl - 1) * (_IllIllIlll / 4), 0, 0)
        _IlllIlIIII.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
        _IlllIlIIII.BackgroundTransparency = 0.30
        _IlllIlIIII.BorderSizePixel = 0
        _IlllIlIIII.ClipsDescendants = true
        _IlllIlIIII.ZIndex = 5
        Instance.new("UICorner", _IlllIlIIII).CornerRadius = UDim.new(0, 9)
        _lIIlIlIllI(_IlllIlIIII, "BackgroundColor3", "btn")

        local _IlIllIlIIl = Instance.new("Frame", _IlllIlIIII)
        _IlIllIlIIl.Name = "StatusDot"
        _IlIllIlIIl.Size = UDim2.fromOffset(5, 5)
        _IlIllIlIIl.Position = UDim2.new(0, 8, 0, 8)
        _IlIllIlIIl.BackgroundColor3 = Color3.fromRGB(125, 125, 135)
        _IlIllIlIIl.BorderSizePixel = 0
        _IlIllIlIIl.ZIndex = 6
        Instance.new("UICorner", _IlIllIlIIl).CornerRadius = UDim.new(1, 0)
        _IlIllIlIIl:SetAttribute("PreserveThemeColor", true)

        local _lIllllIIIl = Instance.new("TextLabel", _IlllIlIIII)
        _lIllllIIIl.Size = UDim2.new(1, -19, 0, 11)
        _lIllllIIIl.Position = UDim2.new(0, 17, 0, 4)
        _lIllllIIIl.BackgroundTransparency = 1
        _lIllllIIIl.Text = def.label
        _lIllllIIIl.TextColor3 = _lIIIlIlIIl
        _lIllllIIIl.TextSize = 7
        _lIllllIIIl.Font = Enum.Font.GothamBold
        _lIllllIIIl.TextXAlignment = Enum.TextXAlignment.Left
        _lIllllIIIl.TextTruncate = Enum.TextTruncate.AtEnd
        _lIllllIIIl.ZIndex = 6
        _lIIlIlIllI(_lIllllIIIl, "TextColor3", "textDim")

        local _IlIlIlIlll = Instance.new("TextLabel", _IlllIlIIII)
        _IlIlIlIlll.Size = UDim2.new(1, -14, 0, 14)
        _IlIlIlIlll.Position = UDim2.new(0, 7, 0, 19)
        _IlIlIlIlll.BackgroundTransparency = 1
        _IlIlIlIlll.Text = "--"
        _IlIlIlIlll.TextColor3 = _llIIIIIIIl
        _IlIlIlIlll.TextSize = 8
        _IlIlIlIlll.Font = Enum.Font.GothamMedium
        _IlIlIlIlll.TextXAlignment = Enum.TextXAlignment.Left
        _IlIlIlIlll.TextTruncate = Enum.TextTruncate.AtEnd
        _IlIlIlIlll.ZIndex = 6
        _lIIlIlIllI(_IlIlIlIlll, "TextColor3", "text")

        _lIllIlllll[def.key] = {_IlIllIlIIl=_IlIllIlIIl, _IlIlIlIlll=_IlIlIlIlll}
    end

    local _lllIlIlIll = Color3.fromRGB(65, 220, 135)
    local _IIIIIlIlIl = Color3.fromRGB(255, 190, 70)
    local _IIIIlIllll = Color3.fromRGB(245, 82, 98)
    local _IIIlIIIIlI = Color3.fromRGB(125, 125, 135)

    local function _IlIIlIllll(_IlIIllIIIl, _llIlllIIII, _IlIlllIIlI)
        if not _IlIIllIIIl then return end
        _IlIIllIIIl.value.Text = tostring(_llIlllIIII or "--")
        _IlIIllIIIl.dot.BackgroundColor3 = _IlIlllIIlI or _IIIlIIIIlI
    end

    local function _llIlllIIll()
        if Panel.State.apiOnline then
            _IlIIlIllll(_lIllIlllll.api, "Online", _lllIlIlIll)
        elseif Panel.State.offlineMode then
            _IlIIlIllll(_lIllIlllll.api, "Offline", _IIIIlIllll)
        else
            _IlIIlIllll(_lIllIlllll.api, "Checking", _IIIIIlIlIl)
        end

        _IlIIlIllll(_lIllIlllll.session, Panel.State.sessionConnected and "Connected" or "Disconnected", Panel.State.sessionConnected and _lllIlIlIll or _IIIlIIIIlI)

        local _lIlllIIlIl = tonumber(Panel.State.lastApiLatencyMs)
        if _lIlllIIlIl then
            local _lIIlllIIII = _lIlllIIlIl < 180 and _lllIlIlIll or (_lIlllIIlIl < 450 and _IIIIIlIlIl or _IIIIlIllll)
            _IlIIlIllll(_lIllIlllll.latency, tostring(math.floor(_lIlllIIlIl + 0.5)) .. " ms", _lIIlllIIII)
        else
            _IlIIlIllll(_lIllIlllll.latency, "-- ms", _IIIlIIIIlI)
        end

        local _llIIIlIllI, _lIlIllIIII = 0, 0
        for _llIIIIIIII, _lIlIlllIII in pairs(Panel.Runtime.modules or {}) do
            _llIIIlIllI += 1
            if _lIlIlllIII.status == "ERROR" then _lIlIllIIII += 1 end
        end
        if _lIlIllIIII > 0 then
            _IlIIlIllll(_lIllIlllll.modules, tostring(_llIIIlIllI) .. " / " .. tostring(_lIlIllIIII) .. " err", _IIIIlIllll)
        else
            _IlIIlIllll(_lIllIlllll.modules, tostring(_llIIIlIllI) .. " loaded", _llIIIlIllI > 0 and _lllIlIlIll or _IIIlIIIIlI)
        end
    end

    HomeUI.healthItems = _lIllIlllll
    HomeUI.refreshHealth = _llIlllIIll
    _llIlllIIll()
    task.spawn(function()
        while _lIlllIlIlI.Parent and not _lIlIllllII do
            _llIlllIIll()
            task.wait(1)
        end
    end)
    refreshCanvas(_IllllIllll)
end

-- ==================== VIP TAB ====================
do
    local _IllllIllll = Tabs["VIP"].frame
    local _lllIlIlllI = 10
    local _llIlIllIlI = {
        {"Fling", 1},
        {"AntiFling", 2, true}
    }
    for _llIIIIIIII, _lIlIIIIIIl in ipairs(_llIlIllIlI) do
        local _IIlIllIIII, _IlIlIIIIll = gridSlot(_lIlIIIIIIl[2], _lllIlIlllI)
        local _IlIIlIlIIl = makeToggleButton(_IllllIllll, _lIlIIIIIIl[1], _IIlIllIIII, _IlIlIIIIll, BTN_W, BTN_H, false)
        table.insert(_IlIllIlllI, _IlIIlIlIIl)
        _IlIIlIlIIl.Active = _IllIlIIlIl
        _IlIIlIlIIl.Selectable = _IllIlIIlIl
        _IlIIlIlIIl.BackgroundColor3 = Color3.fromRGB(28,28,28)
        _IlIIlIlIIl.TextColor3       = Color3.fromRGB(120,120,120)
        _IlIIlIlIIl.TextTransparency = 0.3
        _IlIIlIlIIl.MouseButton1Click:Connect(function()
            if not _IllIlIIlIl then return end
            local _llllIlIIIl = _lIlIIIIIIl[1]:gsub("%s+", "")
            loadModule("modules/VIP/" .. _llllIlIIIl)
        end)
        _llllllIIlI("VIP/" .. _lIlIIIIIIl[1], function()
            if _lIIlIlIlII[_IlIIlIlIIl] then
                loadModule("modules/VIP/" .. _lIlIIIIIIl[1]:gsub("%s+", ""))
            end
        end)
    end
    local _IIIIIIIIIl = Instance.new("Frame")
    _IIIIIIIIIl.Name             = "VipLockOverlay"
    _IIIIIIIIIl.Size             = UDim2.new(1,0,1,0)
    _IIIIIIIIIl.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].main
    _IIIIIIIIIl.BackgroundTransparency = 0.12
    _IIIIIIIIIl.BorderSizePixel  = 0
    _IIIIIIIIIl.Active           = true
    _IIIIIIIIIl.ZIndex           = 6
    _IIIIIIIIIl.Parent           = _IllllIllll
    _llIlllIlll = _IIIIIIIIIl
    _IIIIllIIIl(_lIIIIlIIlI, _IllIlIIlIl)
    local _lIIlllIlIl = Instance.new("TextLabel")
    _lIIlllIlIl.Size = UDim2.new(1, -28, 0, 38)
    _lIIlllIlIl.Position = UDim2.new(0, 14, 0, 16)
    _lIIlllIlIl.BackgroundTransparency = 1
    _lIIlllIlIl.Text = "Acesso VIP"
    _lIIlllIlIl.TextColor3 = _llIIIIIIIl
    _lIIlllIlIl.TextSize = 27
    _lIIlllIlIl.Font = Enum.Font.GothamBold
    _lIIlllIlIl.TextXAlignment = Enum.TextXAlignment.Center
    _lIIlllIlIl.ZIndex = 7
    _lIIlllIlIl.Parent = _IIIIIIIIIl

    local _IIIllIlIll = Instance.new("TextLabel")
    _IIIllIlIll.Size = UDim2.new(1, -36, 0, 28)
    _IIIllIlIll.Position = UDim2.new(0, 18, 0, 56)
    _IIIllIlIll.BackgroundTransparency = 1
    _IIIllIlIll.Text = "Entre no Discord para falar com o suporte e acessar os recursos VIP."
    _IIIllIlIll.TextColor3 = _lIIIlIlIIl
    _IIIllIlIll.TextSize = 12
    _IIIllIlIll.Font = Enum.Font.Gotham
    _IIIllIlIll.TextWrapped = true
    _IIIllIlIll.TextXAlignment = Enum.TextXAlignment.Center
    _IIIllIlIll.ZIndex = 7
    _IIIllIlIll.Parent = _IIIIIIIIIl

    local _IIlIIllIIl = Instance.new("TextButton")
    _IIlIIllIIl.Name = "VipSupportButton"
    _IIlIIllIIl.Size = UDim2.new(0, 220, 0, 36)
    _IIlIIllIIl.Position = UDim2.new(0.5, -110, 0, 185)
    _IIlIIllIIl.BackgroundColor3 = _lIIlIlIlIl
    _IIlIIllIIl.BorderSizePixel = 0
    _IIlIIllIIl.Text = "Discord de Suporte"
    _IIlIIllIIl.TextColor3 = Color3.fromRGB(255, 255, 255)
    _IIlIIllIIl.TextSize = 12
    _IIlIIllIIl.Font = Enum.Font.GothamSemibold
    _IIlIIllIIl.AutoLocalize = false
    _IIlIIllIIl.AutoButtonColor = false
    _IIlIIllIIl.ZIndex = 8
    _IIlIIllIIl.Parent = _IIIIIIIIIl
    Instance.new("UICorner", _IIlIIllIIl).CornerRadius = UDim.new(0, 10)
    _llIlIIIlII(_IIlIIllIIl, true)
    _lIIlIlIllI(_IIlIIllIIl, "BackgroundColor3", "accent")
    _IIlIIllIIl.MouseButton1Click:Connect(function()
        local _IIlIIlllIl = pcall(function() _lIllIlllII:OpenBrowserWindow(_lllllllIIl) end)
        if not _IIlIIlllIl then
            pcall(function() setclipboard(_lllllllIIl) end)
            notifyPanel("Discord", "Convite de suporte copiado.", "success", 5)
        end
    end)

    local _lllIIIIIll = Instance.new("TextButton")
    _lllIIIIIll.Name = "VipThemePicker"
    _lllIllllII = _lllIIIIIll
    _lllIIIIIll.Visible = _IllIlIIlIl
    _lllIIIIIll.Size = UDim2.new(0, 34, 0, 34)
    _lllIIIIIll.Position = UDim2.new(1, -44, 1, -44)
    _lllIIIIIll.BackgroundColor3 = _lIIlIIlIlI
    _lllIIIIIll.BackgroundTransparency = 1
    _lllIIIIIll.BorderSizePixel = 0
    _lllIIIIIll.Text = ""
    _lllIIIIIll.AutoButtonColor = false
    _lllIIIIIll.ZIndex = 8
    _lllIIIIIll.Parent = _IllllIllll
    local _IIIlllIIIl = Instance.new("UIStroke")
    _IIIlllIIIl.Color = _lIIlIlIlIl
    _IIIlllIIIl.Transparency = 1
    _IIIlllIIIl.Parent = _lllIIIIIll
    _lIIlIlIllI(_IIIlllIIIl, "Color", "accent")
    local _IIIIllIIII = Instance.new("ImageLabel")
    _IIIIllIIII.Name = "VipThemeBrushAssetIcon"
    _IIIIllIIII.AnchorPoint = Vector2.new(0.5, 0.5)
    _IIIIllIIII.Position = UDim2.new(0.5, 0, 0.5, 0)
    _IIIIllIIII.Size = UDim2.new(0, 28, 0, 28)
    _IIIIllIIII.BackgroundTransparency = 1
    _IIIIllIIII.BorderSizePixel = 0
    _IIIIllIIII.Image = "rbxassetid://6953987987"
    _IIIIllIIII.ImageColor3 = _lIIlIlIlIl
    _IIIIllIIII.ScaleType = Enum.ScaleType.Fit
    _IIIIllIIII.ZIndex = _lllIIIIIll.ZIndex + 3
    _IIIIllIIII.Parent = _lllIIIIIll
    _lIIlIlIllI(_IIIIllIIII, "ImageColor3", "accent")

    _llIlIIIlII(_lllIIIIIll, false)
    _lIIlIlIllI(_lllIIIIIll, "BackgroundColor3", "btn")

    local _llIIIIIlll = Instance.new("Frame")
    _llIIIIIlll.Name = "ThemeModalOverlay"
    _IIIlIllIlI = _llIIIIIlll
    _llIIIIIlll.Size = UDim2.new(1, 0, 1, 0)
    _llIIIIIlll.BackgroundColor3 = Color3.fromRGB(3, 3, 6)
    _llIIIIIlll.BackgroundTransparency = 0.28
    _llIIIIIlll.BorderSizePixel = 0
    _llIIIIIlll.Visible = false
    _llIIIIIlll.ZIndex = 100
    _llIIIIIlll.Parent = MainFrame

    local _llIIllIlII = Instance.new("ImageButton")
    _llIIllIlII.Name = "DismissThemeModal"
    _llIIllIlII.Size = UDim2.new(1, 0, 1, 0)
    _llIIllIlII.BackgroundTransparency = 1
    _llIIllIlII.BorderSizePixel = 0
    _llIIllIlII.Image = ""
    _llIIllIlII.AutoButtonColor = false
    _llIIllIlII.ZIndex = 100
    _llIIllIlII.Parent = _llIIIIIlll

    local _IlIllIIlll = Instance.new("Frame")
    _IlIllIIlll.Name = "ThemeModal"
    _IlIllIIlll.AnchorPoint = Vector2.new(0.5, 0.5)
    _IlIllIIlll.Position = UDim2.new(0.5, 0, 0.5, 0)
    _IlIllIIlll.Size = UDim2.new(0, 370, 0, 268)
    _IlIllIIlll.BackgroundColor3 = _IllllIIlII.dark.main
    _IlIllIIlll.BorderSizePixel = 0
    _IlIllIIlll.ZIndex = 101
    _IlIllIIlll.Parent = _llIIIIIlll
    Instance.new("UICorner", _IlIllIIlll).CornerRadius = UDim.new(0, 18)
    local _IIlIIllIll = Instance.new("UIStroke")
    _IIlIIllIll.Color = _lIIlIlIlIl
    _IIlIIllIll.Transparency = 0.35
    _IIlIIllIll.Parent = _IlIllIIlll
    _lIIlIlIllI(_IlIllIIlll, "BackgroundColor3", "main")

    local _IIlIIIllII = Instance.new("TextLabel")
    _IIlIIIllII.Size = UDim2.new(1, -64, 0, 48)
    _IIlIIIllII.Position = UDim2.new(0, 20, 0, 4)
    _IIlIIIllII.BackgroundTransparency = 1
    _IIlIIIllII.Text = _IlIlllIlII("VIP THEMES")
    _IIlIIIllII.TextColor3 = _llIIIIIIIl
    _IIlIIIllII.TextSize = 15
    _IIlIIIllII.Font = Enum.Font.GothamBold
    _IIlIIIllII.TextXAlignment = Enum.TextXAlignment.Left
    _IIlIIIllII.ZIndex = 102
    _IIlIIIllII.Parent = _IlIllIIlll
    _lIIlIlIllI(_IIlIIIllII, "TextColor3", "text")

    local _IIIIlIlIll = Instance.new("TextButton")
    _IIIIlIlIll.Size = UDim2.new(0, 30, 0, 30)
    _IIIIlIlIll.Position = UDim2.new(1, -40, 0, 10)
    _IIIIlIlIll.BackgroundColor3 = _IllllIIlII.dark.btn
    _IIIIlIlIll.BorderSizePixel = 0
    _IIIIlIlIll.Text = ""
    _IIIIlIlIll.ZIndex = 103
    _IIIIlIlIll.Parent = _IlIllIIlll
    Instance.new("UICorner", _IIIIlIlIll).CornerRadius = UDim.new(1, 0)
    _llllIIlllI(_IIIIlIlIll, "close", 7, 7, 16, _lIIlIlIlIl)
    _lIIlIlIllI(_IIIIlIlIll, "BackgroundColor3", "btn")

    -- Claro/Noturno ficam exclusivamente no controle da aba Sobre.
    local _lIllIIlIll = {
        "ocean", "crimson", "forest",
        "sunset", "aurora", "gold",
        "roseglass", "midnightwave", "prismflow"
    }
    local _IIlIlIIllI = {}
    for _lllllIlIIl, themeName in ipairs(_lIllIIlIll) do
        local _IlllIllIll = _IllllIIlII[themeName]
        local _IIIlIIlIII = (_lllllIlIIl - 1) % 3
        local _lIIllIIIII = math.floor((_lllllIlIIl - 1) / 3)
        local _lIlIIIIlll = Instance.new("TextButton")
        _lIlIIIIlll.Name = "Theme_" .. themeName
        _lIlIIIIlll:SetAttribute("PreserveThemeColor", true)
        _lIlIIIIlll.Size = UDim2.new(0, 102, 0, 54)
        _lIlIIIIlll.Position = UDim2.new(0, 20 + _IIIlIIlIII * 112, 0, 54 + _lIIllIIIII * 64)
        _lIlIIIIlll.BackgroundColor3 = _IlllIllIll.btn
        _lIlIIIIlll.BorderSizePixel = 0
        _lIlIIIIlll.Text = ""
        _lIlIIIIlll.AutoButtonColor = false
        _lIlIIIIlll.ZIndex = 102
        _lIlIIIIlll.Parent = _IlIllIIlll
        Instance.new("UICorner", _lIlIIIIlll).CornerRadius = UDim.new(0, 12)
        local _IIlllllIlI = Instance.new("UIStroke")
        _IIlllllIlI.Color = _IlllIllIll.accent
        _IIlllllIlI.Transparency = themeName == _lIIlIIlllI and 0 or 0.68
        _IIlllllIlI.Thickness = themeName == _lIIlIIlllI and 2 or 1
        _IIlllllIlI:SetAttribute("PreserveThemeColor", true)
        _IIlllllIlI.Parent = _lIlIIIIlll
        local _lllIIlIlIl = Instance.new("Frame")
        _lllIIlIlIl.Size = UDim2.new(0, 14, 0, 20)
        _lllIIlIlIl.Position = UDim2.new(0, 10, 0.5, -10)
        _lllIIlIlIl.BackgroundColor3 = _IlllIllIll.accent
        _lllIIlIlIl.BorderSizePixel = 0
        _lllIIlIlIl.ZIndex = 103
        _lllIIlIlIl:SetAttribute("PreserveThemeColor", true)
        _lllIIlIlIl.Parent = _lIlIIIIlll
        Instance.new("UICorner", _lllIIlIlIl).CornerRadius = UDim.new(1, 0)
        if type(_IlllIllIll.gradient) == "table" then
            local _IIIlllllII = Instance.new("UIGradient")
            _IIIlllllII.Name = "ThemePreviewGradient"
            _IIIlllllII.Color = _llIllIIlII(_IlllIllIll, 0)
            _IIIlllllII.Rotation = tonumber(_IlllIllIll.gradientRotation) or 35
            _IIIlllllII.Parent = _lllIIlIlIl
        end

        local _IIllllIlIl = Instance.new("TextLabel")
        _IIllllIlIl.Size = UDim2.new(1, -36, 1, 0)
        _IIllllIlIl.Position = UDim2.new(0, 31, 0, 0)
        _IIllllIlIl.BackgroundTransparency = 1
        _IIllllIlIl.Text = _IlIlllIlII(_IlllIllIll.label)
        _IIllllIlIl.TextColor3 = _IlllIllIll.text
        _IIllllIlIl.TextSize = 10
        _IIllllIlIl.Font = Enum.Font.GothamMedium
        _IIllllIlIl.TextXAlignment = Enum.TextXAlignment.Left
        _IIllllIlIl.TextTruncate = Enum.TextTruncate.AtEnd
        _IIllllIlIl.ZIndex = 103
        _IIllllIlIl:SetAttribute("PreserveThemeColor", true)
        _IIllllIlIl.Parent = _lIlIIIIlll
        if _IlllIllIll.animated then
            local _IlIIIIllIl = Instance.new("TextLabel")
            _IlIIIIllIl.Name = "AnimatedThemeBadge"
            _IlIIIIllIl.Size = UDim2.new(0, 26, 0, 12)
            _IlIIIIllIl.Position = UDim2.new(1, -30, 0, 4)
            _IlIIIIllIl.BackgroundColor3 = _IlllIllIll.accent
            _IlIIIIllIl.BackgroundTransparency = 0.15
            _IlIIIIllIl.BorderSizePixel = 0
            _IlIIIIllIl.Text = "LIVE"
            _IlIIIIllIl.TextColor3 = Color3.new(1,1,1)
            _IlIIIIllIl.TextSize = 7
            _IlIIIIllIl.Font = Enum.Font.GothamBold
            _IlIIIIllIl.ZIndex = 104
            _IlIIIIllIl:SetAttribute("PreserveThemeColor", true)
            _IlIIIIllIl.Parent = _lIlIIIIlll
            Instance.new("UICorner", _IlIIIIllIl).CornerRadius = UDim.new(1,0)
        end
        _IIlIlIIllI[themeName] = _IIlllllIlI

        _IIIIIIlIlI(_lIlIIIIlll.MouseEnter, function()
            _lllIllIlIl:Create(_lIlIIIIlll, TweenInfo.new(0.12), {
                BackgroundColor3 = _IlllIllIll.btnHover,
            }):Play()
        end)
        _IIIIIIlIlI(_lIlIIIIlll.MouseLeave, function()
            _lllIllIlIl:Create(_lIlIIIIlll, TweenInfo.new(0.12), {
                BackgroundColor3 = _IlllIllIll.btn,
            }):Play()
        end)

        _lIlIIIIlll.MouseButton1Click:Connect(function()
            _lIIIIllIII(themeName, { userInitiated = true, persistRemote = true })
            setTab(CurrentTab)
            _IIlIIllIll.Color = _IlllIllIll.accent
            _IIIlllIIIl.Color = _IlllIllIll.accent
            for _IlIlIlllll, _lllllIIlIl in pairs(_IIlIlIIllI) do
                local _IlllIIIIIl = _IlIlIlllll == themeName
                _lllllIIlIl.Transparency = _IlllIIIIIl and 0 or 0.68
                _lllllIIlIl.Thickness = _IlllIIIIIl and 2 or 1
            end
        end)
    end

    _lllIIIIIll.MouseButton1Click:Connect(function()
        local _IlllIllIll = _IllllIIlII[_lIIlIIlllI]
        _IIlIIllIll.Color = _IlllIllIll.accent
        _IIIlllIIIl.Color = _IlllIllIll.accent
        for _IlIlIlllll, _lllllIIlIl in pairs(_IIlIlIIllI) do
            local _IlllIIIIIl = _IlIlIlllll == _lIIlIIlllI
            _lllllIIlIl.Transparency = _IlllIIIIIl and 0 or 0.68
            _lllllIIlIl.Thickness = _IlllIIIIIl and 2 or 1
        end
        _llIIIIIlll.Visible = true
    end)
    _IIIIlIlIll.MouseButton1Click:Connect(function() _llIIIIIlll.Visible = false end)
    _llIIllIlII.MouseButton1Click:Connect(function() _llIIIIIlll.Visible = false end)
    refreshCanvas(_IllllIllll)
end

-- ==================== EMPHASIS TAB ====================
do
    local _IllllIllll = Tabs["Emphasis"].frame
    local _lllIlIlllI = 10
    local _IllIIllIll = {}

    -- Mouse icon = one-time UI initializer. After initialization the module is
    -- controlled only by its own keyboard/mouse hotkeys.
    local _llIlIIlIll = {
        {_IlIlIlllll="Invisible", _llIIllIIIl=1, hint="E: para Ativar/Desativar"},
        {_IlIlIlllll="ClickTP", _llIIllIIIl=2, hint="LeftControl + MouseButton1: Teleport"},
        {_IlIlIlllll="NoClip", _llIIllIIIl=3, hint="N: para Ativar/Desativar"},
        {_IlIlIlllll="JerkOff", _llIIllIIIl=4, hint="R: para Ativar/Desativar"},
        {_IlIlIlllll="Impulse", _llIIllIIIl=5, hint="M: para Ativar"},
        {_IlIlIlllll="FaceBang", _llIIllIIIl=6, hint="Z: para Ativar/Desativar"},
        {_IlIlIlllll="Spin", _llIIllIIIl=7, hint="T: para Ativar/Desativar"},
        {_IlIlIlllll="AnimSpeed", _llIIllIIIl=8, hint="Q: Slow On/Off | E: Speed On/Off"},
        {_IlIlIlllll="feFlip", _llIIllIIIl=9, hint="X: FrontFlip | C: BackFlip"},
        {_IlIlIlllll="Flashback", _llIIllIIIl=10, hint="Segure V para retroceder"},
        {_IlIlIlllll="AntiVoid", _llIIllIIIl=11, hint="J: para Ativar/Desativar"},
    }

    for _llIIIIIIII, _lIlIIIIIIl in ipairs(_llIlIIlIll) do
        local _IIlIllIIII, _IlIlIIIIll = gridSlot(_lIlIIIIIIl.order, _lllIlIlllI)
        -- Deliberately NOT a toggle button: clicking only initializes once.
        local _IlIIlIlIIl = makeButton(_IllllIllll, _lIlIIIIIIl.name, _IIlIllIIII, _IlIlIIIIll, BTN_W, BTN_H)
        _IlIIlIlIIl.TextSize = 13
        _IlIIlIlIIl:SetAttribute("288SilentNotification", true)
        local _llIlIlIIll = (_lIlIIIIIIl.order % 2 == 1) and DOT1_X or DOT2_X
        makeMouseDot(_IllllIllll, _llIlIlIIll, _IlIlIIIIll + BTN_H/2 - DOT_SIZE/2, DOT_SIZE, _IlIIlIlIIl)

        local _IIIIlIIIll = tostring(_lIlIIIIIIl.name):gsub("%s+", "")
        local function _IlIllIllIl()
            if _IIIIlIIIll == "ClickTP" then
                return tostring((Panel.Settings.keybinds or {}).ClickTP or "LeftControl") .. " + MouseButton1: Teleport"
            end
            return _lIlIIIIIIl.hint
        end
        local _lllllllIll = {_IlIIlIlIIl=_IlIIlIlIIl, _IIIIlIIIll=_IIIIlIIIll, initialized=false, loading=false}
        _IllIIllIll[_IIIIlIIIll] = _lllllllIll

        _IlIIlIlIIl.MouseButton1Click:Connect(function()
            if not _IIIlllIllI(_IlIIlIlIIl) then return end
            if _lllllllIll.initialized or _lllllllIll.loading then
                notifyPanel(_lIlIIIIIIl.name, _IlIllIllIl(), "info", 3.5)
                return
            end
            _lllllllIll.loading = true
            task.defer(function()
                local _IIIIIlllIl = loadModule("modules/Emphasis/" .. _IIIIlIIIll)
                _lllllllIll.loading = false
                if not _IIIIIlllIl then
                    _IlIIlIlIIl.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
                    notifyPanel(_lIlIIIIIIl.name, "Falha ao inicializar o modulo.", "error", 5)
                    return
                end
                _lllllllIll.initialized = true
                _IlIIlIlIIl.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btnOn
                notifyPanel(_lIlIIIIIIl.name, _IlIllIllIl(), "info", 4)
            end)
        end)
    end

    refreshCanvas(_IllllIllll)
end

-- ==================== CHARACTER TAB ====================
do
    local _IllllIllll = Tabs["Character"].frame
    local _lllIlIlllI = 10

    local _IIIIIIIlll = 16
    local _lllIIIIlll = 50

    local _IlIIIlIIlI   = makeButton(_IllllIllll,"Walk Speed",COL1,_lllIlIlllI,BTN_W,BTN_H)
    local _llIllIlIII   = makeStatusDot(_IllllIllll, DOT1_X, _lllIlIlllI + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
    local _IllllIIIll = makeInput(_IllllIllll,"[0-n]",DOT1_X + DOT_SIZE + GAP, _lllIlIlllI, BTN_W, BTN_H)
    local _IlIIlllIll = false
    local _IlIlllllIl = false
    local function _llIIIlIlII()
        _IlIlllllIl = true
        _IlIIlllIll = not _IlIIlllIll
        _llIllIlIII.setActive(_IlIIlllIll)
        _IlIIIlIIlI.BackgroundColor3 = _IlIIlllIll and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
        _IlIIIlllIl.__288WalkSpeedValue = tonumber(_IllllIIIll.Text) or _IIIIIIIlll
        loadModule("modules/Character/WalkSpeed.lua")
    end
    _IlIIIlllIl.__288ToggleWalkSpeed = function()
        if not _IlIlllllIl then return end
        _llIIIlIlII()
    end
    _IlIIIlIIlI.MouseButton1Click:Connect(_llIIIlIlII)
    _llllllIIlI("WalkSpeed", function()
        if _IlIIlllIll then loadModule("modules/Character/WalkSpeed.lua") end
    end)
    local _IIlIlIIlIl = 0
    _IllllIIIll:GetPropertyChangedSignal("Text"):Connect(function()
        if not _IlIIlllIll then return end
        local _lIIIIlIlll = tonumber(_IllllIIIll.Text)
        if not _lIIIIlIlll then return end
        _IlIIIlllIl.__288WalkSpeedValue = _lIIIIlIlll
        _IIlIlIIlIl += 1
        local _lllIlIllII = _IIlIlIIlIl
        task.delay(0.45, function()
            if _lllIlIllII == _IIlIlIIlIl and _IlIIlllIll then
                notifyPanel("Walk Speed", "Velocidade: " .. tostring(_lIIIIlIlll), "info")
            end
        end)
    end)

    _lllIlIlllI = _lllIlIlllI + BTN_H + GAP

    local _IIllIIIllI   = makeButton(_IllllIllll,"Jump Power",COL1,_lllIlIlllI,BTN_W,BTN_H)
    local _lIIIllllII   = makeStatusDot(_IllllIllll, DOT1_X, _lllIlIlllI + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
    local _IlIIlIlIll = makeInput(_IllllIllll,"[0-n]",DOT1_X + DOT_SIZE + GAP, _lllIlIlllI, BTN_W, BTN_H)
    local _lIlIlllllI = false
    local _IIIlIllllI = false
    local function _IlIllIIIII()
        _IIIlIllllI = true
        _lIlIlllllI = not _lIlIlllllI
        _lIIIllllII.setActive(_lIlIlllllI)
        _IIllIIIllI.BackgroundColor3 = _lIlIlllllI and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
        _IlIIIlllIl.__288JumpPowerValue = tonumber(_IlIIlIlIll.Text) or _lllIIIIlll
        loadModule("modules/Character/JumpPower.lua")
    end
    _IlIIIlllIl.__288ToggleJumpPower = function()
        if not _IIIlIllllI then return end
        _IlIllIIIII()
    end
    _IIllIIIllI.MouseButton1Click:Connect(_IlIllIIIII)
    _llllllIIlI("JumpPower", function()
        if _lIlIlllllI then loadModule("modules/Character/JumpPower.lua") end
    end)
    local _lIlllIllII = 0
    _IlIIlIlIll:GetPropertyChangedSignal("Text"):Connect(function()
        if not _lIlIlllllI then return end
        local _lIIIIlIlll = tonumber(_IlIIlIlIll.Text)
        if not _lIIIIlIlll then return end
        _IlIIIlllIl.__288JumpPowerValue = _lIIIIlIlll
        _lIlllIllII += 1
        local _lllIlIllII = _lIlllIllII
        task.delay(0.45, function()
            if _lllIlIllII == _lIlllIllII and _lIlIlllllI then
                notifyPanel("Jump Power", "Potencia: " .. tostring(_lIIIIlIlll), "info")
            end
        end)
    end)

    _lllIlIlllI = _lllIlIlllI + BTN_H + GAP

    local _IIlIlllIll   = makeButton(_IllllIllll,"Fly",COL1,_lllIlIlllI,BTN_W,BTN_H)
    local _IlIlllIIIl   = makeStatusDot(_IllllIllll, DOT1_X, _lllIlIlllI + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
    local _llIIlllIII = makeInput(_IllllIllll,"[0-n]",DOT1_X + DOT_SIZE + GAP, _lllIlIlllI, BTN_W, BTN_H)
    local _IIIlIlIIIl = false
    local _lIIllIlIIl = false
    _IIlIlllIll:SetAttribute("288SilentNotification", true)
    local _lllIlIllll = 0
    _llIIlllIII:GetPropertyChangedSignal("Text"):Connect(function()
        local _lIIIIlIlll = tonumber(_llIIlllIII.Text)
        if not _lIIIIlIlll then return end
        _IlIIIlllIl.__288FlySpeed = _lIIIIlIlll
        if not _IIIlIlIIIl then return end
        _lllIlIllll += 1
        local _lllIlIllII = _lllIlIllll
        task.delay(0.45, function()
            if _lllIlIllII == _lllIlIllll and _IIIlIlIIIl then
                notifyPanel("Fly", "Velocidade: " .. tostring(_lIIIIlIlll), "info")
            end
        end)
    end)

    local function _llIIIIIIll(_llIlIIlIlI)
        _IIIlIlIIIl = _llIlIIlIlI
        _IlIlllIIIl.setActive(_IIIlIlIIIl)
        _IIlIlllIll.BackgroundColor3 = _IIIlIlIIIl and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
        loadModule("modules/Character/Fly")
    end
    _IlIIIlllIl.__288ToggleFly = function()
        if not _lIIllIlIIl then return end
        _llIIIIIIll(not _IIIlIlIIIl)
    end

    _IIlIlllIll.MouseButton1Click:Connect(function()
        _lIIllIlIIl = true
        _llIIIIIIll(not _IIIlIlIIIl)
        notifyPanel(
            "Fly",
            _IIIlIlIIIl and "F: para Ativar/Desativar" or "Status: Desativado",
            _IIIlIlIIIl and "success" or "warning"
        )
    end)
    _llllllIIlI("Fly", function()
        if _IIIlIlIIIl then loadModule("modules/Character/Fly") end
    end)

    _lllIlIlllI = _lllIlIlllI + BTN_H + GAP

    local _lllIIlIIlI = makeButton(_IllllIllll,"Respawn",COL1,_lllIlIlllI,BTN_W,BTN_H)
    local _lIllIlIlll      = makeButton(_IllllIllll,"Checkpoint",COL2,_lllIlIlllI,BTN_W,BTN_H)
    local _lIllIlIIIl      = makeStatusDot(_IllllIllll, DOT2_X, _lllIlIlllI + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
    local _IllIIIIIIl    = false
    _lllIIlIIlI.MouseButton1Click:Connect(function()
        loadModule("modules/Character/Respawn.lua")
    end)
    _lIllIlIlll.MouseButton1Click:Connect(function()
        _IllIIIIIIl = not _IllIIIIIIl
        _lIllIlIIIl.setActive(_IllIIIIIIl)
        _lIllIlIlll.BackgroundColor3 = _IllIIIIIIl and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
        loadModule("modules/Character/Checkpoint.lua")
    end)
    _llllllIIlI("Checkpoint", function()
        if _IllIIIIIIl then loadModule("modules/Character/Checkpoint.lua") end
    end)

    refreshCanvas(_IllllIllll)
end

-- ==================== TARGET TAB ====================
do
    local _IllllIllll = Tabs["Target"].frame

    local _llIllIllIl = 132; local _IIllIlIIlI = 54
    local _IlIIIIlIlI = 6
    local _llIIlIIlIl = BTN_W; local _llIlIIllII = BTN_H

    -- Avatar do target (canto esquerdo)
    local _IIIIIlIIlI = Instance.new("ImageLabel")
    _IIIIIlIIlI.Size             = UDim2.new(0, 95, 0, 95)
    _IIIIIlIIlI.Position         = UDim2.new(0, PAD, 0, _IlIIIIlIlI)
    _IIIIIlIIlI.BackgroundColor3 = Color3.fromRGB(30,30,30)
    _IIIIIlIIlI.BorderSizePixel  = 0
    _IIIIIlIIlI.Image            = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    _IIIIIlIIlI.ImageColor3      = Color3.fromRGB(90,90,90)
    _IIIIIlIIlI.ScaleType        = Enum.ScaleType.Fit
    _IIIIIlIIlI.ZIndex           = 4
    _IIIIIlIIlI.Parent           = _IllllIllll
    local _IIlIIlIlII = Instance.new("UIStroke")
    _IIlIIlIlII.Color=_llIIllllll; _IIlIIlIlII.Thickness=1; _IIlIIlIlII.Parent=_IIIIIlIIlI
    _lIIlIlIllI(_IIIIIlIIlI,"BackgroundColor3","surface2")
    _lIIlIlIllI(_IIlIIlIlII,"Color","stroke")

    -- Input e botÃ£o buscar no canto direito
    local _lllIlIIlIl = PAD + 95 + GAP
    local _IlllllIIll = 488 - _lllIlIIlIl - PAD  -- espaÃ§o disponÃ­vel para input + botÃ£o
    local _IlIIlllIlI = _IlllllIIll - BTN_H - GAP  -- BTN_H Ã© o tamanho do botÃ£o buscar

    local _llIllllIll = Instance.new("TextBox")
    _llIllllIll.Size             = UDim2.new(0, _IlIIlllIlI, 0, _llIlIIllII)
    _llIllllIll.Position         = UDim2.new(0, _lllIlIIlIl, 0, _IlIIIIlIlI)
    _llIllllIll.BackgroundColor3 = _lIIlIIlIlI
    _llIllllIll.BorderSizePixel  = 0
    _llIllllIll.Text             = ""
    _llIllllIll.PlaceholderText  = _IlIlllIlII("@username or display name...")
    _llIllllIll.PlaceholderColor3= _lIIIlIlIIl
    _llIllllIll.TextColor3       = _llIIIIIIIl
    _llIllllIll.TextSize         = 12
    _llIllllIll.Font             = Enum.Font.Gotham
    _llIllllIll.ClearTextOnFocus = false
    _llIllllIll.ZIndex           = 4
    _llIllllIll.Parent           = _IllllIllll
    Instance.new("UICorner",_llIllllIll).CornerRadius=UDim.new(0,5)
    local _IllIIIlIll = Instance.new("UIStroke")
    _IllIIIlIll.Color=_llIIllllll; _IllIIIlIll.Thickness=1; _IllIIIlIll.Parent=_llIllllIll

    -- BotÃ£o buscar
    local _IIlIIIlIII = Instance.new("TextButton")
    _IIlIIIlIII.Size             = UDim2.new(0, BTN_H, 0, BTN_H)
    _IIlIIIlIII.Position         = UDim2.new(0, _lllIlIIlIl + _IlIIlllIlI + GAP, 0, _IlIIIIlIlI)
    _IIlIIIlIII.BackgroundColor3 = _lIIlIIlIlI
    _IIlIIIlIII.BorderSizePixel  = 0
    _IIlIIIlIII.Text             = ""
    _IIlIIIlIII.TextSize         = 18
    _IIlIIIlIII.Font             = Enum.Font.Gotham
    _IIlIIIlIII.ZIndex           = 4
    _IIlIIIlIII.Parent           = _IllllIllll
    Instance.new("UICorner",_IIlIIIlIII).CornerRadius=UDim.new(0,8)
    local _IlIIlIIlII = Instance.new("UIStroke")
    _IlIIlIIlII.Color = _llIIllllll
    _IlIIlIIlII.Transparency = 0.35
    _IlIIlIIlII.Parent = _IIlIIIlIII
    _llllIIlllI(_IIlIIIlIII, "search", 8, 8, 18, _lIIlIlIlIl)
    _llIlIIIlII(_IIlIIIlIII, false)

    -- Dica inicial
    local _IlIIIlllll = Instance.new("TextLabel")
    _IlIIIlllll.Size             = UDim2.new(0, 175, 0, 32)
    _IlIIIlllll.Position         = UDim2.new(0, _lllIlIIlIl, 0, 76)
    _IlIIIlllll.BackgroundTransparency = 1
    _IlIIIlllll.Text             = "Enter a name above\nto find a player"
    _IlIIIlllll.TextColor3       = Color3.fromRGB(120,120,120)
    _IlIIIlllll.TextSize         = 11
    _IlIIIlllll.Font             = Enum.Font.Gotham
    _IlIIIlllll.TextXAlignment   = Enum.TextXAlignment.Left
    _IlIIIlllll.TextWrapped      = true
    _IlIIIlllll.ZIndex           = 4
    _IlIIIlllll.AutoLocalize     = false
    _IlIIIlllll.Parent           = _IllllIllll
    _lIIlIlIllI(_IlIIIlllll,"TextColor3","textDim")

    -- Info labels
    local function _IIIIIIllII(_llIlllIIII, _lIlIIllIII)
        local _IlIlIIIIII=Instance.new("TextLabel")
        _IlIlIIIIII.Size=UDim2.new(0, 175, 0, 17)
        _IlIlIIIIII.Position=UDim2.new(0, _lllIlIIlIl, 0, _lIlIIllIII)
        _IlIlIIIIII.BackgroundTransparency=1
        _IlIlIIIIII.Text=_llIlllIIII
        _IlIlIIIIII.TextColor3=Color3.fromRGB(185,185,185)
        _IlIlIIIIII.TextSize=11
        _IlIlIIIIII.Font=Enum.Font.Gotham
        _IlIlIIIIII.TextXAlignment=Enum.TextXAlignment.Left
        _IlIlIIIIII.ZIndex=4
        _IlIlIIIIII.Parent=_IllllIllll
        _lIIlIlIllI(_IlIlIIIIII,"TextColor3","textDim")
        return _IlIlIIIIII
    end
    local _lIlIlIlIlI = _IIIIIIllII("UserID:",  40)
    local _lIIlllIlII= _IIIIIIllII("Display:", 58)
    local _lIllIIlIIl  = _IIIIIIllII("Name:",    76)
    _lIlIlIlIlI.Visible  = false
    _lIIlllIlII.Visible = false
    _lIllIIlIIl.Visible   = false

    -- Dropdown
    local _llIllIllll   = 40
    local _lIIlIIIlll = 1
    local _lIIIlIllIl  = 6

    local _llIIlIlIIl = Instance.new("ScrollingFrame")
    _llIIlIlIIl.Size                 = UDim2.new(0, _IlIIlllIlI, 0, 0)
    _llIIlIlIIl.BackgroundColor3     = _IllllIIlII[_lIIlIIlllI].surface2
    _llIIlIlIIl.BorderSizePixel      = 0
    _llIIlIlIIl.ScrollBarThickness   = 3
    _llIIlIlIIl.ScrollBarImageColor3 = Color3.fromRGB(75,75,75)
    _llIIlIlIIl.CanvasSize           = UDim2.new(0,0,0,0)
    _llIIlIlIIl.ZIndex               = 50
    _llIIlIlIIl.Visible              = false
    _llIIlIlIIl.ClipsDescendants     = true
    _llIIlIlIIl.Parent               = _lIlllIlIlI
    Instance.new("UICorner",_llIIlIlIIl).CornerRadius=UDim.new(0,6)
    local _lIIIIIIIll=Instance.new("UIStroke")
    _lIIIIIIIll.Color=_IllllIIlII[_lIIlIIlllI].stroke; _lIIIIIIIll.Thickness=1; _lIIIIIIIll.Parent=_llIIlIlIIl
    _lIIlIlIllI(_llIIlIlIIl,"BackgroundColor3","surface2")
    _lIIlIlIllI(_lIIIIIIIll,"Color","stroke")

    local _IIllllllII=Instance.new("UIListLayout")
    _IIllllllII.SortOrder=Enum.SortOrder.LayoutOrder
    _IIllllllII.Padding=UDim.new(0,_lIIlIIIlll)
    _IIllllllII.Parent=_llIIlIlIIl

    local function _llIllIIIII()
        local _IlllIlIlll = _llIllllIll.AbsolutePosition
        local _IIIIIlIIII = _llIllllIll.AbsoluteSize
        _llIIlIlIIl.Position = UDim2.fromOffset(_IlllIlIlll.X, _IlllIlIlll.Y + _IIIIIlIIII.Y + 2)
        _llIIlIlIIl.Size = UDim2.fromOffset(_IIIIIlIIII.X, _llIIlIlIIl.AbsoluteSize.Y)
    end
    _IIIIIIlIlI(MainFrame:GetPropertyChangedSignal("AbsolutePosition"), function()
        if _llIIlIlIIl.Visible then _llIllIIIII() end
    end)
    _IIIIIIlIlI(_llIllllIll:GetPropertyChangedSignal("AbsoluteSize"), function()
        if _llIIlIlIIl.Visible then _llIllIIIII() end
    end)

    local _IIIllIIlll = {}

    -- BotÃµes de aÃ§Ã£o
    local _lIIlIlIlll = {
        {_IlIlIlllll="View", _llIIllIIIl=1}, {_IlIlIlllll="Focus", _llIIllIIIl=2},
        {_IlIlIlllll="Follow", _llIIllIIIl=3}, {_IlIlIlllll="Stand", _llIIllIIIl=4},
        {_IlIlIlllll="Bang", _llIIllIIIl=5}, {_IlIlIlllll="Drag", _llIIllIIIl=6},
        {_IlIlIlllll="Headsit", _llIIllIIIl=7}, {_IlIlIlllll="Doggy", _llIIllIIIl=8},
        {_IlIlIlllll="Backpack", _llIIllIIIl=9},
        {_IlIlIlllll="CopyID", _llIIllIIIl=10, instant=true}, {_IlIlIlllll="Bring", _llIIllIIIl=11, instant=true}, {_IlIlIlllll="Teleport", _llIIllIIIl=12, instant=true},
    }
    local _IllllIIIIl = 108
    local _IlllIIllII = nil
    local _IllIIIllll = {}
    local _llllllIIII = false
    local _llIIIIlIII = false
    local _IIlllIlllI = {
        Focus = true, Follow = true, Stand = true, Bang = true,
        Drag = true, Headsit = true, Doggy = true, Backpack = true,
    }

    local function _lIllIlIllI()
        local _IIIllIllII = _IlllllllII.Character
        local _lIIIIIIIII = _IIIllIllII and _IIIllIllII:FindFirstChildOfClass("Humanoid")
        local _lIllIlIIII = _IIIllIllII and _IIIllIllII:FindFirstChild("HumanoidRootPart")
        if _lIIIIIIIII then
            _lIIIIIIIII.AutoRotate = true
            _lIIIIIIIII.Sit = false
            _lIIIIIIIII.PlatformStand = false
            _lIIIIIIIII:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        if _lIllIlIIII then
            _lIllIlIIII.Anchored = false
            _lIllIlIIII.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local function _IIIIIIIIlI()
        for _llIIIIIIII, _lllllllIll in ipairs(_IllIIIllll) do
            if _IIlllIlllI[_lllllllIll.name] and _lllllllIll.isActive() then return true end
        end
        return false
    end

    for _llIIIIIIII, _lIlIIIIIIl in ipairs(_lIIlIlIlll) do
        local _IIlIllIIII, _IlIlIIIIll = gridSlot(_lIlIIIIIIl.order, _IllllIIIIl)
        local _IlIIlIlIIl = makeButton(_IllllIllll, _lIlIIIIIIl.name, _IIlIllIIII, _IlIlIIIIll, BTN_W, BTN_H, _lIlIIIIIIl.vip)
        _IlIIlIlIIl:SetAttribute("288RequiresTarget", true)
        _IlIIlIlIIl.TextSize = 13
        local _llIlIlIIll = (_lIlIIIIIIl.order % 2 == 1) and DOT1_X or DOT2_X
        local _IlIllIlIIl
        if _lIlIIIIIIl.instant then
            makeMouseDot(_IllllIllll, _llIlIlIIll, _IlIlIIIIll + BTN_H/2 - DOT_SIZE/2, DOT_SIZE, _IlIIlIlIIl)
            _IlIllIlIIl = {setActive = function() end}
        else
            _IlIllIlIIl = makeStatusDot(_IllllIllll, _llIlIlIIll, _IlIlIIIIll + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
        end
        local _IIlIlIIIIl = false
        table.insert(_IllIIIllll, {
            _lIIlIIllII = _IlIIlIlIIl,
            _IlIllIlIIl = _IlIllIlIIl,
            _IlIlIlllll = _lIlIIIIIIl.name,
            instant = _lIlIIIIIIl.instant == true,
            isActive = function() return _IIlIlIIIIl end,
            deactivate = function()
                _IIlIlIIIIl = false
                _IlIllIlIIl.setActive(false)
                _IlIIlIlIIl.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
            end,
        })
        if _lIlIIIIIIl.instant then
            -- aÃ§Ã£o instantÃ¢nea (nÃ£o toggle)
            _IlIIlIlIIl.MouseButton1Click:Connect(function()
                if _lIlIIIIIIl.vip and not _IllIlIIlIl then return end
                if not _IlllIIllII or not _IIIlllIllI(_IlIIlIlIIl) then return end
                _IlIIIlllIl.__288TargetUserId = _IlllIIllII.UserId
                if _lIlIIIIIIl.name == "CopyID" then
                    pcall(function() setclipboard(tostring(_IlllIIllII.UserId)) end)
                    return
                end
                -- Bring / Teleport -> carrega mÃ³dulo Ãºnico
                local _llllIlIIIl = _lIlIIIIIIl.name:gsub(" ", "")
                loadModule("modules/Target/"..safe)
            end)
        else
            _IlIIlIlIIl.MouseButton1Click:Connect(function()
                if _lIlIIIIIIl.vip and not _IllIlIIlIl then return end
                if not _IlllIIllII then return end
                _IlIIIlllIl.__288TargetUserId = _IlllIIllII.UserId
                _IIlIlIIIIl = not _IIlIlIIIIl
                _IlIIlIlIIl.BackgroundColor3 = _IIlIlIIIIl and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
                _IlIllIlIIl.setActive(_IIlIlIIIIl)
                local _llllIlIIIl = _lIlIIIIIIl.name:gsub(" ","")
                if _IIlIlIIIIl and _IIlllIlllI[_lIlIIIIIIl.name] then
                    for _llIIIIIIII, _lllllllIll in ipairs(_IllIIIllll) do
                        if _lllllllIll.name ~= _lIlIIIIIIl.name
                            and _IIlllIlllI[_lllllllIll.name]
                            and _lllllllIll.isActive()
                        then
                            _lllllllIll.deactivate()
                            loadModule("modules/Target/" .. _lllllllIll.name:gsub(" ", ""))
                        end
                    end
                end
                local _IIIIIlllIl = loadModule("modules/Target/" .. _llllIlIIIl)
                if _IIIIIlllIl == false then
                    _IIlIlIIIIl = false
                    _IlIllIlIIl.setActive(false)
                    _IlIIlIlIIl.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
                end
                if not _IIlIlIIIIl and _IIlllIlllI[_lIlIIIIIIl.name] then
                    task.defer(function()
                        if not _IIIIIIIIlI() then _lIllIlIllI() end
                    end)
                end
            end)
        end
    end

    local function _IIIIIlIllI(_IlIIlIIIII, _IIIllIllll)
        if _llllllIIII then return end
        _llllllIIII = true

        local _IIlIIIllIl = {}
        for _llIIIIIIII, _lllllllIll in ipairs(_IllIIIllll) do
            if not _lllllllIll.instant and _lllllllIll.isActive() then
                local _llllIlIIIl = _lllllllIll.name:gsub(" ", "")
                table.insert(_IIlIIIllIl, "modules/Target/" .. _llllIlIIIl)
            end
            _lllllllIll.deactivate()
        end

        for _llIIIIIIII, modulePath in ipairs(_IIlIIIllIl) do
            loadModule(modulePath)
        end

        -- Os modulos usam o mesmo arquivo para ligar e desligar. Headsit tambem
        -- observa o ID e se encerra imediatamente quando ele e limpo.
        _IlllIIllII = nil
        _IlIIIlllIl.__288TargetUserId = nil
        _lIlIlIlIlI.Visible = false
        _lIIlllIlII.Visible = false
        _lIllIIlIIl.Visible = false
        _IlIIIlllll.Visible = true
        _IIIIIlIIlI.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        _IIIIIlIIlI.ImageColor3 = Color3.fromRGB(90, 90, 90)
        _llIllllIll.Text = ""
        _IllIIIlIll.Color = _llIIllllll
        _llIIlIlIIl.Visible = false
        _llllllIIII = false

        if _IlIIlIIIII then
            notifyPanel(_IlIIlIIIII, _IIIllIllll or "All actions have been stopped.", "warning", 5)
        end
        task.defer(_lIllIlIllI)
    end

    _llllllIIlI("TargetActions", function()
        _IIIIIlIllI()
    end)

    local function _lIllllllII(_IIllIlIlII)
        if _IlllIIllII and _IlllIIllII ~= _IIllIlIlII then
            _IIIIIlIllI()
        end
        _IlllIIllII   = _IIllIlIlII
        _lIlIlIlIlI.Text  = "UserID: "  .. tostring(_IIllIlIlII.UserId)
        _lIIlllIlII.Text = "Display: " .. tostring(_IIllIlIlII.DisplayName)
        _lIllIIlIIl.Text   = "Name: "    .. tostring(_IIllIlIlII.Name)
        _lIlIlIlIlI.Visible  = true
        _lIIlllIlII.Visible = true
        _lIllIIlIIl.Visible   = true
        _IlIIIlllll.Visible     = false
        _IIIIIlIIlI.ImageColor3 = Color3.fromRGB(255,255,255)

        if _IIIllIIlll[_IIllIlIlII.UserId] then
            _IIIIIlIIlI.Image = _IIIllIIlll[_IIllIlIlII.UserId]
        else
            task.spawn(function()
                local _lllIllIllI, _llIIIIllII = pcall(function()
                    return _lllIIIlIlI:GetUserThumbnailAsync(
                        _IIllIlIlII.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
                end)
                if _lllIllIllI and _IIIIIlIIlI.Parent then
                    _IIIllIIlll[_IIllIlIlII.UserId] = _llIIIIllII
                    _IIIIIlIIlI.Image = _llIIIIllII
                end
            end)
        end

        _llIIlIlIIl.Visible = false
        _IllIIIlIll.Color    = Color3.fromRGB(80,180,80)
        _llIIIIlIII = true
        _llIllllIll.Text   = _IIllIlIlII.Name
        _llIIIIlIII = false
    end

    _IIIIIIlIlI(_lllIIIlIlI.PlayerRemoving, function(_IIllIlIlII)
        if _IIllIlIlII ~= _IlllIIllII then return end

        local _IIlIlIlIIl = _IIllIlIlII.DisplayName ~= _IIllIlIlII.Name
            and (_IIllIlIlII.DisplayName .. " (@" .. _IIllIlIlII.Name .. ")")
            or ("@" .. _IIllIlIlII.Name)

        _IIIIIlIllI("Target left", _IIlIlIlIIl .. " left the server. All actions have been stopped.")
    end)

    local function _IIllIlIIll(_llIllIlIll)
        _llIllIIIII()
        for _llIIIIIIII, _lIIlIIllll in pairs(_llIIlIlIIl:GetChildren()) do
            if _lIIlIIllll:IsA("Frame") then _lIIlIIllll:Destroy() end
        end

        for i, _IIlIIIlIIl in ipairs(_llIllIlIll) do
            local _lIIllIIIII = Instance.new("Frame")
            _lIIllIIIII.Name             = "Row"..i
            _lIIllIIIII.Size             = UDim2.new(1,0,0,_llIllIllll)
            _lIIllIIIII.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
            _lIIllIIIII.BorderSizePixel  = 0
            _lIIllIIIII.LayoutOrder      = i
            _lIIllIIIII.ZIndex           = 51
            _lIIllIIIII.Parent           = _llIIlIlIIl

            local _llIIIIlllI = Instance.new("ImageLabel")
            _llIIIIlllI.Size=UDim2.new(0,30,0,30)
            _llIIIIlllI.Position=UDim2.new(0,5,0.5,-15)
            _llIIIIlllI.BackgroundColor3=Color3.fromRGB(38,38,38)
            _llIIIIlllI.BorderSizePixel=0
            _llIIIIlllI.ZIndex=52
            _llIIIIlllI.Parent=_lIIllIIIII
            Instance.new("UICorner",_llIIIIlllI).CornerRadius=UDim.new(0,4)

            if _IIIllIIlll[_IIlIIIlIIl.UserId] then
                _llIIIIlllI.Image = _IIIllIIlll[_IIlIIIlIIl.UserId]
            else
                task.spawn(function()
                    local _lllIllIllI, _llIIIIllII = pcall(function()
                        return _lllIIIlIlI:GetUserThumbnailAsync(
                            _IIlIIIlIIl.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                    end)
                    if _lllIllIllI and _llIIIIlllI.Parent then
                        _IIIllIIlll[_IIlIIIlIIl.UserId] = _llIIIIllII
                        _llIIIIlllI.Image = _llIIIIllII
                    end
                end)
            end

            local _IIIllIlIIl=Instance.new("TextLabel")
            _IIIllIlIIl.Size=UDim2.new(1,-42,0,19)
            _IIIllIlIIl.Position=UDim2.new(0,40,0,3)
            _IIIllIlIIl.BackgroundTransparency=1
            _IIIllIlIIl.Text=_IIlIIIlIIl.Name
            _IIIllIlIIl.TextColor3=_IllllIIlII[_lIIlIIlllI].text
            _IIIllIlIIl.TextSize=12
            _IIIllIlIIl.Font=Enum.Font.GothamBold
            _IIIllIlIIl.TextXAlignment=Enum.TextXAlignment.Left
            _IIIllIlIIl.TextTruncate=Enum.TextTruncate.AtEnd
            _IIIllIlIIl.ZIndex=52
            _IIIllIlIIl.Parent=_lIIllIIIII

            local _lIlIllIIIl=Instance.new("TextLabel")
            _lIlIllIIIl.Size=UDim2.new(1,-42,0,16)
            _lIlIllIIIl.Position=UDim2.new(0,40,0,22)
            _lIlIllIIIl.BackgroundTransparency=1
            _lIlIllIIIl.Text=_IIlIIIlIIl.DisplayName
            _lIlIllIIIl.TextColor3=_IllllIIlII[_lIIlIIlllI].textDim
            _lIlIllIIIl.TextSize=10
            _lIlIllIIIl.Font=Enum.Font.Gotham
            _lIlIllIIIl.TextXAlignment=Enum.TextXAlignment.Left
            _lIlIllIIIl.TextTruncate=Enum.TextTruncate.AtEnd
            _lIlIllIIIl.ZIndex=52
            _lIlIllIIIl.Parent=_lIIllIIIII

            _lIIlIlIllI(_lIIllIIIII,"BackgroundColor3","btn")
            _lIIlIlIllI(_IIIllIlIIl,"TextColor3","text")
            _lIIlIlIllI(_lIlIllIIIl,"TextColor3","textDim")
            _lIIllIIIII.MouseEnter:Connect(function() _lIIllIIIII.BackgroundColor3=_IllllIIlII[_lIIlIIlllI].btnHover end)
            _lIIllIIIII.MouseLeave:Connect(function() _lIIllIIIII.BackgroundColor3=_IllllIIlII[_lIIlIIlllI].btn end)

            local _lIIIllIlll=Instance.new("TextButton")
            _lIIIllIlll.Size=UDim2.new(1,0,1,0)
            _lIIIllIlll.BackgroundTransparency=1
            _lIIIllIlll:SetAttribute("PreserveTransparency", true)
            _lIIIllIlll.Text=""
            _lIIIllIlll.ZIndex=53
            _lIIIllIlll.Parent=_lIIllIIIII
            _lIIIllIlll.MouseButton1Click:Connect(function() _lIllllllII(_IIlIIIlIIl) end)
        end

        local _IIIlIlIlIl = math.min(#_llIllIlIll, _lIIIlIllIl)
        _llIIlIlIIl.CanvasSize = UDim2.new(0,0,0, #_llIllIlIll*(_llIllIllll+_lIIlIIIlll))
        _llIIlIlIIl.Size       = UDim2.fromOffset(_llIllllIll.AbsoluteSize.X, _IIIlIlIlIl*(_llIllIllll+_lIIlIIIlll))
        _llIIlIlIIl.Visible    = MainFrame.Visible and _IllllIllll.Visible
    end

    local function _lIIllllIIl(_IlIlIlIlll)
        return tostring(_IlIlIlIlll or "")
            :gsub("^%s+", "")
            :gsub("%s+$", "")
            :gsub("^@", "")
            :lower()
    end

    local function _llllIIlIll(_IIlllIIIII, _lllllIlIII)
        local _llIlIIIlll = _IIlllIIIII.Name:lower()
        local _llIIIlIIll = _IIlllIIIII.DisplayName:lower()
        local _IlllIIlIII = tostring(_IIlllIIIII.UserId)
        if _IlllIIlIII == _lllllIlIII then return 1000 end
        if _llIlIIIlll == _lllllIlIII then return 950 end
        if _llIIIlIIll == _lllllIlIII then return 900 end
        if _llIlIIIlll:sub(1, #_lllllIlIII) == _lllllIlIII then return 800 - (#_llIlIIIlll - #_lllllIlIII) end
        if _llIIIlIIll:sub(1, #_lllllIlIII) == _lllllIlIII then return 700 - (#_llIIIlIIll - #_lllllIlIII) end
        local _IIllIIIlIl = _llIlIIIlll:find(_lllllIlIII, 1, true)
        if _IIllIIIlIl then return 500 - _IIllIIIlIl end
        local _IllIlIllII = _llIIIlIIll:find(_lllllIlIII, 1, true)
        if _IllIlIllII then return 400 - _IllIlIllII end
        return nil
    end

    local function _IIlIlllIII(_lllllIlIII)
        local _lIlIlIlIll = _lIIllllIIl(_lllllIlIII)
        if _lIlIlIlIll == "" then
            _llIIlIlIIl.Visible = false
            _IllIIIlIll.Color = _IllllIIlII[_lIIlIIlllI].stroke
            return {}
        end

        local _llIlIlIlll = {}
        for _llIIIIIIII, _IIlllIIIII in ipairs(_lllIIIlIlI:GetPlayers()) do
            if _IIlllIIIII ~= _IlllllllII then
                local _llIIIllIIl = _llllIIlIll(_IIlllIIIII, _lIlIlIlIll)
                if _llIIIllIIl then _llIlIlIlll[#_llIlIlIlll + 1] = {_IIllIlIlII = _IIlllIIIII, _llIIIllIIl = _llIIIllIIl} end
            end
        end
        table.sort(_llIlIlIlll, function(_llIlIIIIlI, b)
            if _llIlIIIIlI.score == b.score then return _llIlIIIIlI.player.Name:lower() < b.player.Name:lower() end
            return _llIlIIIIlI.score > b.score
        end)

        local _llIllIlIll = {}
        for _llIIIIIIII, _lllIlIIlII in ipairs(_llIlIlIlll) do _llIllIlIll[#_llIllIlIll + 1] = _lllIlIIlII.player end
        if #_llIllIlIll == 0 then
            _llIIlIlIIl.Visible = false
            _IllIIIlIll.Color = Color3.fromRGB(220, 80, 90)
        else
            _IllIIIlIll.Color = _IllllIIlII[_lIIlIIlllI].accent
            _IIllIlIIll(_llIllIlIll)
        end
        return _llIllIlIll
    end
    _llIllllIll:GetPropertyChangedSignal("Text"):Connect(function()
        if _llIIIIlIII then return end
        if _IlllIIllII and _llIllllIll.Text == _IlllIIllII.Name then
            _llIIlIlIIl.Visible = false
            return
        end
        _IllIIIlIll.Color = Color3.fromRGB(60,60,60)
        if _llIllllIll.Text == "" and _IlllIIllII and not _llllllIIII then
            _IIIIIlIllI("Target cleared", "All actions on the target have been stopped.")
            return
        end
        _IIlIlllIII(_llIllllIll.Text)
    end)

    local function _IIllIllllI()
        local _llIllIlIll = _IIlIlllIII(_llIllllIll.Text)
        if _llIllIlIll[1] then _lIllllllII(_llIllIlIll[1]) end
    end

    _IIlIIIlIII.MouseButton1Click:Connect(_IIllIllllI)
    _llIllllIll.FocusLost:Connect(function(enterPressed)
        if enterPressed then _IIllIllllI() end
    end)
    _IIIIIIlIlI(MainFrame:GetPropertyChangedSignal("Visible"), function()
        if not MainFrame.Visible then _llIIlIlIIl.Visible = false end
    end)

    for _llIIIIIIII, _llIlIlIIlI in pairs(Tabs) do
        _llIlIlIIlI.btn.MouseButton1Click:Connect(function()
            if _llIlIlIIlI.name ~= "Target" then
                _llIIlIlIIl.Visible = false
            else
                _llIllIIIII()
            end
        end)
    end

    refreshCanvas(_IllllIllll)
end

-- ==================== MORE TAB ====================
do
    local _IllllIllll = Tabs["More"].frame
    local _lllIlIlllI = 8

    makeSectionLabel(_IllllIllll,"Casual",PAD,_lllIlIlllI)
    _lllIlIlllI = _lllIlIlllI + 20 + GAP

    local _IIlIIIlllI = makeButton(_IllllIllll,"AntiBanVC  -  LOCKED",COL1,_lllIlIlllI,BTN_W,BTN_H)
    _IIlIIIlllI:SetAttribute("HoverDisabled", true)
    _IIlIIIlllI.Active = false
    _IIlIIIlllI.Selectable = false
    _IIlIIIlllI.TextColor3 = _lIIIlIlIIl
    _IIlIIIlllI.TextTransparency = 0.28
    local _IlIIllllll = Instance.new("TextLabel")
    _IlIIllllll.Size=UDim2.new(0,30,0,22)
    _IlIIllllll.Position=UDim2.new(0, DOT1_X + DOT_SIZE + GAP, 0, _lllIlIlllI+6)
    _IlIIllllll.BackgroundTransparency=1
    _IlIIllllll.Text="LOCK"
    _IlIIllllll.TextColor3=Color3.fromRGB(120,120,120)
    _IlIIllllll.TextSize=12
    _IlIIllllll.Font=Enum.Font.Gotham
    _IlIIllllll.ZIndex=4
    _IlIIllllll.Parent=_IllllIllll
    local _IlIlIlIIIl = makeButton(_IllllIllll,"PianoAuto",COL2,_lllIlIlllI,BTN_W,BTN_H)
    makeMouseDot(_IllllIllll, DOT2_X, _lllIlIlllI + BTN_H/2 - DOT_SIZE/2, DOT_SIZE, _IlIlIlIIIl)
    _IlIlIlIIIl.MouseButton1Click:Connect(function() if _IIIlllIllI(_IlIlIlIIIl) then runPanelModule("PianoAuto") end end)
    _lllIlIlllI = _lllIlIlllI + BTN_H + GAP + 4

    makeSectionLabel(_IllllIllll,"FPS",PAD,_lllIlIlllI)
    _lllIlIlllI = _lllIlIlllI + 20 + GAP

    local _lIlllllIll  = makeButton(_IllllIllll,"ESP",COL1,_lllIlIlllI,BTN_W,BTN_H)
    local _lllIIIIlIl  = makeStatusDot(_IllllIllll, DOT1_X, _lllIlIlllI+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    local _IlIIIIlllI = false
    local _lIlllIIlll = false
    local function _llllIlllll(_llIlIIlIlI)
        if _llIlIIlIlI == _IlIIIIlllI then return true end
        local _IIIIIlllIl = runPanelModule("ESP")
        if not _IIIIIlllIl then
            _lllIIIIlIl.setActive(false)
            _lIlllllIll.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
            notifyPanel("ESP", "The API could not load modules/More/ESP.", "error", 6)
            return false
        end
        _IlIIIIlllI = _llIlIIlIlI
        _lllIIIIlIl.setActive(_IlIIIIlllI)
        _lIlllllIll.BackgroundColor3 = _IlIIIIlllI and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn

        -- O script remoto controla a prÃ³pria ativaÃ§Ã£o/desativaÃ§Ã£o.
        return true
    end
    _lIlllllIll.MouseButton1Click:Connect(function()
        if _llllIlllll(not _IlIIIIlllI) then _lIlllIIlll = true end
    end)
    _llllllIIlI("ESP", function()
        if _IlIIIIlllI then runPanelModule("ESP") end
    end)

    local _IllllllIII  = makeButton(_IllllIllll,"Aimbot",COL2,_lllIlIlllI,BTN_W,BTN_H)
    local _lllIIIIIIl  = makeStatusDot(_IllllIllll, DOT2_X, _lllIlIlllI+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    local _llIIIllIlI = false
    local _IIIllIIIll = false
    local function _llIllIIIlI(_llIlIIlIlI)
        if _llIlIIlIlI == _llIIIllIlI then return true end
        local _IIIIIlllIl = runPanelModule("Aimbot")
        if not _IIIIIlllIl then
            _lllIIIIIIl.setActive(false)
            _IllllllIII.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
            notifyPanel("Aimbot", "The API could not load modules/More/Aimbot.", "error", 6)
            return false
        end
        _llIIIllIlI = _llIlIIlIlI
        _lllIIIIIIl.setActive(_llIIIllIlI)
        _IllllllIII.BackgroundColor3 = _llIIIllIlI and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
        return true
    end
    _IllllllIII.MouseButton1Click:Connect(function()
        if _llIllIIIlI(not _llIIIllIlI) then _IIIllIIIll = true end
    end)
    _llllllIIlI("Aimbot", function()
        if _llIIIllIlI then runPanelModule("Aimbot") end
    end)
    _lllIlIlllI = _lllIlIlllI + BTN_H + GAP

    _IIIIIIlIlI(_IIIIllIllI.InputBegan, function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.E and _lIlllIIlll then
            _IlIIIIlllI = not _IlIIIIlllI
            _lllIIIIlIl.setActive(_IlIIIIlllI)
            _lIlllllIll.BackgroundColor3 = _IlIIIIlllI and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
        elseif input.KeyCode == Enum.KeyCode.F and _IIIllIIIll then
            _llIIIllIlI = not _llIIIllIlI
            _lllIIIIIIl.setActive(_llIIIllIlI)
            _IllllllIII.BackgroundColor3 = _llIIIllIlI and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
        end
    end)
    refreshCanvas(_IllllIllll)
end

-- ==================== MISC TAB ====================
do
    local _IllllIllll = Tabs["Misc"].frame
    local _lllIlIlllI = 10

    -- Linha 1
    local _lIlIIIlIII = makeButton(_IllllIllll,"Anti AFK",COL1,_lllIlIlllI,BTN_W,BTN_H)
    local _IlllIlIlII = makeStatusDot(_IllllIllll, DOT1_X, _lllIlIlllI+BTN_H/2-DOT_SIZE/2, DOT_SIZE)
    local _lllIIIllII = false
    local function _IIIIIIllll(_llIlIIlIlI, _llIlllllIl)
        if _llIlIIlIlI == _lllIIIllII then
            if _llIlllllIl then _llIlIlIIIl(_lIlIllIlll, _llIlIIlIlI) end
            return true
        end
        _IlIIIlllIl.__288AntiAfkRequestedState = _llIlIIlIlI
        local _IIIIIlllIl = loadModule("modules/Misc/AntiAFK")
        _IlIIIlllIl.__288AntiAfkRequestedState = nil
        if not _IIIIIlllIl then return false end
        _lllIIIllII = _llIlIIlIlI
        _IlllIlIlII.setActive(_lllIIIllII)
        _lIlIIIlIII.BackgroundColor3 = _lllIIIllII and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
        if _llIlllllIl then _llIlIlIIIl(_lIlIllIlll, _llIlIIlIlI) end
        return true
    end
    _lIlIIIlIII.MouseButton1Click:Connect(function() _IIIIIIllll(not _lllIIIllII, true) end)
    _llllllIIlI("AntiAFK", function() _IIIIIIllll(false, false) end)

    if _IllIllllII(_lIlIllIlll) then
        task.defer(function()
            if _lIlllIlIlI.Parent and not _lIlIllllII then _IIIIIIllll(true, false) end
        end)
    end

    local _llIlIIlIIl = makeButton(_IllllIllll,"TpToOwner",COL2,_lllIlIlllI,BTN_W,BTN_H)
    makeMouseDot(_IllllIllll, DOT2_X, _lllIlIlllI+BTN_H/2-DOT_SIZE/2, DOT_SIZE, _llIlIIlIIl)
    _llIlIIlIIl.MouseButton1Click:Connect(function() if _IIIlllIllI(_llIlIIlIIl) then loadModule("modules/Misc/TpToOwner") end end)
    _lllIlIlllI = _lllIlIlllI + BTN_H + GAP

    -- Linha 2
    local _IIIIIllIII = makeButton(_IllllIllll,"Clear Chat",COL1,_lllIlIlllI,BTN_W,BTN_H)
    makeMouseDot(_IllllIllll, DOT1_X, _lllIlIlllI+BTN_H/2-DOT_SIZE/2, DOT_SIZE, _IIIIIllIII)
    _IIIIIllIII.MouseButton1Click:Connect(function() if _IIIlllIllI(_IIIIIllIII) then loadModule("modules/Misc/ClearChat") end end)

    local _IlIllllIlI = makeButton(_IllllIllll,"Rejoin",COL2,_lllIlIlllI,BTN_W,BTN_H)
    makeMouseDot(_IllllIllll, DOT2_X, _lllIlIlllI+BTN_H/2-DOT_SIZE/2, DOT_SIZE, _IlIllllIlI)
    _IlIllllIlI.MouseButton1Click:Connect(function()
        if not _IIIlllIllI(_IlIllllIlI) then return end
        local _IllIlIlIII = game:GetService("TeleportService")
        pcall(function()
            _IllIlIlIII:TeleportToPlaceInstance(game.PlaceId, game.JobId, _IlllllllII)
        end)
    end)
    _lllIlIlllI = _lllIlIlllI + BTN_H + GAP

    -- Linha 3
    local _IIlIlIIIlI = makeButton(_IllllIllll,"Infinite Premium",COL1,_lllIlIlllI,BTN_W,BTN_H)
    makeMouseDot(_IllllIllll, DOT1_X, _lllIlIlllI+BTN_H/2-DOT_SIZE/2, DOT_SIZE, _IIlIlIIIlI)
    _IIlIlIIIlI.MouseButton1Click:Connect(function() if _IIIlllIllI(_IIlIlIIIlI) then loadModule("modules/Misc/InfinitePremium.lua") end end)
    local _IIlIllIlIl = makeButton(_IllllIllll,"Smartphone",COL2,_lllIlIlllI,BTN_W,BTN_H)
    makeMouseDot(_IllllIllll, DOT2_X, _lllIlIlllI+BTN_H/2-DOT_SIZE/2, DOT_SIZE, _IIlIllIlIl)
    _IIlIllIlIl:SetAttribute("288SilentNotification", true)
    _IIlIllIlIl.MouseButton1Click:Connect(function()
        if not _IIIlllIllI(_IIlIllIlIl) then return end
        _IlIIIlllIl.__288SmartphoneActivate = true
        local _IIIIIlllIl = loadModule("modules/Misc/Smartphone")
        _IlIIIlllIl.__288SmartphoneActivate = nil
        if _IIIIIlllIl then
            notifyPanel("Smartphone", "Celular enviado para o prÃ³ximo slot da hotbar.", "success", 4)
        else
            notifyPanel("Smartphone", "NÃ£o foi possÃ­vel baixar o mÃ³dulo. Verifique a API.", "error", 6)
        end
    end)
    _lllIlIlllI = _lllIlIlllI + BTN_H + GAP

        -- ============================================================
    -- FREE CAM (F = liga/desliga | G = alterna modo)
    -- ============================================================
    local _llIllllllI = makeButton(_IllllIllll, "Free Cam [F]", COL1, _lllIlIlllI, BTN_W, BTN_H)
    _llIllllllI:SetAttribute("288SilentNotification", true)
    local _IIIlllIIll = makeStatusDot(_IllllIllll, DOT1_X, _lllIlIlllI + BTN_H/2 - DOT_SIZE/2, DOT_SIZE)
    local _llIllIlllI = false

    local function _IllllIIIlI()
        local _IllIIIlllI = (getgenv and getgenv()) or _G
        local _lIIIlllIII = _IllIIIlllI.__288FreeCam
        if not _lIIIlllIII or not _lIIIlllIII.active then
            _IIIlllIIll.setActive(false)
            _llIllllllI.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
            return
        end
        _IIIlllIIll.setActive(true)
        _llIllllllI.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btnOn
    end

    local function _lllllIIIll()
        local _IllIIIlllI = (getgenv and getgenv()) or _G
        local _lIIIlllIII = _IllIIIlllI.__288FreeCam
        if not _lIIIlllIII then return end
        _lIIIlllIII.onModeChanged = function() _IllllIIIlI() end
        _lIIIlllIII.onStateChanged = function() _IllllIIIlI() end
    end

    _llIllllllI.MouseButton1Click:Connect(function()
        task.defer(function()
            local _IllIIIlllI = (getgenv and getgenv()) or _G

            if not _llIllIlllI then
                local _IIIIIlllIl = loadModule("modules/Misc/FreeCam")
                if _IIIIIlllIl then
                    _llIllIlllI = true
                    _lllllIIIll()
                    _IllllIIIlI()
                    notifyPanel("Free Cam", "F = liga/desliga | G = CAMERA/BODY.", "success", 5)
                else
                    notifyPanel("Free Cam", "Falha ao carregar o mÃ³dulo.", "error", 5)
                end
                return
            end

            local _lIIIlllIII = _IllIIIlllI.__288FreeCam
            if _lIIIlllIII then
                if not _lIIIlllIII.active then
                    _lIIIlllIII:Start()
                    notifyPanel("Free Cam", "Ativado em CAMERA MODE. Use G para alternar.", "success", 4)
                else
                    _lIIIlllIII:Stop()
                    notifyPanel("Free Cam", "Desativado.", "warning", 3)
                end
                _IllllIIIlI()
            else
                _llIllIlllI = false
                notifyPanel("Free Cam", "Modulo reiniciado. Pressione o botao novamente.", "info", 4)
            end
        end)
    end)

    task.spawn(function()
        while _lIlllIlIlI.Parent and not _lIlIllllII do
            task.wait(0.3)
            _IllllIIIlI()
        end
    end)

    _lllIlIlllI = _lllIlIlllI + BTN_H + GAP

    _llllllIIlI("FreeCam", function()
        local _IllIIIlllI = (getgenv and getgenv()) or _G
        if _IllIIIlllI.__288FreeCam then
            pcall(function() _IllIIIlllI.__288FreeCam:Destroy() end)
        end
    end)

    refreshCanvas(_IllllIllll)
end

-- ==================== DETECTED GAME TAB ====================
-- ==================== MM2 TAB ====================
if DETECTED_GAME and DETECTED_GAME.key == "MM2" then
    local _IllllIllll = Tabs[DETECTED_GAME.name].frame
    local _lllIlIlllI = 10

    local function _llllIlIllI(_llIIlllIll, _lIIllIlIlI)
        makeSectionLabel(_IllllIllll, _llIIlllIll, PAD, _lllIlIlllI)
        local _IIlIlllIIl = _lllIlIlllI + 20 + GAP
        for _lllllIlIIl, definition in ipairs(_lIIllIlIlI) do
            local _IIIlIIlIII, _lIlIIlIIll = gridSlot(_lllllIlIIl, _IIlIlllIIl)
            local _lIIlIIllII = makeToggleButton(_IllllIllll, definition.name, _IIIlIIlIII, _lIlIIlIIll, BTN_W, BTN_H)
            local _IlIIIIIIII = definition.feature
            _lIIlIIllII.MouseButton1Click:Connect(function()
                task.defer(function()
                    _IlIIIlllIl.__288MM2Command = {
                        _IlIIIIIIII = _IlIIIIIIII,
                        _lIlIlIIIll = _lIIlIlIlII[_lIIlIIllII] == true,
                    }
                    loadModule("modules/Games/MM2/Controller.lua")
                end)
            end)
        end
        _lllIlIlllI = _IIlIlllIIl + math.ceil(#_lIIllIlIlI / 2) * (BTN_H + GAP) + GAP
    end

    local function _IIllIIIlll(_llIIlllIll, _lIIllIlIlI)
        makeSectionLabel(_IllllIllll, _llIIlllIll, PAD, _lllIlIlllI)
        local _IIlIlllIIl = _lllIlIlllI + 20 + GAP
        for _lllllIlIIl, definition in ipairs(_lIIllIlIlI) do
            local _IIIlIIlIII, _lIlIIlIIll = gridSlot(_lllllIlIIl, _IIlIlllIIl)
            local _lIIlIIllII = makeButton(_IllllIllll, definition.name, _IIIlIIlIII, _lIlIIlIIll, BTN_W, BTN_H)
            local _IIllIlllIl = definition.action
            local _llIlIlIIll = _lllllIlIIl % 2 == 1 and DOT1_X or DOT2_X
            makeMouseDot(_IllllIllll, _llIlIlIIll, _lIlIIlIIll + BTN_H / 2 - DOT_SIZE / 2, DOT_SIZE, _lIIlIIllII)
            _lIIlIIllII.MouseButton1Click:Connect(function()
                if not _IIIlllIllI(_lIIlIIllII) then return end
                _IlIIIlllIl.__288MM2Command = {_IIllIlllIl = _IIllIlllIl}
                loadModule("modules/Games/MM2/Controller.lua")
            end)
        end
        _lllIlIlllI = _IIlIlllIIl + math.ceil(#_lIIllIlIlI / 2) * (BTN_H + GAP) + GAP
    end

    _llllIlIllI("Automation", {
        {_IlIlIlllll="Auto TP para GunDrop", _IlIIIIIIII="autoGun"},
        {_IlIlIlllll="Auto Win", _IlIIIIIIII="autoWin"},
        {_IlIlIlllll="Auto Farm Coins", _IlIIIIIIII="coins"},
    })
    _llllIlIllI("Combat", {
        {_IlIlIlllll="Auto Shoot Murderer", _IlIIIIIIII="autoShoot"},
        {_IlIlIlllll="Auto Kill All", _IlIIIIIIII="autoKill"},
        {_IlIlIlllll="Aim Lock Murderer", _IlIIIIIIII="aimLock"},
        {_IlIlIlllll="Hitbox 12", _IlIIIIIIII="hitbox"},
        {_IlIlIlllll="Noclip Players", _IlIIIIIIII="noclipFriends"},
    })
    _IIllIIIlll("Teleport", {
        {_IlIlIlllll="TP Sheriff", _IIllIlllIl="tpSheriff"},
        {_IlIlIlllll="TP Murderer", _IIllIlllIl="tpMurderer"},
        {_IlIlIlllll="TP Sheriff Gun", _IIllIlllIl="tpGun"},
        {_IlIlIlllll="TP Lobby", _IIllIlllIl="tpLobby"},
        {_IlIlIlllll="TP Map", _IIllIlllIl="tpMap"},
        {_IlIlIlllll="TP Nearest Player", _IIllIlllIl="tpNearest"},
    })
    _IIllIIIlll("Actions", {
        {_IlIlIlllll="Shoot Murderer", _IIllIlllIl="shoot"},
        {_IlIlIlllll="Throw Knife", _IIllIlllIl="throwKnife"},
        {_IlIlIlllll="Kill All", _IIllIlllIl="killAll"},
        {_IlIlIlllll="Fling Sheriff", _IIllIlllIl="flingSheriff"},
        {_IlIlIlllll="Fling Murder", _IIllIlllIl="flingMurderer"},
        {_IlIlIlllll="Mini TP Gun", _IIllIlllIl="miniGun"},
        {_IlIlIlllll="Mini Shoot", _IIllIlllIl="miniShoot"},
    })

    _llllllIIlI("Game/MM2", function()
        _IlIIIlllIl.__288MM2Command = {_llIlllIlII = true}
        loadModule("modules/Games/MM2/Controller.lua")
        _IlIIIlllIl.__288MM2Command = nil
    end)
    refreshCanvas(_IllllIllll)
end
-- ==================== ParkVoice TAB ====================
if DETECTED_GAME and DETECTED_GAME.key == "ParkVoice" then
    local _IllllIllll = Tabs[DETECTED_GAME.name].frame
    local _lllIlIlllI = 10
    makeSectionLabel(_IllllIllll, "Automation", PAD, _lllIlIlllI)
    _lllIlIlllI = _lllIlIlllI + 20 + GAP

    local _lIllllllll = makeToggleButton(_IllllIllll, "Auto Pool", COL1, _lllIlIlllI, BTN_W, BTN_H)
    _lIllllllll:SetAttribute("288SilentNotification", true)
    _lIllllllll.MouseButton1Click:Connect(function()
        task.defer(function()
            _IlIIIlllIl.__288ParkVoiceCommand = {
                _IlIIIIIIII = "autoPool",
                _lIlIlIIIll = _lIIlIlIlII[_lIllllllll] == true,
            }
            loadModule("modules/Games/ParkVoice/Controller")
        end)
    end)

    _llllllIIlI("Game/ParkVoice", function()
        _IlIIIlllIl.__288ParkVoiceCommand = {_llIlllIlII = true}
        loadModule("modules/Games/ParkVoice/Controller")
        _IlIIIlllIl.__288ParkVoiceCommand = nil
    end)

    refreshCanvas(_IllllIllll)
end
-- ==================== ETE TAB ====================
if DETECTED_GAME and DETECTED_GAME.key == "EatTheEarth" then
    local _IllllIllll = Tabs[DETECTED_GAME.name].frame
    local _lllIlIlllI = 10
    makeSectionLabel(_IllllIllll, "Automation", PAD, _lllIlIlllI)
    local _IIlIlllIIl = _lllIlIlllI + 20 + GAP

    local _lllIIlIIll = makeToggleButton(_IllllIllll, "Auto Eat", COL1, _IIlIlllIIl, BTN_W, BTN_H)
    _lllIIlIIll:SetAttribute("288SilentNotification", true)
    _lllIIlIIll.MouseButton1Click:Connect(function()
        task.defer(function()
            _IlIIIlllIl.__288EatTheEarthCommand = {
                _IlIIIIIIII = "autoEat",
                _lIlIlIIIll = _lIIlIlIlII[_lllIIlIIll] == true,
            }
            loadModule("modules/Games/EatTheEarth/Controller")
        end)
    end)

    _lllIlIlllI = _IIlIlllIIl + BTN_H + GAP
    makeSectionLabel(_IllllIllll, "Actions", PAD, _lllIlIlllI)
    local _lIlIllllIl = _lllIlIlllI + 20 + GAP
    local _IllIlIIlII = makeButton(_IllllIllll, "Sell Now", COL1, _lIlIllllIl, BTN_W, BTN_H)
    _IllIlIIlII:SetAttribute("288SilentNotification", true)

    _IllIlIIlII.MouseButton1Click:Connect(function()

        _IlIIIlllIl.__288EatTheEarthCommand = { _IIllIlllIl = "sellNow" }
        loadModule("modules/Games/EatTheEarth/Controller")
    end)

    _llllllIIlI("Game/EatTheEarth", function()
        _IlIIIlllIl.__288EatTheEarthCommand = {_llIlllIlII = true}
        loadModule("modules/Games/EatTheEarth/Controller")
        _IlIIIlllIl.__288EatTheEarthCommand = nil
    end)

    refreshCanvas(_IllllIllll)
end
-- ==================== MushYO TAB ====================
if DETECTED_GAME and DETECTED_GAME.key == "MushYO" then
    local _IllllIllll = Tabs[DETECTED_GAME.name].frame
    local _lllIlIlllI = 10
    makeSectionLabel(_IllllIllll, "Automation", PAD, _lllIlIlllI)
    _lllIlIlllI = _lllIlIlllI + 20 + GAP

    -- Controles principais sempre seguem a grade de duas colunas.
    -- Com tres botoes: dois na primeira linha e um na segunda.

    local _llllIIIllI = 24
    local _lllIIIIllI = 4
    local _IlIlIllIIl = BTN_H
    local _lIIllIIllI = BTN_H + GAP + _llllIIIllI
    local _IIllIIllIl = _lllIlIlllI + _lIIllIIllI + GAP
    makeSectionLabel(_IllllIllll, "Farming & Teleport", PAD, _IIllIIllIl)
    local _llIIIlIlIl = _IIllIIllIl + 20 + GAP

    -- IMPORTANTE: largura de UMA coluna apenas. Nunca cresce horizontalmente.
    local _IllIllIllI = Instance.new("Frame")
    _IllIllIllI.Name = "AutoFishAccordion"
    _IllIllIllI.Size = UDim2.new(0, BTN_W + GAP + DOT_SIZE, 0, _IlIlIllIIl)
    _IllIllIllI.Position = UDim2.new(0, COL1, 0, _lllIlIlllI)
    _IllIllIllI.BackgroundTransparency = 1
    _IllIllIllI.BorderSizePixel = 0
    _IllIllIllI.ClipsDescendants = true
    _IllIllIllI.ZIndex = 3
    _IllIllIllI.LayoutOrder = 1
    _IllIllIllI.Parent = _IllllIllll

    local _IllllllllI = makeToggleButton(_IllIllIllI, "Auto Fish", 0, 0, BTN_W, BTN_H)

    local _IIlllIlIIl = makeToggleButton(_IllllIllll, "Butterfly Farm", COL2, _lllIlIlllI, BTN_W, BTN_H)
    _IIlllIlIIl.LayoutOrder = 2

    _IIlllIlIIl.MouseButton1Click:Connect(function()
        task.defer(function()
            if not requireVipAccess() then
                _lIIlIlIlII[_IIlllIlIIl] = false
                _IIlllIlIIl.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
                local _lIIIIlIIII = toggleIcons[_IIlllIlIIl]
                if _lIIIIlIIII then _lIIIIlIIII.ImageColor3 = _lIllIIlllI end
                return
            end

            _IlIIIlllIl.__288MushYOCommand = {
                _IlIIIIIIII = "butterflyFarm",
                _lIlIlIIIll = _lIIlIlIlII[_IIlllIlIIl] == true
            }
            loadModule("modules/Games/MushYO/Controller")
        end)
    end)

    local _IIllIlIlIl = makeToggleButton(
        _IllllIllll,
        "Auto Treasure",
        COL1,
        _llIIIlIlIl,
        BTN_W,
        BTN_H
    )
    _IIllIlIlIl.LayoutOrder = 3

    local _IllllIlIIl = makeButton(_IllllIllll, "TP Fruta Amarela", COL2, _llIIIlIlIl, BTN_W, BTN_H)
    _IllllIlIIl.LayoutOrder = 4
    _IllllIlIIl:SetAttribute("288SilentNotification", true)

    local _IIlIIIIIlI = makeMouseDot(_IllllIllll, DOT2_X, _llIIIlIlIl + BTN_H / 2 - DOT_SIZE / 2, DOT_SIZE, _IllllIlIIl)
    _IllllIlIIl.MouseButton1Click:Connect(function()
        if not _IIIlllIllI(_IllllIlIIl) then return end
        _IlIIIlllIl.__288MushYOCommand = { _IIllIlllIl = "yellowFruit" }
        loadModule("modules/Games/MushYO/Controller")
    end)

    local _IlIIIIIllI = makeToggleButton(
        _IllllIllll,
        "Auto Capture Bola",
        COL1,
        _llIIIlIlIl + BTN_H + GAP,
        BTN_W,
        BTN_H
    )
    _IlIIIIIllI.LayoutOrder = 5
    _IlIIIIIllI:SetAttribute("288SilentNotification", true)
    _IlIIIIIllI.MouseButton1Click:Connect(function()
        task.defer(function()
            _IlIIIlllIl.__288MushYOCommand = {
                _IlIIIIIIII = "autoDodgeballCatch",
                _lIlIlIIIll = _lIIlIlIlII[_IlIIIIIllI] == true
            }
            loadModule("modules/Games/MushYO/Controller")
        end)
    end)

    _IIllIlIlIl.MouseButton1Click:Connect(function()
        task.defer(function()
            _IlIIIlllIl.__288MushYOCommand = {
                _IlIIIIIIII = "treasureFarm",
                _lIlIlIIIll = _lIIlIlIlII[_IIllIlIlIl] == true
            }
            loadModule("modules/Games/MushYO/Controller")
        end)
    end)

    -- Footer do HUD: Auto Venda Ã  esquerda e Auto Reparo Ã  direita.
    local _lIIlllIlll = Instance.new("Frame")
    _lIIlllIlll.Name = "AutoFishOptions"
    _lIIlllIlll.Size = UDim2.new(0, BTN_W, 0, _llllIIIllI)
    _lIIlllIlll.Position = UDim2.new(0, 0, 0, BTN_H + GAP)
    _lIIlllIlll.BackgroundTransparency = 1
    _lIIlllIlll.BorderSizePixel = 0
    _lIIlllIlll.ZIndex = 3
    _lIIlllIlll.Parent = _IllIllIllI

    local _IlIIllIlII = Instance.new("UIListLayout")
    _IlIIllIlII.FillDirection = Enum.FillDirection.Horizontal
    _IlIIllIlII.SortOrder = Enum.SortOrder.LayoutOrder
    _IlIIllIlII.HorizontalAlignment = Enum.HorizontalAlignment.Left
    _IlIIllIlII.VerticalAlignment = Enum.VerticalAlignment.Center
    _IlIIllIlII.Padding = UDim.new(0, _lllIIIIllI)
    _IlIIllIlII.Parent = _lIIlllIlll

    local function _IIIlIlIIII(_llIlllIIII, _IlIIIIIIII, _llIIllIIIl)
        local _lIIlIIllII = Instance.new("TextButton")
        _lIIlIIllII.Name = _IlIIIIIIII .. "Switch"
        _lIIlIIllII.Size = UDim2.new(0, math.floor((BTN_W - _lllIIIIllI) / 2), 0, _llllIIIllI)
        _lIIlIIllII.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
        _lIIlIIllII.BackgroundTransparency = 0.18
        _lIIlIIllII.BorderSizePixel = 0
        _lIIlIIllII.AutoButtonColor = false
        _lIIlIIllII.AutoLocalize = false
        _lIIlIIllII.Text = _IlIlllIlII(_llIlllIIII)
        _lIIlIIllII.TextColor3 = _IllllIIlII[_lIIlIIlllI].textDim
        _lIIlIIllII.TextSize = 8
        _lIIlIIllII.Font = Enum.Font.GothamMedium
        _lIIlIIllII.TextXAlignment = Enum.TextXAlignment.Left
        _lIIlIIllII.LayoutOrder = _llIIllIIIl
        _lIIlIIllII.ZIndex = 4
        _lIIlIIllII.Parent = _lIIlllIlll
        _lIIlIIllII:SetAttribute("HoverDisabled", true)

        local _IIIllIlIlI = Instance.new("UIPadding")
        _IIIllIlIlI.PaddingLeft = UDim.new(0, 6)
        _IIIllIlIlI.PaddingRight = UDim.new(0, 34)
        _IIIllIlIlI.Parent = _lIIlIIllII

        Instance.new("UICorner", _lIIlIIllII).CornerRadius = UDim.new(0, 7)
        _lIIlIlIllI(_lIIlIIllII, "BackgroundColor3", "btn")
        _lIIlIlIllI(_lIIlIIllII, "TextColor3", "textDim")

        local _llIIIlIIII = Instance.new("Frame")
        _llIIIlIIII.Name = "Track"
        _llIIIlIIII.Size = UDim2.fromOffset(26, 14)
        _llIIIlIIII.AnchorPoint = Vector2.new(1, 0.5)
        _llIIIlIIII.Position = UDim2.new(1, -5, 0.5, 0)
        _llIIIlIIII.BackgroundColor3 = Color3.fromRGB(72, 70, 80)
        _llIIIlIIII.BorderSizePixel = 0
        _llIIIlIIII.ZIndex = 5
        _llIIIlIIII.Parent = _lIIlIIllII
        Instance.new("UICorner", _llIIIlIIII).CornerRadius = UDim.new(1, 0)

        local _lllIlllllI = Instance.new("ImageLabel")
        _lllIlllllI.Name = "ToggleAsset"
        _lllIlllllI.Size = UDim2.fromOffset(10, 10)
        _lllIlllllI.Position = UDim2.fromOffset(2, 2)
        _lllIlllllI.BackgroundTransparency = 1
        _lllIlllllI.Image = _lIIIlllIIl
        _lllIlllllI.ImageColor3 = _lIllIIlllI
        _lllIlllllI.ScaleType = Enum.ScaleType.Fit
        _lllIlllllI.BorderSizePixel = 0
        _lllIlllllI.ZIndex = 6
        _lllIlllllI.Parent = _llIIIlIIII
        local _IIlIlIIIIl = false

        local function _IIIIllIlII(_IIlllllIIl)
            local _IlIlIIlIll = TweenInfo.new(
                _IIlllllIIl and 0.14 or 0,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )

            _lllIllIlIl:Create(_llIIIlIIII, _IlIlIIlIll, {
                BackgroundColor3 = _IIlIlIIIIl and _lIIlIlIlIl or Color3.fromRGB(72, 70, 80)
            }):Play()

            _lllIllIlIl:Create(_lllIlllllI, _IlIlIIlIll, {
                Position = _IIlIlIIIIl and UDim2.fromOffset(14, 2) or UDim2.fromOffset(2, 2),
                ImageColor3 = _IIlIlIIIIl and _IlIlIlIlII or _lIllIIlllI
            }):Play()
            _lllIllIlIl:Create(_lIIlIIllII, _IlIlIIlIll, {
                TextColor3 = _IIlIlIIIIl and _lIIlIlIlIl or _IllllIIlII[_lIIlIIlllI].textDim,
                BackgroundColor3 = _IIlIlIIIIl and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
            }):Play()
        end

        _IIIIllIlII(false)

        _lIIlIIllII.MouseButton1Click:Connect(function()
            _IIlIlIIIIl = not _IIlIlIIIIl
            _IIIIllIlII(true)

            -- Primeiro atualiza o estado do recurso dentro do Controller.
            _IlIIIlllIl.__288MushYOCommand = {
                _IlIIIIIIII = _IlIIIIIIII,
                _lIlIlIIIll = _IIlIlIIIIl
            }
            loadModule("modules/Games/MushYO/Controller")

            -- Ao LIGAR Auto Venda, executa uma venda imediatamente.
            -- O Controller do Auto Fish expoe SellNow depois de carregado.
            if _IlIIIIIIII == "autoSell" and _IIlIlIIIIl then
                task.defer(function()
                    local _IIllIIIIII = _IlIIIlllIl.SellNow
                    if type(_IIllIIIIII) == "function" then
                        pcall(_IIllIIIIII)
                    else
                        -- Fallback para Controllers que tratem a acao pela command table.
                        _IlIIIlllIl.__288MushYOCommand = { _IIllIlllIl = "sellNow" }
                        loadModule("modules/Games/MushYO/Controller")
                    end
                end)
            end
        end)

        return _lIIlIIllII
    end

    -- Footer horizontal: venda Ã  esquerda e reparo Ã  direita.
    _IIIlIlIIII("Auto Venda", "autoSell", 1)
    _IIIlIlIIII("Auto Reparo", "autoRepair", 2)

    local _IllllIllII = false
    local _lIIIllIlIl = nil

    local function _lIIIIIIlll(_IlIlIlIlll)
        _IllllIllII = _IlIlIlIlll == true

        if _lIIIllIlIl then
            pcall(function() _lIIIllIlIl:Cancel() end)
        end

        _lIIIllIlIl = _lllIllIlIl:Create(
            _IllIllIllI,
            TweenInfo.new(
                0.18,
                Enum.EasingStyle.Quad,
                _IllllIllII and Enum.EasingDirection.Out or Enum.EasingDirection.In
            ),
            {
                -- SOMENTE altura muda. A largura permanece BTN_W.
                Size = UDim2.new(0, BTN_W + GAP + DOT_SIZE, 0, _IllllIllII and _lIIllIIllI or _IlIlIllIIl),
            }
        )

        _lIIIllIlIl:Play()
        _lIIIllIlIl.Completed:Once(function()
            refreshCanvas(_IllllIllll)
        end)
    end

    _IllllllllI.MouseButton1Click:Connect(function()
        task.defer(function()
            if not requireVipAccess() then
                _lIIlIlIlII[_IllllllllI] = false
                _IllllllllI.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
                local _lIIIIlIIII = toggleIcons[_IllllllllI]
                if _lIIIIlIIII then _lIIIIlIIII.ImageColor3 = _lIllIIlllI end
                _lIIIIIIlll(false)
                return
            end

            local _IIlIlIIIIl = _lIIlIlIlII[_IllllllllI] == true

            _IlIIIlllIl.__288MushYOCommand = {
                _IlIIIIIIII = "autoFish",
                _lIlIlIIIll = _IIlIlIIIIl
            }
            loadModule("modules/Games/MushYO/Controller")

            -- O accordion acompanha o estado do Auto Fish.
            _lIIIIIIlll(_IIlIlIIIIl)
        end)
    end)

    _llllllIIlI("Game/MushYO", function()
        _IlIIIlllIl.__288MushYOCommand = {_llIlllIlII = true}
        loadModule("modules/Games/MushYO/Controller")
        _IlIIIlllIl.__288MushYOCommand = nil
    end)

    refreshCanvas(_IllllIllll)
end

-- ==================== RO-VIBES TAB ====================
if DETECTED_GAME and DETECTED_GAME.key == "RoVibes" then
    local _IllllIllll = Tabs[DETECTED_GAME.name].frame
    local _lllIlIlllI = 10
    local _llIIllIIlI = "modules/Games/RoVibes/AutoCollectLuckyBlocks"
    local _lllllllIII = "__288LuckyBlock"
    local _IllIIIlllI = (getgenv and getgenv()) or _G
    local _IIIlIIllll = {}

    local function _llIlIIIlIl(_lIIlIIllII, _IIlIlIIIIl)
        _lIIlIlIlII[_lIIlIIllII] = _IIlIlIIIIl
        _lIIlIIllII.BackgroundColor3 = _IIlIlIIIIl and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
        local _IlIIlIlIlI = toggleIcons[_lIIlIIllII]
        if _IlIIlIlIlI then _IlIIlIlIlI.ImageColor3 = _IIlIlIIIIl and _IlIlIlIlII or _lIllIIlllI end
    end

    local function _IlIlIIllll(_llIIlllIll, _lIIllIlIlI)
        makeSectionLabel(_IllllIllll, _llIIlllIll, PAD, _lllIlIlllI)
        local _IIlIlllIIl = _lllIlIlllI + 20 + GAP
        for _lllllIlIIl, _lIIIlllIll in ipairs(_lIIllIlIlI) do
            local _IIIlIIlIII, _lIlIIlIIll = gridSlot(_lllllIlIIl, _IIlIlllIIl)
            local _lIIlIIllII
            if _lIIIlllIll.oneShot then
                _lIIlIIllII = makeButton(_IllllIllll, _lIIIlllIll.name, _IIIlIIlIII, _lIlIIlIIll, BTN_W, BTN_H, _lIIIlllIll.vipOnly)
                _lIIlIIllII:SetAttribute("288SilentNotification", true)
                local _llIlIlIIll = (_lllllIlIIl % 2 == 1) and DOT1_X or DOT2_X
                makeMouseDot(_IllllIllll, _llIlIlIIll, _lIlIIlIIll + BTN_H / 2 - DOT_SIZE / 2, DOT_SIZE, _lIIlIIllII)
            else
                _lIIlIIllII = makeToggleButton(_IllllIllll, _lIIIlllIll.name, _IIIlIIlIII, _lIlIIlIIll, BTN_W, BTN_H, _lIIIlllIll.vipOnly)
                _lIIlIIllII:SetAttribute("288SilentNotification", true)
            end

            if _lIIIlllIll.vipOnly then
                local _IlIllIIllI = _IllIlIIlIl or _lIIlIIllII:GetAttribute("288RedirectToVip") == true
                _lIIlIIllII.Active = _IlIllIIllI
                _lIIlIIllII.Selectable = _IlIllIIllI
                pcall(function() _lIIlIIllII.Interactable = _IlIllIIllI end)
            end

            local _lllllllIll = {
                _IlIlIlllll = _lIIIlllIll.name,
                _lIlIlIIllI = _lIIIlllIll.path,
                envKey = _lIIIlllIll.envKey,
                luckyOption = _lIIIlllIll.luckyOption,
                vipOnly = _lIIIlllIll.vipOnly,
                oneShot = _lIIIlllIll.oneShot,
                _lIIlIIllII = _lIIlIIllII,
            }
            _IIIlIIllll[_lIIIlllIll.name] = _lllllllIll

            _lIIlIIllII.MouseButton1Click:Connect(function()
                if _lIIIlllIll.oneShot and not _IIIlllIllI(_lIIlIIllII) then return end
                task.defer(function()
                    if _lIIIlllIll.vipOnly and not _IllIlIIlIl then
                        _llIlIIIlIl(_lIIlIIllII, false)
                        return
                    end

                    if _lIIIlllIll.luckyOption then
                        local _IIlIlIIIIl = _lIIlIlIlII[_lIIlIIllII] == true
                        local _IllIlllIll = _IllIIIlllI[_lIIIlllIll.envKey]
                        if _IIlIlIIIIl then
                            _IllIIIlllI.__288LuckyCommand = { option = _lIIIlllIll.luckyOption, _lIlIlIIIll = true }
                            local _lllIllIllI, _IIIIIlllIl = pcall(loadModule, _lIIIlllIll.path)
                            _IllIIIlllI.__288LuckyCommand = nil
                            if not _lllIllIllI or not _IIIIIlllIl then
                                _llIlIIIlIl(_lIIlIIllII, false)
                                notifyPanel(_lIIIlllIll.name, "Could not start this Lucky Block option.", "error", 5)
                                return
                            end

                            if _lIIIlllIll.luckyOption ~= "esp" then
                                for _llIIIIIIII, other in pairs(_IIIlIIllll) do
                                    if other.luckyOption and other.luckyOption ~= "esp"
                                        and other.luckyOption ~= _lIIIlllIll.luckyOption
                                        and _lIIlIlIlII[other.button] then
                                        _llIlIIIlIl(other.button, false)
                                    end
                                end
                            end
                        elseif _IllIlllIll and type(_IllIlllIll.SetOption) == "function" then
                            local _lllIllIllI, _lllIlIIlII = pcall(function()
                                return _IllIlllIll:SetOption(_lIIIlllIll.luckyOption, false)
                            end)
                            if not _lllIllIllI or _lllIlIIlII == false then
                                notifyPanel(_lIIIlllIll.name, "Could not stop this Lucky Block option.", "warning", 4)
                            end
                        end
                        return
                    end

                    if _lIIIlllIll.oneShot then
                        local _IIIIIlllIl = loadModule(_lIIIlllIll.path)
                        if not _IIIIIlllIl then
                            notifyPanel(_lIIIlllIll.name, "Failed to load the teleport module.", "error", 5)
                        end
                        return
                    end

                    local _IIlIlIIIIl = _lIIlIlIlII[_lIIlIIllII] == true
                    if _IIlIlIIIIl then
                        local _IIIIIlllIl = loadModule(_lIIIlllIll.path)
                        if not _IIIIIlllIl then
                            _llIlIIIlIl(_lIIlIIllII, false)
                            notifyPanel(_lIIIlllIll.name, "Failed to load the module.", "error", 5)
                        end
                    else
                        local _IllIlllIll = _IllIIIlllI[_lIIIlllIll.envKey]
                        if _IllIlllIll and type(_IllIlllIll.Stop) == "function" then
                            pcall(function() _IllIlllIll:Stop() end)
                        end
                    end
                end)
            end)
        end
        _lllIlIlllI = _IIlIlllIIl + math.ceil(#_lIIllIlIlI / 2) * (BTN_H + GAP) + 4
    end

    _IlIlIIllll("Lucky Block", {
        { _IlIlIlllll = "Lucky Compass", _lIlIlIIllI = _llIIllIIlI, envKey = _lllllllIII, luckyOption = "free" },
        { _IlIlIlllll = "Lucky ESP", _lIlIlIIllI = _llIIllIIlI, envKey = _lllllllIII, luckyOption = "esp", vipOnly = true },
        { _IlIlIlllll = "Lucky Collect", _lIlIlIIllI = _llIIllIIlI, envKey = _lllllllIII, luckyOption = "collect", vipOnly = true },
        { _IlIlIlllll = "Lucky Top", _lIlIlIIllI = _llIIllIIlI, envKey = _lllllllIII, luckyOption = "top", vipOnly = true },
    })

    _IlIlIIllll("Automation", {
        { _IlIlIlllll = "Auto Grimoire", _lIlIlIIllI = "modules/Games/RoVibes/AutoCollectGrimorios", envKey = "__288Grimorio" }
    })

    _IlIlIIllll("Teleport", {
        { _IlIlIlllll = "TP Cave", _lIlIlIIllI = "modules/Games/RoVibes/TPCaverna", envKey = "__288TPCaverna", oneShot = true },
        { _IlIlIlllll = "TP Pet", _lIlIlIIllI = "modules/Games/RoVibes/TPPet", envKey = "__288TPPet", oneShot = true },
        { _IlIlIlllll = "TP Dragon", _lIlIlIIllI = "modules/Games/RoVibes/TPDragao", envKey = "__288TPDragao", oneShot = true },
    })

    _llllllIIlI("Game/RoVibes", function()
        for _llIIIIIIII, _lllllllIll in pairs(_IIIlIIllll) do
            local _IllIlllIll = _IllIIIlllI[_lllllllIll.envKey]
            if _IllIlllIll and type(_IllIlllIll.Stop) == "function" then
                pcall(function() _IllIlllIll:Stop() end)
            end
        end
    end)

    refreshCanvas(_IllllIllll)
end
-- ==================== SERVERS TAB ====================
do
    local _IllllIllll = Tabs["Servers"].frame
    _IllllIllll.ScrollingEnabled = false

    local http_request = http and http.request or syn and syn.request or request
    local _IIlIlIllll = game:GetService("HttpService")
    local _IllIlIlIII = game:GetService("TeleportService")

    -- MantÃ©m exatamente o mesmo espaÃ§amento/grid visual usado nas demais abas.
    local _IllIIIllII = 10
    local _IIIIIIIIII = 38
    local _llllllIIll = 70
    local _IIIIIIIIll = 122
    local _IlIllIllll = 150

    makeSectionLabel(_IllllIllll, "Friends on other servers:", PAD, _IllIIIllII)

    local _IIIIlIIIlI = makeButton(_IllllIllll, "Refresh", COL2, 6, BTN_W, BTN_H)
    _IIIIlIIIlI.Name = "RefreshServersButton"
    _IIIIlIIIlI:SetAttribute("288SilentNotification", true)

    local _IIIIllllll = _llllIIlllI(_IIIIlIIIlI, "status", 12, 8, 18, _lIIlIlIlIl)
    _IIIIllllll.Position = UDim2.new(0, 12, 0.5, -9)

    local _IlIIlIIllI = Instance.new("ScrollingFrame")
    _IlIIlIIllI.Name = "FriendsServerList"
    _IlIIlIIllI.Size = UDim2.new(1, -PAD * 2, 0, _llllllIIll)
    _IlIIlIIllI.Position = UDim2.new(0, PAD, 0, _IIIIIIIIII)
    _IlIIlIIllI.BackgroundTransparency = 1
    _IlIIlIIllI.BorderSizePixel = 0
    _IlIIlIIllI.ScrollBarThickness = 3
    _IlIIlIIllI.ScrollBarImageColor3 = _lIIlIlIlIl
    _IlIIlIIllI.ScrollingDirection = Enum.ScrollingDirection.X
    _IlIIlIIllI.CanvasSize = UDim2.new(0, 0, 0, 0)
    _IlIIlIIllI.AutomaticCanvasSize = Enum.AutomaticSize.None
    _IlIIlIIllI.ZIndex = 4
    _IlIIlIIllI.Parent = _IllllIllll
    _lIIlIlIllI(_IlIIlIIllI, "ScrollBarImageColor3", "accent")

    local _IlllllIlII = Instance.new("UIListLayout")
    _IlllllIlII.FillDirection = Enum.FillDirection.Horizontal
    _IlllllIlII.VerticalAlignment = Enum.VerticalAlignment.Center
    _IlllllIlII.SortOrder = Enum.SortOrder.LayoutOrder
    _IlllllIlII.Padding = UDim.new(0, GAP)
    _IlllllIlII.Parent = _IlIIlIIllI

    local _llIIlIlIlI = Instance.new("TextLabel")
    _llIIlIlIlI.Name = "NoFriendsLabel"
    _llIIlIlIlI.Size = UDim2.new(1, 0, 1, 0)
    _llIIlIlIlI.BackgroundTransparency = 1
    _llIIlIlIlI.Text = "No friends are playing this game on another server."
    _llIIlIlIlI.TextColor3 = _lIIIlIlIIl
    _llIIlIlIlI.TextSize = 11
    _llIIlIlIlI.Font = Enum.Font.Gotham
    _llIIlIlIlI.TextXAlignment = Enum.TextXAlignment.Left
    _llIIlIlIlI.TextYAlignment = Enum.TextYAlignment.Center
    _llIIlIlIlI.ZIndex = 4
    _llIIlIlIlI.Parent = _IlIIlIIllI
    _lIIlIlIllI(_llIIlIlIlI, "TextColor3", "textDim")

    makeSectionLabel(_IllllIllll, "Available servers:", PAD, _IIIIIIIIll)

    local _IlllIIlIlI = Instance.new("ScrollingFrame")
    _IlllIIlIlI.Name = "AvailableServerList"
    _IlllIIlIlI.Size = UDim2.new(1, -PAD * 2, 1, -(_IlIllIllll + 10))
    _IlllIIlIlI.Position = UDim2.new(0, PAD, 0, _IlIllIllll)
    _IlllIIlIlI.BackgroundTransparency = 1
    _IlllIIlIlI.BorderSizePixel = 0
    _IlllIIlIlI.ScrollBarThickness = 3
    _IlllIIlIlI.ScrollBarImageColor3 = _lIIlIlIlIl
    _IlllIIlIlI.CanvasSize = UDim2.new(0, 0, 0, 0)
    _IlllIIlIlI.ZIndex = 4
    _IlllIIlIlI.Parent = _IllllIllll
    _lIIlIlIllI(_IlllIIlIlI, "ScrollBarImageColor3", "accent")

    local _IlIIIllIll = BTN_W
    local _IlllIlllll = BTN_H
    local _lIIIlIIIll = GAP
    local _IIlllIIIll = 0
    local _lIllIlIlIl = BTN_W + GAP + DOT_SIZE + GAP

    local function _IIllllIIlI(_lIlIIIIlll)
        _lIlIIIIlll.BackgroundColor3 = _llIIIIIlIl
        _lIlIIIIlll.BackgroundTransparency = 0.16
        _lIlIIIIlll.AutoButtonColor = false
        _lIlIIIIlll.BorderSizePixel = 0
        _lIlIIIIlll.Text = ""
        Instance.new("UICorner", _lIlIIIIlll).CornerRadius = UDim.new(0, 11)
        _lIIlIlIllI(_lIlIIIIlll, "BackgroundColor3", "btn")

        local _lllllIIlIl = Instance.new("UIStroke")
        _lllllIIlIl.Name = "ServerCardStroke"
        _lllllIIlIl.Color = _llIIllllll
        _lllllIIlIl.Transparency = 0.58
        _lllllIIlIl.Thickness = 1
        _lllllIIlIl.Parent = _lIlIIIIlll
        _lIIlIlIllI(_lllllIIlIl, "Color", "stroke")
        _llIlIIIlII(_lIlIIIIlll, false)
    end

    local function _llIIIllIII(_lllIIlIllI, _lIIIIIIllI)
        local _IlllIIlIII = tonumber(_lllIIlIllI.VisitorId or _lllIIlIllI.UserId or _lllIIlIllI.Id)
        local _llIlIIIlll = tostring(_lllIIlIllI.UserName or _lllIIlIllI.Username or "Friend")
        local _llIIIlIIll = tostring(_lllIIlIllI.DisplayName or _llIlIIIlll)
        local _IIlIlIlllI = tostring(_lllIIlIllI.GameId or "")

        local _lIlIIIIlll = Instance.new("TextButton")
        _lIlIIIIlll.Name = "Friend" .. tostring(_IlllIIlIII or _lIIIIIIllI)
        _lIlIIIIlll.Size = UDim2.new(0, BTN_W, 0, 58)
        _lIlIIIIlll.LayoutOrder = _lIIIIIIllI
        _lIlIIIIlll.ZIndex = 5
        _lIlIIIIlll.Parent = _IlIIlIIllI
        _IIllllIIlI(_lIlIIIIlll)

        local _lIlllIllll = Instance.new("ImageLabel")
        _lIlllIllll.Name = "Avatar"
        _lIlllIllll.Size = UDim2.new(0, 42, 0, 42)
        _lIlllIllll.Position = UDim2.new(0, 8, 0.5, -21)
        _lIlllIllll.BackgroundColor3 = _lIIlIIlIlI
        _lIlllIllll.BackgroundTransparency = 0.08
        _lIlllIllll.BorderSizePixel = 0
        _lIlllIllll.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        _lIlllIllll.ZIndex = 6
        _lIlllIllll.Parent = _lIlIIIIlll
        Instance.new("UICorner", _lIlllIllll).CornerRadius = UDim.new(1, 0)
        _lIIlIlIllI(_lIlllIllll, "BackgroundColor3", "surface2")

        local _IllllllIIl = Instance.new("UIStroke")
        _IllllllIIl.Color = _llIIllllll
        _IllllllIIl.Transparency = 0.58
        _IllllllIIl.Thickness = 1
        _IllllllIIl.Parent = _lIlllIllll
        _lIIlIlIllI(_IllllllIIl, "Color", "stroke")

        local _llIllIIlIl = Instance.new("TextLabel")
        _llIllIIlIl.Size = UDim2.new(1, -68, 0, 19)
        _llIllIIlIl.Position = UDim2.new(0, 58, 0, 10)
        _llIllIIlIl.BackgroundTransparency = 1
        _llIllIIlIl.Text = _llIIIlIIll
        _llIllIIlIl.TextColor3 = _llIIIIIIIl
        _llIllIIlIl.TextSize = 11
        _llIllIIlIl.Font = Enum.Font.GothamBold
        _llIllIIlIl.TextXAlignment = Enum.TextXAlignment.Left
        _llIllIIlIl.TextTruncate = Enum.TextTruncate.AtEnd
        _llIllIIlIl.ZIndex = 6
        _llIllIIlIl.Parent = _lIlIIIIlll
        _lIIlIlIllI(_llIllIIlIl, "TextColor3", "text")

        local _llIlIlIlII = Instance.new("TextLabel")
        _llIlIlIlII.Size = UDim2.new(1, -68, 0, 16)
        _llIlIlIlII.Position = UDim2.new(0, 58, 0, 30)
        _llIlIlIlII.BackgroundTransparency = 1
        _llIlIlIlII.Text = "Join server"
        _llIlIlIlII.TextColor3 = _lIIlIlIlIl
        _llIlIlIlII.TextSize = 9
        _llIlIlIlII.Font = Enum.Font.GothamMedium
        _llIlIlIlII.TextXAlignment = Enum.TextXAlignment.Left
        _llIlIlIlII.ZIndex = 6
        _llIlIlIlII.Parent = _lIlIIIIlll
        _lIIlIlIllI(_llIlIlIlII, "TextColor3", "accent")

        if _IlllIIlIII then
            task.spawn(function()
                local _lllIllIllI, _lIlIlIlIIl = pcall(function()
                    return _lllIIIlIlI:GetUserThumbnailAsync(
                        _IlllIIlIII,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size100x100
                    )
                end)
                if _lllIllIllI and _lIlllIllll.Parent then _lIlllIllll.Image = _lIlIlIlIIl end
            end)
        end

        _lIlIIIIlll.MouseButton1Click:Connect(function()
            if _IIlIlIlllI == "" then return end
            pcall(function()
                _IllIlIlIII:TeleportToPlaceInstance(game.PlaceId, _IIlIlIlllI, _IlllllllII)
            end)
        end)
    end

    local function _lIllllIlII()
        for _llIIIIIIII, child in ipairs(_IlIIlIIllI:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local _lllIllIllI, _lllllIllIl = pcall(function()
            return _IlllllllII:GetFriendsOnline(200)
        end)

        local _llIllIllII = 0
        if _lllIllIllI and type(_lllllIllIl) == "table" then
            for _llIIIIIIII, _lllIIlIllI in ipairs(_lllllIllIl) do
                local _IlIIlIllIl = tonumber(_lllIIlIllI.PlaceId)
                local _IIlIlIlllI = tostring(_lllIIlIllI.GameId or "")
                if _IlIIlIllIl == game.PlaceId
                    and _IIlIlIlllI ~= ""
                    and _IIlIlIlllI ~= tostring(game.JobId) then
                    _llIllIllII += 1
                    _llIIIllIII(_lllIIlIllI, _llIllIllII)
                end
            end
        end

        _llIIlIlIlI.Visible = _llIllIllII == 0
        _IlIIlIIllI.CanvasSize = UDim2.new(
            0,
            _llIllIllII > 0 and (_llIllIllII * BTN_W + math.max(0, _llIllIllII - 1) * GAP) or 0,
            0,
            0
        )
    end

    local function _llIlIlIllI(_IllIllIIIl, _lIIIIIIllI)
        local _lIlIIIIlll = Instance.new("TextButton")
        _lIlIIIIlll.Name = "ServerCard" .. tostring(_lIIIIIIllI)
        _lIlIIIIlll.Size = UDim2.new(0, _IlIIIllIll, 0, _IlllIlllll)
        _lIlIIIIlll.Position = UDim2.new(
            0,
            (_lIIIIIIllI % 2 == 1) and _IIlllIIIll or _lIllIlIlIl,
            0,
            math.floor((_lIIIIIIllI - 1) / 2) * (_IlllIlllll + _lIIIlIIIll)
        )
        _lIlIIIIlll.ZIndex = 5
        _lIlIIIIlll.Parent = _IlllIIlIlI
        _IIllllIIlI(_lIlIIIIlll)

        local _IlIllIIlIl = Instance.new("TextLabel")
        _IlIllIIlIl.Name = "ServerInfo"
        _IlIllIIlIl.Size = UDim2.new(1, -42, 1, 0)
        _IlIllIIlIl.Position = UDim2.new(0, 13, 0, 0)
        _IlIllIIlIl.BackgroundTransparency = 1
        _IlIllIIlIl.Text = string.format("%d/%d  â€¢  %dms", _IllIllIIIl.players, _IllIllIIIl.maxPlayers, _IllIllIIIl.ping)
        _IlIllIIlIl.TextColor3 = _llIIIIIIIl
        _IlIllIIlIl.TextSize = 11
        _IlIllIIlIl.Font = Enum.Font.GothamMedium
        _IlIllIIlIl.TextXAlignment = Enum.TextXAlignment.Left
        _IlIllIIlIl.TextTruncate = Enum.TextTruncate.AtEnd
        _IlIllIIlIl.ZIndex = 6
        _IlIllIIlIl.Parent = _lIlIIIIlll
        _lIIlIlIllI(_IlIllIIlIl, "TextColor3", "text")

        local _llIIIIllIl = Instance.new("Frame")
        _llIIIIllIl.Name = "PingDot"
        _llIIIIllIl.Size = UDim2.new(0, 7, 0, 7)
        _llIIIIllIl.Position = UDim2.new(1, -20, 0.5, -3.5)
        _llIIIIllIl.BackgroundColor3 = _IllIllIIIl.ping < 80
            and Color3.fromRGB(80, 220, 100)
            or (_IllIllIIIl.ping < 160 and Color3.fromRGB(255, 180, 70) or Color3.fromRGB(255, 95, 110))
        _llIIIIllIl.BorderSizePixel = 0
        _llIIIIllIl.ZIndex = 6
        _llIIIIllIl.Parent = _lIlIIIIlll
        _llIIIIllIl:SetAttribute("PreserveThemeColor", true)
        Instance.new("UICorner", _llIIIIllIl).CornerRadius = UDim.new(1, 0)

        _lIlIIIIlll.MouseButton1Click:Connect(function()
            pcall(function()
                _IllIlIlIII:TeleportToPlaceInstance(game.PlaceId, _IllIllIIIl.id, _IlllllllII)
            end)
        end)

        return _lIlIIIIlll
    end

    local _IIlIIlllII = {}
    local _lllIIIIIII = false

    local function _IIIlIIlIIl()
        table.clear(_IIlIIlllII)
        for _llIIIIIIII, child in ipairs(_IlllIIlIlI:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
    end

    local function _llllllIlll(_lIlIIIIlll, _IllIllIIIl)
        if not _lIlIIIIlll or not _lIlIIIIlll.Parent then return end

        local _IlIllIIlIl = _lIlIIIIlll:FindFirstChild("ServerInfo")
        if _IlIllIIlIl then
            _IlIllIIlIl.Text = string.format(
                "%d/%d  â€¢  %dms",
                tonumber(_IllIllIIIl.players) or 0,
                tonumber(_IllIllIIIl.maxPlayers) or 0,
                tonumber(_IllIllIIIl.ping) or 0
            )
        end

        local _llIIIIllIl = _lIlIIIIlll:FindFirstChild("PingDot")
        if _llIIIIllIl then
            local _IlllllIIlI = tonumber(_IllIllIIIl.ping) or 0
            _llIIIIllIl.BackgroundColor3 =
                _IlllllIIlI < 80 and Color3.fromRGB(80, 220, 100)
                or (_IlllllIIlI < 160 and Color3.fromRGB(255, 180, 70)
                or Color3.fromRGB(255, 95, 110))
        end
    end

    local function _lIIIllIIlI(_IIIIIlIIll)
        local _lllIIlllII = "https://games.roblox.com/v1/games/"
            .. game.PlaceId
            .. "/servers/Public?sortOrder=Asc&excludeFullGames=false&limit=100"

        if _IIIIIlIIll and _IIIIIlIIll ~= "" then
            _lllIIlllII = _lllIIlllII .. "&cursor=" .. _IIlIlIllll:UrlEncode(_IIIIIlIIll)
        end

        local _IIIlllllll, _llllllllII = pcall(http_request, {
            Url = _lllIIlllII,
            Method = "GET"
        })

        if not _IIIlllllll or not _llllllllII then
            return nil, "request"
        end

        local _lIIIlIIlIl = tonumber(_llllllllII.StatusCode or _llllllllII.Status or 0) or 0
        if _lIIIlIIlIl ~= 200 then
            return nil, "http " .. tostring(_lIIIlIIlIl)
        end

        local _lllIllIIII, _lIIllIIIll = pcall(function()
            return _IIlIlIllll:JSONDecode(_llllllllII.Body or "{}")
        end)

        if not _lllIllIIII or type(_lIIllIIIll) ~= "table" or type(_lIIllIIIll.data) ~= "table" then
            return nil, "decode"
        end

        return _lIIllIIIll
    end

    local function _lIIlIIlIll()
        if not http_request then
            return nil, "HTTP request indisponÃ­vel"
        end

        local _lllIlIIlII = {}
        local _IIIIIlIIll = nil
        local _IIIlIIIIIl = {}

        repeat
            local _lIIllIIIll, _lIIIIlllII = _lIIIllIIlI(_IIIIIlIIll)
            if not _lIIllIIIll then
                return nil, _lIIIIlllII
            end

            for _llIIIIIIII, s in ipairs(_lIIllIIIll.data) do
                table.insert(_lllIlIIlII, {
                    _lllIIllllI = tostring(s.id or ""),
                    players = tonumber(s.playing) or 0,
                    maxPlayers = tonumber(s.maxPlayers) or 0,
                    _IlllllIIlI = tonumber(s.ping) or 0,
                })
            end

            local _lIIllIlIII = _lIIllIIIll.nextPageCursor
            if not _lIIllIlIII or _lIIllIlIII == "" or _IIIlIIIIIl[_lIIllIlIII] then
                _IIIIIlIIll = nil
            else
                _IIIlIIIIIl[_lIIllIlIII] = true
                _IIIIIlIIll = _lIIllIlIII
            end

            -- Evita monopolizar a thread quando hÃ¡ muitas pÃ¡ginas.
            if _IIIIIlIIll then
                task.wait()
            end
        until not _IIIIIlIIll

        return _lllIlIIlII
    end

    local function _lIlllIIllI(_IlIIllllIl, _lIlIIIIllI)
        if _lIlIIIIllI then
            _IIIlIIlIIl()
        end

        for i, _IllIllIIIl in ipairs(_IlIIllllIl) do
            local _lIlIIIIlll = _IIlIIlllII[_IllIllIIIl.id]
            if not _lIlIIIIlll or not _lIlIIIIlll.Parent then
                _lIlIIIIlll = _llIlIlIllI(_IllIllIIIl, i)
                _IIlIIlllII[_IllIllIIIl.id] = _lIlIIIIlll
            else
                _lIlIIIIlll.Position = UDim2.new(
                    0,
                    (i % 2 == 1) and _IIlllIIIll or _lIllIlIlIl,
                    0,
                    math.floor((i - 1) / 2) * (_IlllIlllll + _lIIIlIIIll)
                )
                _llllllIlll(_lIlIIIIlll, _IllIllIIIl)
            end
        end

        -- Remove servidores que deixaram de existir entre uma atualizaÃ§Ã£o e outra.
        local _IlIIllIlIl = {}
        for _llIIIIIIII, _IllIllIIIl in ipairs(_IlIIllllIl) do
            _IlIIllIlIl[_IllIllIIIl.id] = true
        end
        for _lllIIllllI, _lIlIIIIlll in pairs(_IIlIIlllII) do
            if not _IlIIllIlIl[_lllIIllllI] then
                if _lIlIIIIlll and _lIlIIIIlll.Parent then _lIlIIIIlll:Destroy() end
                _IIlIIlllII[_lllIIllllI] = nil
            end
        end

        local _IIlllIIIlI = math.ceil(#_IlIIllllIl / 2)
        _IlllIIlIlI.CanvasSize = UDim2.new(
            0, 0, 0,
            math.max(0, _IIlllIIIlI * (_IlllIlllll + _lIIIlIIIll) - _lIIIlIIIll)
        )
    end

    local function _lIlllIlIll(_lIlllIlIIl)
        if _lllIIIIIII then return end
        _lllIIIIIII = true

        _lIllllIlII()

        if not http_request then
            warn("[288] Este ambiente nÃ£o fornece uma funÃ§Ã£o de HTTP request compatÃ­vel para listar servidores.")
            _lllIIIIIII = false
            return
        end

        local _IlIIllllIl, _lIIIIlllII = _lIIlIIlIll()
        if _IlIIllllIl then
            _lIlllIIllI(_IlIIllllIl, _lIlllIlIIl == true)
        else
            warn("[288] Falha ao buscar todos os servidores: " .. tostring(_lIIIIlllII))
        end

        _lllIIIIIII = false
    end

    _IIIIlIIIlI.MouseButton1Click:Connect(function()
        task.spawn(function()
            _lIlllIlIll(true)
        end)
    end)

    -- Primeira carga: lista TODAS as pÃ¡ginas de servidores pÃºblicos.
    task.spawn(function()
        _lIlllIlIll(true)
    end)

    -- MantÃ©m jogadores/ping dos cards atualizados sem recriar a lista inteira.
    task.spawn(function()
        while _lIlllIlIlI.Parent and not _lIlIllllII do
            task.wait(5)
            if CurrentTab == "Servers" then
                _lIlllIlIll(false)
            end
        end
    end)
end

-- ==================== STAFF / TARGETS ====================
do
    local _IllllIllll = Tabs["Staff"].frame
    makeSectionLabel(_IllllIllll, "TARGET Â· USERS IN THIS SERVER", PAD, 12)

    local _lllIIlllIl = Instance.new("TextLabel")
    _lllIIlllIl.Name = "StaffTargetStatus"
    _lllIIlllIl.Size = UDim2.new(0, 196, 0, 22)
    _lllIIlllIl.Position = UDim2.new(0, PAD, 0, 35)
    _lllIIlllIl.BackgroundTransparency = 1
    _lllIIlllIl.Text = "Loading users..."
    _lllIIlllIl.TextColor3 = _lIIIlIlIIl
    _lllIIlllIl.TextSize = 10
    _lllIIlllIl.Font = Enum.Font.Gotham
    _lllIIlllIl.TextXAlignment = Enum.TextXAlignment.Left
    _lllIIlllIl.ZIndex = 4
    _lllIIlllIl.Parent = _IllllIllll

    local _lIIIlllllI = makeButton(_IllllIllll, "Refresh", COL2, 10, BTN_W, 30)
    _lIIIlllllI:SetAttribute("288SilentNotification", true)

    local _lIlIlIIlIl = Instance.new("ScrollingFrame")
    _lIlIlIIlIl.Name = "StaffTargetList"
    _lIlIlIIlIl.Size = UDim2.new(1, -PAD * 2, 0, 112)
    _lIlIlIIlIl.Position = UDim2.new(0, PAD, 0, 58)
    _lIlIlIIlIl.BackgroundColor3 = _llIIIIIlIl
    _lIlIlIIlIl.BackgroundTransparency = 0.12
    _lIlIlIIlIl.BorderSizePixel = 0
    _lIlIlIIlIl.ScrollBarThickness = 4
    _lIlIlIIlIl.ScrollBarImageColor3 = _lIIlIlIlIl
    _lIlIlIIlIl.CanvasSize = UDim2.new(0, 0, 0, 0)
    _lIlIlIIlIl.AutomaticCanvasSize = Enum.AutomaticSize.Y
    _lIlIlIIlIl.ZIndex = 4
    _lIlIlIIlIl.Parent = _IllllIllll
    Instance.new("UICorner", _lIlIlIIlIl).CornerRadius = UDim.new(0, 10)
    _lIIlIlIllI(_lIlIlIIlIl, "BackgroundColor3", "btn")

    local _llllIlIlIl = Instance.new("UIListLayout")
    _llllIlIlIl.Padding = UDim.new(0, 3)
    _llllIlIlIl.SortOrder = Enum.SortOrder.LayoutOrder
    _llllIlIlIl.Parent = _lIlIlIIlIl
    local _IIIIlIlIII = Instance.new("UIPadding")
    _IIIIlIlIII.PaddingTop = UDim.new(0, 5)
    _IIIIlIlIII.PaddingBottom = UDim.new(0, 5)
    _IIIIlIlIII.PaddingLeft = UDim.new(0, 6)
    _IIIIlIlIII.PaddingRight = UDim.new(0, 6)
    _IIIIlIlIII.Parent = _lIlIlIIlIl

    local _IIIIllIlIl = Instance.new("TextLabel")
    _IIIIllIlIl.Name = "StaffSelectedTarget"
    _IIIIllIlIl.Size = UDim2.new(1, -PAD * 2, 0, 22)
    _IIIIllIlIl.Position = UDim2.new(0, PAD, 0, 175)
    _IIIIllIlIl.BackgroundTransparency = 1
    _IIIIllIlIl.Text = "Selected: none"
    _IIIIllIlIl.TextColor3 = _llIIIIIIIl
    _IIIIllIlIl.TextSize = 10
    _IIIIllIlIl.Font = Enum.Font.GothamMedium
    _IIIIllIlIl.TextXAlignment = Enum.TextXAlignment.Left
    _IIIIllIlIl.TextTruncate = Enum.TextTruncate.AtEnd
    _IIIIllIlIl.ZIndex = 4
    _IIIIllIlIl.Parent = _IllllIllll

    local _llIIlllllI = {}
    local _IIlIlIIIll = nil
    local _lIIllIllIl = {}
    local _lIlllllIIl = false
    local _lIIIlIlIII = nil
    local _llIlIIIIll = {3, 7, 30}
    local _Illlllllll = 1
    local _IlllIlIIlI
    local _IIllIIlIll, _llIlllIIlI, _IIIlllllIl, _IlIIIIllII, _IlllllIIII
    local _lIllIIllIl, _IIlIlIIlII, _lIlIIIIlII, _IIlIllIIlI
    local _llIlllllII

    local function _llllIllIlI(_lIlIlIIllI, _IlIIIIIIll)
        _IlIIIIIIll = _IlIIIIIIll or {}
        _IlIIIIIIll.userid = _IlllllllII.UserId
        _IlIIIIIIll.sessionId = _lIlIllIllI
        _IlIIIIIIll.targetUserId = _IIlIlIIIll
        return _IIIIIlIlII("/api/staff/" .. _lIlIlIIllI, _IlIIIIIIll)
    end

    local function _lIlIllIIlI()
        if not _lIlIllIllI then return false end
        if _lIlllllIIl then return nil end
        _lIlllllIIl = true
        local _lllllIlIII = "?userid=" .. _IIlIlIllll:UrlEncode(tostring(_IlllllllII.UserId))
            .. "&sessionId=" .. _IIlIlIllll:UrlEncode(tostring(_lIlIllIllI))
        local _lllIllIllI, _llllllllII = pcall(_llllIlllII, "/api/staff/tags" .. _lllllIlIII)
        _lIlllllIIl = false
        if not _lllIllIllI or not _llllllllII or type(_llllllllII.tags) ~= "table" then
            _lIIllIllIl = _llllIIlIlI()
            return #_lIIllIllIl > 0
        end
        _lIIllIllIl = _llllllllII.tags
        if #_lIIllIllIl == 0 then _lIIllIllIl = _llllIIlIlI() end
        return #_lIIllIllIl > 0
    end

    local function _lIIlIlIIII()
        local _lllIlIIIlI = _IIlIlIIIll and _llIIlllllI[tostring(_IIlIlIIIll)]
        if not _lllIlIIIlI then
            _IIIIllIlIl.Text = "Selected: none"
            return
        end
        local _IllIllIlIl = _lllIlIIIlI.vip and (_lllIlIIIlI.vipExpiresAt == 0 and " Â· VIP permanent" or " Â· VIP") or ""
        _IIIIllIlIl.Text = string.format("Selected: %s (@%s) - %s%s%s", _lllIlIIIlI.username, _lllIlIIIlI.userid, _lllIlIIIlI.rank or "User", _IllIllIlIl, _lllIlIIIlI.offline and " - OFFLINE BANNED" or "")
    end

    local function _llllllIllI(_IlIIlIIIlI, _IlIlllIIlI)
        _lllIIlllIl.Text = tostring(_IlIIlIIIlI or "")
        _lllIIlllIl.TextColor3 = _IlIlllIIlI or _lIIIlIlIIl
    end

    local function _llIllIIlll(_lIlIIIIIll)
        for _llIIIIIIII, child in ipairs(_lIlIlIIlIl:GetChildren()) do
            if child:IsA("GuiObject") and child ~= _llllIlIlIl then child:Destroy() end
        end
        table.clear(_llIIlllllI)
        for _llIIIIIIII, _lllIlIIIlI in ipairs(_lIlIIIIIll or {}) do
            local _lllIIllllI = tostring(_lllIlIIIlI.userid)
            _llIIlllllI[_lllIIllllI] = _lllIlIIIlI
            local _lIIllIIIII = Instance.new("Frame")
            _lIIllIIIII.Name = "Target_" .. _lllIIllllI
            _lIIllIIIII.Size = UDim2.new(1, -2, 0, 28)
            _lIIllIIIII.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].surface2
            _lIIllIIIII.BackgroundTransparency = 0.22
            _lIIllIIIII.BorderSizePixel = 0
            _lIIllIIIII.LayoutOrder = #_lIlIlIIlIl:GetChildren()
            _lIIllIIIII.ZIndex = 5
            _lIIllIIIII.Parent = _lIlIlIIlIl
            Instance.new("UICorner", _lIIllIIIII).CornerRadius = UDim.new(0, 7)

            local _lIllllIIIl = Instance.new("TextLabel")
            _lIllllIIIl.Size = UDim2.new(1, -86, 1, 0)
            _lIllllIIIl.Position = UDim2.new(0, 8, 0, 0)
            _lIllllIIIl.BackgroundTransparency = 1
            _lIllllIIIl.Text = string.format("%s  |  %s%s", tostring(_lllIlIIIlI.username), tostring(_lllIlIIIlI.rank or "User"), _lllIlIIIlI.banned and (_lllIlIIIlI.offline and "  |  BANNED OFFLINE" or "  |  BANNED") or "")
            _lIllllIIIl.TextColor3 = _lllIlIIIlI.banned and Color3.fromRGB(255, 125, 125) or _llIIIIIIIl
            _lIllllIIIl.TextSize = 10
            _lIllllIIIl.Font = Enum.Font.Gotham
            _lIllllIIIl.TextXAlignment = Enum.TextXAlignment.Left
            _lIllllIIIl.TextTruncate = Enum.TextTruncate.AtEnd
            _lIllllIIIl.ZIndex = 6
            _lIllllIIIl.Parent = _lIIllIIIII

            local _IllIlIIIlI = Instance.new("TextButton")
            _IllIlIIIlI.Size = UDim2.new(0, 68, 0, 22)
            _IllIlIIIlI.Position = UDim2.new(1, -74, 0.5, -11)
            _IllIlIIIlI.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btnOn
            _IllIlIIIlI.BorderSizePixel = 0
            _IllIlIIIlI.Text = "Select"
            _IllIlIIIlI.TextColor3 = _llIIIIIIIl
            _IllIlIIIlI.TextSize = 9
            _IllIlIIIlI.Font = Enum.Font.GothamBold
            _IllIlIIIlI.AutoButtonColor = false
            _IllIlIIIlI.ZIndex = 6
            _IllIlIIIlI.Parent = _lIIllIIIII
            Instance.new("UICorner", _IllIlIIIlI).CornerRadius = UDim.new(0, 6)
            _IllIlIIIlI.MouseButton1Click:Connect(function()
                _IIlIlIIIll = _lllIIllllI
                _lIIIlIlIII = nil
                if _IIllIIlIll then _IIllIIlIll.Text = "Choose tag" end
                _lIIlIlIIII()
                if _IlllIlIIlI then _IlllIlIIlI.Visible = false end
            end)
        end
        if _IIlIlIIIll and not _llIIlllllI[tostring(_IIlIlIIIll)] then _IIlIlIIIll = nil end
        _lIIlIlIIII()
        if #(_lIlIIIIIll or {}) == 0 then _llllllIllI("No users found in this server.") end
    end

    _llIlllllII = function()
        if not _lIlIllIllI then _llllllIllI("Session unavailable.", Color3.fromRGB(255, 145, 145)); return end
        _llllllIllI("Updating users...")
        local _lllllIlIII = "?userid=" .. _IIlIlIllll:UrlEncode(tostring(_IlllllllII.UserId))
            .. "&sessionId=" .. _IIlIlIllll:UrlEncode(tostring(_lIlIllIllI))
        local _llllllllII = _llllIlllII("/api/staff/targets" .. _lllllIlIII)
        if not _llllllllII or type(_llllllllII.users) ~= "table" then
            _llllllIllI("Unable to load users. Check staff access/API.", Color3.fromRGB(255, 145, 145))
            return
        end
        _llIllIIlll(_llllllllII.users)
        _llllllIllI(tostring(#_llllllllII.users) .. " user(s) online in this server.", Color3.fromRGB(120, 210, 145))
        local _IIlIIlIIlI = _llllllllII.canManageBenefits == true and _llIIIIllll[tostring(_lIIIIlIIlI)] == true
        local _IlIIllllII = _llllllllII.canModerateTargets == true and _llIIlIlllI[tostring(_lIIIIlIIlI)] == true
        local _IIIlIlIIll = _llllllllII.canPullTargets == true and _lllIIllIIl[tostring(_lIIIIlIIlI)] == true
        local _IlllllllIl = _llllllllII.canKickTargets == true and _lllllIIlll[tostring(_lIIIIlIIlI)] == true
        if _lIllIIllIl then _lIllIIllIl.Visible = _IIIlIlIIll end
        if _IIlIlIIlII then _IIlIlIIlII.Visible = _IlIIllllII end
        if _lIlIIIIlII then _lIlIIIIlII.Visible = _IlIIllllII end
        if _IIlIllIIlI then _IIlIllIIlI.Visible = _IlllllllIl end
        if _IIllIIlIll then _IIllIIlIll.Visible = _IIlIIlIIlI end
        if _llIlllIIlI then _llIlllIIlI.Visible = _IIlIIlIIlI end
        if _IIIlllllIl then _IIIlllllIl.Visible = _IIlIIlIIlI end
        if _IlIIIIllII then _IlIIIIllII.Visible = _IIlIIlIIlI end
        if _IlllllIIII then _IlllllIIII.Visible = _IIlIIlIIlI end
        if _IlllIlIIlI and not _IIlIIlIIlI then _IlllIlIIlI.Visible = false end
        if _IIlIIlIIlI then
            _lIlIllIIlI()
        else
            _lIIllIllIl = {}
            if _IlllIlIIlI then _IlllIlIIlI.Visible = false end
        end
    end

    local function _IIlllIllll(_llIlllIIII, _IllIIllllI, _lllIlIlllI, _lIlIIlIIIl, _IlIIIIlIIl)
        local _lIIlIIllII = makeButton(_IllllIllll, _llIlllIIII, _IllIIllllI, _lllIlIlllI, _lIlIIlIIIl, 30)
        _lIIlIIllII:SetAttribute("288SilentNotification", true)
        _lIIlIIllII.MouseButton1Click:Connect(function()
            if not _IIlIlIIIll or not _llIIlllllI[tostring(_IIlIlIIIll)] then
                _llllllIllI("Select an active user first.", Color3.fromRGB(255, 190, 70))
                return
            end
            _IlIIIIlIIl(_lIIlIIllII)
        end)
        return _lIIlIIllII
    end

    _lIllIIllIl = _IIlllIllll("Pull", PAD, 202, 94, function()
        local _lllIlIIIlI = _lllIIIlIlI:GetPlayerByUserId(tonumber(_IIlIlIIIll))
        if not _lllIlIIIlI then _llllllIllI("Target is not present in this client server.", Color3.fromRGB(255, 190, 70)); return end
        local _llIlIlIlIl = _IlllllllII.Character
        local _llllIIlIII = _llIlIlIlIl and _llIlIlIlIl:FindFirstChild("HumanoidRootPart")
        if not _llllIIlIII then _llllllIllI("Your character is not ready for Pull.", Color3.fromRGB(255, 190, 70)); return end
        local _IllIIllllI, _lllIlIlllI, _IIIllIIIIl, _IllIlllIlI, _llIIlllIlI, _lIllIllIIl, _lIIlIIIlII, _IIllIIlllI, _lllIIIIIlI, _llIlIIIIII, _llIlIlllll, _llllIIllll = _llllIIlIII.CFrame:GetComponents()
        local _llllllllII = _llllIllIlI("pull", {cframe = {_IllIIllllI, _lllIlIlllI, _IIIllIIIIl, _IllIlllIlI, _llIIlllIlI, _lIllIllIIl, _lIIlIIIlII, _IIllIIlllI, _lllIIIIIlI, _llIlIIIIII, _llIlIlllll, _llllIIllll}})
        if _llllllllII and _llllllllII.success then
            _llllllIllI("Teleport request sent to " .. tostring(_lllIlIIIlI.Name) .. ".", Color3.fromRGB(120, 210, 145))
        else
            _llllllIllI("Pull denied or target is no longer active.", Color3.fromRGB(255, 145, 145))
        end
    end)
    _IIlIlIIlII = _IIlllIllll("Ban", PAD + 102, 202, 94, function()
        local _IlllIIIIIl = _llIIlllllI[tostring(_IIlIlIIIll)]
        if _IlllIIIIIl and _IlllIIIIIl.offline then _llllllIllI("This banned user is offline; use Unban.", Color3.fromRGB(255, 190, 70)); return end
        local _llllllllII = _llllIllIlI("ban")
        if _llllllllII and _llllllllII.success then _llllllIllI("User banned.", Color3.fromRGB(120, 210, 145)); _llIlllllII()
        else _llllllIllI("Ban failed: check hierarchy and target status.", Color3.fromRGB(255, 145, 145)) end
    end)
    _lIlIIIIlII = _IIlllIllll("Unban", PAD + 204, 202, 94, function()
        local _llllllllII = _llllIllIlI("unban")
        if _llllllllII and _llllllllII.success then _llllllIllI("User unbanned.", Color3.fromRGB(120, 210, 145)); _llIlllllII()
        else _llllllIllI("Unban failed: check hierarchy and target status.", Color3.fromRGB(255, 145, 145)) end
    end)
    _IIlIllIIlI = _IIlllIllll("Kick", PAD + 306, 202, 94, function()
        local _IlllIIIIIl = _llIIlllllI[tostring(_IIlIlIIIll)]
        if not _IlllIIIIIl or _IlllIIIIIl.offline then _llllllIllI("Select an active target to kick.", Color3.fromRGB(255, 190, 70)); return end
        local _llllllllII = _llllIllIlI("kick")
        if _llllllllII and _llllllllII.success then _llllllIllI("Kick sent. The target panel will close on its next heartbeat.", Color3.fromRGB(120, 210, 145)); _llIlllllII()
        else _llllllIllI("Kick failed: check rank and target status.", Color3.fromRGB(255, 145, 145)) end
    end)
    _lIllIIllIl.Visible, _IIlIlIIlII.Visible, _lIlIIIIlII.Visible, _IIlIllIIlI.Visible = false, false, false, false

    makeSectionLabel(_IllllIllll, "SET TAG", PAD, 244)
    _IIllIIlIll = makeButton(_IllllIllll, "Choose tag", PAD, 267, BTN_W, 30)
    _IIllIIlIll:SetAttribute("288SilentNotification", true)
    _llIlllIIlI = makeButton(_IllllIllll, "Apply tag", COL2, 267, BTN_W, 30)
    _llIlllIIlI:SetAttribute("288SilentNotification", true)
    _IIllIIlIll.Visible, _llIlllIIlI.Visible = false, false

    _IlllIlIIlI = Instance.new("ScrollingFrame")
    _IlllIlIIlI.Name = "StaffTagOptions"
    _IlllIlIIlI.Size = UDim2.new(0, BTN_W, 0, 104)
    _IlllIlIIlI.Position = UDim2.new(0, PAD, 0, 300)
    _IlllIlIIlI.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].main
    _IlllIlIIlI.BorderSizePixel = 0
    _IlllIlIIlI.ScrollBarThickness = 3
    _IlllIlIIlI.CanvasSize = UDim2.new(0, 0, 0, 0)
    _IlllIlIIlI.AutomaticCanvasSize = Enum.AutomaticSize.Y
    _IlllIlIIlI.Visible = false
    _IlllIlIIlI.ZIndex = 100
    _IlllIlIIlI.Parent = _IllllIllll
    Instance.new("UICorner", _IlllIlIIlI).CornerRadius = UDim.new(0, 8)
    local _IIIlIlllll = Instance.new("UIListLayout")
    _IIIlIlllll.Padding = UDim.new(0, 2)
    _IIIlIlllll.Parent = _IlllIlIIlI
    local _llllIIIIlI = Instance.new("UIPadding")
    _llllIIIIlI.PaddingTop = UDim.new(0, 4)
    _llllIIIIlI.PaddingBottom = UDim.new(0, 4)
    _llllIIIIlI.PaddingLeft = UDim.new(0, 4)
    _llllIIIIlI.PaddingRight = UDim.new(0, 4)
    _llllIIIIlI.Parent = _IlllIlIIlI

    local function _IIllIllIII(_IIIlIIIIII)
        for _llIIIIIIII, child in ipairs(_IlllIlIIlI:GetChildren()) do
            if child:IsA("GuiObject") and child ~= _IIIlIlllll then child:Destroy() end
        end
        local _lIIlllIlll = {}
        if #_lIIllIllIl == 0 then
            table.insert(_lIIlllIlll, {_IlIlIlllll=_IIIlIIIIII or "Loading roles...", _IlIlllIIlI="#A0A0A0", disabled=true})
        else
            table.insert(_lIIlllIlll, {_IlIlIlllll="Remove current tag", _IlIlllIIlI="#FF7D7D", _IlllIlIllI=true})
            for _llIIIIIIII, option in ipairs(_lIIllIllIl) do table.insert(_lIIlllIlll, option) end
        end
        for _llIIIIIIII, option in ipairs(_lIIlllIlll) do
            local _lIIlIlllIl = tostring(option.name or "")
            local _llIIIIlIll = Instance.new("TextButton")
            _llIIIIlIll.Size = UDim2.new(1, -2, 0, 24)
            _llIIIIlIll.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
            _llIIIIlIll.BorderSizePixel = 0
            _llIIIIlIll.AutoButtonColor = option.disabled ~= true
            _llIIIIlIll.Text = _lIIlIlllIl
local _IlIIllIlll = (typeof(option.color) == "Color3" and option.color) or _lIIIlIIIII(option.color) or _llIIIIIIIl
            if _IlIIllIlll.R + _IlIIllIlll.G + _IlIIllIlll.B < 0.35 then _IlIIllIlll = _llIIIIIIIl end
            _llIIIIlIll.TextColor3 = _IlIIllIlll
            _llIIIIlIll.TextSize = 10
            _llIIIIlIll.Font = Enum.Font.Gotham
            _llIIIIlIll.ZIndex = 101
            _llIIIIlIll.Parent = _IlllIlIIlI
            Instance.new("UICorner", _llIIIIlIll).CornerRadius = UDim.new(0, 5)
            if not option.disabled then
                _llIIIIlIll.MouseButton1Click:Connect(function()
                    _lIIIlIlIII = option.remove and "" or _lIIlIlllIl
                    _IIllIIlIll.Text = option.remove and "Remove current tag" or _lIIlIlllIl
                    _IlllIlIIlI.Visible = false
                end)
            end
        end
    end

    local function _llIIllIlIl()
        _IlllIlIIlI.Visible = true
        if #_lIIllIllIl > 0 then
            _IIllIllIII()
            return
        end
        _IIllIllIII("Loading roles...")
        task.spawn(function()
            local _IIllIlIIII = _lIlIllIIlI()
            if _IIllIlIIII == nil or not _IlllIlIIlI or not _IlllIlIIlI.Parent then return end
            _IIllIllIII(_IIllIlIIII and nil or "Roles unavailable")
            _IlllIlIIlI.Visible = true
            if not _IIllIlIIII then _llllllIllI("Tag options unavailable.", Color3.fromRGB(255, 145, 145)) end
        end)
    end
    local _IIlIIlIIll = false
    local function _lllllIIllI()
        task.delay(0.08, function()
            if not _IIlIIlIIll and _IlllIlIIlI and _IlllIlIIlI.Parent then
                _IlllIlIIlI.Visible = false
            end
        end)
    end
    _IIllIIlIll.MouseButton1Click:Connect(_llIIllIlIl)
    _IIllIIlIll.MouseEnter:Connect(function()
        _IIlIIlIIll = true
        _llIIllIlIl()
    end)
    _IIllIIlIll.MouseLeave:Connect(function()
        _IIlIIlIIll = false
        _lllllIIllI()
    end)
    _IlllIlIIlI.MouseEnter:Connect(function()
        _IIlIIlIIll = true
    end)
    _IlllIlIIlI.MouseLeave:Connect(function()
        _IIlIIlIIll = false
        _lllllIIllI()
    end)
    _llIlllIIlI.MouseButton1Click:Connect(function()
        if not _IIlIlIIIll or not _lIIIlIlIII then _llllllIllI("Select a target and tag first.", Color3.fromRGB(255, 190, 70)); return end
        if _llIIlllllI[tostring(_IIlIlIIIll)].offline then _llllllIllI("This banned user is offline.", Color3.fromRGB(255, 190, 70)); return end
        local _llllllllII
        if _lIIIlIlIII == "VIP" then
            local _IIllIlIIIl = tonumber(_IIIlllllIl:GetAttribute("288VipDuration")) or 3
            _llllllllII = _llllIllIlI("vip", {_lIlIlIIIll = true, durationDays = _IIllIlIIIl})
        else
            _llllllllII = _llllIllIlI("tag", {tag = _lIIIlIlIII})
        end
        if _llllllllII and _llllllllII.success then
            local _IIIIIIIlIl = _lIIIlIlIII == "" and "Custom tag removed." or (_lIIIlIlIII == "VIP" and "VIP granted using the selected duration." or ("Rank updated to " .. _lIIIlIlIII .. "."))
            _llllllIllI(_IIIIIIIlIl, Color3.fromRGB(120, 210, 145))
            _lIIIlIlIII = nil
            _IIllIIlIll.Text = "Choose tag"
            _llIlllllII()
        else _llllllIllI("Tag update failed: check hierarchy and target status.", Color3.fromRGB(255, 145, 145)) end
    end)

    makeSectionLabel(_IllllIllll, "VIP ACCESS", PAD, 309)
    _IIIlllllIl = makeButton(_IllllIllll, "VIP ï¿½ 3 days", PAD, 332, BTN_W, 30)
    _IIIlllllIl:SetAttribute("288SilentNotification", true)
    _IIIlllllIl.Visible = false
    _IlIIIIllII = makeButton(_IllllIllll, "Grant VIP", COL2, 332, BTN_W, 30)
    _IlIIIIllII:SetAttribute("288SilentNotification", true)
    _IlIIIIllII.Visible = false
    _IlllllIIII = makeButton(_IllllIllll, "Revoke VIP", PAD, 368, BTN_W, 30)
    _IlllllIIII:SetAttribute("288SilentNotification", true)
    _IlllllIIII.Visible = false

    _IIIlllllIl.MouseButton1Click:Connect(function()
        if tostring(_lIIIIlIIlI) == "Owner" then
            local _IlllIlIIll = {3, 7, 30, 0}
            _Illlllllll = _Illlllllll % #_IlllIlIIll + 1
            local _IIllIlIIIl = _IlllIlIIll[_Illlllllll]
            _IIIlllllIl:SetAttribute("288VipDuration", _IIllIlIIIl)
            _IIIlllllIl.Text = _IIllIlIIIl == 0 and "VIP Â· Lifetime" or ("VIP Â· " .. tostring(_IIllIlIIIl) .. " days")
        else
            _Illlllllll = _Illlllllll % #_llIlIIIIll + 1
            local _IIllIlIIIl = _llIlIIIIll[_Illlllllll]
            _IIIlllllIl:SetAttribute("288VipDuration", _IIllIlIIIl)
            _IIIlllllIl.Text = "VIP Â· " .. tostring(_IIllIlIIIl) .. " days"
        end
    end)
    _IIIlllllIl:SetAttribute("288VipDuration", 3)
    _IlIIIIllII.MouseButton1Click:Connect(function()
        if not _IIlIlIIIll then _llllllIllI("Select a target first.", Color3.fromRGB(255, 190, 70)); return end
        local _IIllIlIIIl = tonumber(_IIIlllllIl:GetAttribute("288VipDuration")) or 3
        if _IIllIlIIIl == 0 and tostring(_lIIIIlIIlI) ~= "Owner" then _llllllIllI("Only Owner can grant lifetime VIP.", Color3.fromRGB(255, 145, 145)); return end
        if _llIIlllllI[tostring(_IIlIlIIIll)] and _llIIlllllI[tostring(_IIlIlIIIll)].offline then _llllllIllI("This banned user is offline.", Color3.fromRGB(255, 190, 70)); return end
        local _llllllllII = _llllIllIlI("vip", {_lIlIlIIIll = true, durationDays = _IIllIlIIIl})
        if _llllllllII and _llllllllII.success then _llllllIllI("VIP granted.", Color3.fromRGB(120, 210, 145)); _llIlllllII()
        else _llllllIllI("VIP grant failed: check hierarchy, VIP rank or term.", Color3.fromRGB(255, 145, 145)) end
    end)
    _IlllllIIII.MouseButton1Click:Connect(function()
        if not _IIlIlIIIll then _llllllIllI("Select a target first.", Color3.fromRGB(255, 190, 70)); return end
        local _llllllllII = _llllIllIlI("vip", {_lIlIlIIIll = false})
        if _llllllllII and _llllllllII.success then _llllllIllI("VIP revoked.", Color3.fromRGB(120, 210, 145)); _llIlllllII()
        else _llllllIllI("VIP revoke failed: only Owner can revoke lifetime VIP.", Color3.fromRGB(255, 145, 145)) end
    end)

    _lIIIlllllI.MouseButton1Click:Connect(_llIlllllII)
    Tabs["Staff"].btn.MouseButton1Click:Connect(function() task.spawn(_llIlllllII) end)
    task.spawn(function()
        while _lIlllIlIlI.Parent and not _lIlIllllII do
            if CurrentTab == "Staff" then _llIlllllII() end
            task.wait(10)
        end
    end)
    _llIlllllII()
    refreshCanvas(_IllllIllll, 20)
end
-- ==================== LOGS / DIAGNOSTICS TAB ====================
do
    local _llIlIIIllI, _IIIIIIlIll = pcall(function()
    local _IllllIllll=Tabs["Logs"].frame
        makeSectionLabel(_IllllIllll,"Panel diagnostics",PAD,14)
        local _lllIIlllIl=Instance.new("TextLabel") _lllIIlllIl.Size=UDim2.new(1,-PAD*2,0,24) _lllIIlllIl.Position=UDim2.new(0,PAD,0,38) _lllIIlllIl.BackgroundTransparency=1 _lllIIlllIl.TextColor3=_lIIIlIlIIl _lllIIlllIl.TextSize=10 _lllIIlllIl.Font=Enum.Font.Gotham _lllIIlllIl.TextXAlignment=Enum.TextXAlignment.Left _lllIIlllIl.ZIndex=4 _lllIIlllIl.Parent=_IllllIllll
        local _lllllIllll=Instance.new("TextLabel") _lllllIllll.Name="DiagnosticConsole" _lllllIllll.Size=UDim2.new(1,-PAD*2,0,245) _lllllIllll.Position=UDim2.new(0,PAD,0,68) _lllllIllll.BackgroundColor3=_llIIIIIlIl _lllllIllll.BackgroundTransparency=0.12 _lllllIllll.BorderSizePixel=0 _lllllIllll.Text="" _lllllIllll.TextColor3=_llIIIIIIIl _lllllIllll.TextSize=10 _lllllIllll.Font=Enum.Font.Code _lllllIllll.TextWrapped=false _lllllIllll.TextXAlignment=Enum.TextXAlignment.Left _lllllIllll.TextYAlignment=Enum.TextYAlignment.Top _lllllIllll.ClipsDescendants=true _lllllIllll.ZIndex=4 _lllllIllll.Parent=_IllllIllll Instance.new("UICorner",_lllllIllll).CornerRadius=UDim.new(0,12) _lIIlIlIllI(_lllllIllll,"BackgroundColor3","btn") _lIIlIlIllI(_lllllIllll,"TextColor3","text")
        local _lIIIllIIIl=makeButton(_IllllIllll,"Copy logs",COL1,326,BTN_W,BTN_H) _lIIIllIIIl:SetAttribute("288SilentNotification",true)
        local _IIIIIllIII=makeButton(_IllllIllll,"Clear logs",COL2,326,BTN_W,BTN_H) _IIIIIllIII:SetAttribute("288SilentNotification",true)
        local function _lllllIIlII() local _lIIlIlIIlI=math.max(1,#Panel.Logs-17) local _IIlllIIIlI={} for i=_lIIlIlIIlI,#Panel.Logs do local _lIIlllllll=Panel.Logs[i] _IIlllIIIlI[#_IIlllIIIlI+1]=string.format("[%s] %-7s %-9s %s",_lIIlllllll.time,_lIIlllllll.level,_lIIlllllll.source,_lIIlllllll.message) end _lllllIllll.Text=table.concat(_IIlllIIIlI,"\n") local _llIIllIIII=Panel.State.apiOnline and "Online" or (Panel.State.offlineMode and "Offline mode" or "Checking") local _llIIIlIllI=0 for _llIIIIIIII in pairs(Panel.Runtime.modules) do _llIIIlIllI+=1 end _lllIIlllIl.Text=string.format("API: %s   â€¢   Session: %s   â€¢   Modules: %d",_llIIllIIII,Panel.State.sessionConnected and "Connected" or "Disconnected",_llIIIlIllI) end
        table.insert(Panel.LogListeners,function() task.defer(_lllllIIlII) end)
        _lIIIllIIIl.MouseButton1Click:Connect(function() if setclipboard then pcall(setclipboard,_lIIIIIIIlI()) end notifyPanel("Diagnostics","Logs copied.","success",3) end)
        _IIIIIllIII.MouseButton1Click:Connect(function() table.clear(Panel.Logs) _lIlIllIlIl("info","LOG","Log buffer cleared") _lllllIIlII() end)
        if Tabs["Logs"] and Tabs["Logs"].btn then Tabs["Logs"].btn.MouseButton1Click:Connect(_lllllIIlII) end _lllllIIlII() if type(refreshCanvas)=="function" then refreshCanvas(_IllllIllll,20) end
    end)
    if not _llIlIIIllI then _lIlIllIlIl("error","LOGS",tostring(_IIIIIIlIll)) end
end

-- ==================== ABOUT TAB ====================
do
    local _IllllIllll = Tabs["About"].frame
    _IllllIllll.ScrollingEnabled = false

    local _IIIlIIIllI = Instance.new("Frame")
    _IIIlIIIllI.Size = UDim2.new(0, 42, 0, 42)
    _IIIlIIIllI.Position = UDim2.new(1, -64, 0, 20)
    _IIIlIIIllI.BackgroundColor3 = _lIIlIIlIlI
    _IIIlIIIllI.BorderSizePixel = 0
    _IIIlIIIllI.ZIndex = 4
    _IIIlIIIllI.Parent = _IllllIllll
    Instance.new("UICorner", _IIIlIIIllI).CornerRadius = UDim.new(0, 13)
    _llllIIlllI(_IIIlIIIllI, "info", 10, 10, 22, _lIIlIlIlIl)
    _lIIlIlIllI(_IIIlIIIllI, "BackgroundColor3", "btn")

    local _IllIIIllIl = Instance.new("TextLabel")
    _IllIIIllIl.Size=UDim2.new(0,112,0,28)
    _IllIIIllIl.Position=UDim2.new(0,PAD,0,20)
    _IllIIIllIl.BackgroundTransparency=1
    _IllIIIllIl.Text="Developers:"
    _IllIIIllIl.TextColor3=Color3.fromRGB(200,200,200)
    _IllIIIllIl.TextSize=14
    _IllIIIllIl.Font=Enum.Font.Gotham
    _IllIIIllIl.TextXAlignment=Enum.TextXAlignment.Left
    _IllIIIllIl.ZIndex=4
    _IllIIIllIl.Parent=_IllllIllll
    _lIIlIlIllI(_IllIIIllIl,"TextColor3","textDim")

    local function _IlIlIIllIl(_IlllIIlIII, _llIlIIIlll)
        local _lllIIlllII = "https://www.roblox.com/users/" .. tostring(_IlllIIlIII) .. "/profile"
        local _IIlIIlllIl = pcall(function() _lIllIlllII:OpenBrowserWindow(_lllIIlllII) end)
        if not _IIlIIlllIl then
            pcall(function() setclipboard(_lllIIlllII) end)
            pcall(function()
                _IllIlIlllI:SetCore("SendNotification", {
                    Title = _llIlIIIlll .. "'s profile",
                    Text = "Link copied. Paste it into your browser to open the profile.",
                    Duration = 5,
                })
            end)
        end
    end

    local _IllIlIIllI = {
        { _llIlIIIlll = "driblaestado", _IlllIIlIII = 4885351053 },
        { _llIlIIIlll = "eotaldojapakk", _IlllIIlIII = 609332724 },
    }
    for _lllllIlIIl, developer in ipairs(_IllIlIIllI) do
        local _IlIlllllII = Instance.new("TextButton")
        _IlIlllllII.Size = UDim2.new(0, 116, 0, 24)
        _IlIlllllII.Position = UDim2.new(0, PAD + 122 + ((_lllllIlIIl - 1) * 124), 0, 22)
        _IlIlllllII.BackgroundTransparency = 1
        _IlIlllllII:SetAttribute("PreserveTransparency", true)
        _IlIlllllII.Text = "@" .. developer.username
        _IlIlllllII.TextColor3 = Color3.fromRGB(80,160,255)
        _IlIlllllII.TextSize = 13
        _IlIlllllII.Font = Enum.Font.GothamBold
        _IlIlllllII.TextXAlignment = Enum.TextXAlignment.Left
        _IlIlllllII.ZIndex = 5
        _IlIlllllII.Parent = _IllllIllll
        _llIlIIIlII(_IlIlllllII)
        _IlIlllllII.MouseButton1Click:Connect(function()
            _IlIlIIllIl(developer.userId, developer.username)
        end)
    end

    local _IIlIIIIIll = Instance.new("TextLabel")
    _IIlIIIIIll.Size=UDim2.new(1,-20,0,28)
    _IIlIIIIIll.Position=UDim2.new(0,PAD,0,60)
    _IIlIIIIIll.BackgroundTransparency=1
    _IIlIIIIIll.Text="Version: "
    _IIlIIIIIll.TextColor3=Color3.fromRGB(200,200,200)
    _IIlIIIIIll.TextSize=14
    _IIlIIIIIll.Font=Enum.Font.Gotham
    _IIlIIIIIll.TextXAlignment=Enum.TextXAlignment.Left
    _IIlIIIIIll.ZIndex=4
    _IIlIIIIIll.Parent=_IllllIllll
    _lIIlIlIllI(_IIlIIIIIll,"TextColor3","textDim")

    local _IIIlllIlIl = Instance.new("TextLabel")
    _IIIlllIlIl.Size=UDim2.new(0,60,0,28)
    _IIIlllIlIl.Position=UDim2.new(0,PAD+74,0,60)
    _IIIlllIlIl.BackgroundTransparency=1
    _IIIlllIlIl.Text=_IIIIlIIlIl
    _IIIlllIlIl.TextColor3=Color3.fromRGB(220,50,50)
    _IIIlllIlIl.TextSize=14
    _IIIlllIlIl.Font=Enum.Font.GothamBold
    _IIIlllIlIl.TextXAlignment=Enum.TextXAlignment.Left
    _IIIlllIlIl.ZIndex=5
    _IIIlllIlIl.Parent=_IllllIllll

    local _lIIIIIllIl = Instance.new("TextLabel")
    _lIIIIIllIl.Size=UDim2.new(1,-20,0,22)
    _lIIIIIllIl.Position=UDim2.new(0,PAD,0,100)
    _lIIIIIllIl.BackgroundTransparency=1
    _lIIIIIllIl.Text="Donate:"
    _lIIIIIllIl.TextColor3=Color3.fromRGB(180,180,180)
    _lIIIIIllIl.TextSize=12
    _lIIIIIllIl.Font=Enum.Font.Gotham
    _lIIIIIllIl.TextXAlignment=Enum.TextXAlignment.Left
    _lIIIIIllIl.ZIndex=4
    _lIIIIIllIl.Parent=_IllllIllll
    _lIIlIlIllI(_lIIIIIllIl,"TextColor3","textDim")

    local _IIIIlIIllI = Instance.new("TextLabel")
    _IIIIlIIllI.Size=UDim2.new(0,160,0,22)
    _IIIIlIIllI.Position=UDim2.new(0,PAD+64,0,100)
    _IIIIlIIllI.BackgroundTransparency=1
    _IIIIlIIllI.Text="support project"
    _IIIIlIIllI.TextColor3=Color3.fromRGB(80,140,255)
    _IIIIlIIllI.TextSize=12
    _IIIIlIIllI.Font=Enum.Font.Gotham
    _IIIIlIIllI.TextXAlignment=Enum.TextXAlignment.Left
    _IIIIlIIllI.ZIndex=5
    _IIIIlIIllI.Parent=_IllllIllll

    local _lIlllIIIll = _lIIIIIllIl:Clone()
    _lIlllIIIll.Position=UDim2.new(0,PAD,0,126)
    _lIlllIIIll.Text="Support:"
    _lIlllIIIll.Parent=_IllllIllll

    local _IIlIIIIlIl= _IIIIlIIllI:Clone()
    _IIlIIIIlIl.Position=UDim2.new(0,PAD+68,0,126)
    _IIlIIIIlIl.Text="open support"
    _IIlIIIIlIl.Size=UDim2.new(0,160,0,22)
    _IIlIIIIlIl.Parent=_IllllIllll

    local _IlllIlIlIl = Instance.new("TextButton")
    _IlllIlIlIl.Name = "AboutLightDarkToggle"
    _IlllIlIlIl.Size = UDim2.new(0, 34, 0, 34)
    _IlllIlIlIl.Position = UDim2.new(1, -50, 1, -50)
    _IlllIlIlIl.BackgroundColor3 = _lIIlIIlIlI
    _IlllIlIlIl.BackgroundTransparency = 0.12
    _IlllIlIlIl.BorderSizePixel = 0
    _IlllIlIlIl.Text = ""
    _IlllIlIlIl.AutoButtonColor = false
    _IlllIlIlIl.ZIndex = 10
    _IlllIlIlIl.Parent = _IllllIllll
    local _lIlIIIIIlI = Instance.new("UIStroke")
    _lIlIIIIIlI.Color = _lIIlIlIlIl
    _lIlIIIIIlI.Transparency = 1
    _lIlIIIIIlI.Parent = _IlllIlIlIl
    _lIIlIlIllI(_lIlIIIIIlI, "Color", "accent")
    _lIIlIlIllI(_IlllIlIlIl, "BackgroundColor3", "btn")
    _llIlIIIlII(_IlllIlIlIl, false)

    local _IllIIIlIlI = "rbxassetid://106440221119133"
    local _IIlIlllllI = nil
    local function _llllIllIll()
        if _IIlIlllllI then _IIlIlllllI:Destroy() end

        _IIlIlllllI = Instance.new("ImageLabel")
        _IIlIlllllI.Name = "AboutThemeAssetIcon"
        _IIlIlllllI.AnchorPoint = Vector2.new(0.5, 0.5)
        _IIlIlllllI.Position = UDim2.new(0.5, 0, 0.5, 0)
        _IIlIlllllI.Size = UDim2.new(0, 28, 0, 28)
        _IIlIlllllI.BackgroundTransparency = 1
        _IIlIlllllI.BorderSizePixel = 0
        _IIlIlllllI.Image = _IllIIIlIlI
        -- O mesmo asset e usado nos dois temas; fica invertido de lado.
        _IIlIlllllI.Rotation = 180
        -- Tema claro -> icone escuro. Tema escuro/colorido -> icone claro.
        _IIlIlllllI.ImageColor3 = _lIIlIIlllI == "light"
            and Color3.fromRGB(28, 28, 32)
            or Color3.fromRGB(245, 245, 248)
        _IIlIlllllI.ScaleType = Enum.ScaleType.Fit
        _IIlIlllllI.ZIndex = _IlllIlIlIl.ZIndex + 3
        _IIlIlllllI.Parent = _IlllIlIlIl
        _IIlIlllllI:SetAttribute("PreserveThemeColor", true)

        _lIlIIIIIlI.Color = _lIIlIlIlIl
    end
    _llllIllIll()

    _IlllIlIlIl.MouseButton1Click:Connect(function()
        local _llIIlIIllI = _lIIlIIlllI == "light" and "dark" or "light"
        _lIIIIllIII(_llIIlIIllI, { userInitiated = true, persistRemote = true })
        _llllIllIll()
        setTab("About")
    end)

    Tabs["About"].btn.MouseButton1Click:Connect(_llllIllIll)
    local _lllIlllIIl = Instance.new("Frame")
    _lllIlllIIl.Name = "NotificationVolumeSlider"
    _lllIlllIIl.Size = UDim2.new(1, -32, 0, 34)
    _lllIlllIIl.Position = UDim2.new(0, 16, 0, 0)
    _lllIlllIIl.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].btn
    _lllIlllIIl.BackgroundTransparency = 0.12
    _lllIlllIIl.BorderSizePixel = 0
    _lllIlllIIl.ZIndex = 4
    _lllIlllIIl.Parent = Tabs["Config"].frame
    Instance.new("UICorner", _lllIlllIIl).CornerRadius = UDim.new(0, 11)
    _lIIlIlIllI(_lllIlllIIl, "BackgroundColor3", "btn")

    local _lIlIIllIll = Instance.new("TextLabel", _lllIlllIIl)
    _lIlIIllIll.Size = UDim2.new(1, -66, 0, 18)
    _lIlIIllIll.Position = UDim2.new(0, 12, 0, 1)
    _lIlIIllIll.BackgroundTransparency = 1
    _lIlIIllIll.Text = "Notification Volume"
    _lIlIIllIll.TextColor3 = _lIIIlIlIIl
    _lIlIIllIll.TextSize = 10
    _lIlIIllIll.Font = Enum.Font.GothamMedium
    _lIlIIllIll.TextXAlignment = Enum.TextXAlignment.Left
    _lIlIIllIll.ZIndex = 5
    _lIIlIlIllI(_lIlIIllIll, "TextColor3", "textDim")

    local _IIllllIlII = Instance.new("TextLabel", _lllIlllIIl)
    _IIllllIlII.Size = UDim2.new(0, 48, 0, 18)
    _IIllllIlII.Position = UDim2.new(1, -58, 0, 1)
    _IIllllIlII.BackgroundTransparency = 1
    _IIllllIlII.TextColor3 = _lIIlIlIlIl
    _IIllllIlII.TextSize = 10
    _IIllllIlII.Font = Enum.Font.GothamBold
    _IIllllIlII.TextXAlignment = Enum.TextXAlignment.Right
    _IIllllIlII.ZIndex = 5

    local _lIIIIIlIIl = Instance.new("Frame", _lllIlllIIl)
    _lIIIIIlIIl.Name = "Track"
    _lIIIIIlIIl.Size = UDim2.new(1, -24, 0, 5)
    _lIIIIIlIIl.Position = UDim2.new(0, 12, 0, 25)
    _lIIIIIlIIl.BackgroundColor3 = _IllllIIlII[_lIIlIIlllI].surface2
    _lIIIIIlIIl.BackgroundTransparency = 1
    _lIIIIIlIIl.BorderSizePixel = 0
    _lIIIIIlIIl.ZIndex = 5
    Instance.new("UICorner", _lIIIIIlIIl).CornerRadius = UDim.new(1, 0)
    _lIIlIlIllI(_lIIIIIlIIl, "BackgroundColor3", "surface2")

    local _llIIlIllll = Instance.new("Frame", _lIIIIIlIIl)
    _llIIlIllll.Name = "Fill"
    _llIIlIllll.Size = UDim2.new(0.8, 0, 1, 0)
    _llIIlIllll.BackgroundColor3 = _lIIlIlIlIl
    _llIIlIllll.BorderSizePixel = 0
    _llIIlIllll.ZIndex = 6
    Instance.new("UICorner", _llIIlIllll).CornerRadius = UDim.new(1, 0)

    local _IIlIIlIllI = Instance.new("Frame", _lIIIIIlIIl)
    _IIlIIlIllI.Name = "Knob"
    _IIlIIlIllI.AnchorPoint = Vector2.new(0.5, 0.5)
    _IIlIIlIllI.Size = UDim2.fromOffset(13, 13)
    _IIlIIlIllI.Position = UDim2.new(0.8, 0, 0.5, 0)
    _IIlIIlIllI.BackgroundColor3 = _lIIlIlIlIl
    _IIlIIlIllI.BorderSizePixel = 0
    _IIlIIlIllI.ZIndex = 7
    Instance.new("UICorner", _IIlIIlIllI).CornerRadius = UDim.new(1, 0)
    local _lIIIlIllll = Instance.new("UIStroke", _IIlIIlIllI)
    _lIIIlIllll.Color = Color3.fromRGB(255,255,255)
    _lIIIlIllll.Transparency = 0.48
    _lIIIlIllll.Thickness = 1

    local _llIIlIIIll = Instance.new("TextButton", _lllIlllIIl)
    _llIIlIIIll.Name = "SliderHitbox"
    _llIIlIIIll.Size = UDim2.new(1, -16, 0, 20)
    _llIIlIIIll.Position = UDim2.new(0, 8, 0, 14)
    _llIIlIIIll.BackgroundTransparency = 1
    _llIIlIIIll:SetAttribute("PreserveTransparency", true)
    _llIIlIIIll.Text = ""
    _llIIlIIIll.AutoButtonColor = false
    _llIIlIIIll.ZIndex = 8

    local _IIIIIIllIl = false
    local _IIIlIIllIl = math.clamp(tonumber(Panel.Settings.notificationVolume) or 0.8, 0, 1)

    local function _IllIIllIIl(_IlIlIlIlll)
        _IlIlIlIlll = math.clamp(tonumber(_IlIlIlIlll) or 0.8, 0, 1)
        Panel.Settings.notificationVolume = _IlIlIlIlll
        local _IlIIIllIlI = math.floor(_IlIlIlIlll * 100 + 0.5)
        _IIllllIlII.Text = tostring(_IlIIIllIlI) .. "%"
        _lllIllIlIl:Create(_llIIlIllll, TweenInfo.new(0.08), {Size=UDim2.new(_IlIlIlIlll, 0, 1, 0)}):Play()
        _lllIllIlIl:Create(_IIlIIlIllI, TweenInfo.new(0.08), {Position=UDim2.new(_IlIlIlIlll, 0, 0.5, 0)}):Play()
    end

    _IllIIlllII = function(_IlIlIlIlll)
        _IlIlIlIlll = math.clamp(tonumber(_IlIlIlIlll) or 0.8, 0, 1)
        _IIIlIIllIl = _IlIlIlIlll
        _IllIIllIIl(_IlIlIlIlll)
        task.defer(_lIlllIllIl)
    end
    local function _lIllIIIllI(_IllIIllllI)
        local _lIlIIlIIIl = math.max(1, _lIIIIIlIIl.AbsoluteSize.X)
        return math.clamp((_IllIIllllI - _lIIIIIlIIl.AbsolutePosition.X) / _lIlIIlIIIl, 0, 1)
    end

    local function _IlllIllIIl()
        local _IlIlIlIlll = math.clamp(tonumber(Panel.Settings.notificationVolume) or 0.8, 0, 1)
        if math.abs(_IlIlIlIlll - _IIIlIIllIl) >= 0.001 then
            _IIIlIIllIl = _IlIlIlIlll
            _lIlllIllIl()
            task.spawn(_IllIIlIlIl, _IlIlIlIlll)
        end
    end

    _IllIIllIIl(_IIIlIIllIl)

    _llIIlIIIll.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            _IIIIIIllIl = true
            _IllIIllIIl(_lIllIIIllI(input.Position.X))
        end
    end)
    _IIIIIIlIlI(_IIIIllIllI.InputChanged, function(input)
        if not _IIIIIIllIl then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            _IllIIllIIl(_lIllIIIllI(input.Position.X))
        end
    end)
    _IIIIIIlIlI(_IIIIllIllI.InputEnded, function(input)
        if _IIIIIIllIl and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            _IIIIIIllIl = false
            _IlllIllIIl()
        end
    end)
end

-- ==================== CONFIG TAB ====================
do
    local _IllllIllll = Tabs["Config"].frame
    local _lllIlIlllI = 16
    makeSectionLabel(_IllllIllll, "Painel e atalhos", COL1, _lllIlIlllI)
    _lllIlIlllI += 24

    local _llIIlllIIl = Panel.Settings.keybinds or {}
    Panel.Settings.keybinds = _llIIlllIIl
    local _lllIIllIII = {
        {_lllIIllllI="panel", _lIllllIIIl="Abrir / minimizar painel"},
        {_lllIIllllI="ClickTP", _lIllllIIIl="Click TP (segurar + clique)"},
        {_lllIIllllI="Invisible", _lIllllIIIl="Invisible"},
        {_lllIIllllI="NoClip", _lIllllIIIl="NoClip"},
        {_lllIIllllI="JerkOff", _lIllllIIIl="JerkOff"},
        {_lllIIllllI="Impulse", _lIllllIIIl="Impulse"},
        {_lllIIllllI="FaceBang", _lIllllIIIl="FaceBang"},
        {_lllIIllllI="Spin", _lIllllIIIl="Spin"},
        {_lllIIllllI="AnimSpeed", _lIllllIIIl="AnimSpeed (Slow)"},
        {_lllIIllllI="AnimSpeed2", _lIllllIIIl="AnimSpeed (Speed)"},
        {_lllIIllllI="feFlip", _lIllllIIIl="FrontFlip"},
        {_lllIIllllI="feFlip2", _lIllllIIIl="BackFlip"},
        {_lllIIllllI="Flashback", _lIllllIIIl="Flashback"},
        {_lllIIllllI="AntiVoid", _lIllllIIIl="AntiVoid"},
        {_lllIIllllI="ESP", _lIllllIIIl="ESP"},
        {_lllIIllllI="Aimbot", _lIllllIIIl="Aimbot"},
        {_lllIIllllI="AimbotAim", _lIllllIIIl="Aimbot aim (segurar)"},
        {_lllIIllllI="WalkSpeed", _lIllllIIIl="Walk Speed (vazio = sem tecla)"},
        {_lllIIllllI="JumpPower", _lIllllIIIl="Jump Power (vazio = sem tecla)"},
        {_lllIIllllI="Fly", _lIllllIIIl="Fly"},
    }
    local _IlIllIIIll = nil
    local _lIlIIIlllI = {}
    local function _lIlIlIllII(_lIIlIIllII, _lllIIllllI)
        local _IlIlIlIlll = tostring(_llIIlllIIl[_lllIIllllI] or "")
        _lIIlIIllII.Text = _IlIlIlIlll == "" and "Sem tecla" or _IlIlIlIlll
    end
    local function _lIlllIIIlI(_lllIIllllI, _lIIlIIllII)
        if _IlIllIIIll then
            _IlIllIIIll.Text = tostring(_llIIlllIIl[_IlIllIIIll:GetAttribute("288KeybindId")] or "Sem tecla")
        end
        _IlIllIIIll = _lIIlIIllII
        _IlIIIlllIl.__288CapturingKeybind = true
        _lIIlIIllII.Text = _lllIIllllI == "AimbotAim" and "Pressione tecla/botÃ£o..." or "Pressione uma tecla..."
        _lIIlIIllII:SetAttribute("288KeybindId", _lllIIllllI)
    end
    for _lllllIlIIl, _IlIIllIIIl in ipairs(_lllIIllIII) do
        local _lIIllIIIII = _lllllIlIIl - 1
        local _IIIlIIlIII = _lIIllIIIII % 2
        local _llIIIlllII = _lllIlIlllI + math.floor(_lIIllIIIII / 2) * 38
        local _lIIlIlllll = _IIIlIIlIII == 0 and COL1 or (COL1 + 209)
        local _lIllllIIIl = Instance.new("TextLabel")
        _lIllllIIIl.Size = UDim2.new(0, 88, 0, 30)
        _lIllllIIIl.Position = UDim2.new(0, _lIIlIlllll, 0, _llIIIlllII)
        _lIllllIIIl.BackgroundTransparency = 1
        _lIllllIIIl.Text = _IlIIllIIIl.label
        _lIllllIIIl.TextColor3 = _llIIIIIIIl
        _lIllllIIIl.TextSize = 10
        _lIllllIIIl.Font = Enum.Font.Gotham
        _lIllllIIIl.TextXAlignment = Enum.TextXAlignment.Left
        _lIllllIIIl.TextTruncate = Enum.TextTruncate.AtEnd
        _lIllllIIIl.ZIndex = 4
        _lIllllIIIl.Parent = _IllllIllll
        _lIIlIlIllI(_lIllllIIIl, "TextColor3", "text")

        local _lIIlIIllII = makeButton(_IllllIllll, "", _lIIlIlllll + 92, _llIIIlllII, 110, 30)
        _lIIlIIllII:SetAttribute("288KeybindId", _IlIIllIIIl.id)
        _lIlIlIllII(_lIIlIIllII, _IlIIllIIIl.id)
        _lIlIIIlllI[_IlIIllIIIl.id] = _lIIlIIllII
        _lIIlIIllII.MouseButton1Click:Connect(function() _lIlllIIIlI(_IlIIllIIIl.id, _lIIlIIllII) end)
    end
    _IIIIIIlIlI(_IIIIllIllI.InputBegan, function(input, processed)
        if not _IlIllIIIll then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
            local _lIIlIIllII = _IlIllIIIll
            _IlIllIIIll = nil
            _IlIIIlllIl.__288CapturingKeybind = false
            _lIlIlIllII(_lIIlIIllII, _lIIlIIllII:GetAttribute("288KeybindId"))
            return
        end
        local _lIIlIIllII = _IlIllIIIll
        local _lllIIllllI = _lIIlIIllII:GetAttribute("288KeybindId")
        local _IlllllIllI
        if input.UserInputType == Enum.UserInputType.Keyboard then
            _IlllllIllI = input.KeyCode == Enum.KeyCode.Backspace and "" or input.KeyCode.Name
        elseif _lllIIllllI == "AimbotAim" and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3) then
            _IlllllIllI = input.UserInputType.Name
        else
            return
        end
        _llIIlllIIl[_lllIIllllI] = _IlllllIllI
        _IlIllIIIll = nil
        _IlIIIlllIl.__288CapturingKeybind = false
        _lIlIlIllII(_lIIlIIllII, _lllIIllllI)
        _lIlllIllIl()
        if _lllIIllllI == "ClickTP" then _IlIIIlllIl.__288ClickTPKeyCode = Enum.KeyCode[_llIIlllIIl.ClickTP] or Enum.KeyCode.LeftControl end
        notifyPanel("Config", "Atalho atualizado: " .. _lllIIllllI, "success", 3)
    end)
    for _llIIIIIIII, _IlIIllIIIl in ipairs(_lllIIllIII) do
        if _llIIlllIIl[_IlIIllIIIl.id] == nil then
            local _IlllIlllIl = {panel="B", ClickTP="LeftControl", Invisible="K", NoClip="N", JerkOff="R", Impulse="M", FaceBang="Z", Spin="T", AnimSpeed="Q", AnimSpeed2="E", feFlip="X", feFlip2="C", Flashback="V", AntiVoid="J", ESP="E", Aimbot="F", AimbotAim="MouseButton1", Fly="F", WalkSpeed="", JumpPower=""}
            _llIIlllIIl[_IlIIllIIIl.id] = _IlllIlllIl[_IlIIllIIIl.id] or ""
        end
    end
    if _llIIlllIIl.ClickTP == "" then _llIIlllIIl.ClickTP = "LeftControl" end
    _IlIIIlllIl.__288ClickTPKeyCode = Enum.KeyCode[_llIIlllIIl.ClickTP] or Enum.KeyCode.LeftControl

    _lllIlIlllI += math.ceil(#_lllIIllIII / 2) * 38 + 12
    makeSectionLabel(_IllllIllll, "Sons e notificaÃ§Ãµes", COL1, _lllIlIlllI)
    _lllIlIlllI += 24
    local _IIIllllllI = Instance.new("Frame")
    _IIIllllllI.Name = "ConfigAudioControls"
    _IIIllllllI.Size = UDim2.new(1, -32, 0, 122)
    _IIIllllllI.Position = UDim2.new(0, 16, 0, _lllIlIlllI)
    _IIIllllllI.BackgroundTransparency = 1
    _IIIllllllI.Parent = _IllllIllll
    local _IlIllIIlII = {
        {_lllIIllllI="uiSounds", _lIllllIIIl="UI Sounds"},
        {_lllIIllllI="loadingMusic", _lIllllIIIl="Loading Music"},
        {_lllIIllllI="notificationMusic", _lIllllIIIl="Notification Music"},
    }
    for _lllllIlIIl, _IlIIllIIIl in ipairs(_IlIllIIlII) do
        local _IIIlIIlIII = (_lllllIlIIl - 1) % 2
        local _lIIlIlllll = _IIIlIIlIII == 0 and 0 or 224
        local _llIIIlllII = math.floor((_lllllIlIIl - 1) / 2) * 42
        local _lIIlIIllII = makeToggleButton(_IIIllllllI, _IlIIllIIIl.label, _lIIlIlllll, _llIIIlllII, 190, BTN_H)
        local _lIlIlIIIll = Panel.Settings[_IlIIllIIIl.id] ~= false
        _lIIlIlIlII[_lIIlIIllII] = _lIlIlIIIll
        _lIIlIIllII.BackgroundColor3 = _lIlIlIIIll and _IllllIIlII[_lIIlIIlllI].btnOn or _IllllIIlII[_lIIlIIlllI].btn
        if toggleIcons[_lIIlIIllII] then toggleIcons[_lIIlIIllII].ImageColor3 = _lIlIlIIIll and _IlIlIlIlII or _lIllIIlllI end
        _lIIlIIllII:SetAttribute("288SilentNotification", true)
        _lIIlIIllII.MouseButton1Click:Connect(function()
            Panel.Settings[_IlIIllIIIl.id] = _lIIlIlIlII[_lIIlIIllII] == true
            _lIlllIllIl()
        end)
    end
    local _lllIlllIIl = _IllllIllll:FindFirstChild("NotificationVolumeSlider")
    if _lllIlllIIl then
        _lllIlllIIl.Position = UDim2.new(0, 0, 0, 88)
        _lllIlllIIl.Size = UDim2.new(1, -32, 0, 34)
        _lllIlllIIl.Parent = _IIIllllllI
    end
    refreshCanvas(_IllllIllll, 20)
end

ROBLOX_LOCALE = tostring(game:GetService("LocalizationService").RobloxLocaleId or "en-us"):lower()
USE_PORTUGUESE_FALLBACK = ROBLOX_LOCALE:sub(1, 2) == "pt"
PORTUGUESE_TEXT = {
    ["ONLINE"] = "ONLINE", ["USERS"] = "USUÃRIOS", ["SESSION"] = "SESSÃƒO",
    ["Friends on other servers:"] = "Amigos em outros servidores:",
    ["Available servers:"] = "Servidores disponÃ­veis:",
    ["No friends are playing this game on another server."] = "Nenhum amigo estÃ¡ jogando este jogo em outro servidor.",
    ["Join server"] = "Entrar no servidor", ["Friend"] = "Amigo",
    ["Enter a name above\nto find a player"] = "Digite um nome acima\npara encontrar um jogador",
    ["@username or display name..."] = "@usuÃ¡rio ou nome de exibiÃ§Ã£o...",
    ["UserID:"] = "ID do usuÃ¡rio:", ["Display:"] = "ExibiÃ§Ã£o:", ["Name:"] = "Nome:",
    ["View"] = "View", ["Focus"] = "Focus", ["Follow"] = "Follow", ["Stand"] = "Stand",
    ["Bang"] = "Bang", ["Drag"] = "Drag", ["Headsit"] = "Headsit", ["Doggy"] = "Doggy",
    ["Backpack"] = "Backpack", ["CopyID"] = "Copy ID", ["Bring"] = "Bring", ["Teleport"] = "Teleport",
    ["Developers:"] = "Desenvolvedores:", ["Version: "] = "VersÃ£o: ", ["Donate:"] = "Doar:",
    ["support project"] = "apoiar projeto", ["Support:"] = "Suporte:", ["open\nsupport"] = "abrir\nsuporte",
}

function portugueseFallback(_IIlllIIIIl)
    _IIlllIIIIl = tostring(_IIlllIIIIl or ""):gsub(_lIIlllIIIl, "")
    if not USE_PORTUGUESE_FALLBACK or _IIlllIIIIl == "" then return _IIlllIIIIl end
    if PORTUGUESE_TEXT[_IIlllIIIIl] then return PORTUGUESE_TEXT[_IIlllIIIIl] end
    if _IIlllIIIIl:match("^SESSION%s") then return _IIlllIIIIl:gsub("^SESSION", "SESSÃƒO", 1) end
    local _llIIIlIIll = _IIlllIIIIl:match("^Hello, (.+)%.$")
    if _llIIIlIIll then return "OlÃ¡, " .. _llIIIlIIll .. "." end
    if _IIlllIIIIl:find("Press ", 1, true) and _IIlllIIIIl:find("to\nopen/close the panel", 1, true) then
        return _IIlllIIIIl:gsub("Press ", "Pressione "):gsub("to\nopen/close the panel", "para\nabrir/fechar o painel")
    end
    local _IlIlIlIlll = _IIlllIIIIl:match("^UserID:%s*(.*)$")
    if _IlIlIlIlll then return "ID do usuÃ¡rio: " .. _IlIlIlIlll end
    _IlIlIlIlll = _IIlllIIIIl:match("^Display:%s*(.*)$")
    if _IlIlIlIlll then return "ExibiÃ§Ã£o: " .. _IlIlIlIlll end
    _IlIlIlIlll = _IIlllIIIIl:match("^Name:%s*(.*)$")
    if _IlIlIlIlll then return "Nome: " .. _IlIlIlIlll end
    return _IIlllIIIIl
end

-- LocalizationManager is disabled (active = false). The translator is not applied
-- to prevent conflicts with Roblox CoreGui localization.
-- LocalizationManager:SetTranslator(portugueseFallback)
-- LocalizationManager:BindRoot(ScreenGui)
-- LocalizationManager:BindRoot(NotificationGui)

-- ==================== MODERN VISUAL POLISH ====================
function applyModernPolish()
    task.defer(function()
        pcall(_lIIlIIIlIl)
    end)

    for _llIIIIIIII, _lIIllIIlll in ipairs(_lIlllIlIlI:GetDescendants()) do
        if _lIIllIIlll:IsA("GuiBase2d") then
            _lIIllIIlll.AutoLocalize = false
            if _llIlIllllI(_lIIllIIlll) then _IIIllIIIII:BindObject(_lIIllIIlll) end
        end
        if _lIIllIIlll:IsA("TextLabel") then
            if _lIIllIIlll.TextColor3 == Color3.fromRGB(200,200,200)
                or _lIIllIIlll.TextColor3 == Color3.fromRGB(180,180,180)
                or _lIIllIIlll.TextColor3 == Color3.fromRGB(185,185,185) then
                _lIIllIIlll.TextColor3 = _lIIIlIlIIl
            end
        elseif _lIIllIIlll:IsA("ScrollingFrame") then
            _lIIllIIlll.ScrollBarImageColor3 = _lIIlIlIlIl
            _lIIllIIlll.ScrollBarThickness = math.min(_lIIllIIlll.ScrollBarThickness, 3)
        elseif _lIIllIIlll:IsA("TextButton") or _lIIllIIlll:IsA("TextBox") then
            local _lIIIIllIll = _lIIllIIlll.Size.X.Offset == _lIIllIIlll.Size.Y.Offset and _lIIllIIlll.Size.X.Offset <= 40
            local _IlllIllIII = _lIIllIIlll:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
            _IlllIllIII.CornerRadius = _lIIIIllIll and UDim.new(1, 0) or UDim.new(0, 12)
            _IlllIllIII.Parent = _lIIllIIlll

            if not _lIIllIIlll:FindFirstChildOfClass("UIStroke") then
                local _IIIIIIlIII = Instance.new("UIStroke")
                _IIIIIIlIII.Name = "ModernSoftStroke"
                _IIIIIIlIII.Color = _llIIllllll
                _IIIIIIlIII.Transparency = 0.52
                _IIIIIIlIII.Thickness = 1
                _IIIIIIlIII.Parent = _lIIllIIlll
            end
        end
    end

    if Sidebar and Sidebar.Parent then
        for _llIIIIIIII, _lIIllIIlll in ipairs(Sidebar:GetDescendants()) do
            if _lIIllIIlll:IsA("Frame") and _lIIllIIlll.Name ~= "ActiveAccent" and _lIIllIIlll.Size.Y.Offset == 1 then
                _lIIllIIlll.BackgroundColor3 = Color3.fromRGB(39,39,45)
                _lIIllIIlll.BackgroundTransparency = 0.2
            end
        end
    end
end
_IIlIlIIlll(56, "Applying interface styling...", function()
    applyModernPolish()
    -- Reaplica o tema depois de todos os componentes existirem.
    -- Assim cards, inputs, modais, sliders e abas criados mais tarde tambem
    -- recebem a paleta atual por completo.
    if _IllllIIlII[_lIIlIIlllI] then _lIIIIllIII(_lIIlIIlllI) end
end, 1.05)

-- ==================== START STATE =========   ===========
local _lIIIlIIllI = "Home"
setTab(_lIIIlIIllI)
_IIlIlIIlll(66, "Preparing module registry...", nil, 1.05)
_IIlIlIIlll(73, "Checking API availability...", nil, 1.05)

-- Impede que uma indisponibilidade externa deixe o usuario preso no loading.
task.delay(15,function() if not loadingFinished then Panel.State.offlineMode=true Panel.State.apiOnline=false _lIlIllIlIl("warning","BOOT","Loading watchdog switched to offline mode") finishLoading("Painel iniciado em modo offline") end end)

-- ==================== SESSION START ====================

task.spawn(function()
    setLoadingProgress(80, "Connecting session...")
    local _llllllIlII = _IIIIIlIlII("/session/start", {
        userid   = _IlllllllII.UserId,
        _llIlIIIlll = _IlllllllII.Name,
        _lllIlIllII  = _IIIIlIIlIl,
        game     = tostring(game.PlaceId),
        _IllIllIIIl   = tostring(game.JobId),
        _lIIlIIlIII   = _llllIlllIl,
        executor = _lIIIIIllll,
    })
    if not _llllllIlII then Panel.State.apiOnline=false Panel.State.sessionConnected=false Panel.State.offlineMode=true _lIlIllIlIl("warning","API","Session start unavailable; offline mode") finishLoading("API indisponivel - modo offline") return end
    Panel.State.apiOnline=true Panel.State.sessionConnected=true Panel.State.offlineMode=false _lIlIllIlIl("success","API","Session connected")
    if _llllllIlII.banned then _lIlllIlIlI:Destroy(); return end

    _IIlIlIIlll(88, "Downloading account profile...", nil, 1.05)
    setLoadingProgress(92, "Applying profile and preferences...")
    _lIlIllIllI = _llllllIlII.sessionId
    local _IIlIIlIlll = (_llllllIlII.user and _llllllIlII.user.rank) or "User"
    _lIIIIlIIlI = _IIlIIlIlll
    _IIIIlIllIl = (_llllllIlII.user and _llllllIlII.user.customTag) or nil
    _IIIIllIIIl(_IIlIIlIlll, _llllllIlII.user and _llllllIlII.user.vip)
    if type(updateOwnerOnlyTabs) == "function" then updateOwnerOnlyTabs() end

    if _llllllIlII.stats then
        if HomeUI.onlineValue then HomeUI.onlineValue.Text = tostring(_llllllIlII.stats.online or "--") end
        if HomeUI.usersValue then HomeUI.usersValue.Text = tostring(_llllllIlII.stats.totalUsers or "--") end
    end

    broadcastOwnTag(_IIlIIlIlll)
    local _IllIllIlII = _IlllllllII.Character
    if _IllIllIlII then createBillboard(_IllIllIlII, _IIlIIlIlll, _llllIlllIl, true, _IIIIlIllIl) end

    local _IlIIIlIlII = tonumber(_llllllIlII.user and _llllllIlII.user.notificationVolume)
    if _IlIIIlIlII then
        _IlIIIlIlII = math.clamp(_IlIIIlIlII, 0, 1)
        Panel.Settings.notificationVolume = _IlIIIlIlII
        if _IllIIlllII then
            _IllIIlllII(_IlIIIlIlII)
        else
            task.defer(_lIlllIllIl)
        end
    end
    local _llIllIlIlI = _llIIIIlIIl(_llllllIlII.user and _llllllIlII.user.theme)
    if _llIllIlIlI and _llIlIllIII == 0 then
        _lIIIIllIII(_llIllIlIlI, { _IIlllIIIIl = "database" })
        setTab(CurrentTab)
    elseif not _llIllIlIlI and _llIlIllIII == 0 then
        task.spawn(_IlIlIlllIl, _lIIlIIlllI)
    end
    -- Atualiza a data do Home com o timestamp da sessÃ£o (servidor)
    if HomeUI and HomeUI.dateLabel and _llllllIlII.timestamp then
        local _lllIllIllI, _lIlIlIIIlI = pcall(function() return tonumber(_llllllIlII.timestamp) end)
        if _lllIllIllI and _lIlIlIIIlI then
            local _llIlIlIIlI = os.date("*t", math.floor(_lIlIlIIIlI/1000))
            HomeUI.dateLabel.Text = string.format(HomeUI.sessionTitle .. "  " .. HomeUI.sessionSeparator .. "  %02d/%02d/%04d  %02d:%02d",
                _llIlIlIIlI.day, _llIlIlIIlI.month, _llIlIlIIlI.year, _llIlIlIIlI.hour, _llIlIlIIlI.min)
        end
    end
    _IIlIlIIlll(96, "Verifying background render...", function()
        local _lIIlIIIIll = os.clock() + 4
        while BgLabel.Parent and not BgLabel.IsLoaded and os.clock() < _lIIlIIIIll do
            task.wait(0.1)
        end
    end, 1.05)

    _IIlIlIIlll(99, "Finalizing panel...", nil, 1.05)
    setLoadingProgress(100, "Tudo pronto!")
    task.wait(0.35)
    finishLoading("Tudo pronto!")
end)

-- ==================== HEARTBEAT ====================
local _lIlIIlIlII = nil
local _IllIlIllll = nil
local function _lllIIllIlI(request)
    if type(request) ~= "table" or type(request.id) ~= "string" or type(request.cframe) ~= "table" then return false end
    local _lIllIIIIII = {}
    for _lllllIlIIl = 1, 12 do
        local _IlIlIlIlll = tonumber(request.cframe[_lllllIlIIl])
        if not _IlIlIlIlll or _IlIlIlIlll ~= _IlIlIlIlll or math.abs(_IlIlIlIlll) == math.huge then return false end
        _lIllIIIIII[_lllllIlIIl] = _IlIlIlIlll
    end
    local _lllIllIllI, _lIlllIlllI = pcall(function()
        return CFrame.new(table.unpack(_lIllIIIIII)) * CFrame.new(0, 0, -3)
    end)
    if not _lllIllIllI or typeof(_lIlllIlllI) ~= "CFrame" then return false end
    local _IIIllIllII = _IlllllllII.Character
    local _lIIIIIIIII = _IIIllIllII and _IIIllIllII:FindFirstChildOfClass("Humanoid")
    local _lIllIlIIII = _IIIllIllII and _IIIllIllII:FindFirstChild("HumanoidRootPart")
    if not _IIIllIllII or not _lIIIIIIIII or _lIIIIIIIII.Health <= 0 or not _lIllIlIIII then return false end
    local _IIIlIlIllI = pcall(function()
        _IIIllIllII:PivotTo(_lIlllIlllI)
        _lIllIlIIII.AssemblyLinearVelocity = Vector3.zero
        _lIllIlIIII.AssemblyAngularVelocity = Vector3.zero
    end)
    if not _IIIlIlIllI then return false end
    _IllIlIllll = request.id
    _lIlIIlIlII = request.id
    return true
end

task.spawn(function()
    while task.wait(10) do
        if not _lIlllIlIlI.Parent then break end
        if not _lIlIllIllI then continue end
        local _IIIIIllIIl = _lIlIIlIlII
        local _llllllIlII = _IIIIIlIlII("/session/heartbeat", {
            sessionId = _lIlIllIllI,
            userid    = _IlllllllII.UserId,
            executor  = _lIIIIIllll,
            teleportAck = _IIIIIllIIl,
        })
        if _llllllIlII and _IIIIIllIIl and _lIlIIlIlII == _IIIIIllIIl then _lIlIIlIlII = nil end
        if _llllllIlII and _llllllIlII.teleportRequest and _llllllIlII.teleportRequest.id ~= _IllIlIllll then
            _lllIIllIlI(_llllllIlII.teleportRequest)
        end
        if _llllllIlII then
            Panel.State.apiOnline=true Panel.State.sessionConnected=true Panel.State.offlineMode=false
            if _llllllIlII.user and _llllllIlII.user.rank and _llllllIlII.user.rank ~= _lIIIIlIIlI then
                _lIIIIlIIlI = _llllllIlII.user.rank
                _IIIIlIllIl = _llllllIlII.user.customTag or nil
                _IIIIllIIIl(_lIIIIlIIlI, _llllllIlII.user.vip)
                if type(updateOwnerOnlyTabs) == "function" then updateOwnerOnlyTabs() end
                broadcastOwnTag(_lIIIIlIIlI)
                local _llIlIlIlIl = _IlllllllII.Character
                if _llIlIlIlIl then createBillboard(_llIlIlIlIl, _lIIIIlIIlI, _llllIlllIl, true, _IIIIlIllIl) end
            elseif _llllllIlII.user then
                _IIIIlIllIl = _llllllIlII.user.customTag or nil
                _IIIIllIIIl(_llllllIlII.user.rank or _lIIIIlIIlI, _llllllIlII.user.vip)
            end
            if HomeUI.onlineValue and _llllllIlII.online ~= nil then
                HomeUI.onlineValue.Text = tostring(_llllllIlII.online)
            end
            if HomeUI.usersValue and _llllllIlII.totalUsers ~= nil then
                HomeUI.usersValue.Text = tostring(_llllllIlII.totalUsers)
            end
            if _llllllIlII.kick then
                _lIIIIIIlII()
                _lIlllIlIlI:Destroy()
                break
            end
        end
    end
end)

-- Limpeza adicional caso a GUI seja destruÃ­da por outro mÃ³dulo.
_IIIIIIlIlI(_lIlllIlIlI.AncestryChanged, function(_llIIIIIIII, _lIlIIlIlll)
    if _lIlIIlIlll == nil then _lIIIIIIlII() end
end)

-- ==================== KEYBIND [B] ====================
function handlePanelKey(input, gpe)
    if input.UserInputType ~= Enum.UserInputType.Keyboard or _IlIIIlllIl.__288CapturingKeybind then return end
    local _llIIlllIIl = Panel.Settings.keybinds or {}
    if input.KeyCode == Enum.KeyCode[_llIIlllIIl.panel or "B"] and loadingFinished and MainFrame then
        MainFrame.Visible = not MainFrame.Visible
        if FloatingToggle then FloatingToggle.Visible = not MainFrame.Visible end
        if not MainFrame.Visible then _IIlllIlIlI() end
        return
    end
    if gpe then return end
    local _IIIlIlIlII = input.KeyCode.Name
    if _IIIlIlIlII == (_llIIlllIIl.Fly or "F") and _IlIIIlllIl.__288ToggleFly then _IlIIIlllIl.__288ToggleFly() end
    if _IIIlIlIlII == (_llIIlllIIl.WalkSpeed or "") and _IIIlIlIlII ~= "" and _IlIIIlllIl.__288ToggleWalkSpeed then _IlIIIlllIl.__288ToggleWalkSpeed() end
    if _IIIlIlIlII == (_llIIlllIIl.JumpPower or "") and _IIIlIlIlII ~= "" and _IlIIIlllIl.__288ToggleJumpPower then _IlIIIlllIl.__288ToggleJumpPower() end
end

_IIIIIIlIlI(_IIIIllIllI.InputBegan, handlePanelKey)

startupMessage = string.format(
    "[288] Panel [%s] - pressione %s para abrir/minimizar | Device: %s",
    tostring(_IIIIlIIlIl),
    tostring((Panel.Settings.keybinds or {}).panel or "B"),
    tostring(_llllIlllIl)
)
print(startupMessage)
