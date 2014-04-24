package com.haxepunk.ai.behaviors;

class Decorator extends Behavior
{

	public function new(child:Behavior)
	{
		super();
		this.child = child;
	}

	private var child:Behavior;

}