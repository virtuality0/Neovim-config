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
          added     = "A",
          modified  = "M",
          deleted   = "D",
          renamed   = "R",
          untracked = "U",
          ignored   = "I",
          staged    = "",
          conflict  = "",
        },
      },
    },
    filesystem = {
      use_libuv_file_watcher = true
    },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)

    -- keymaps (unchanged)
    vim.keymap.set("n", "<C-n>", "<Cmd>Neotree toggle<CR>", {})
    vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})

    -- 🔄 Refresh after :!git commands
    vim.api.nvim_create_autocmd("ShellCmdPost", {
      pattern = "*",
      callback = function()
        local cmd = vim.v.shell_cmd or ""
        if cmd:match("^%s*git") then
          require("neo-tree.sources.manager").refresh("filesystem")
          require("neo-tree.sources.manager").refresh("git_status")
        end
      end,
    })

    -- 🔄 Refresh after terminal git commands
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*",
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local name = vim.api.nvim_buf_get_name(buf)

        -- crude but effective: check if it's a terminal buffer
        if name:match("term://") then
          -- Optional: small delay to let git finish writing
          vim.defer_fn(function()
            require("neo-tree.sources.manager").refresh("filesystem")
            require("neo-tree.sources.manager").refresh("git_status")
          end, 100)
        end
      end,
    })
  end,
}
