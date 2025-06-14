local colorschemeName = nixCats("colorscheme")
if not require("nixCatsUtils").isNixCats then
	colorschemeName = "catppuccin"
end
vim.cmd.colorscheme(colorschemeName)

require("conf.plugins.snacks")
require("conf.plugins.oil")

require("lze").load({
	{ import = "conf.plugins.treesitter" },

	-- general utility
	-- { import = "conf.plugins.snacks" },
	{ import = "conf.plugins.mini" },

	{ import = "conf.plugins.ui" },

	{ import = "conf.plugins.ufo" },

	{ import = "conf.plugins.lspconfig" },
	{ import = "conf.plugins.completion" },
	{ import = "conf.plugins.lazydev" },
	{ import = "conf.plugins.lint" },

	{ import = "conf.plugins.flash" },
	{ import = "conf.plugins.harpoon" },

	{ import = "conf.plugins.conform" },
	{ import = "conf.plugins.gitsigns" },

	{ import = "conf.plugins.rust" },
})
