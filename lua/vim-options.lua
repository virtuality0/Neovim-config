vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set ignorecase")
vim.cmd("set smartcase")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
vim.keymap.set('i', 'js', '<Esc>')

vim.wo.number = true
--True

-- toggle hidden files like .env node_modules
vim.keymap.set("n", "<leader>I", function()
  local state = require("neo-tree.sources.manager").get_state("filesystem")
  if state then
    state.filtered_items.visible = not state.filtered_items.visible
    require("neo-tree.sources.manager").refresh("filesystem")
  end
end, { desc = "Toggle hidden files in Neo-tree" })

--Open Neo-tree whenever I open a directory
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Auto open Neo-tree",
  callback = function()
    -- Only open if Neovim was launched with a directory or no file
    if vim.fn.argc() == 0 or vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      vim.cmd("Neotree reveal")
    end
  end,
})


--rename a variable
vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
