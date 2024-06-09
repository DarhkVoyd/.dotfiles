return {
	"nvim-telescope/telescope.nvim",

	tag = "0.1.5",

	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},

	config = function()
		local telescope = require("telescope")
		local telescopeConfig = require("telescope.config")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
		table.insert(vimgrep_arguments, "--hidden")
		table.insert(vimgrep_arguments, "--iglob")
		table.insert(vimgrep_arguments, "!**/.git/*")
		table.insert(vimgrep_arguments, "--iglob")
		table.insert(vimgrep_arguments, "!**/node_modules/*")
		table.insert(vimgrep_arguments, "--iglob")
		table.insert(vimgrep_arguments, "!**/.next/*")
		table.insert(vimgrep_arguments, "--iglob")
		table.insert(vimgrep_arguments, "!**/venv/*")
		table.insert(vimgrep_arguments, "--iglob")
		table.insert(vimgrep_arguments, "!**/__pycache__/*")
		telescope.setup({
			defaults = {
				vimgrep_arguments = vimgrep_arguments,
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		vim.keymap.set("n", "<leader>ff", function()
			builtin.find_files({
				find_command = {
					"rg",
					"--no-ignore",
					"--hidden",
					"--files",
					"--iglob",
					"!**/.git/*",
					"--iglob",
					"!**/node_modules/*",
					"--iglob",
					"!**/.next/*",
					"--iglob",
					"!**/venv/*",
					"--iglob",
					"!**/__pycache__/*",
				},
			})
		end, { desc = "Fuzzy find files in cwd" })
		vim.keymap.set("n", "<leader>fgf", builtin.git_files, { desc = "Fuzzy find files in git" })
		vim.keymap.set("n", "<leader>fws", function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end, { desc = "Find current word string in cwd (case-sensitive)" })
		vim.keymap.set("n", "<leader>fWs", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end, { desc = "Find current word string in cwd (case-insensitive)" })
		vim.keymap.set("n", "<leader>fg", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "Grep string" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Fuzzy find help tags" })
		vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
	end,
}
