return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    tag = "v0.9.3",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "swift",
          "python",
          "go",
          "javascript",
          "typescript",
          "html",
          "css",
          "rust",
          "c",
          "cpp",
          "kotlin",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
