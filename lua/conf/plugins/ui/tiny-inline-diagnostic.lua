return {
	{
		"tiny-inline-diagnostic.nvim",
		for_cat = {
			cat = "general",
			default = true,
		},
		event = { "BufEnter" },
		priority = 1000,
		after = function()
			require("tiny-inline-diagnostic").setup({
				-- Style preset for diagnostic messages
				-- Available options:
				-- "modern", "classic", "minimal", "powerline",
				-- "ghost", "simple", "nonerdfont", "amongus"
				preset = "modern",

				options = {
					add_messages = {
						display_count = true,
					},

					break_line = {
						enabled = true,
						after = 80,
					},

					multilines = {
						-- Enable multiline diagnostic messages
						enabled = true,

						-- Always show messages on all lines for multiline diagnostics
						always_show = true,

						-- Trim whitespaces from the start/end of each line
						trim_whitespaces = false,

						-- Replace tabs with spaces in multiline diagnostics
						tabstop = 4,
					},

					show_code = true,
					show_source = {
						enabled = true,
						if_many = false,
					},
				},
			})
			vim.diagnostic.config({ virtual_lines = false })
		end,
	},
}
