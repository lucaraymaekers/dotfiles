 function ColorMyPencils(color)
	if color == "nord" then
		vim.cmd.colorscheme(color)
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.cmd.highlight("SignColumn guibg=none")
		vim.g.nord_uniform_diff_background = true
		vim.g.nord_contrast = true
		vim.g.nord_borders = true
		local highlights = require("nord").bufferline.highlights({
			italic = true,
			bold = true,
		})
	elseif color == "pywal" then
		local pywal16 = require('pywal16')
		pywal16.setup()
	else
		vim.cmd("colorscheme " .. color)
	end
end
ColorMyPencils("nord")
