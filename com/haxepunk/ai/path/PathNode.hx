package com.haxepunk.ai.path;

class PathNode
{
	public var x:Int = 0;
	public var y:Int = 0;
	public var worldX:Float = 0;
	public var worldY:Float = 0;

	public var g:Int = 0;
	public var h:Int = 0;

	public var walkable:Bool;
	public var parent:PathNode;
	public var neighbors:Array<PathNode>;

	public function new(x:Int, y:Int, parent:PathNode=null)
	{
		this.x = x;
		this.y = y;
		this.parent = parent;
		neighbors = new Array<PathNode>();
	}

	public function toString():String
	{
		return "[pos:" + x + ", " + y + "]";
	}

}