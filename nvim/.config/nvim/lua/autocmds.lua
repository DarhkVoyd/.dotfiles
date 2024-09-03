local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local whitespace_cleanup_group = augroup("WhitespaceCleanup", {})
local yank_highlight_group = augroup("YankHighlight", {})
local user_lsp_config_group = augroup("UserLspConfig", {})
local jsDevGroup = augroup("jsDevGroup", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

autocmd("TextYankPost", {
	group = yank_highlight_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd("BufWritePre", {
	group = whitespace_cleanup_group,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- autocmd("BufWritePre", {
-- 	group = jsDevGroup,
-- 	pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
-- 	command = "silent! EslintFixAll",
-- })

autocmd("LspAttach", {
	group = user_lsp_config_group,
	callback = function(e)
		local opts = { buffer = e.buf }

		opts.desc = "[G]oto [R]eferences"
		vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

		opts.desc = "Go to declaration"
		vim.keymap.set("n", "gD", function()
			vim.lsp.buf.declaration()
		end, opts)

		opts.desc = "[G]oto [D]efinition"
		vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

		opts.desc = "[G]oto [I]mplementation"
		vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

		opts.desc = "Show LSP type definitions"
		vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

		opts.desc = "Show documentation for what is under cursor"
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)

		opts.desc = "Searches for symbols (functions, variables, classes, etc.) across your entire workspace"
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)

		opts.desc = "Fuzzy find buffer diagnostics"
		vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

		opts.desc = "Display current diagnostics"
		vim.keymap.set("n", "<leader>d", function()
			vim.diagnostic.open_float()
		end, opts)

		opts.desc = "Go to next diagnostics"
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_next()
		end, opts)

		opts.desc = "Go to previous diagnostics"
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_prev()
		end, opts)

		opts.desc = "[C]ode [A]ction"
		vim.keymap.set({ "n", "v" }, "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, opts)

		opts.desc = "Show LSP references"
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, opts)

		opts.desc = "[R]e[n]ame"
		vim.keymap.set("n", "<leader>rn", function()
			vim.lsp.buf.rename()
		end, opts)

		opts.desc = "Show lsp signature help"
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)

		opts.desc = "Restart LSP"
		vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

		opts.desc = "Format file with LSP"
		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
	end,
})
