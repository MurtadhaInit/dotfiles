local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- retain copied text after pasting it (don't yank the selected text)
keymap("v", "p", '"_dP', opts)

-- vim.commentary functionality
vim.cmd [[
    xmap gc  <Plug>VSCodeCommentary
    nmap gc  <Plug>VSCodeCommentary
    omap gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine
]]

