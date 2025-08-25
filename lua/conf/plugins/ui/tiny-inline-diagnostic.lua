return {
	{
		"tiny-inline-diagnostic.nvim",
		for_cat = "general",
		event = "BufEnter",
		priority = 1000,
		after = function()
			require("tiny-inline-diagnostic").setup({
				-- Style preset for diagnostic messages
				-- Available options:
				-- "modern", "classic", "minimal", "powerline",
				-- "ghost", "simple", "nonerdfont", "amongus"
				preset = "modern",

				show_source = {
					enabled = true,
					if_many = false,
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

				-- Configuration for breaking long messages into separate lines
				break_line = {
					-- Enable the feature to break messages after a specific length
					enabled = true,

					-- Number of characters after which to break the line
					after = 50,
				},
			})
			vim.diagnostic.config({ virtual_lines = false })
		end,
	},
}
