package com.haxepunk.ai.behaviors;

class Sequence extends Composite
{

	override private function initialize()
	{
		_current = children.iterator();
		_currentBehavior = _current.next();
	}

	override private function update():BehaviorStatus
	{
		while (_currentBehavior != null)
		{
			var status = _currentBehavior.tick();

			// if the child fails, or keeps running, do the same.
			if (status != Success)
			{
				return status;
			}

			if (_current.hasNext())
			{
				_currentBehavior = _current.next();
			}
			else
			{
				break;
			}
		}
		return Success;
	}

	private var _current:Iterator<Behavior>;
	private var _currentBehavior:Behavior;

}
