return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
		},
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- JSON schemas for package.json, tsconfig.json, eslintrc, etc.
		"b0o/SchemaStore.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		require("fidget").setup({})
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		-- Server configuration uses the `vim.lsp.config` API (Neovim 0.11+).
		-- mason-lspconfig v2 dropped the `handlers` table it used to take, and
		-- ignores it silently, so per-server settings must live here instead.
		-- Anything not listed below just uses nvim-lspconfig's own defaults.

		-- Applies to every server.
		vim.lsp.config("*", { capabilities = capabilities })

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim", "it", "describe", "before_each", "after_each" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})

		vim.lsp.config("pyright", {
			settings = {
				python = {
					-- tell pyright where pyenv virtualenvs live so it resolves names from .python-version
					venvPath = vim.fn.expand("~/.pyenv/versions"),
					analysis = {
						typeCheckingMode = "basic",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
						-- ruff handles diagnostics; suppress duplicate pyright warnings
						ignore = { "*" },
					},
				},
			},
		})

		-- ruff: fast lint + import-sort diagnostics; pyright owns hover/types
		vim.lsp.config("ruff", {
			on_attach = function(client)
				client.server_capabilities.hoverProvider = false
			end,
		})

		-- Tailwind v4 is configured in CSS (`@theme`, `@apply`, `@utility`), which
		-- the vscode-css-language-server does not know about and reports as
		-- "Unknown at rule". Tailwind's own docs recommend silencing that check.
		vim.lsp.config("cssls", {
			settings = {
				css = { lint = { unknownAtRules = "ignore" } },
				scss = { lint = { unknownAtRules = "ignore" } },
				less = { lint = { unknownAtRules = "ignore" } },
			},
		})

		-- jsonls gains package.json / tsconfig.json validation from SchemaStore.
		vim.lsp.config("jsonls", {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})

		-- ts_ls and emmet_ls previously carried custom settings here; upstream
		-- defaults now cover both (monorepo/deno-aware root detection, and the
		-- full jsx/css filetype list respectively), so they are left alone.

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				-- "denols",
				"ts_ls",
				"eslint",
				"tailwindcss",
				"html",
				"cssls",
				"jsonls",
				"emmet_ls",
				"pyright",
				"ruff",
			},
			-- nvim-jdtls manages jdtls; prevent a second client being started
			automatic_enable = { exclude = { "jdtls" } },
		})
		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettierd",
				"prettier",
				"stylua",
				"isort",
				"black",
				"pylint",
				"google-java-format",
				"java-debug-adapter",
				"java-test",
				"ruff",
				"debugpy",
				"mypy",
			},
		})
		-- require("lint").linters.pylint.cmd = "python"
		-- require("lint").linters.pylint.args = { "-m", "pylint", "-f", "json" }
		require("luasnip.loaders.from_vscode").lazy_load()

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif require("luasnip").expand_or_jumpable() then
						require("luasnip").expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif require("luasnip").jumpable(-1) then
						require("luasnip").jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
				{ name = "neorg" },
			}, {
				{ name = "buffer" },
				{ name = "path" },
			}),
			formatting = {
				fields = { "abbr", "kind", "menu" },
				expandable_indicator = true,
				format = require("lspkind").cmp_format({
					mode = "symbol", -- show only symbol annotations
					maxwidth = 50,
					ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
					-- show_labelDetails = true, -- show labelDetails in menu. Disabled by default
				}),
			},
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
