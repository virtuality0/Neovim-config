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
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "vue_ls",
          "gopls",
          "pyright",
          "html",
          "cssls",
          "tailwindcss",
          "lua_ls",
          "kotlin_language_server",
          "clangd",
          "sourcekit",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local tb = require("telescope.builtin")

      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              preview_width = 0.6,
              results_width = 0.4,
            },
            width = 0.95,
            height = 0.90,
          },
          path_display = { "filename_first" },
        },
      })

      local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
      local vue_language_server_path =
          mason_path .. "/vue-language-server/node_modules/@vue/language-server"

      local function uri_to_fname(uri)
        return vim.uri_to_fname(uri)
      end

      local function is_import_line(fname, lnum)
        local ok, lines = pcall(vim.fn.readfile, fname)
        if not ok or not lines or not lines[lnum] then
          return false
        end
        local line = lines[lnum]
        return line:match("^%s*import%s") ~= nil
            or line:match("^%s*export%s+.*from%s") ~= nil
      end

      local function score_location(loc)
        local uri = loc.uri or loc.targetUri
        if not uri then
          return -math.huge
        end

        local range = loc.range or loc.targetSelectionRange or loc.targetRange
        local fname = uri_to_fname(uri)
        local lnum = (range and range.start and range.start.line or 0) + 1
        local score = 0

        if fname:match("%.vue$") then
          score = score + 120
        end
        if fname:match("%.ts$") or fname:match("%.js$") then
          score = score + 80
        end

        if fname:match("%.d%.ts$") then
          score = score - 200
        end
        if fname:match("shims%-vue%.d%.ts$") or fname:match("env%.d%.ts$") then
          score = score - 300
        end
        if fname:match("/node_modules/") then
          score = score - 120
        end
        if fname:match("/%.nuxt/") or fname:match("/%.vite/") or fname:match("/dist/") then
          score = score - 100
        end

        if is_import_line(fname, lnum) then
          score = score - 90
        end

        return score
      end

      local function dedupe_locations(locs)
        local seen = {}
        local out = {}

        for _, loc in ipairs(locs) do
          local uri = loc.uri or loc.targetUri
          local range = loc.range or loc.targetSelectionRange or loc.targetRange
          if uri and range and range.start then
            local key = table.concat({
              uri,
              tostring(range.start.line),
              tostring(range.start.character),
            }, ":")

            if not seen[key] then
              seen[key] = true
              table.insert(out, loc)
            end
          end
        end

        return out
      end

      local function get_client_encoding(client)
        return client and client.offset_encoding or "utf-8"
      end

      local function open_locations(locations, position_encoding)
        if not locations or vim.tbl_isempty(locations) then
          vim.notify("No definition found", vim.log.levels.INFO)
          return
        end

        if #locations == 1 then
          vim.lsp.util.show_document(locations[1], position_encoding, { reuse_win = true })
        else
          vim.fn.setqflist(vim.lsp.util.locations_to_items(locations, position_encoding))
          vim.cmd("copen")
        end
      end

      local function smart_vue_definition(bufnr)
        local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "vue_ls" })
        local client = clients[1] or vim.lsp.get_clients({ bufnr = bufnr })[1]
        local position_encoding = get_client_encoding(client)
        local params = vim.lsp.util.make_position_params(0, position_encoding)

        vim.lsp.buf_request_all(bufnr, "textDocument/definition", params, function(results)
          local all = {}

          for _, res in pairs(results or {}) do
            if res.result then
              if vim.islist(res.result) then
                vim.list_extend(all, res.result)
              else
                table.insert(all, res.result)
              end
            end
          end

          all = dedupe_locations(all)

          if vim.tbl_isempty(all) then
            vim.notify("No definition found", vim.log.levels.INFO)
            return
          end

          table.sort(all, function(a, b)
            return score_location(a) > score_location(b)
          end)

          local best_score = score_location(all[1])

          if #all > 1 and best_score < 0 then
            tb.lsp_definitions({
              layout_strategy = "horizontal",
              layout_config = {
                horizontal = { preview_width = 0.6 },
                width = 0.95,
                height = 0.90,
              },
              path_display = { "filename_first" },
            })
            return
          end

          local top = {}
          local top_score = score_location(all[1])

          for _, loc in ipairs(all) do
            if score_location(loc) >= top_score - 40 then
              table.insert(top, loc)
            end
          end

          open_locations(top, position_encoding)
        end)
      end

      local on_attach = function(client, bufnr)
        local function buf_map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        local ft = vim.bo[bufnr].filetype
        local position_encoding = get_client_encoding(client)

        buf_map("n", "K", vim.lsp.buf.hover, "Hover")
        buf_map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")

        if client:supports_method("textDocument/definition") then
          if ft == "vue" then
            buf_map("n", "<leader>gd", function()
              smart_vue_definition(bufnr)
            end, "Smart Vue Definition")
          else
            buf_map("n", "<leader>gd", function()
              local params = vim.lsp.util.make_position_params(0, position_encoding)

              client:exec_cmd({
                title = "Go to Source Definition",
                command = "_typescript.goToSourceDefinition",
                arguments = { params.textDocument.uri, params.position },
              }, { bufnr = bufnr }, function(err, result)
                if err then
                  tb.lsp_definitions({
                    layout_strategy = "horizontal",
                    layout_config = {
                      horizontal = { preview_width = 0.6 },
                      width = 0.95,
                      height = 0.90,
                    },
                    path_display = { "filename_first" },
                  })
                  return
                end

                if not result or vim.tbl_isempty(result) then
                  tb.lsp_definitions({
                    layout_strategy = "horizontal",
                    layout_config = {
                      horizontal = { preview_width = 0.6 },
                      width = 0.95,
                      height = 0.90,
                    },
                    path_display = { "filename_first" },
                  })
                  return
                end

                open_locations(result, position_encoding)
              end)
            end, "Go to Source Definition")
          end
        end

        if client:supports_method("textDocument/references") then
          buf_map("n", "<leader>gr", function()
            tb.lsp_references({
              include_declaration = false,
              layout_strategy = "horizontal",
              layout_config = {
                horizontal = { preview_width = 0.6 },
                width = 0.95,
                height = 0.90,
              },
              path_display = { "filename_first" },
              show_line = false,
            })
          end, "References")
        end

        if client:supports_method("textDocument/implementation") then
          buf_map("n", "<leader>gi", function()
            tb.lsp_implementations({
              layout_strategy = "horizontal",
              layout_config = {
                horizontal = { preview_width = 0.6 },
                width = 0.95,
                height = 0.90,
              },
              path_display = { "filename_first" },
            })
          end, "Implementations")
        end

        if client:supports_method("textDocument/declaration") then
          buf_map("n", "<leader>gD", vim.lsp.buf.declaration, "Go to Declaration")
        end

        if client.name == "ts_ls" then
          local caps = client.server_capabilities
          if caps and caps.semanticTokensProvider and ft == "vue" then
            caps.semanticTokensProvider.full = false
          end
        end

        if client.name == "clangd" then
          client.server_capabilities.signatureHelpProvider = false
        end
      end

      local servers = {
        ts_ls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
          },
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
              },
            },
          },
        },

        vue_ls = {
          filetypes = { "vue" },
        },

        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = {
                unusedparams = true,
              },
            },
          },
        },

        pyright = {},
        html = {},
        cssls = {},
        tailwindcss = {},

        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },

        kotlin_language_server = {
          filetypes = { "kotlin" },
          single_file_support = false,
          root_markers = {
            "settings.gradle.kts",
            "settings.gradle",
            "build.gradle.kts",
            "build.gradle",
            "gradlew",
          },
        },

        clangd = {
          filetypes = { "c", "cpp" },
        },

        sourcekit = {
          filetypes = { "swift" },
        },
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        vim.lsp.config(server, config)
      end

      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
}
