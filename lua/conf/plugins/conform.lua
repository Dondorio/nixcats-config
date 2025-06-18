return {
	"conform.nvim",
	for_cat = {
		cat = "format",
		default = true,
	},
	-- keys = {
	-- 	-- Create a key mapping and lazy-load when it is used
	-- 	{ "<leader>gf", mode = { "n", "x", "o" }, "<cmd>AutoFormatDisable<CR>", desc = "Disable auto formatting" },
	-- },
	event = { "DeferredUIEnter" },
	after = function(plugin)
		vim.b.disable_autoformat = false
		vim.g.disable_autoformat = false

		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				nix = { "alejandra" },

				rust = { "rustfmt" },
				go = { "goimports", "gofmt" },
				-- Use the "*" filetype to run formatters on all filetypes.
				["*"] = { "codespell" },
				-- Use the "_" filetype to run formatters on filetypes that don't
				-- have other formatters configured.
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
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
}
