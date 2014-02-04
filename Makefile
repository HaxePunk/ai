all: unit

unit:
	cd tests && haxe compile.hxml && neko unit.n