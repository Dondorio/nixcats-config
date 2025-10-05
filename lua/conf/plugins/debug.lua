return {
	{
		"nvim-dap",
		for_cat = {
			cat = "debug",
			default = true,
		},
		on_require = { "dap" },
		cmd = {
			"DapNew",
		},
		keys = {
			{ "<F5>", desc = "Debug: Start/Continue" },
			{ "<F1>", desc = "Debug: Step Into" },
			{ "<F2>", desc = "Debug: Step Over" },
			{ "<F3>", desc = "Debug: Step Out" },
			{ "<leader>b", desc = "Debug: Toggle Breakpoint" },
			{ "<leader>B", desc = "Debug: Set Breakpoint" },
			{ "<F7>", desc = "Debug: See last session result." },
		},
		load = function(name)
			require("lzextras").loaders.multi({
				name,
				"nvim-dap-ui",
				"nvim-dap-virtual-text",
			})
		end,

		after = function()
			local dap = require("dap")
			local dapui = require("dapui")

			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "gb", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "gB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Set Breakpoint" })

			vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

			vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticSignError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DiagnosticSignInfo" })
			vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapLogPoint", { text = ">>", texthl = "DiagnosticSignInfo" })
			vim.fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine" })

			dap.adapters.codelldb = {
				type = "executable",
				command = "codelldb",
			}

			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp

			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			-- dapui.setup({
			-- 	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			-- 	controls = {
			-- 		icons = {
			-- 			pause = "⏸",
			-- 			play = "▶",
			-- 			step_into = "⏎",
			-- 			step_over = "⏭",
			-- 			step_out = "⏮",
			-- 			step_back = "b",
			-- 			run_last = "▶▶",
			-- 			terminate = "⏹",
			-- 			disconnect = "⏏",
			-- 		},
			-- 	},
			-- })

			dapui.setup()

			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				clear_on_continue = false,

				display_callback = function(variable, _buf, _stackframe, _node, options)
					if options.virt_text_pos == "inline" then
						return " = " .. variable.value
					else
						return variable.name .. " = " .. variable.value
					end
				end,
				virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

				all_frames = false,
				virt_lines = true,
				virt_text_win_col = nil,
			})
		end,
	},
}
