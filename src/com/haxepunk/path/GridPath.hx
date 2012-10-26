package com.haxepunk.path;

import com.haxepunk.masks.Grid;
import com.haxepunk.path.Heuristic;
import com.haxepunk.ds.PriorityQueue;

typedef PathOptions = {
	@:optional public var heuristic:HeuristicFunction;
	@:optional public var walkDiagonal:Bool;
	@:optional public var optimizedList:Bool;
};

class GridPath
{

	public function new(grid:Grid, ?options:PathOptions)
	{
		nodes = new Array<Array<PathNode>>();
		openList = new PriorityQueue<PathNode>();
		closedList = new Array<PathNode>();

		// build node list
		var w = Std.int(grid.width / grid.tileWidth);
		var h = Std.int(grid.height / grid.tileHeight);
		for (x in 0...w)
		{
			nodes[x] = new Array<PathNode>();
			for (y in 0...h)
			{
				var node = new PathNode(x, y);
				node.walkable = !grid.getTile(x, y);
				nodes[x].push(node);
			}
		}

		// set defaults
		heuristic = Heuristic.manhattanMethod;
		walkDiagonal = false;
		optimizedList = true;

		if (options != null)
		{
			if (Reflect.hasField(options, "heuristic"))
				heuristic = options.heuristic;

			if (Reflect.hasField(options, "walkDiagonal"))
				walkDiagonal = options.walkDiagonal;

			if (Reflect.hasField(options, "optimizedList"))
				optimizedList = options.optimizedList;
		}
	}

	public inline function checkNeighbor(parent:PathNode, x:Int, y:Int)
	{
		var node = getNode(parent.x + x, parent.y + y);
		if (node == null || !node.walkable || Lambda.has(closedList, node))
		{
			return;
		}
		else
		{
			var diagonal = (x != 0 && y != 0);

			node.g = parent.g + (diagonal ? 14 : 10);
			node.h = heuristic(parent.x, parent.y, destX, destY) * 10;
			node.f = node.g + node.h;
			node.parent = parent;

			// remove the node if it exists on the open list
			openList.remove(node);
			// enqueue the node with the new priority
			openList.enqueue(node, node.f);
		}
	}

	public function findPath(sx:Int, sy:Int, dx:Int, dy:Int):Array<PathNode>
	{
		destX = dx; destY = dy;

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
			checkNeighbor(node, 1, 0);
			checkNeighbor(node, 0,-1);
			checkNeighbor(node,-1, 0);
			checkNeighbor(node, 0, 1);

			if (walkDiagonal)
			{
				checkNeighbor(node, 1, 1);
				checkNeighbor(node, 1,-1);
				checkNeighbor(node,-1,-1);
				checkNeighbor(node,-1, 1);
			}
		}

		return null;
	}

	private inline function calcSlope(a:PathNode, b:PathNode):Float
	{
		return (b.y - a.y) / (b.x - a.x);
	}

	private function buildList(node:PathNode):Array<PathNode>
	{
		var path = new Array<PathNode>();

		// optimized list skips nodes with the same slope
		if (optimizedList)
		{
			var slope:Float = 0;
			while (node != null)
			{
				var parent = node.parent;
				if (parent == null)
				{
					path.insert(0, node);
				}
				else
				{
					var newSlope = calcSlope(node, parent);
					if (slope != newSlope)
					{
						path.insert(0, node);
						slope = newSlope;
					}
				}
				node = parent;
			}
		}
		else
		{
			while (node != null)
			{
				path.insert(0, node);
				node = node.parent;
			}
		}

		return path;
	}

	private inline function getNode(x:Int, y:Int):PathNode
	{
		if (x > -1 && x < nodes.length &&
			y > -1 && y < nodes[x].length)
			return nodes[x][y];
		else
			return null;
	}

	private var heuristic:HeuristicFunction;
	private var walkDiagonal:Bool;
	private var optimizedList:Bool;

	private var destX:Int;
	private var destY:Int;

	private var nodes:Array<Array<PathNode>>;
	private var openList:PriorityQueue<PathNode>;
	private var closedList:Array<PathNode>;

}
