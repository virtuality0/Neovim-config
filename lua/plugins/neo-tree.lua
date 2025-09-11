return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    default_component_configs = {
      git_status = {
        symbols = {
          added     = "A",   -- new file
          modified  = "M",   -- file with changes
          deleted   = "D",   -- file deleted
          renamed   = "R",  -- file renamed
          untracked = "U",   -- file not tracked
          ignored   = "I",   -- file ignored
          staged    = "",   -- changes staged
          conflict  = "",  -- merge conflict
        },
      },
    },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)
    vim.keymap.set("n", "<C-n>", "<Cmd>Neotree toggle<CR>", {})
    vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
  end,
}
