-- base16-vis (https://github.com/pshevtsov/base16-vis)
-- by Petr Shevtsov
-- Nord scheme by arcticicestudio
local lexers = vis.lexers

local colors = {
    ['bg'] = '#2E3440',
    ['black'] = '#3B4252',
    ['light_black'] = '#434C5E',
    ['dark_gray'] = '#4C566A',
    ['gray'] = '#D8DEE9',
    ['light_gray'] = '#616E88',
    ['fg'] = '#E5E9F0',
    ['white'] = '#ECEFF4',
    ['turquoise'] = '#8FBCBB',
    ['light_cyan'] = '#88C0D0',
    ['cyan'] = '#81A1C1',
    ['blue'] = '#5E81AC',
    ['red'] = '#BF616A',
    ['orange'] = '#D08770',
    ['yellow'] = '#EBCB8B',
    ['green'] = '#A3BE8C',
    ['magenta'] = '#B48EAD'
}

lexers.colors = colors

local fg = 'fore:' .. colors.fg
local bg = 'back:' .. colors.bg

lexers.STYLE_DEFAULT = bg .. ',' .. fg
lexers.STYLE_NOTHING = bg
lexers.STYLE_CLASS = 'fore:' .. colors.blue
lexers.STYLE_COMMENT = 'fore:' .. colors.light_gray .. ',italics'
lexers.STYLE_CONSTANT = 'fore:' .. colors.cyan
lexers.STYLE_DEFINITION = 'fore:' .. colors.green
lexers.STYLE_ERROR = 'fore:' .. colors.light_cyan .. ',italics'
lexers.STYLE_FUNCTION = 'fore:' .. colors.light_cyan .. ',bold'
lexers.STYLE_HEADING = 'fore:' .. colors.bg .. ',back:' .. colors.yellow
lexers.STYLE_KEYWORD = 'fore:' .. colors.cyan .. ',bold'
lexers.STYLE_LABEL = 'fore:' .. colors.blue
lexers.STYLE_NUMBER = 'fore:' .. colors.magenta
lexers.STYLE_OPERATOR = 'fore:' .. colors.light_cyan
lexers.STYLE_REGEX = 'fore:' .. colors.orange
lexers.STYLE_STRING = 'fore:' .. colors.green
lexers.STYLE_PREPROCESSOR = 'fore:' .. colors.blue
lexers.STYLE_TAG = 'fore:' .. colors.blue
lexers.STYLE_TYPE = 'fore:' .. colors.cyan
lexers.STYLE_VARIABLE = 'fore:' .. colors.cyan .. ',bold'
lexers.STYLE_WHITESPACE = 'fore:' .. colors.light_black
lexers.STYLE_EMBEDDED = 'fore:' .. colors.magenta
lexers.STYLE_IDENTIFIER = fg .. ',bold'

lexers.STYLE_LINENUMBER = 'fore:' .. colors.light_black .. ',back:' .. colors.bg
lexers.STYLE_CURSOR = 'fore:' .. colors.bg .. ',back:' .. colors.fg
lexers.STYLE_CURSOR_PRIMARY = 'fore:' .. colors.bg .. ',back:' .. colors.fg
lexers.STYLE_CURSOR_LINE = 'back:' .. colors.black
lexers.STYLE_COLOR_COLUMN = 'back:' .. colors.black
lexers.STYLE_SELECTION = 'back:' .. colors.light_black
lexers.STYLE_STATUS = 'fore:' .. colors.gray .. ',back:' .. colors.black
lexers.STYLE_STATUS_FOCUSED = 'fore:' .. colors.cyan .. ',back:' .. colors.black
lexers.STYLE_SEPARATOR = lexers.STYLE_DEFAULT
lexers.STYLE_INFO = 'fore:default,back:default,bold'
lexers.STYLE_EOF = ''

-- lexer specific styles

-- Diff
lexers.STYLE_ADDITION = 'back:' .. colors.green .. ',fore:' .. colors.bg
lexers.STYLE_DELETION = 'back:' .. colors.red .. ',fore:' .. colors.bg
lexers.STYLE_CHANGE = 'back:' .. colors.yellow .. ',fore:' .. colors.bg

-- CSS
lexers.STYLE_PROPERTY = lexers.STYLE_ATTRIBUTE
lexers.STYLE_PSEUDOCLASS = ''
lexers.STYLE_PSEUDOELEMENT = ''

-- HTML
lexers.STYLE_TAG_UNKNOWN = lexers.STYLE_TAG .. ',italics'
lexers.STYLE_ATTRIBUTE_UNKNOWN = lexers.STYLE_ATTRIBUTE .. ',italics'

-- Latex, TeX, and Texinfo
lexers.STYLE_COMMAND = lexers.STYLE_KEYWORD
lexers.STYLE_COMMAND_SECTION = lexers.STYLE_CLASS
lexers.STYLE_ENVIRONMENT = lexers.STYLE_TYPE
lexers.STYLE_ENVIRONMENT_MATH = lexers.STYLE_NUMBER

-- Makefile
lexers.STYLE_TARGET = ''

-- Markdown
lexers.STYLE_HR = ''
lexers.STYLE_HEADING_H1 = 'fore:' .. colors.orange .. ',bold'
lexers.STYLE_HEADING_H2 = 'fore:' .. colors.red .. ',bold'
for i = 3, 6 do
    lexers['STYLE_HEADING_H' .. i] = 'fore:' .. colors.magenta .. ',bold'
end
lexers.STYLE_BOLD = 'bold'
lexers.STYLE_ITALIC = 'italics'
lexers.STYLE_LIST = lexers.STYLE_KEYWORD
lexers.STYLE_LINK = 'fore:' .. colors.yellow .. ',italics'
lexers.STYLE_REFERENCE = 'fore:' .. colors.blue
lexers.STYLE_CODE = 'back:' .. colors.black .. ',fore:' .. colors.turquoise

-- Output
lexers.STYE_FILENAME = 'bold'
lexers.STYLE_LINE = 'fore:' .. colors.green
lexers.STYLE_COLUMN = 'underline'
lexers.STYLE_MESSAGE = ''

-- Python
lexers.STYLE_KEYWORD_SOFT = ''

-- YAML
lexers.STYLE_ERROR_INDENT = 'back:' .. colors.red

-- GO
lexers.STYLE_CONSTANT_BUILTIN = 'fore:' .. colors.yellow
lexers.STYLE_FUNCTION_METHOD = 'fore:' .. colors.light_cyan
lexers.STYLE_FUNCTION_BUILTIN = 'fore:' .. colors.light_cyan .. ',bold'

-- Lua
lexers.STYLE_ATTRIBUTE = 'fore:' .. colors.yellow .. ',bold'
