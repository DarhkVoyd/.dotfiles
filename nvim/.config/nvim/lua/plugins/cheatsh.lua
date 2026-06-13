return {
	"dbeniamine/cheat.sh-vim",
	cmd = { "Cheat", "CheatPager", "CheatReplace", "CheatPast", "CheatError", "HowIn", "CheatId" },
	init = function()
		vim.g.CheatSheetDefaultMode = 0
		vim.g.CheatSheetDefaultSelection = "line"
		vim.g.CheatSheetStayInOrigBuf = 1
		vim.g.CheatSheetBaseUrl = "https://cht.sh"
	end,
	keys = {
		{ "<leader>?", ":Cheat<CR>", mode = { "n", "v" }, desc = "cheat.sh query (buffer)" },
		{ "<leader>cS", ":CheatPager<CR>", mode = { "n", "v" }, desc = "cheat.sh query (pager)" },
	},
}
