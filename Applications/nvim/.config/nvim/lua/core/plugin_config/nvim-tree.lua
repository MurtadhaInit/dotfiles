vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- maybe remove the setup function from packer setup and keep this?
-- require("nvim-tree").setup()

-- "project view", i.e. the file explorer
vim.keymap.set('n', '<leader>pv', ':NvimTreeFindFileToggle<CR>')
