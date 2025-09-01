return {
	"folke/zen-mode.nvim",
	config = function()
		vim.keymap.set("n", "<leader>zz", function()
			require("zen-mode").setup({
				window = {
					width = 140,
					options = {},
				},
				plugins = {
					twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
					wezterm = {
						enabled = true,
						font = "+2", -- (10% increase per step)
					},
				},
			})
			require("zen-mode").toggle()
			vim.wo.wrap = false
			vim.wo.number = true
			vim.wo.rnu = true
			SetTheme()
		end)

		vim.keymap.set("n", "<leader>zZ", function()
			require("zen-mode").setup({
				window = {
					width = 80,
					options = {},
				},
			})
			require("zen-mode").toggle()
			vim.wo.wrap = false
			vim.wo.number = false
			vim.wo.rnu = false
			vim.opt.colorcolumn = "0"
			SetTheme()
		end)
	end,
}
