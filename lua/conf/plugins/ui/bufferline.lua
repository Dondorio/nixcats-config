return {
	{
		"bufferline.nvim",
		for_cat = "general",
		event = "DeferredUIEnter",
		after = function(plugin)
			require("bufferline").setup({})
		end,
	},
}
