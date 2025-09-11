vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
vim.keymap.set('i', 'jk', '<Esc>')

vim.wo.number = true

-- toggle hidden files like .env node_modules
vim.keymap.set("n", "<leader>th", function()
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

-- open terminal window
vim.keymap.set("n", "<leader>t", function()
  vim.cmd("botright split | terminal")
end, { desc = "Open terminal in horizontal split at bottom" })


vim.api.nvim_set_keymap('t','<C-k>', [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })

-- open terminal window in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd("startinsert!")
  end,
})

--rename a variable 
vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
