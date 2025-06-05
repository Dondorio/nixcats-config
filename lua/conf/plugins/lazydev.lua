return {
  "lazydev.nvim",
  for_cat = {
    cat = "general",
    default = true,
  },
  cmd = { "LazyDev" },
  ft = "lua",
  after = function(plugin)
    require("lazydev").setup({
      library = {
        "nvim-dap-ui",
        {
          words = { "nixCats" },
          path = (require("nixCats").nixCatsPath or "") .. "/lua",
        },
      },
    })
  end,
}
