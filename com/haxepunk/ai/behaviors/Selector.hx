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
			_currentBehavior = _current.next();
			var status = _currentBehavior.tick();

			if (status != Failure)
			{
				return status;
			}
		}
		return Failure;
	}

	private var _current:Iterator<Behavior>;
	private var _currentBehavior:Behavior;

}
