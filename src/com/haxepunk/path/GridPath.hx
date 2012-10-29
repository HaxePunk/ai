package com.haxepunk.path;

import com.haxepunk.masks.Grid;
import com.haxepunk.path.Heuristic;
import com.haxepunk.ds.PriorityQueue;

enum PathOptimize
{
	NONE;
	SLOPE_MATCH;
	LINE_OF_SIGHT;
}

/**
 * A set of options for pathfinding
 */
typedef PathOptions = {
	/** The heuristic to use for path finding (default: Heuristic.manhattan) */
	@:optional public var heuristic:HeuristicFunction;
	/** Allows diagonal movement in path generation (default: false) */
	@:optional public var walkDiagonal:Bool;
	/** Generates an optimized path list, removes identical slopes (default:true) */
	@:optional public var optimize:PathOptimize;
};

/**
 * An A* implementation for Grid masks
 */
class GridPath
{

	public static inline var HORIZONTAL_COST:Int = 10;
	public static inline var VERTICAL_COST:Int = 14;

	/**
	 * Creates a GridPath class
	 * @param grid the Grid mask to use for path info
	 * @param options a set of options that determine how paths are generated
	 */
	public function new(grid:Grid, ?options:PathOptions)
	{
		nodes = new Array<PathNode>();
		openList = new PriorityQueue<PathNode>();
		closedList = new Array<PathNode>();

		// build node list
		width = Std.int(grid.width / grid.tileWidth);
		height = Std.int(grid.height / grid.tileHeight);
		var x:Int, y:Int;
		for (i in 0...(width * height))
		{
			x = i % width;
			y = Std.int(i / width);
			nodes[i] = new PathNode(x, y);
			nodes[i].walkable = !grid.getTile(x, y);
		}

		// set defaults
		heuristic = Heuristic.manhattan;
		optimize = PathOptimize.SLOPE_MATCH;
		walkDiagonal = false;

		if (options != null)
		{
			if (Reflect.hasField(options, "heuristic"))
				heuristic = options.heuristic;

			if (Reflect.hasField(options, "walkDiagonal"))
				walkDiagonal = options.walkDiagonal;

			if (Reflect.hasField(options, "optimize"))
				optimize = options.optimize;
		}
	}

	/**
	 * Finds the shortest path between two points, if possible
	 * @param sx the start x coordinate
	 * @param sy the start y coordinate
	 * @param dx the destination x coordinate
	 * @param dy the destination y coordinate
	 * @return a list of nodes from the start to finish
	 */
	public function findPath(sx:Int, sy:Int, dx:Int, dy:Int):Array<PathNode>
	{
		destX = dx; destY = dy;

		reset();

		// push starting node to the open list
		var start = getNode(sx, sy);
		start.parent = null;
		openList.enqueue(start, 0);

		while (openList.length > 0)
		{
			var node:PathNode = openList.dequeue();

			// check if we found the target
			if (node.x == dx && node.y == dy)
			{
				return buildList(node);
			}

			// push the node to the closed list
			closedList.push(node);

			// check all the neighbors
			updateNeighbor(node, 1, 0);
			updateNeighbor(node, 0,-1);
			updateNeighbor(node,-1, 0);
			updateNeighbor(node, 0, 1);

			if (walkDiagonal)
			{
				updateNeighbor(node, 1, 1);
				updateNeighbor(node, 1,-1);
				updateNeighbor(node,-1,-1);
				updateNeighbor(node,-1, 1);
			}
		}

		return null;
	}

	/**
	 * Updates a neighboring node info
	 * @param parent the neighbor node's parent
	 * @param x the neighbor x distance from the parent
	 * @param y the neighbor y distance from the parent
	 */
	private inline function updateNeighbor(parent:PathNode, x:Int, y:Int)
	{
		var node = getNode(parent.x + x, parent.y + y);
		if (node == null || !node.walkable || Lambda.has(closedList, node))
		{
			return;
		}
		else
		{
			var horizontal = (x == 0 || y == 0);
			var g = parent.g + (horizontal ? HORIZONTAL_COST : VERTICAL_COST);
			if (g < node.g || node.parent == null)
			{
				node.g = g;
				node.h = Std.int(heuristic(parent.x, parent.y, destX, destY) * HORIZONTAL_COST);
				node.parent = parent;

				// remove the node if it exists on the open list
				openList.remove(node);
				// enqueue the node with the new priority
				openList.enqueue(node, node.g + node.h);
			}
		}
	}

	/**
	 * Calculates the slope between two nodes
	 */
	private inline function calcSlope(a:PathNode, b:PathNode):Float
	{
		return (b.y - a.y) / (b.x - a.x);
	}

	/**
	 * Builds a list backwards from the destination node
	 * @param node the destination node to start backtracking from
	 * @return a list of nodes to travel to reach the destination
	 */
	private function buildList(node:PathNode):Array<PathNode>
	{
		var path = new Array<PathNode>();

		// optimized list skips nodes with the same slope
		switch (optimize)
		{
			case NONE:
				while (node != null)
				{
					path.insert(0, node);
					node = node.parent;
				}
			case SLOPE_MATCH:
				path.push(node);
				// check if this is the only node
				if (node.parent != null)
				{
					var slope:Float = calcSlope(node, node.parent);
					while (node != null)
					{
						if (node.parent == null)
						{
							path.insert(0, node);
						}
						else
						{
							var newSlope = calcSlope(node, node.parent);
							if (slope != newSlope)
							{
								path.insert(0, node);
								slope = newSlope;
							}
						}
						node = node.parent;
					}
				}
			case LINE_OF_SIGHT:
				path.push(node);
				if (node.parent != null)
				{

				}
		}

		return path;
	}

	private function reset()
	{
// clear out any old data we had
#if (cpp || php)
		closedList.splice(0,closedList.length);
#else
		untyped closedList.length = 0;
#end
		openList.clear();

		for (i in 0...nodes.length)
		{
			nodes[i].parent = null;
		}
	}

	/**
	 * Retrieves a PathNode at a specific index
	 */
	private inline function getNode(x:Int, y:Int):PathNode
	{
		var index = y * width + x;
		if (x < 0 || y < 0 || index >= nodes.length)
			return null;
		else
			return nodes[index];
	}

	private var heuristic:HeuristicFunction;
	private var walkDiagonal:Bool;
	private var optimize:PathOptimize;

	private var destX:Int;
	private var destY:Int;

	private var width:Int;
	private var height:Int;

	private var nodes:Array<PathNode>;
	private var openList:PriorityQueue<PathNode>;
	private var closedList:Array<PathNode>;

}
