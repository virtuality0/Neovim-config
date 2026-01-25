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
      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local on_attach = function(client, bufnr)
        local buf_map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
        end
        buf_map("n", "K", vim.lsp.buf.hover)
        buf_map("n", "<leader>gd", "<cmd>Telescope lsp_definitions<cr>")
        buf_map("n", "<leader>gr", "<cmd>Telescope lsp_references<cr>")
        buf_map("n", "<leader>gi", "<cmd>Telescope lsp_implementatons<cr>")
        buf_map("n", "<leader>ca", vim.lsp.buf.code_action)
      end

      -- Setup Typescript/JS servers covering js, ts, jsx, tsx files
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      })

      -- Go language server
      lspconfig.gopls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedParams = true
            }
          }
        }
      })

      -- Python
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- HTML
      lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- CSS
      lspconfig.cssls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Tailwind CSS
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Lua language server (optional, if needed)
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Vue / Volar
      lspconfig.volar.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "vue" }, -- or takeover mode list if you want
        init_options = {
          typescript = {
            -- if using Mason's TS install, adjust this path
            tsdk = vim.fn.stdpath("data")
                .. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
          },
        },
      })

      -- Kotlin language server
      lspconfig.kotlin_language_server.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "kotlin" },
      })
    end,
  },
}
