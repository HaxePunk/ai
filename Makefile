all: unit example

unit:
	cd tests && haxe compile.hxml && neko unit.n

example:
	cd examples && lime test neko -debug
