package com.haxepunk.ai.path;

import com.haxepunk.HXP;
import com.haxepunk.masks.Grid;
import com.haxepunk.ai.path.Heuristic;
import com.haxepunk.ds.PriorityQueue;
import haxe.ds.IntMap;

/**
 * Optimization options for path traversal
 */
enum PathOptimize
{
	None; /** no optimization **/
	SlopeMatch; /** any nodes with matching slopes are dropped **/
}

/**
 * A set of options for pathfinding
 */
typedef PathOptions = {
	/** The heuristic to use for path finding (default: Heuristic.manhattan) */
	@:optional public var heuristic:HeuristicFunction;
	/** Generates an optimized path list, removes identical slopes (default:None) */
	@:optional public var optimize:PathOptimize;
};

/**
 * A node graph class for A* pathfinding
 */
class NodeGraph
{

	/**
	 * NodeGraph constructor
	 * @param options a set of options that determine how paths are generated
	 */
	public function new(?options:PathOptions)
	{
		nodes = new Array<PathNode>();
		openList = new PriorityQueue<PathNode>();
		closedList = new List<PathNode>();

		// set defaults
		heuristic = Heuristic.manhattan;
		optimize = PathOptimize.None;

		if (options != null)
		{
			if (Reflect.hasField(options, "heuristic"))
				heuristic = options.heuristic;

			if (Reflect.hasField(options, "optimize"))
				optimize = options.optimize;
		}
	}

	/**
	 * Adds a node to the graph
	 */
	public inline function addNode(node:PathNode):Void
	{
		nodes.push(node);
	}

	/**
	 * Builds a graph from a Grid object
	 * @param grid the grid object to use for generation (open spaces are considered nodes)
	 * @param allowDiagonal whether to allow diagonal movement on the grid
	 */
	public function fromGrid(grid:Grid, allowDiagonal:Bool=false):Void
	{
		// build node list
		width = Std.int(grid.width / grid.tileWidth);
		height = Std.int(grid.height / grid.tileHeight);
		var x:Int, y:Int;
		var size:Int = width * height;
		var map = new IntMap<PathNode>();

		var getNode = function(x:Int, y:Int):PathNode {
			var node:PathNode;
			var index:Int = y * width + x;
			if (index < 0 || index > size) return null;
			if (map.exists(index))
			{
				node = map.get(index);
			}
			else
			{
				node = new PathNode(x, y);
				map.set(index, node);
			}
			return node;
		};

		for (i in 0...size)
		{
			x = i % width;
			y = Std.int(i / width);
			if (!grid.getTile(x, y))
			{
				var node = getNode(x, y);
				// add neighbors
				node.addNeighbor(getNode(x    , y - 1), HORIZONTAL_COST);
				node.addNeighbor(getNode(x    , y + 1), HORIZONTAL_COST);
				node.addNeighbor(getNode(x - 1, y    ), HORIZONTAL_COST);
				node.addNeighbor(getNode(x + 1, y    ), HORIZONTAL_COST);

				if (allowDiagonal)
				{
					node.addNeighbor(getNode(x - 1, y - 1), DIAGONAL_COST);
					node.addNeighbor(getNode(x + 1, y - 1), DIAGONAL_COST);
					node.addNeighbor(getNode(x - 1, y + 1), DIAGONAL_COST);
					node.addNeighbor(getNode(x + 1, y + 1), DIAGONAL_COST);
				}
				addNode(node);
			}
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
			closedList.add(node);

			// check all the neighbors
			for (neighbor in node.neighbors)
			{
				var n = neighbor.node;
				if (Lambda.has(closedList, n))
				{
					continue;
				}
				else
				{
					var g = node.g + HXP.distance(node.x, node.y, n.x, n.y);
					if (g < n.g || n.parent == null)
					{
						n.g = g;
						n.h = heuristic(n.x, n.y, dx, dy) * neighbor.cost;
						n.parent = node;

						// remove the node if it exists on the open list
						openList.remove(n);
						// enqueue the node with the new priority
						openList.enqueue(n, Std.int(n.g + n.h));
					}
				}
			}
		}

		return null;
	}

	/**
	 * Calculates the slope between two nodes
	 * @return the slope between two nodes
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
		}

		return path;
	}

	/**
	 * Clears the open and closed lists
	 */
	private function reset()
	{
		// clear out any old data we had
		closedList.clear();
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
		var closestDist:Float = HXP.NUMBER_MAX_VALUE;
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
	private var closedList:List<PathNode>;

	private static inline var HORIZONTAL_COST:Int = 10;
	private static inline var DIAGONAL_COST:Int = 14;

}
