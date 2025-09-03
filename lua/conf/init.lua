require("conf.keymap")

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.colorcolumn = "80"

require("lze").register_handlers(require("nixCatsUtils.lzUtils").for_cat)
require("lze").register_handlers(require("lzextras").lsp)

vim.diagnostic.config({ virtual_lines = { current_line = true } })
vim.lsp.inlay_hint.enable(true)

vim.lsp.enable("lua_ls")

vim.lsp.enable("nil_ls")
vim.lsp.enable("nixd")

vim.lsp.enable("clangd")
vim.lsp.enable("gopls")

-- BEAM
vim.lsp.enable("elixirls")

require("conf.plugins")
