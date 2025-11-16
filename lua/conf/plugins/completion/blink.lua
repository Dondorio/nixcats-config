return {
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
			require("blink.cmp").setup({
				completion = {
					accept = {
						auto_brackets = {
							enabled = true,
						},
					},

					menu = {
						-- auto_show = true,
						border = "rounded",

						draw = {
							treesitter = { "lsp" },

							components = {
								kind_icon = {
									text = function(ctx)
										local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
										return kind_icon
									end,
									-- (optional) use highlights from mini.icons
									highlight = function(ctx)
										local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
										return hl
									end,
								},
								kind = {
									-- (optional) use highlights from mini.icons
									highlight = function(ctx)
										local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
										return hl
									end,
								},
							},
						},
					},

					documentation = {
						auto_show = true,
						auto_show_delay_ms = 200,
						window = { border = "rounded" },
					},

					ghost_text = {
						enabled = true,
					},
				},

				signature = {
					enabled = true,
				},

				keymap = {
					preset = "default",
					["<Down>"] = { "select_next", "fallback" },
					["<C-d>"] = { "select_next", "fallback" },

					["<Up>"] = { "select_prev", "fallback" },
					["<C-u>"] = { "select_prev", "fallback" },

					["<CR>"] = { "accept", "fallback" },
					["<C-e>"] = { "accept", "fallback" },
				},

				sources = {
					default = function()
						local sourceList = {
							"lsp",
							"path",
							"snippets",
							"buffer",
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
			})
		end,
	},
}
