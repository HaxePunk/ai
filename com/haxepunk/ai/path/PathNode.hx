package com.haxepunk.ai.path;

/**
 * Neighbor contains a reference to a node and cost value
 */
typedef Neighbor = {
	var node:PathNode;
	var cost:Int;
}

/**
 * A node used for pathfinding
 */
class PathNode
{
	/**
	 * The x-axis position of the node
	 */
	public var x:Float = 0;
	/**
	 * The y-axis position of the node
	 */
	public var y:Float = 0;

	/**
	 * The cost from the start node
	 */
	public var g:Float = 0;
	/**
	 * The heuristic value
	 */
	public var h:Float = 0;

	/**
	 * The parent of the node (overwritten during traversal)
	 */
	public var parent:PathNode;
	/**
	 * The connecting node neighbors
	 */
	public var neighbors:List<Neighbor>;

	/**
	 * PathNode constructor
	 * @param x the x-axis position of the node
	 * @param y the y-axis position of the node
	 * @param parent the parent of the node (used for traversal)
	 */
	public function new(x:Float, y:Float, parent:PathNode=null)
	{
		this.x = x;
		this.y = y;
		this.parent = parent;
		neighbors = new List<Neighbor>();
	}

	/**
	 * Connects to a neighboring node
	 * @param node the neighbor node
	 * @param cost the cost to get to that node
	 * @param reverse whether to make the connection in reverse as well
	 */
	public inline function addNeighbor(node:PathNode, cost:Int, reverse:Bool=false):Void
	{
		if (node == null) return;
		neighbors.add({
			node: node,
			cost: cost
		});
		if (reverse) node.addNeighbor(this, cost);
	}

	/**
	 * Provides a string representation of the node
	 */
	public function toString():String
	{
		return "[node:" + x + ", " + y + "]";
	}

}