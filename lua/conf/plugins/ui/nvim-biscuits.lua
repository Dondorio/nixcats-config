return {
	"nvim-biscuits",
	for_cat = {
		cat = "general",
		default = true,
	},
	on_plugin = { "nvim-treesitter" },
	after = function()
		require("nvim-biscuits").setup({
			cursor_line_only = true,
		})
	end,
}
