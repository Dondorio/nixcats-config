return {
	{
		"harpoon2",
		for_cat = "general",
		event = "DeferredUIEnter",
		after = function()
			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup()
			-- REQUIRED

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Add file to harpoon" })
			vim.keymap.set("n", "<leader>h", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Open harpoon" })

			vim.keymap.set("n", "<C-1>", function()
				harpoon:list():select(1)
			end, { desc = "Select harpoon: 1" })
			vim.keymap.set("n", "<C-2>", function()
				harpoon:list():select(2)
			end, { desc = "Select harpoon: 2" })
			vim.keymap.set("n", "<C-3>", function()
				harpoon:list():select(3)
			end, { desc = "Select harpoon: 3" })
			vim.keymap.set("n", "<C-4>", function()
				harpoon:list():select(4)
			end, { desc = "Select harpoon: 4" })

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end, { desc = "Haproon previous" })
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end, { desc = "Haproon next" })
		end,
	},
}
