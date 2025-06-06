return {
  "gitsigns.nvim",
  for_cat = {
    cat = "general",
    default = true,
  },
  keys = {
    -- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  },
  event = { 'DeferredUIEnter' },
  after = function(plugin)
    require("gitsigns").setup()
  end,
}
