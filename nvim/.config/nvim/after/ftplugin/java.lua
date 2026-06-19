local jdtls = require("jdtls")
local mason_path = vim.fn.stdpath("data") .. "/mason"
local jdtls_path = mason_path .. "/packages/jdtls"

-- jdtls 1.30+ requires Java 21 to run (separate from your project's JDK)
local java_21 = vim.fn.glob(vim.fn.expand("~/.sdkman/candidates/java/21*/bin/java"))
if java_21 == "" then
	vim.notify(
		"jdtls requires Java 21+. Run: sdk install java 21-amzn",
		vim.log.levels.ERROR,
		{ title = "nvim-jdtls" }
	)
	return
end

local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local lombok = jdtls_path .. "/lombok.jar"

local arch = vim.fn.system("uname -m"):gsub("%s+", "")
local os_config = jdtls_path .. "/config_mac" .. (arch == "arm64" and "_arm" or "")

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspaces/" .. project_name

-- DAP bundles: java-debug-adapter + java-test (install via mason)
local bundles = {}
local debug_jar = vim.fn.glob(
	mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
)
if debug_jar ~= "" then
	table.insert(bundles, debug_jar)
end
local test_jars = vim.fn.glob(mason_path .. "/packages/java-test/extension/server/*.jar", true, true)
vim.list_extend(bundles, test_jars)

local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
if ok then
	capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
end

local config = {
	cmd = {
		java_21,
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.level=ALL",
		"-noverify",
		"-Xmx2G",
		"--add-modules=ALL-SYSTEM",
		"--add-opens", "java.base/java.util=ALL-UNNAMED",
		"--add-opens", "java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. lombok,
		"-jar", launcher,
		"-configuration", os_config,
		"-data", workspace_dir,
	},

	root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }),

	settings = {
		java = {
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			configuration = { updateBuildConfiguration = "interactive" },
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			references = { includeDecompiledSources = true },
			-- Disable jdtls built-in format; we use google-java-format via conform
			format = { enabled = false },
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.Assume.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.junit.jupiter.api.Assumptions.*",
					"org.mockito.Mockito.*",
					"org.mockito.ArgumentMatchers.*",
				},
				importOrder = { "java", "javax", "com", "org" },
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				useBlocks = true,
			},
		},
	},

	init_options = { bundles = bundles },
	capabilities = capabilities,

	on_attach = function(_, bufnr)
		jdtls.setup_dap({ hotcodereplace = "auto" })
		jdtls.setup.add_commands()

		local opts = function(desc)
			return { buffer = bufnr, silent = true, desc = desc }
		end

		-- Refactoring
		vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts("Java: Organize imports"))
		vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts("Java: Extract variable"))
		vim.keymap.set("v", "<leader>jv", function() jdtls.extract_variable(true) end, opts("Java: Extract variable"))
		vim.keymap.set("n", "<leader>jm", jdtls.extract_method, opts("Java: Extract method"))
		vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end, opts("Java: Extract method"))
		vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts("Java: Extract constant"))
		vim.keymap.set("n", "<leader>ju", jdtls.update_project_config, opts("Java: Update project config"))

		-- Tests (requires java-test bundle)
		vim.keymap.set("n", "<leader>jt", jdtls.test_class, opts("Java: Test class"))
		vim.keymap.set("n", "<leader>jT", jdtls.test_nearest_method, opts("Java: Test nearest method"))

		-- DAP
		local dap = require("dap")
		vim.keymap.set("n", "<F5>", dap.continue, opts("DAP: Continue"))
		vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, opts("DAP: Toggle breakpoint"))
		vim.keymap.set("n", "<F10>", dap.step_over, opts("DAP: Step over"))
		vim.keymap.set("n", "<F11>", dap.step_into, opts("DAP: Step into"))
		vim.keymap.set("n", "<F12>", dap.step_out, opts("DAP: Step out"))
		vim.keymap.set("n", "<leader>jdu", function() require("dapui").toggle() end, opts("DAP: Toggle UI"))
	end,
}

jdtls.start_or_attach(config)
