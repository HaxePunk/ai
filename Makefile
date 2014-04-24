all: unit

unit:
	cd tests && haxe compile.hxml && neko unit.n

example:
	cd examples && lime test flash -debug
