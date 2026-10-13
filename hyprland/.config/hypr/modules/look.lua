-- look.lua

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,
        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(88C0D0ff)", "rgba(81A1C1ff)"}, angle = 45 },
            inactive_border = "rgba(4C566Aff)",
        },

        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 4,
        rounding_power = 2,

        active_opacity   = 1,
        inactive_opacity = 1,

        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = 0xee2E3440,
        },

        blur = {
            enabled   = false,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})
