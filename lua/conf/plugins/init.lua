local colorschemeName = nixCats("colorscheme")
if not require("nixCatsUtils").isNixCats then
  colorschemeName = "catppuccin"
end
vim.cmd.colorscheme(colorschemeName)

require("conf.plugins.snacks")
require("conf.plugins.oil")

require("lze").load({
  { import = "conf.plugins.treesitter" },
  { import = "conf.plugins.which-key" },

  -- { import = "conf.plugins.snacks" },
  { import = "conf.plugins.mini" },
  { import = "conf.plugins.lualine" },

  { import = "conf.plugins.lspconfig" },
  { import = "conf.plugins.completion" },
  { import = "conf.plugins.lazydev" },

  { import = "conf.plugins.flash" },

  { import = "conf.plugins.conform" },
  { import = "conf.plugins.gitsigns" },
})
