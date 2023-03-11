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
vim.keymap.set({"i", "s"}, "<C-h>", "<Plug>luasnip-next-choice", { noremap = true })
vim.keymap.set("n", "<leader><leader>s", function()
	ls.cleanup()
	vim.cmd("source ~/.config/nvim/after/plugin/luasnip.lua")
	print("snippets reloaded.")
end, { noremap = true })

ls.add_snippets("lua", {
	-- print
	s("pt", fmt([[print("{}")]], { i(1, "Hello World!") })),
	-- local function
	parse("lf", "local $1 = function($2)\n\t$3\nend$0", {}),
	-- require
	s("lrq", fmt("local {} = require('{}')", { i(1), rep(1) })),
	parse("rq", "require('$1')$0", {}),
	parse("rqs", "require('$1').setup {\n\t$2\n}$0", {}),
	parse("use", "use('$1')$0", {}),
	-- function
	s("fn", fmt(
		[[
		function {}({})
			{}
		end{}
		]],
    { i(1), i(2), i(3), i(0) })),
	parse("sn", "s(\"$1\", fmt(\n[[\n$2\n]],\n{ $3 })),$0", {}),
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
	-- function
	s("fn", fmt(
	[[
	{}{} {} ({}) {{
		{}
	}}
	]],
	{
		c(1, {t "public ", t "private ", t ""}),
		i(2, "type"),
		i(3, "f"),
		i(4), i(0)
	})),
	-- constructor
	s("cst", fmt(
	[[
	public {} ({}) {{
		{}
	}}{}
	]],
	{ i(1), i(2), i(3), i(0) })),
	-- setter function
	s("sfn", fmt(
	[[
	{}void set_{} ({} {}) {{
		this.{} = {};
	}}{}
	]],
	{ c(1, {t "public ", t "private ", t ""}),
	i(2), i(3), rep(2), rep(2), rep(2), i(0) })),
	-- getter function
	s("gfn", fmt(
	[[
	{}{} get_{} () {{
		return this.{};
	}}{}
	]],
	{ c(1, {t "public ", t "private ", t ""}), i(2, "type"), i(3), rep(3), i(0)})),
	s("psv", fmt(
	[[
	public class Main {{
		public static void main (String[] args) {{
			{}
		}}
	}}
	]],
	{ i(0) })),
	-- System.out.print
	s("sout", fmt(
	[[
	System.out.{}({});{}
	]],
	{ c(1, {t "println", t "print", t "printf"}), i(2), i(0)})),
	-- constructor
	s("class", fmt(
	[[
	{}class {} {{
		{}
	}}
	]],
	{ c(1, {t "public ", t "private ", t ""}), i(2), i(0)})),
	-- print variable
	s("pti", fmt(
	[[
	System.out.println("{} :" + {});{}
	]],
	{ i(1), rep(1), i(0) })),
	-- quick
	s("pr", t "private "),
	s("ob", fmt(
	[[
	{} {} = new {}({});
	{}
	]],
	{ i(1), i(2), rep(1), i(3), i(0) })),
})

ls.add_snippets("sh", {
	parse("fn", "function $1 {\n\t$2\n}$0", {})
})
