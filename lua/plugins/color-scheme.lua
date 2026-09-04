return {
  {
    "luisiacc/the-matrix.nvim",
    lazy = false,
    priority = 1000,

    config = function()
      vim.g.thematrix_function_style = "NONE"
      vim.g.thematrix_keyword_style = "italic"

      vim.g.thematrix_telescope_theme = 1
      vim.g.thematrix_transparent_mode = 0

      vim.cmd.colorscheme("thematrix")

      -- Pure black background
      vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#000000" })
    end,
  },
}
