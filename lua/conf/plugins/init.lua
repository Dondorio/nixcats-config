local colorschemeName = nixCats("colorscheme")
if not require("nixCatsUtils").isNixCats then
	colorschemeName = "catppuccin"
end
vim.cmd.colorscheme(colorschemeName)

require("conf.plugins.snacks")
require("conf.plugins.oil")

require("lze").load({
	{ import = "conf.plugins.treesitter" },

	-- General utility
	-- { import = "conf.plugins.snacks" },
	{ import = "conf.plugins.mini" },

	{ import = "conf.plugins.markdown" },
	{ import = "conf.plugins.trouble" },
	{ import = "conf.plugins.ufo" },
	{ import = "conf.plugins.ui" },

	-- Lsp, lint, format, completion, debug
	{ import = "conf.plugins.completion" },
	{ import = "conf.plugins.conform" },
	{ import = "conf.plugins.debug" },
	{ import = "conf.plugins.lazydev" },
	{ import = "conf.plugins.lint" },
	{ import = "conf.plugins.lspconfig" },

	-- Navigation
	{ import = "conf.plugins.flash" },
	{ import = "conf.plugins.harpoon" },

	-- Git
	{ import = "conf.plugins.gitsigns" },

	-- Lang
	-- { import = "conf.plugins.rust" },
	{ import = "conf.plugins.clangd-extensions" },
})
