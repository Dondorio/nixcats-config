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
					},

					ghost_text = {
						enabled = true,
					},
				},

				keymap = {
					preset = "default",
					["<tab>"] = { "select_next", "fallback" },
					["<S-tab>"] = { "select_prev", "fallback" },
					["<CR>"] = { "accept", "fallback" },
				},

				sources = {
					default = function(ctx)
						local sourceList = {
							"lsp",
							"path",
							"snippets",
							"buffer",
							"ripgrep",
							"emoji",
						}

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

				snippets = {
					preset = "luasnip",
				},

				signature = { enabled = true },
			})
		end,
	},
}
