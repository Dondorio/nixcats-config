require("snacks").setup({
	-- dashboard = {},
	animate = {},
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
	scroll = {},

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
			only_current = false,
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

vim.keymap.set("n", "<leader>e", function()
	Snacks.explorer.open()
end, { desc = "Snacks Explorer" })

-- Find files
vim.keymap.set("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader><leader>", function()
	Snacks.picker.files()
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader>fs", function()
	Snacks.picker.smart()
end, { desc = "Smart Find Files" })

-- Find buffers
vim.keymap.set("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Search Buffers" })

-- Grep
vim.keymap.set("n", "<leader>fg", function()
	Snacks.picker.grep()
end, { desc = "Grep" })

vim.keymap.set("n", "<leader>fG", function()
	Snacks.picker.git_files()
end, { desc = "Find Git Files" })

-- Git
vim.keymap.set("n", "<leader>fG", function()
	Snacks.picker.git_files()
end, { desc = "Find Git Files" })
-- vim.keymap.set("n", "<leader>gg", function()
-- 	Snacks.terminal({ "gitui" })
-- end, { desc = "Open gitui" })
-- vim.keymap.set("n", "<leader>gG", function()
-- 	Snacks.terminal({ "gitui" }, { cwd = Snacks.git.get_root() })
-- end, { desc = "Open gitui in git root" })

vim.keymap.set("n", "<leader>uC", function()
	Snacks.picker.colorschemes()
end, { desc = "Colourschemes" })
