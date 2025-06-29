return {
	{
		"render-markdown.nvim",
		for_cat = {
			cat = "general",
			default = true,
		},
		ft = "markdown",
		after = function()
			require("render-markdown").setup({})
		end,
	},
}
