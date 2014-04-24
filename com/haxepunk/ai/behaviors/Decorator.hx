package com.haxepunk.ai.behaviors;

class Decorator extends Behavior
{

	public function new(child:Behavior)
	{
		this.child = child;
	}

	private var child:Behavior;

}