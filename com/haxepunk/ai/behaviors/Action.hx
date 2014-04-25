package com.haxepunk.ai.behaviors;

typedef ActionMethod = Void->BehaviorStatus;

/**
 * An action specifies a function to be called when updating
 */
class Action extends Behavior
{

	/**
	 * Action constructor
	 * @param action the callback method when this behavior runs
	 */
	public function new(action:ActionMethod)
	{
		super();
		this.action = action;
	}

	override public function update():BehaviorStatus
	{
		return action();
	}

	private var action:ActionMethod;

}
