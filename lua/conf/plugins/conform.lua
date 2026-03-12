return {
	"conform.nvim",
	for_cat = {
		cat = "format",
		default = true,
	},
	keys = {
		{ "\\f", mode = { "n", "x", "o" }, "<cmd>AutoFormatToggle<CR>", desc = "Disable auto formatting" },
		{
			"\\F",
			mode = { "n", "x", "o" },
			"<cmd>AutoFormatToggle!<CR>",
			desc = "Disable auto formatting in the current buffer",
		},
	},
	event = { "BufWritePre" },
	after = function()
		vim.b.disable_autoformat = false
		vim.g.disable_autoformat = false

		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				nix = { "alejandra" },

				c = { "clang-format" },
				cpp = { "clang-format" },
				go = { "golangci-lint" },
				ocaml = { "ocamlformat" },
				rust = { "rustfmt" },
				python = { "ruff" },
				zig = { "zigfmt" },
				haskell = { "ormolu" },

				-- Beam
				gleam = { "gleam" },

				-- Web
				html = { "prettierd" },

				css = { "prettierd" },
				scss = { "prettierd" },

				javascript = { "prettierd" },
				typescript = { "prettierd" },

				svelte = { "prettierd" },

				-- Extra
				bash = { "prettierd" },

				-- Document
				-- TODO markdown and toml formatters
				kdl = { "kdlfmt" },

				["_"] = { "trim_whitespace" },
			},
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
		})

		vim.api.nvim_create_user_command("AutoFormatDisable", function(args)
			if args.bang then
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("AutoFormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})

		vim.api.nvim_create_user_command("AutoFormatToggle", function(args)
			if args.bang then
				vim.b.disable_autoformat = not vim.b.disable_autoformat
			else
				vim.g.disable_autoformat = not vim.g.disable_autoformat
			end
		end, {
			desc = "Toggle autoformat-on-save",
			bang = true,
		})
	end,
}
