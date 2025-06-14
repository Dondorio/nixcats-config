return {
	{
		"noice.nvim",
		for_cat = "general",
		event = "DeferredUIEnter",
		after = function()
			require("noice").setup({})
		end,
	},
}
