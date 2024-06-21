.PHONY: check 

LUA_FILES := $(shell find . -type f -name "*.lua")

check:
	luacheck --no-color --globals=vis -- $(LUA_FILES)
