return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 10,
      direction = "horizontal",
      start_in_insert = true,
      persist_size = true,
      close_on_exit = true,
      hide_numbers = true,
      on_open = function(term)
local opts = {noremap = true, silent = true, buffer = term.bufnr}
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
        -- Re-enter insert mode when switching back to terminal
        vim.cmd("startinsert!")
      end,
    },
    keys = {
{ "<leader>t", function() require("toggleterm").toggle(1) end, desc = "Toggle Terminal" },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },
}
