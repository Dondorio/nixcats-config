return {
	-- Completion engines
	{
		"blink-ripgrep.nvim",
		for_cat = { cat = "general", default = true },
		on_plugin = { "blink.cmp" },
	},
	{
		"blink-emoji.nvim",
		for_cat = { cat = "general", default = true },
		on_plugin = { "blink.cmp" },
	},
	{
		"blink-cmp-spell",
		for_cat = { cat = "general", default = true },
		on_plugin = { "blink.cmp" },
	},
	{
		"blink.compat",
		for_cat = { cat = "general", default = true },
		on_plugin = { "blink.cmp" },
	},
	{
		"blink.cmp",
		for_cat = { cat = "general", default = true },
		event = { "InsertEnter" },
		on_require = { "blink" },
		after = function()
			local bl = require("blink.cmp")
			bl.setup({
				completion = {
					-- keyword = {
					-- 	range = "full",
					-- },
					-- trigger = {
					-- 	show_on_keyword = true,
					-- 	show_on_trigger_character = true,
					-- 	show_on_insert_on_trigger_character = true,
					-- },
					-- list = {
					-- 	selection = {
					-- 		preselect = false,
					-- 		auto_insert = true,
					-- 	},
					-- },
					accept = {
						auto_brackets = {
							enabled = true,
						},
					},
					menu = {
						-- auto_show = true,
						draw = {
							treesitter = { "lsp" },
						},
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 200,
						-- treesitter_highlighting = false,
					},
					ghost_text = {
						enabled = true,
					},
				},
				-- Keymap
				keymap = {
					preset = "default",
					["<tab>"] = { "select_next", "fallback" },
					["<S-tab>"] = { "select_prev", "fallback" },
					["<CR>"] = { "accept", "fallback" },
				},
				-- Completion sources
				sources = {
					default = function(ctx)
						-- Default list of completion sources
						local sourceList = {
							"lsp",
							"path",
							"snippets",
							"buffer",
							"ripgrep",
							"emoji",
						}
						-- Conditionally add sources
						if vim.bo.filetype == "lua" then
							table.insert(sourceList, "lazydev")
						end
						return sourceList
					end,
					providers = {
						path = {
							async = true,
						},
						ripgrep = {
							module = "blink-ripgrep",
							name = "Ripgrep",
							opts = {
								prefix_min_len = 3,
								context_size = 4,
								max_filesize = "1M",
								project_root_marker = {
									".git",
									"flake.lock",
									"uv.lock",
								},
							},
						},
						emoji = {
							module = "blink-emoji",
							name = "Emoji",
							score_offset = 15,
							opts = {
								insert = true,
							},
						},
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							score_offset = 100,
						},
					},
				},
				-- Snippets
				snippets = {
					preset = "luasnip",
				},
				-- Signature help
				signature = { enabled = true },
			})
		end,
	},
}
