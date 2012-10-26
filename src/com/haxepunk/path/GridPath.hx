package com.haxepunk.path;

import com.haxepunk.masks.Grid;
import com.haxepunk.path.Heuristic;

class GridPath
{

	public function new(grid:Grid, ?heuristic:HeuristicFunction)
	{
		this.grid = grid;
		this.openList = new Array<PathNode>();
		this.closedList = new Array<PathNode>();

		if (heuristic == null)
		{
			this.heuristic = Heuristic.manhattanMethod;
		}
		else
		{
			this.heuristic = heuristic;
		}
	}

	public inline function manhattanMethod(node:PathNode)
	{
		return Std.int(Math.abs(node.x - destX) + Math.abs(node.y - destY)) * 10;
	}

	public inline function checkNode(node:PathNode, x:Int, y:Int)
	{
		if (grid.getTile(node.x + x, node.y + y) == false)
		{
			var n = new PathNode(node.x + x, node.y + y);
			var diagonal = (x != 0 && y != 0);
			n.g = node.g + (diagonal ? 14 : 10);
			n.h = heuristic(node.x, node.y, destX, destY);
			n.f = n.g + n.h;
			n.parent = node;
			openList.push(n);
		}
	}

	public function findPath(sx:Int, sy:Int, dx:Int, dy:Int)
	{
		destX = dx; destY = dy;

		// push starting node to the open list
		openList.push(new PathNode(sx, sy));
		var node = openList.pop();
		//for (node in openList)
		{
			checkNode(node, 1, 1);
			checkNode(node, 1, 0);
			checkNode(node, 1,-1);
			checkNode(node, 0,-1);
			checkNode(node,-1,-1);
			checkNode(node,-1, 0);
			checkNode(node,-1, 1);
			checkNode(node, 0, 1);

			closedList.push(node);

			openList.remove(node);
		}
		trace(openList);
	}

	private var heuristic:HeuristicFunction;

	private var destX:Int;
	private var destY:Int;

	private var grid:Grid;
	private var openList:Array<PathNode>;
	private var closedList:Array<PathNode>;

}
