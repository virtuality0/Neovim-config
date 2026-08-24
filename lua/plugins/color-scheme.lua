return {
  -- {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "catppuccin-mocha"
  --   end
  -- }
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.o.background = "dark" -- or "light"
  --     vim.cmd.colorscheme("gruvbox")
  --   end,
  -- }
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Optional configuration
      require("kanagawa").setup({
        compile = false,
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        theme = "dragon"
      })

      vim.cmd.colorscheme("kanagawa")
    end,
  },
  -- {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "catppuccin-mocha"
  --   end
  -- }
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.o.background = "dark" -- or "light"
  --     vim.cmd.colorscheme("gruvbox")
  --   end,
  -- }
  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("kanagawa").setup({
  --       theme = "dragon", -- "wave", "dragon", or "lotus"
  --
  --       compile = true,
  --       transparent = false,
  --       terminalColors = true,
  --
  --       commentStyle = { italic = true },
  --       keywordStyle = { italic = true },
  --       statementStyle = { bold = true },
  --
  --       colors = {
  --         theme = {
  --           all = {
  --             ui = {
  --               bg_gutter = "none", -- cleaner sign column
  --             },
  --           },
  --         },
  --       },
  --     })
  --
  --     vim.cmd.colorscheme("kanagawa-dragon")
  --   end,
  -- },
}
