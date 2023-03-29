local home = os.getenv('HOME')
local root_markers = {'gradlew', 'mvnw', '.git'}
local root_dir = require('jdtls.setup').find_root(root_markers)
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
local jdtls = require('jdtls')

local function nnoremap(rhs, lhs, bufopts, desc)
  bufopts.desc = desc
  vim.keymap.set("n", rhs, lhs, bufopts)
end

local on_attach = function(_, bufnr)
  -- Regular Neovim LSP client keymappings
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  nnoremap('gD', vim.lsp.buf.declaration, bufopts, "Go to declaration")
  nnoremap('gd', vim.lsp.buf.definition, bufopts, "Go to definition")
  nnoremap('gi', vim.lsp.buf.implementation, bufopts, "Go to implementation")
  nnoremap('K', vim.lsp.buf.hover, bufopts, "Hover text")
  nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts, "Show signature")
  nnoremap('<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts, "Add workspace folder")
  nnoremap('<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts, "Remove workspace folder")
  nnoremap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts, "List workspace folders")
  nnoremap('<leader>D', vim.lsp.buf.type_definition, bufopts, "Go to type definition")
  nnoremap('<leader>rn', vim.lsp.buf.rename, bufopts, "Rename")
  nnoremap('<leader><Return>', vim.lsp.buf.code_action, bufopts, "Code actions")
  vim.keymap.set('v', "<leader><Return>", "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
    { noremap=true, silent=true, buffer=bufnr, desc = "Code actions" })
  nnoremap('<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts, "Format file")

  -- Java extensions provided by jdtls
  nnoremap("<leader><leader>i", jdtls.organize_imports, bufopts, "Organize imports")
  nnoremap("<leader>ev", jdtls.extract_variable, bufopts, "Extract variable")
  nnoremap("<leader>ec", jdtls.extract_constant, bufopts, "Extract constant")
  vim.keymap.set('v', "<leader>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    { noremap=true, silent=true, buffer=bufnr, desc = "Extract method" })
end

local config = {
	flags = {
		debounce_text_changes = 80,
	},
	cmd = {
		'jdtls',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-Xms4g',
		'-data', workspace_folder,
	},
	on_attach = on_attach,
	root_dir = root_dir,
}
require('jdtls').start_or_attach(config)

vim.keymap.set("n", "<LocalLeader>t", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1System.out.println(\\2);<cr>")
vim.keymap.set("i", "<LocalLeader>t", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1System.out.println(\\2);<cr><esc>A")
vim.keymap.set("n", "<LocalLeader>i", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1System.out.println(\"\\2: \" + \\2);<cr>")
vim.keymap.set("i", "<LocalLeader>i", "<cmd>s/\\(\\s*\\)\\(.*\\)/\\1System.out.println(\"\\2: \" + \\2);<cr><esc>A")
