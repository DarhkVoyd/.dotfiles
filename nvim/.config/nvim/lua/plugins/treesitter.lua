-- nvim-treesitter `main` branch: a full rewrite. Highlighting, folding and
-- indentation now come from Neovim itself and are opt-in per buffer; this
-- plugin only ships the parsers and queries. Lazy-loading is unsupported.

-- Parsers to have on disk up front. Everything else is installed on demand by
-- the FileType autocmd below, which replaces the old `auto_install = true`.
local ensure_installed = {
	"lua",
	"javascript",
	"typescript",
	"tsx",
	"rust",
	"java",
	"python",
	"markdown",
	"markdown_inline",
}

-- `incremental_selection` was dropped in the rewrite; this reimplements the
-- old <C-space> / <bs> node grow/shrink on top of the core treesitter API.
local selection_stack = {}

local function same_range(a, b)
	local a1, a2, a3, a4 = a:range()
	local b1, b2, b3, b4 = b:range()
	return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
end

local function select_node(node)
	local srow, scol, erow, ecol = node:range()

	-- Treesitter end positions are exclusive, so a node spanning whole lines
	-- ends at column 0 of the *following* line. Pull it back to the last real
	-- character, otherwise the visual selection collapses.
	if ecol == 0 and erow > srow then
		erow = erow - 1
		ecol = #(vim.api.nvim_buf_get_lines(0, erow, erow + 1, false)[1] or "")
	end

	if vim.fn.mode():match("[vV\22]") then
		vim.cmd("normal! \27")
	end
	vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
	vim.cmd("normal! v")
	vim.api.nvim_win_set_cursor(0, { erow + 1, math.max(ecol - 1, 0) })
end

local function node_incremental()
	local top = selection_stack[#selection_stack]
	local node

	if top then
		-- Already in a treesitter selection: walk up to the next larger node.
		node = top:parent()
		while node and same_range(node, top) do
			node = node:parent()
		end
	else
		local ok, found = pcall(vim.treesitter.get_node)
		node = ok and found or nil
	end

	if not node then
		return
	end

	table.insert(selection_stack, node)
	select_node(node)
end

local function node_decremental()
	table.remove(selection_stack)
	local node = selection_stack[#selection_stack]
	if node then
		select_node(node)
	else
		vim.cmd("normal! \27")
	end
end

-- Turn on the treesitter-backed features for a buffer whose parser is ready.
local function enable(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	-- Highlighting (provided by Neovim, see :h treesitter-highlight).
	if not pcall(vim.treesitter.start, buf) then
		return
	end

	-- Folding. `foldmethod` is already "expr" globally (editor.lua).
	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end

	-- Indentation (experimental, provided by nvim-treesitter).
	vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

	-- markdown still wants regex highlighting alongside treesitter, which is
	-- what `additional_vim_regex_highlighting` used to do.
	if vim.bo[buf].filetype == "markdown" then
		vim.bo[buf].syntax = "on"
	end
end

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	init = function()
		-- ts_context_commentstring registers itself as an nvim-treesitter
		-- module by default, a system the rewrite removed.
		vim.g.skip_ts_context_commentstring_module = true
	end,
	config = function()
		local ts = require("nvim-treesitter")
		ts.install(ensure_installed)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
				if not lang then
					return
				end

				-- Parser already available (installed, or shipped with Neovim).
				-- `language.add` returns false rather than throwing when the
				-- parser is missing, so check the value, not just the pcall.
				local ok, added = pcall(vim.treesitter.language.add, lang)
				if ok and added then
					enable(args.buf)
					return
				end

				-- Otherwise fetch it in the background, then enable. This is
				-- also what makes a fresh clone work: `install()` above is
				-- async, so the first buffers open before it finishes.
				if vim.list_contains(ts.get_available(), lang) then
					ts.install(lang):await(function()
						vim.schedule(function()
							enable(args.buf)
						end)
					end)
				end
			end,
		})

		vim.keymap.set({ "n", "x" }, "<C-space>", function()
			-- Reset the stack when starting a fresh selection from normal mode.
			if not vim.fn.mode():match("[vV\22]") then
				selection_stack = {}
			end
			node_incremental()
		end, { desc = "Treesitter: expand selection to node" })

		vim.keymap.set("x", "<bs>", node_decremental, { desc = "Treesitter: shrink selection" })
	end,
}
