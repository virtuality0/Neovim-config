return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local on_attach = function(client, bufnr)
        local buf_map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
        end
        buf_map("n", "K", vim.lsp.buf.hover)
        buf_map("n", "<leader>gd", "<cmd>Telescope lsp_definitions<cr>")
        buf_map("n", "<leader>gr", "<cmd>Telescope lsp_references<cr>")
        buf_map("n", "<leader>gi", "<cmd>Telescope lsp_implementations<cr>")
        buf_map("n", "<leader>ca", vim.lsp.buf.code_action)
      end

      local servers = {
        ts_ls = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = { unusedParams = true },
            },
          },
        },
        pyright = {},
        html = {},
        cssls = {},
        tailwindcss = {},
        lua_ls = {},
        volar = {
          filetypes = { "vue" },
          init_options = {
            typescript = {
              tsdk = vim.fn.stdpath("data")
                  .. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
            },
          },
        },
        kotlin_language_server = {
          filetypes = { "kotlin" },
        },
        clangd = {
          filetypes = { "c", "cpp" },
        },
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        -- clangd needs special on_attach
        if server == "clangd" then
          config.on_attach = function(client, bufnr)
            client.server_capabilities.signatureHelpProvider = false
            on_attach(client, bufnr)
          end
        else
          config.on_attach = on_attach
        end
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },
}
