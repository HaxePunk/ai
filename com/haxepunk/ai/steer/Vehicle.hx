package com.haxepunk.ai.steer;

import com.haxepunk.Entity;
import com.haxepunk.ds.Vector2D;

class Vehicle extends Entity
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

	public function seek(target:Vector2D)
	{
		var desiredVelocity = (target - position).unit * maxVelocity;

		var steering = desiredVelocity - velocity;
		// steering.truncate(maxForce);
		steering = steering / mass;

		velocity += steering;
		// velocity.truncate(maxSpeed);

		moveBy(velocity.x, velocity.y);
		position.x = x;
		position.y = y;
	}

	public function flee(target:Vector2D)
	{
		var desiredVelocity = (position - target).unit * maxVelocity;

		var steering = desiredVelocity - velocity;
		// steering.truncate(maxForce);
		steering = steering / mass;

		velocity = velocity + steering;
		// velocity.truncate(maxSpeed);

		moveBy(velocity.x, velocity.y);
		position.x = x;
		position.y = y;
	}

	public function wander()
	{
		var dt = HXP.elapsed;
	}

	public function separate(flock:Array<Vehicle>)
	{

	}

	public function cohere(flock:Array<Vehicle>)
	{

	}

	public function align(flock:Array<Vehicle>)
	{

	}

	public function pursue(vehicle:Vehicle)
	{

	}

	public function evade(vehicle:Vehicle)
	{

	}

	public override function update()
	{
		super.update();
	}

}