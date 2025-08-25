return {
	{
		"clangd_extensions.nvim",
		for_cat = {
			cat = "lsp",
			default = true,
		},
		after = function()
			require("clangd_extensions").setup()
			vim.keymap.set("n", "gh", "<cmd>ClangdSwitchSourceHeader<CR>")
		end,
	},
}
