package com.haxepunk.ai.behaviors;

class Composite extends Behavior
{
	public function new()
	{
		super();
		children = new Array<Behavior>();
	}

	public function addChild(child:Behavior)
	{
		children.push(child);
	}

	public function removeChild(child:Behavior)
	{
		children.remove(child);
	}

	public function clear()
	{
		#if (cpp || php)
			children.splice(0, children.length);
		#else
			untyped children.length = 0;
		#end
	}

	private var children:Array<Behavior>;
}