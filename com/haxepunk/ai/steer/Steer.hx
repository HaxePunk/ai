package com.haxepunk.ai.steer;

import com.haxepunk.Entity;
import com.haxepunk.ds.Vector2D;

class Steer extends Entity
{
	public var position:Vector2D;
	public var velocity:Vector2D;
	public var maxVelocity:Float = 0;
	public var mass:Float = 1;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		this.position = new Vector2D(x, y);
		velocity = new Vector2D(0, 0);
	}

	public function seek(target:Steer)
	{
		var desiredVelocity = (target.position - position).unit * maxVelocity;

		var steering = desiredVelocity - velocity;
		// steering.truncate(maxForce);
		steering = steering / mass;

		velocity = velocity + steering;
		// velocity.truncate(maxSpeed);
		position = position + velocity;
	}

	public function flee(target:Steer)
	{
		var desiredVelocity = (position - target.position).unit * maxVelocity;

		var steering = desiredVelocity - velocity;
		// steering.truncate(maxForce);
		steering = steering / mass;

		velocity = velocity + steering;
		// velocity.truncate(maxSpeed);
		position = position + velocity;
	}
}