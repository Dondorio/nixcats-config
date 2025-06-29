return {
	"mini.nvim",
	for_cat = {
		cat = "general",
		default = true,
	},
	event = { "DeferredUIEnter" },
	after = function()
		require("mini.ai").setup()
		require("mini.align").setup()
		require("mini.bracketed").setup()
		require("mini.comment").setup()
		require("mini.cursorword").setup()
		require("mini.icons").setup()
		require("mini.move").setup()
		require("mini.operators").setup()
		require("mini.pairs").setup()
		require("mini.splitjoin").setup()

		require("mini.basics").setup({
			options = {
				basic = true,
				extra_ui = true,
				win_borders = "bold",
			},

			mappings = {
				basic = true,
				option_toggle_prefix = "\\",
				windows = true,
				move_with_alt = true,
			},

			autocommands = {
				basic = true,
				relnum_in_visual_mode = false,
			},
		})

		local minihp = require("mini.hipatterns")
		minihp.setup({
			highlighters = {
				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

				hex_color = minihp.gen_highlighter.hex_color(),
			},
		})

		require("mini.surround").setup({
			mappings = {
				add = "gza",
				delete = "gzd",
				find = "gzf",
				find_left = "gzF",
				highlight = "gzh",
				replace = "gzr",
				update_n_lines = "gzn",

				suffix_last = "l",
				suffix_next = "n",
			},
		})
	end,
}
