return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		-- `prettierd` is a long-lived daemon and much faster, but it is not always
		-- present; fall back to a plain `prettier` (conform prefers the project's
		-- own node_modules/.bin copy, which is what the ecosystem expects so the
		-- formatting matches CI).
		local prettier = { "prettierd", "prettier", stop_after_first = true }

		conform.setup({
			formatters_by_ft = {
				javascript = prettier,
				typescript = prettier,
				javascriptreact = prettier,
				typescriptreact = prettier,
				svelte = prettier,
				css = prettier,
				scss = prettier,
				less = prettier,
				html = prettier,
				json = prettier,
				jsonc = prettier,
				yaml = prettier,
				markdown = prettier,
				["markdown.mdx"] = prettier,
				graphql = prettier,
				liquid = prettier,
				lua = { "stylua" },
				python = { "ruff_format", "ruff" },
				java = { "google-java-format" },
			},
			format_on_save = function(bufnr)
				-- Apply ESLint's auto-fixes (unused imports, import order, rule
				-- fixes) *before* prettier formats, so prettier owns the final
				-- layout and eslint never re-mangles it. This mirrors VS Code's
				-- `source.fixAll.eslint` + `formatOnSave`, which is what the
				-- Next.js ecosystem assumes.
				-- `LspEslintFixAll` is buffer-local and synchronous.
				if vim.fn.exists(":LspEslintFixAll") == 2 then
					pcall(vim.cmd, "LspEslintFixAll")
				end

				return {
					-- `lsp_fallback` was renamed to `lsp_format`.
					lsp_format = "fallback",
					async = false,
					timeout_ms = 1000,
				}
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_format = "fallback",
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
