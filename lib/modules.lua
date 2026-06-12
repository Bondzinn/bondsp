--[[
    288 Panel — modules.lua
    Registro central de módulos.
    Define categorias, caminhos e metadados.
    NÃO executa lógica — apenas descreve o que existe.
]]

return {

    -- ==================== EMPHASIS ====================
    {
        Name        = "NoClip",
        Category    = "Emphasis",
        Path        = "modules/Emphasis/NoClip.lua",
        Description = "Atravessa paredes e objetos sólidos.",
        RequireVip  = false,
    },
    {
        Name        = "Hitbox Expander",
        Category    = "Emphasis",
        Path        = "modules/Emphasis/Hitbox.lua",
        Description = "Expande o hitbox dos jogadores.",
        RequireVip  = false,
    },
    {
        Name        = "Speed Hack",
        Category    = "Emphasis",
        Path        = "modules/Emphasis/Speed.lua",
        Description = "Aumenta a velocidade de movimento.",
        RequireVip  = false,
    },
    {
        Name        = "Infinite Jump",
        Category    = "Emphasis",
        Path        = "modules/Emphasis/InfiniteJump.lua",
        Description = "Permite pular infinitamente no ar.",
        RequireVip  = false,
    },
    {
        Name        = "Flight",
        Category    = "Emphasis",
        Path        = "modules/Emphasis/Flight.lua",
        Description = "Permite voar livremente.",
        RequireVip  = true,
    },
    {
        Name        = "Gravity Modifier",
        Category    = "Emphasis",
        Path        = "modules/Emphasis/Gravity.lua",
        Description = "Altera a gravidade do personagem.",
        RequireVip  = true,
    },

    -- ==================== MORE ====================
    {
        Name        = "ESP",
        Category    = "More",
        Path        = "modules/More/ESP.lua",
        Description = "Visualiza jogadores através de paredes.",
        RequireVip  = false,
    },
    {
        Name        = "Tracers",
        Category    = "More",
        Path        = "modules/More/Tracers.lua",
        Description = "Desenha linhas até jogadores inimigos.",
        RequireVip  = false,
    },
    {
        Name        = "Aimbot",
        Category    = "More",
        Path        = "modules/More/Aimbot.lua",
        Description = "Mira automaticamente em jogadores.",
        RequireVip  = false,
    },
    {
        Name        = "Silent Aim",
        Category    = "More",
        Path        = "modules/More/SilentAim.lua",
        Description = "Acerta sem mover a câmera.",
        RequireVip  = true,
    },
    {
        Name        = "Anti-AFK",
        Category    = "More",
        Path        = "modules/More/AntiAFK.lua",
        Description = "Previne kick por inatividade.",
        RequireVip  = false,
    },
    {
        Name        = "Rejoin",
        Category    = "More",
        Path        = "modules/More/Rejoin.lua",
        Description = "Reconecta ao servidor atual.",
        RequireVip  = false,
    },

}
