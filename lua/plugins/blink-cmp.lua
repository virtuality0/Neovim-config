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
            documentation = {
                auto_show = true,
            },
        },

        sources = {
            default = { "lsp", "path", "buffer" },
        },
    },
}
