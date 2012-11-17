package com.haxepunk.ai;

class PathNode
{
	public var x:Int;
	public var y:Int;
	public var worldX:Float;
	public var worldY:Float;

	public var g:Int;
	public var h:Int;

	public var walkable:Bool;
	public var parent:PathNode;

	public function new(x:Int, y:Int, parent:PathNode=null)
	{
		this.x = x;
		this.y = y;
		this.parent = parent;

		g = h = 0;
	}

	public function toString():String
	{
		return "[pos:" + x + ", " + y + "]";
	}

}