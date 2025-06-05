local colorschemeName = nixCats("colorscheme")
if not require("nixCatsUtils").isNixCats then
  colorschemeName = "onedark"
end
-- Could I lazy load on colorscheme with lze?
-- sure. But I was going to call vim.cmd.colorscheme() during startup anyway
-- this is just an example, feel free to do a better job!
vim.cmd.colorscheme(colorschemeName)

require("conf.plugins.snacks")
require("conf.plugins.oil")

require("lze").load({
  -- { import = "conf.plugins.telescope" },
  { import = "conf.plugins.treesitter" },
  { import = "conf.plugins.which-key" },
  { import = "conf.plugins.completion" },
  { import = "conf.plugins.lazydev" },
  { import = "conf.plugins.lspconfig" },
  { import = "conf.plugins.flash" },
  { import = "conf.plugins.mini" },
  { import = "conf.plugins.lualine" },
  -- { import = "conf.plugins.snacks" },
  -- { import = "conf.plugins.completion" },
})
