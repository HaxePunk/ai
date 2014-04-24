package com.haxepunk.ai.behaviors;

class Selector extends Composite
{

	override private function initialize()
	{
		_current = children.iterator();
	}

	override private function update():BehaviorStatus
	{
		while (_current.hasNext())
		{
			var status = _current.next().tick();

			if (status != Failure)
			{
				return status;
			}
		}
		return Failure;
	}

	private var _current:Iterator<Behavior>;

}
