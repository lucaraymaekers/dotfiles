local dap = require('dap')

dap.adapters.coreclr = {
  type = 'executable',
  command = 'netcoredbg',
  args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}

local function nnoremap(rhs, lhs, bufopts, desc)
  bufopts.desc = desc
  vim.keymap.set("n", rhs, lhs, bufopts)
end
local bufopts = { noremap=true, silent=true }


nnoremap('<F5>' , dap.continue, bufopts, "Continue")
nnoremap('<F10>' , dap.step_over, bufopts, "Step over")
nnoremap('<F11>' , dap.step_into, bufopts, "Step into")
nnoremap('<F12>' , dap.step_out, bufopts, "Step out")
nnoremap('<Leader>b' , dap.toggle_breakpoint, bufopts, "Toggle breakpoint")

nnoremap('<Leader>B' , function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
	end, bufopts, "Set breakpoint")
nnoremap('<Leader>lp' , function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
	end, bufopts, "set breakpoint with log point message")

nnoremap('<Leader>dr' , dap.repl.open, bufopts, "Reply open")
nnoremap('<Leader>dl' , dap.run_last, bufopts, "Run las")
