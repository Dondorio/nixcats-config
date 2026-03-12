return {
	{
		"bufferline.nvim",
		for_cat = {
			cat = "general",
			default = true,
		},
		after = function()
			require("bufferline").setup({
				options = {
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(_, _, diagnostics_dict, _)
						local s = " "
						for e, n in pairs(diagnostics_dict) do
							local sym = e == "error" and "  " or (e == "warning" and "  " or "  ")
							s = s .. n .. sym
						end
						return s
					end,
				},
			})
		end,
	},
}
