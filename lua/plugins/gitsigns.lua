return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",

  config = function()
    require("gitsigns").setup({
      current_line_blame = true,

      current_line_blame_opts = {
        delay = 50,
        virt_text_pos = "eol", -- eol | overlay | right_align
      },

      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
    })
  end,
  vim.keymap.set("n", "<leader>tb", function()
    require("gitsigns").toggle_current_line_blame()
  end)
}
