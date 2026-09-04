# plugin for autocomplete 

return {
    "saghen/blink.cmp",
    version = "*",

    opts = {
        keymap = {
            preset = "default",

            ["<CR>"] = { "accept", "fallback" },
        },

        completion = {
            menu = {
                border = "single",
            },
            documentation = {
                auto_show = true,
                window = {
                    border = "single",
                },
            },
        },

        sources = {
            default = { "lsp", "path", "buffer" },
        },
    },

    config = function(_, opts)
        require("blink.cmp").setup(opts)

        local completion_highlights = {
            BlinkCmpMenu = { fg = "#00ff66", bg = "#000000" },
            BlinkCmpMenuBorder = { fg = "#00cc55", bg = "#000000" },
            BlinkCmpMenuSelection = { fg = "#66ff99", bg = "#102016", bold = true },
            BlinkCmpLabel = { fg = "#00ff66", bg = "#000000" },
            BlinkCmpLabelDeprecated = { fg = "#008844", bg = "#000000", strikethrough = true },
            BlinkCmpLabelMatch = { fg = "#99ffbb", bg = "#000000", bold = true },
            BlinkCmpKind = { fg = "#00bb55", bg = "#000000" },
            BlinkCmpSource = { fg = "#008844", bg = "#000000" },
            BlinkCmpDoc = { fg = "#00ff66", bg = "#000000" },
            BlinkCmpDocBorder = { fg = "#00cc55", bg = "#000000" },
            BlinkCmpDocSeparator = { fg = "#008833", bg = "#000000" },
        }

        for group, highlight in pairs(completion_highlights) do
            vim.api.nvim_set_hl(0, group, highlight)
        end
    end,
}
