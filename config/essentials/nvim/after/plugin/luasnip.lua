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

ls.add_snippets("lua", {
	-- print
	s("pt", fmt("print({}){}", { i(1, "\"Hello World!\"") , i(0) })),
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
	s("<!DOCTYPE>", fmt(
	[[
	<!DOCTYPE html>
	<html lang="en">
		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width-device-width, initial-scale=1.0">
			<meta http-equiv="X-UA-Compatible" content="ie=edge">
			<title>{}</title>{}
		</head>
		<body>
			<h1>{}</h1>{}
		</body>
	</html>
	]],
	{i(1, "title"), i(2), i(3, "Header"), i(0)})),
	s("sty", fmt(
	[[
	<link rel="stylesheet" type="text/css" href="{}">{}
	]],
	{ i(1), i(0) })),
})

ls.add_snippets("java", {
	-- function
	s("fn", fmt(
	[[
	{}{} {}({})
	{{
		{}
	}}
	]],
	{
		c(1, {t "public ", t "private ", t ""}),
		i(2, "type"),
		i(3, "f"),
		i(4), i(0)
	})),
	-- setter function
	s("psv", fmt(
	[[
	public class Main
	{{
		public static void main (String[] args)
		{{
			{}
		}}
	}}
	]],
	{ i(0) })),
	-- constructor
	s("class", fmt(
	[[
	{}class {}
	{{
		{}
	}}{}
	]],
	{ c(1, {t "public ", t "private ", t ""}), i(2), i(3), i(0)})),
	-- StringBuilder
	s("sb", fmt(
	[[
	public void print()
	{{
		StringBuilder sb = new StringBuilder(30);
		sb.append({});
		sb.append(", ").append({});{}
		System.out.print(sb.toString());
	}}{}
	]],
	{ i(1), i(2), i(3), i(0)})),
	-- print
	parse("pt", "System.out.println($1);$0", {}),
	parse("pti", "System.out.println(\"$1: \" + $1);$0", {}),
	-- quickies 
	s("pr", t "private "),
	s("ob", fmt(
	[[
	{} {} = new {}({});
	{}
	]],
	{ i(1), i(2), rep(1), i(3), i(0) })),
	parse("abs", "Math.abs($1);$0", {}),
})

ls.add_snippets("sh", {
	s("TD", t "THISDIR=\"$(dirname \"$(readlink -f \"$0\")\")\""),
	parse("pf", ">&2 printf '$1\\n'$0", {}),
	parse("fn", "$1 ()\n{\n\t$2\n}$0", {}),
	-- Functions
	parse("rchar",
	[[
	read_char ()
	{
		old_stty_cfg=$(stty -g)
		stty raw -echo 
		dd ibs=1 count=1 2> /dev/null
		stty \$old_stty_cfg
	}
	]], {}),
	parse("fdie",
	[[
	die () { >&2 printf '%s\n' "\$@"; exit 1; }
	]], {}),
	parse("flogn",
	[[
	logn () { >&2 printf '%s\n' "\$@"; }
	]], {}),
	parse("flog",
	[[
	log () { >&2 printf '%s' "\$@"; }
	]], {}),
	s("inp", fmt(
	[[
	test -z "${{{}:=$1}}" && 
		{}="$(cat /dev/stdin)"
	echo "{}: ${}" 1>&2{}
	]],
	{ i(1), rep(1), rep(1), rep(1), i(0) })),
})

ls.add_snippets("javascript", {
	-- print
	s("pt", fmt("console.log({});{}", { i(1, "\"Hello World!\"") , i(0) })),
	s("rq", fmt("const {} = require('{}');", { i(1), rep(1) })),
	s("dbconn", fmt(
	[[
		let conn = null;
		try {{
			conn = await dbConnect();{}
			conn.end()
		}} catch(err) {{
			console.error('Error:', err);
		}}
	]],
	{ i(0) })),
	s("apr", fmt(
	[[
	app.get('{}', (req, res) => {{
		{}
	}});{}
	]],
	{ i(1), i(2, "res.send(\"Hello world!\")"), i(0) })),
	s("cerr", t "console.error('Error:', err);"),
	s("gel", fmt(
	[[
	let {} = document.getElementById('{}');{}
	]],
	{ i(1), rep(1), i(0) })),
})

ls.add_snippets("cs", {
	parse("cw", "Console.WriteLine($1);$0"),
})

ls.add_snippets("telekasten", {
	--link
	s("ln", fmt(
	[[
	[{}]({}){}
	]],
	{
		i(1),
		f(function ()
			return vim.fn.getreg('+')
		end),
		i(0)
	}
	)),
})
