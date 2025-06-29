return {
	{
		"rustaceanvim",
		for_cat = {
			cat = "general",
			default = true,
		},
		ft = "rust",
		after = function()
			local bufnr = vim.api.nvim_get_current_buf()
			vim.keymap.set(
				"n",
				"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
				function()
					vim.cmd.RustLsp({ "hover", "actions" })
				end,
				{ silent = true, buffer = bufnr }
			)
			-- require("rustaceanvim").setup()
		end,
	},
}
