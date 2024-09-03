return {
	"windwp/nvim-ts-autotag",
	event = { "BufReadPre", "BufNewFile" },
	ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	config = function()
		require("nvim-ts-autotag").setup()
	end,
}
