return {
  "stevearc/conform.nvim",
  config = function()
    local function no_eslint_config(ctx)
      local root = ctx.dirname or vim.loop.cwd()
      local eslint_configs = {
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.json",
        ".eslintrc.yaml",
        ".eslintrc.yml",
      }
      for _, file in ipairs(eslint_configs) do
        if vim.loop.fs_stat(root .. "/" .. file) then
          return false
        end
      end
      local pkg_path = root .. "/package.json"
      local stat = vim.loop.fs_stat(pkg_path)
      if stat and stat.type == "file" then
        local lines = vim.fn.readfile(pkg_path)
        local content = table.concat(lines, "\n")
        local ok, data = pcall(vim.fn.json_decode, content)
        if ok and data and data.eslintConfig then
          return false
        end
      end
      return true
    end

    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascriptreact = { "prettier" },
        go = { "gofmt" },
        python = { args = { "--indent-size=2" }, exe = "autopep8" },
        css = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        rust = { "rustfmt" },
      },
      formatters = {
        prettier = {
          condition = no_eslint_config,
        },
        autopep8 = {
          args = { "--indent-size=2" },
        },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })
  end,
}
