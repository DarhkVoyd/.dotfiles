-- Map Leader
vim.g.mapleader = " "

-- General Keymaps
vim.keymap.set("n", "<leader><leader>", vim.cmd.Ex, { desc = "Open file explorer" })

-- Editor Keymaps

-- Normal Mode
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })
vim.keymap.set("n", "<C-i>", "<C-o>", { noremap = true, silent = true, desc = "Go to previous location" })
vim.keymap.set("n", "<C-o>", "<C-i>", { noremap = true, silent = true, desc = "Go to next location" })

-- Visual Mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Insert Mode
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Use Ctrl+C to escape insert mode" })

-- Remaps for Better Pasting, Yanking, and Deleting
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without overwriting register" })

-- Miscellaneous Keymaps
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Open tmux sessionizer" })

-- Navigation Keymaps
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Go to next quickfix item and center" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Go to previous quickfix item and center" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Go to next location list item and center" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Go to previous location list item and center" })

-- Search and Replace Keymaps
vim.keymap.set(
	"n",
	"<leader>r",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Search and replace word under cursor" }
)

-- File Permissions Keymaps
vim.keymap.set("n", "<leader>ch", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
vim.keymap.set("n", "<leader>uch", "<cmd>!chmod -x %<CR>", { silent = true, desc = "Make file non-executable" })

-- Source Vimrc Keymaps
vim.keymap.set("n", "<leader>vc", "<cmd>e ~/.config/nvim/lua/vimrc/<CR>", { desc = "Open vimrc file" })
vim.keymap.set("n", "<leader>vs", function()
	vim.cmd("so")
end, { desc = "Source vimrc" })

-- Window Management Keymaps
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Tab Management Keymaps
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
