return {
	"gitsigns.nvim",
	for_cat = {
		cat = "general",
		default = true,
	},
	keys = {},
	event = { "DeferredUIEnter" },
	after = function(plugin)
		require("gitsigns").setup()
	end,
}
