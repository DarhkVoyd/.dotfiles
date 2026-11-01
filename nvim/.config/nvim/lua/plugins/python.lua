return {
	-- Python DAP adapter (uses debugpy)
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(debugpy)
		end,
	},

	-- Virtual env selector: picks up .venv, virtualenv, conda, pyenv, poetry, pdm, uv
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		ft = "python",
		-- The `regexp` branch was merged back into `main`; on `main` the options
		-- sit at the top level of `opts` rather than nested under `settings`.
		opts = {
			options = {
				notify_user_on_venv_activation = true,
				enable_cached_venvs = true,
				-- auto-activate last used venv when re-entering a project
				cached_venv_automatic_activation = true,
			},
			search = {
				-- search pyenv virtualenvs in addition to local .venv dirs
				pyenv = {
					command = "fd python$ " .. vim.fn.expand("~/.pyenv/versions") .. " --full-path -L",
					type = "python",
				},
			},
		},
		keys = {
			{ "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Python: Select venv", ft = "python" },
		},
	},
}
