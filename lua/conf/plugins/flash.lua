return {
  "flash.nvim",
  for_cat = {
    cat = "general",
    default = true,
  },
  keys = {
    -- Create a key mapping and lazy-load when it is used
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  on_require = { "flash" },
  after = function(plugin)
    require("flash").setup({
      labels = "aoeeuidhtnpyfgcrlqjkxbmwvz",
    })
  end,
}
