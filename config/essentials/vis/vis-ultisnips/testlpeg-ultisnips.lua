local lpeg = require("lpeg")

--------------------------------------------------------------------------------

local tsep = lpeg.S(" ")
local tws = tsep ^ 1
local tnewline = lpeg.S("\n")
local tlowcasedword = lpeg.R("az") ^ 1
local tdigit = lpeg.locale()["digit"]
-- local talphanum          = lpeg.locale()['alnum']
local tanyprintable = lpeg.locale()["print"]
local tcontrol = lpeg.locale()["cntrl"]
local function quoted(p)
	return lpeg.S('"') * p * lpeg.S('"')
end
local function anythingbut(ch)
	return (tanyprintable + tcontrol) - lpeg.S(ch)
end

local ttabtriggercomplex = quoted(tlowcasedword * lpeg.S("()[]?0123456789-") ^ 1)
-- TODO This is just retarded
local ttabtriggerweird = lpeg.S("!") * (lpeg.R("az") + lpeg.S("?()")) ^ 1 * lpeg.S("!")
local ttabtriggerweird2 = lpeg.P("#!")
local ttabtrigger = ttabtriggercomplex + ttabtriggerweird + ttabtriggerweird2 + tlowcasedword
local tdescription = quoted(lpeg.Cg((tanyprintable - lpeg.S('"')) ^ 1, "description"))
local toption = lpeg.R("az")

local tstartsnippet = lpeg.P("snippet")
	* tws
	* lpeg.Cg(ttabtrigger, "tabtrigger")
	* tws
	* tdescription
	* tws ^ 0
	* lpeg.Cg(toption ^ 0, "options")
local tendsnippet = lpeg.P("endsnippet")

-- The content parsing needs cleanup, its really convoluted due to me learning
-- lpeg while using it
--tcontent      = ((tanyprintable + tcontrol)^1 - tendsnippet) * tnewline
local tcontent = ((lpeg.S(" \t") + tanyprintable) ^ 1 - tendsnippet) * tnewline
local tsnippet = tstartsnippet * tnewline * ((tendsnippet * tnewline) + lpeg.Cg(tcontent ^ 1, "content"))

local tcomment = lpeg.S("#") * tanyprintable ^ 0 * tnewline
local tpriority = lpeg.P("priority") * tws * lpeg.Cg(lpeg.S("-") ^ 0 * tdigit ^ 1, "priority")

-- TODO doesn't work
local tsnippetsfile = (lpeg.Ct(tsnippet) + tpriority + tcomment + tnewline) ^ 1

-- TODO does parse values correctly, but parsing out nested tags will
--      require recursion at the callsite since I have no clue how to do it
local ttag = {
	"T",
	Expr = lpeg.C((lpeg.V("T") + anythingbut("}")) ^ 1),
	Tnum = lpeg.Cg(tdigit ^ 1, "tagnum"),
	Ps = lpeg.Cg(lpeg.Cp(), "selstart"),
	Pe = lpeg.Cg(lpeg.Cp(), "selend"),
	Tc = lpeg.V("Ps")
		* lpeg.P("${")
		* lpeg.V("Tnum")
		* lpeg.S(":")
		* lpeg.Cg(lpeg.V("Expr"), "expr")
		* lpeg.V("Pe")
		* lpeg.S("}"),
	Ts = lpeg.V("Ps") * lpeg.S("$") * lpeg.V("Pe") * lpeg.V("Tnum"),
	T = lpeg.V("Tc") + lpeg.V("Ts"),
}

--------------------------------------------------------------------------------

-- local testheader = [[
-- snippet #! "#!/usr/bin/env lua" b
-- ]]

local testcontent = [[
for ${1:idx},${2:val} in ipairs(${3:table_name}) do
	$0
end
]]

local testsnippet = [[
snippet fori "ipair for foop" b
for ${1:idx},${2:val} in ipairs(${3:table_name}) do
	$0
end
endsnippet
]]

local luasnippetfile = [[
priority -50

#################################
# Snippets for the Lua language #
#################################
snippet #! "#!/usr/bin/env lua" b
#!/usr/bin/env lua
$0
endsnippet

snippet !fun(ction)?! "New function" br
local function ${1:new_function}(${2:args})
	$0
end
endsnippet

snippet forp "pair for loop" b
for ${1:name},${2:val} in pairs(${3:table_name}) do
	$0
end
endsnippet

snippet fori "ipair for foop" b
for ${1:idx},${2:val} in ipairs(${3:table_name}) do
	$0
end
endsnippet

snippet for "numeric for loop" b
for ${1:i}=${2:first},${3:last}${4/^..*/(?0:,:)/}${4:step} do
	$0
end
endsnippet

snippet do "do block"
do
	$0
end
endsnippet

snippet repeat "repeat loop" b
repeat
	$1
until $0
endsnippet

snippet while "while loop" b
while $1 do
	$0
end
endsnippet

snippet if "if statement" b
if $1 then
	$0
end
endsnippet

snippet ife "if/else statement" b
if $1 then
	$2
else
	$0
end
endsnippet

snippet eif "if/elseif statement" b
if $1 then
	$2
elseif $3 then
	$0
end
endsnippet

snippet eife "if/elseif/else statement" b
if $1 then
	$2
elseif $3 then
	$4
else
	$0
end
endsnippet

snippet pcall "pcall statement" b
local ok, err = pcall(${1:your_function})
if not ok then
	handler(${2:ok, err})
${3:else
	success(${4:ok, err})
}end
endsnippet

snippet local "local x = 1"
local ${1:x} = ${0:1}
endsnippet

# vim:ft=snippets:
]]

--------------------------------------------------------------------------------
-- Test

local function print_table(tableau, tabwidth)
	if tabwidth == nil then
		tabwidth = 0
	end

	-- Iterate
	for k, v in pairs(tableau) do
		local tabs = ("\t"):rep(tabwidth)

		print(tabs .. k .. ': "' .. tostring(v) .. '"')
		if type(v) == "table" then
			print_table(v, tabwidth + 1)
		end
	end
end

do
	print("------------ snippet test ------------------------------------")
	local p = lpeg.Ct(tsnippet)
	local t = p:match(testsnippet)
	print_table(t)
	print("--------------------------------------------------------------")
end

do
	print("------------ snippetfile test ------------------------------------")
	local p = lpeg.Ct(tsnippetsfile)
	local t = p:match(luasnippetfile)
	print_table(t)
	print("--------------------------------------------------------------")
end

do
	print("------------ tags test -------------------------------------")
	local p = lpeg.Ct((lpeg.Ct(ttag) + tanyprintable + tcontrol) ^ 1)
	local t = p:match(testcontent)
	print_table(t)
	print("--------------------------------------------------------------")
end
