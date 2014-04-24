package com.haxepunk.ai.behaviors;

class ActiveSelector extends Selector
{

	override private function initialize()
	{
		// get last iterator value
		_current = children.iterator();
		while (_current.hasNext())
		{
			_currentBehavior = _current.next();
		}
	}

	override private function update():BehaviorStatus
	{
		var previousBehavior:Behavior = _currentBehavior;

		super.initialize();
		var result = super.update();

		if (_currentBehavior != previousBehavior)
		{
			previousBehavior.terminate(Aborted);
		}

		return result;
	}

}
