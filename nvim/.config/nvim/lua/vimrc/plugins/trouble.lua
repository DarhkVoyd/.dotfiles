return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "Open/close trouble list" },
			{
				"<leader>xw",
				"<cmd>TroubleToggle workspace_diagnostics<CR>",
				desc = "Open trouble workspace diagnostics",
			},
			{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Open trouble document diagnostics" },
			{ "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", desc = "Open trouble quickfix list" },
			{ "<leader>xl", "<cmd>TroubleToggle loclist<CR>", desc = "Open trouble location list" },
			{ "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "Open todos in trouble" },
		},
		config = function()
			require("trouble").setup({
				icons = false,
			})

			-- vim.keymap.set("n", "<leader>tt", function()
			-- 	require("trouble").toggle()
			-- end)

			vim.keymap.set("n", "[t", function()
				require("trouble").next({ skip_groups = true, jump = true })
			end, { desc = "Next trouble" })

			vim.keymap.set("n", "]t", function()
				require("trouble").previous({ skip_groups = true, jump = true })
			end, { desc = "Previous trouble" })
		end,
	},
}
