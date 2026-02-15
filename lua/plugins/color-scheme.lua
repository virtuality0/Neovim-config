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
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark" -- or "light"
      vim.cmd.colorscheme("gruvbox")
    end,
  }
}
