return {
	"folke/trouble.nvim",
	opts = {},
	cmd = "Trouble",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>xL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
	config = function()
		-- vim.keymap.set("n", "<leader>tt", function()
		-- 	require("trouble").toggle()
		-- end)
		require("trouble").setup({})

		vim.keymap.set("n", "]t", function()
			require("trouble").next({ skip_groups = true, jump = true })
		end, { desc = "Next trouble" })

		vim.keymap.set("n", "[t", function()
			require("trouble").previous({ skip_groups = true, jump = true })
		end, { desc = "Previous trouble" })
	end,
}
