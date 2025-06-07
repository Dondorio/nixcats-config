return {
	{
		"which-key.nvim",
		for_cat = "general",
		event = "DeferredUIEnter",
		after = function(plugin)
			require("which-key").setup({})
			require("which-key").add({
				{ "<leader>b", group = "[b]uffer" },
				{ "<leader>b_", hidden = true },
				{ "<leader>c", group = "[c]ode" },
				{ "<leader>c_", hidden = true },
				{ "<leader>d", group = "[d]ocument" },
				{ "<leader>d_", hidden = true },
				{ "<leader>g", group = "[g]it" },
				{ "<leader>g_", hidden = true },
				{ "<leader>m", group = "[m]arkdown" },
				{ "<leader>m_", hidden = true },
				{ "<leader>r", group = "[r]ename" },
				{ "<leader>r_", hidden = true },
				{ "<leader>s", group = "[s]earch" },
				{ "<leader>s_", hidden = true },
				{ "<leader>t", group = "[t]oggles" },
				{ "<leader>t_", hidden = true },
				{ "<leader>w", group = "[w]orkspace" },
				{ "<leader>w_", hidden = true },
				{ "<leader>l", group = "[l]sp" },
				{ "<leader>l_", hidden = true },
			})
		end,
	},
}
