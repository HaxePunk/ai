package com.haxepunk.ai.behaviors;

/**
 * An action specifies a function to be called when updating
 */
class Action extends Behavior
{

	/**
	 * Action constructor
	 * @param action the callback method when this behavior runs
	 */
	public function new(action:String)
	{
		super();
		this.action = action;
	}

	override public function update(context:Dynamic):BehaviorStatus
	{
		var f = Reflect.field(context, action);
		if (Reflect.isFunction(f))
		{
			var result = Reflect.callMethod(context, f, []);
			if (Std.is(result, BehaviorStatus))
			{
				return result;
			}
		}
		return Failure;
	}

	private var action:String;

}
