local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet

-- keymaps
vim.keymap.set({"i", "s"}, "<C-k>", "<Plug>luasnip-expand-or-jump", { noremap = true })
vim.keymap.set({"i", "s"}, "<C-j>", "<Plug>luasnip-jump-prev", { noremap = true })
vim.keymap.set({"i", "s"}, "<C-l>", "<Plug>luasnip-next-choice", { noremap = true })
vim.keymap.set("n", "<leader><leader>s", function()
	ls.cleanup()
	vim.cmd("source ~/.config/nvim/after/plugin/luasnip.lua")
	print("snippets reloaded.")
end, { noremap = true })


local same = function(index)
	return f(function (arg)
		return arg[1]
	end, { index })
end

ls.add_snippets("lua", {
	-- print
	s("pt", {
		t("print(\""),
		i(1, "Hello World!"),
		t("\")"), i(0)
	}),
	-- local function
	parse("lf", "local $1 = function($2)\n\t$3\nend$0", {}),
	-- require
	s("req", fmt("local {} = require('{}')", { i(1), rep(1) })),
	parse("rq", "require('$1')$0", {}),
	-- function
	s("fn", fmt(
		[[
		function {}({})
			{}
		end
		]],
    { i(1), i(2), i(3) }
	), i(0)),
})

ls.add_snippets("html", {
	s("<!DOCTYPE>", {
		t({"<!DOCTYPE html>", "<html lang=\"en\">", "\t<head>", "\t\t<title>"}),
		i(1, "title"),
  		t("</title>"), i(2),
		t({"", "\t</head>", "\t<body>", "\t\t<h1>"}),
		i(3, "Header"),
		t("</h1>"), i(4),
		t({"", "\t</body>", "</html>"}), i(0)
	}),
})

ls.add_snippets("java", {
	s("gfn", fmt(
			[[
				{}static void get_{} () {{
					return this.{};
				}}
			]],
			{ c(1, {t "", t "public ", t "private "}), i(2), rep(2) }
		)),
	s("fn", fmt(
			[[
				{}static {} {} ({}) {{
					{}
					return ({});
				}}
			]],
			{
				c(1, {t "", t "public ", t "private "}),
				i(2, "type"),
				i(3, "\"name\""),
				i(4), i(5),
				rep(2)
			}
		))
})

