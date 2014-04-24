package com.haxepunk.ai.behaviors;

class Sequence extends Composite
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

			// if the child fails, or keeps running, do the same.
			if (status != Success)
			{
				return status;
			}
		}
		return Success;
	}

	private var _current:Iterator<Behavior>;

}
