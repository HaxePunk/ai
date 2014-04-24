package com.haxepunk.ai.behaviors;

class Repeat extends Decorator
{

	public var count:Int = 0;

	public function new(child:Behavior, count:Int = 0)
	{
		super(child);
		this.count = count;
	}

	override private function initialize()
	{
		_counter = 0;
	}

	override private function update():BehaviorStatus
	{
		while(true)
		{
			switch (child.tick())
			{
				case Running:
					break;
				case Failure:
					return Failure;
				default:
					if (++_counter == count) return Success;
			}
			child.reset();
		}
		return Invalid;
	}

	private var _counter:Int = 0;

}