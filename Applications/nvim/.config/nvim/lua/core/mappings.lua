vim.g.mapleader = " "

-- "project view", i.e. the file explorer
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Vex)

-- after selecting text you can move it up or down
 vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
 vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
