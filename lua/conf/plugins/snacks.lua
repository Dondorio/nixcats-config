return {
	"snacks",
	keys = {
		{
			"<leader>e",
			function()
				require("snacks").explorer.open()
			end,
			desc = "Snacks Explorer",
		},

		-- Picker
		{
			"<leader>f",
			function()
				require("snacks").picker.files()
			end,
			desc = "Find Files",
		},

		{
			"<leader>s",
			function()
				require("snacks").picker.smart()
			end,
			desc = "Smart Find Files",
		},

		{
			"<leader>b",
			function()
				require("snacks").picker.buffers()
			end,
			desc = "Search Buffers",
		},

		{
			"<leader>g",
			function()
				require("snacks").picker.grep()
			end,
			desc = "Grep",
		},

		{
			"<leader>G",
			function()
				require("snacks").picker.git_files()
			end,
			desc = "Find Git Files",
		},

		{
			"<leader>uC",
			function()
				require("snacks").picker.colorschemes()
			end,
			desc = "Colourschemes",
		},

		-- Other
		{
			"<leader>tg",
			function()
				require("snacks").terminal({ "gitui" })
			end,
			desc = "Open gitui",
		},
		{
			"<leader>tG",
			function()
				local snacks = require("snacks")
				snacks.terminal({ "gitui" }, { cwd = snacks.git.get_root() })
			end,
			desc = "Open gitui in git root",
		},

		{
			"<leader>.",
			function()
				require("snacks").scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},

		{
			"<leader>,",
			function()
				require("snacks").scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},

		{
			"<leader>dps",
			function()
				require("snacks").profiler.scratch()
			end,
			desc = "Profiler Scratch Buffer",
		},
	},
	after = function()
		require("snacks").setup({
			-- dashboard = {},
			bigfile = {},
			explorer = {},
			gitbrowse = {},
			image = {},
			input = {},
			lazygit = {},
			notifier = {},
			picker = {},
			rename = {},
			scope = {},

			indent = {
				priority = 1000,
				enabled = true, -- enable indent guides
				char = "│",
				only_scope = false, -- only show indent guides of the scope
				only_current = false, -- only show indent guides in the current window
				hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides

				scope = {
					priority = 200,
					enabled = true,
					fonly_current = false,
					-- char = "┇",
					underline = true,
					hl = "SnacksIndentScope",
				},
			},

			statuscolumn = {
				left = { "mark", "sign" }, -- priority of signs on the left (high to low)
				right = { "fold", "git" }, -- priority of signs on the right (high to low)
				folds = {
					open = true, -- show open fold icons
					git_hl = true, -- use Git Signs hl for fold icons
				},
				git = {
					-- patterns to match Git signs
					patterns = { "GitSign", "MiniDiffSign" },
				},
				refresh = 50, -- refresh at most every 50ms
			},
		})
	end,
}
