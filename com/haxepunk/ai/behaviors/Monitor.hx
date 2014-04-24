package com.haxepunk.ai.behaviors;

class Monitor extends Parallel
{

	public function new()
	{
		super(RequireOne, RequireOne);
	}

	public function addCondition(condition:Behavior)
	{
		children.insert(0, condition);
	}

	public function addAction(action:Behavior)
	{
		children.push(action);
	}

}
