.PHONY: check format all

LUA_FILES := $(shell find . -name "*.lua")

all: check format

check:
	luacheck --no-color --globals=vis -- $(LUA_FILES)

format:
	lua-format -i $(LUA_FILES)
