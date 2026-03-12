local list_select = function(num)
	return {
		"<C-" .. num .. ">",
		function()
			require("harpoon"):list():select(num)
		end,
		desc = "Select harpoon: " .. num,
	}
end

return {
	{
		"harpoon2",
		for_cat = {
			cat = "general",
			default = true,
		},
    --stylua: ignore
    keys = {
      { "<leader>a",  function()
        require("harpoon"):list():add()
      end,  desc = "Add file to harpoon" },
      { "<leader>h",  function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,  desc = "Open harpoon" },

      list_select(1),
      list_select(2),
      list_select(3),
      list_select(4),
      list_select(5),
      list_select(6),

      -- Toggle previous & next buffers stored within Harpoon list
      { "<C-S-P>",  function()
        require("harpoon"):list():prev()
      end,  desc = "Haproon previous" },
      { "<C-S-N>",  function()
        require("harpoon"):list():next()
      end,  desc = "Haproon next" },
    },
		after = function()
			local harpoon = require("harpoon")

			harpoon:setup()
		end,
	},
}
