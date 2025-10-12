return {
	"nvim-lint",
	for_cat = { cat = "general", default = true },
	after = function()
		require("lint").linters_by_ft = {
			lua = { "luacheck" },
			nix = { "statix", "deadnix" },

			c = { "clangtidy" },
			cpp = { "clangtidy" },
			go = { "golangcilint" },

			elixir = { "credo" },

			-- Web
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },

			-- Extra
			markdown = { "vale" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
