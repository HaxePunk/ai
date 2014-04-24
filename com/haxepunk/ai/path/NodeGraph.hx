package com.haxepunk.ai.path;

import com.haxepunk.masks.Grid;
import com.haxepunk.ai.path.Heuristic;
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
	/** Generates an optimized path list, removes identical slopes (default:true) */
	@:optional public var optimize:PathOptimize;
};

/**
 * A node graph class for A* pathfinding
 */
class NodeGraph
{

	/**
	 * Creates a GridPath class
	 * @param grid the Grid mask to use for path info
	 * @param options a set of options that determine how paths are generated
	 */
	public function new()
	{
		nodes = new Array<PathNode>();
		openList = new PriorityQueue<PathNode>();
		closedList = new Array<PathNode>();
	}

	public function fromGrid(grid:Grid, allowDiagonal:Bool=false, ?options:PathOptions)
	{
		// build node list
		width = Std.int(grid.width / grid.tileWidth);
		height = Std.int(grid.height / grid.tileHeight);
		var x:Int, y:Int;
		for (i in 0...(width * height))
		{
			x = i % width;
			y = Std.int(i / width);
			if (!grid.getTile(x, y)) {
				nodes.push(new PathNode(x, y));
				// add neighbors
			}
		}

		// set defaults
		heuristic = Heuristic.manhattan;
		optimize = PathOptimize.SLOPE_MATCH;

		if (options != null)
		{
			if (Reflect.hasField(options, "heuristic"))
				heuristic = options.heuristic;

			if (Reflect.hasField(options, "optimize"))
				optimize = options.optimize;
		}
	}

	/**
	 * Finds the shortest path between two points, if possible
	 * @param sx the world start x coordinate
	 * @param sy the world start y coordinate
	 * @param dx the world destination x coordinate
	 * @param dy the world destination y coordinate
	 * @return a list of nodes from the start to finish
	 */
	public function search(sx:Float, sy:Float, dx:Float, dy:Float):Array<PathNode>
	{
		reset();

		// push starting node to the open list
		var start = getClosestNode(sx, sy);
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
			for (neighbor in node.neighbors)
			{
				if (Lambda.has(closedList, neighbor))
				{
					continue;
				}
				else
				{
					var cost = HXP.distance(node.x, node.y, neighbor.x, neighbor.y);
					var g = node.g + cost;
					if (g < neighbor.g || neighbor.parent == null)
					{
						neighbor.g = g;
						neighbor.h = heuristic(neighbor.x, neighbor.y, dx, dy) * HORIZONTAL_COST;
						neighbor.parent = node;

						// remove the node if it exists on the open list
						openList.remove(neighbor);
						// enqueue the node with the new priority
						openList.enqueue(neighbor, Std.int(neighbor.g + neighbor.h));
					}
				}
			}
		}

		return null;
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
	 * Retrieves the closest PathNode to a world point
	 */
	private inline function getClosestNode(x:Float, y:Float):PathNode
	{
		var closestDist:Float = 999999999;
		var closest:PathNode = null;
		for (node in nodes)
		{
			var dist = HXP.distance(node.x, node.y, x, y);
			if (dist < closestDist)
			{
				closest = node;
				closestDist = dist;
			}
		}
		return closest;
	}

	private var heuristic:HeuristicFunction;
	private var optimize:PathOptimize;

	private var width:Int;
	private var height:Int;

	private var nodes:Array<PathNode>;
	private var openList:PriorityQueue<PathNode>;
	private var closedList:Array<PathNode>;

	private static inline var HORIZONTAL_COST:Int = 10;

}