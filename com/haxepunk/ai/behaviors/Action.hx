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
		if (f != null)
		{
			return Reflect.callMethod(context, f, []);
		}
		return Failure;
	}

	private var action:String;

}
