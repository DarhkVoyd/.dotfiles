local dap = require("dap")
local dap_python = require("dap-python")

local opts = function(desc)
	return { buffer = true, silent = true, desc = desc }
end

-- Debug
vim.keymap.set("n", "<F5>", dap.continue, opts("DAP: Continue"))
vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, opts("DAP: Toggle breakpoint"))
vim.keymap.set("n", "<F10>", dap.step_over, opts("DAP: Step over"))
vim.keymap.set("n", "<F11>", dap.step_into, opts("DAP: Step into"))
vim.keymap.set("n", "<F12>", dap.step_out, opts("DAP: Step out"))
vim.keymap.set("n", "<leader>jdu", function() require("dapui").toggle() end, opts("DAP: Toggle UI"))

-- Python test runner (dap-python)
vim.keymap.set("n", "<leader>pt", dap_python.test_method, opts("Python: Debug test method"))
vim.keymap.set("n", "<leader>pT", dap_python.test_class, opts("Python: Debug test class"))
vim.keymap.set("v", "<leader>ps", dap_python.debug_selection, opts("Python: Debug selection"))
