return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			codeLens = {
				enable = true,
			},
			diagnostics = {
				globals = { "nixCats", "require", "vim" },
			},
			formatters = {
				ignoreComments = true,
			},
			hint = {
				enable = true,
				setType = false,
				paramType = true,
				paramName = "Disable",
				semicolon = "Disable",
				arrayIndex = "Disable",
			},
			signatureHelp = { enabled = true },
		},
		telemetry = { enabled = false },
	},
	2,
}
