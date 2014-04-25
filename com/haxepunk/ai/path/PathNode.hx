package com.haxepunk.ai.path;

typedef Neighbor = {
	var node:PathNode;
	var cost:Int;
}

class PathNode
{
	public var x:Float = 0;
	public var y:Float = 0;

	public var g:Float = 0;
	public var h:Float = 0;

	public var parent:PathNode;
	public var neighbors:List<Neighbor>;

	public function new(x:Float, y:Float, parent:PathNode=null)
	{
		this.x = x;
		this.y = y;
		this.parent = parent;
		neighbors = new List<Neighbor>();
	}

	public inline function addNeighbor(node:PathNode, cost:Int)
	{
		if (node == null) return;
		neighbors.add({
			node: node,
			cost: cost
		});
	}

	public function toString():String
	{
		return "[pos:" + x + ", " + y + "]";
	}

}