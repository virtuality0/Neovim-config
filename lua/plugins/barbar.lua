return {
  "romgrk/barbar.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    "lewis6991/gitsigns.nvim"      -- OPTIONAL: for git status
  },
  init = function() vim.g.barbar_auto_setup = false end,
  opts = {},
  version = "^1.0.0", -- Recommended: lock to latest stable tag
  config = function()
    require('barbar').setup {
      -- your barbar options here!
    }

    vim.api.nvim_set_keymap('n', '<Tab>', '<Cmd>BufferNext<CR>', { noremap = true, silent = true })

    vim.api.nvim_set_keymap('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>', { noremap = true, silent = true })

    vim.api.nvim_set_keymap('n', '<leader>x', ':BufferClose<CR>', { noremap = true, silent = true })
  end,
}
