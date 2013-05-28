package com.haxepunk.ai;

import com.haxepunk.masks.Grid;
import com.haxepunk.ai.Heuristic;
import com.haxepunk.ds.PriorityQueue;

enum PathOptimize
{
	None;
	SlopeMatch;
	LineOfSight;
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
		width = grid.columns;
		height = grid.rows;
		var x:Int, y:Int, node:PathNode;
		for (i in 0...(width * height))
		{
			x = i % width;
			y = Std.int(i / width);
			node = new PathNode(x, y);
			// center world coordinate in cell
			node.worldX = x * grid.tileWidth + grid.tileWidth / 2;
			node.worldY = y * grid.tileWidth + grid.tileWidth / 2;
			// determine walkable based on grid value
			node.walkable = !grid.getTile(x, y);
			nodes[i] = node;
		}

		// set defaults
		heuristic = Heuristic.manhattan;
		optimize = PathOptimize.SlopeMatch;
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
	public function search(sx:Int, sy:Int, dx:Int, dy:Int):Array<PathNode>
	{
		destX = dx; destY = dy;

		// early out if this area is blocked
		var dest = getNode(dx, dy);
		if (dest == null || dest.walkable == false) return null;

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
				node.h = Std.int(heuristic(node.x, node.y, destX, destY) * HORIZONTAL_COST);
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
			case None:
				while (node != null)
				{
					path.insert(0, node);
					node = node.parent;
				}
			case SlopeMatch:
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
			case LineOfSight:
				path.push(node);
				var current = node;
				while (node.parent != null)
				{
					// a bit stupid to check the same nodes every time, but I can't figure out a better way to do it...
					if (!hasLineOfSight(current, node.parent))
					{
						path.insert(0, node);
						current = node;
					}
					node = node.parent;
				}
				path.insert(0, node); // last node
		}

		return path;
	}

	private inline function hasLineOfSight(a:PathNode, b:PathNode):Bool
	{
		var dx = abs(b.x - a.x);
		var dy = abs(b.y - a.y);
		var x = a.x;
		var y = a.y;
		var n = 1 + dx + dy;
		var xInc = (b.x == a.x) ? 0 : (b.x > a.x) ? 1 : -1;
		var yInc = (b.y == a.y) ? 0 : (b.y > a.y) ? 1 : -1;
		var error = dx - dy;
		var canSee = true;
		dx *= 2;
		dy *= 2;

		while (n-- > 0)
		{
			var node = getNode(x, y);
			if (node == null || node.walkable == false)
			{
				canSee = false;
				break;
			}

			if (error > 0)
			{
				x += xInc;
				error -= dy;
			}
			else
			{
				y += yInc;
				error += dx;
			}
		}
		return canSee;
	}

	private inline function abs(value:Int):Int
	{
		return value < 0 ? -value : value;
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
		if (x < 0 || y < 0 || x >= width || y >= height)
			return null;
		else
			return nodes[y * width + x];
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
