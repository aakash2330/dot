-- Use nvim-cmp instead of blink.cmp so our cmp opts apply
vim.g.lazyvim_cmp = "nvim-cmp"
require("config.lazy")
vim.opt.laststatus = 0
vim.opt.guicursor = ""
vim.g.autoformat = false
vim.opt.mouse = ""
vim.diagnostic.enable(false)
--vim.opt.background = "light"
