package com.haxepunk.ai.behaviors;

class Behavior
{

	private var status(default, null):BehaviorStatus;

	public function new()
	{
		status = Invalid;
	}

	private function initialize() { }
	private function terminate(status:BehaviorStatus) { }
	private function update():BehaviorStatus { return status; }

	public var terminated(get, never):Bool;
	private inline function get_terminated():Bool
	{
		return status == Success || status == Failure;
	}

	public var running(get, never):Bool;
	private inline function get_running():Bool
	{
		return status == Running;
	}

	public function reset()
	{
		status = Invalid;
	}

	public function abort()
	{
		terminate(Aborted);
		status = Aborted;
	}

	public function tick():BehaviorStatus
	{
		if (status != Running)
		{
			initialize();
		}
		status = update();
		if (status != Running)
		{
			terminate(status);
		}
		return status;
	}

}