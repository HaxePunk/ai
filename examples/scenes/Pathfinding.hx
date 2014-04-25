package scenes;

import com.haxepunk.Scene;
import com.haxepunk.masks.Grid;
import com.haxepunk.ai.path.NodeGraph;
import com.haxepunk.ai.path.PathNode;
import com.haxepunk.utils.Draw;
import com.haxepunk.utils.Input;

import flash.geom.Point;

class Pathfinding extends Scene
{

	private static var map = [
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
		1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
		1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,
		1,0,0,1,1,0,0,0,1,1,1,1,1,1,1,1,0,1,1,1,
		1,0,0,1,1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,
		1,1,0,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,
		1,1,0,1,0,0,0,0,1,0,0,1,1,1,0,0,0,0,0,1,
		1,1,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,0,0,1,
		1,0,1,1,0,0,1,1,1,1,0,1,1,1,1,1,1,1,1,1,
		1,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,1,
		1,0,0,1,1,1,1,0,0,1,1,0,1,0,1,0,1,0,0,1,
		1,0,0,0,0,1,1,1,0,1,1,0,1,0,1,0,1,0,0,1,
		1,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	];

	public function new()
	{
		super();
	}

	public override function begin()
	{
		var ts = 32, w = 20, h = 15;
		grid = new Grid(w * ts, h * ts, ts, ts);
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				grid.setTile(x, y, map[y * w + x] == 1);
			}
		}

		addMask(grid, "solid");
		graph = new NodeGraph({optimize:SlopeMatch});
		graph.fromGrid(grid);
	}

	public override function update()
	{
		if (Input.mousePressed)
		{
			var x = mouseX / grid.tileWidth,
				y = mouseY / grid.tileHeight;
			if (start == null)
			{
				start = new Point(x, y);
			}
			else
			{
				path = graph.search(start.x, start.y, x, y);
				start = null;
			}
		}
	}

	public override function render()
	{
		var w = Std.int(grid.width / grid.tileWidth);
		var h = Std.int(grid.height / grid.tileHeight);
		for (x in 0...w)
		{
			for (y in 0...h)
			{
				Draw.rect(x * grid.tileWidth, y * grid.tileHeight,
						grid.tileWidth, grid.tileHeight,
						grid.getTile(x, y) ? 0x000000 : 0x444444);
			}
		}

		if (path != null)
		{
			var last:PathNode = null;
			for (node in path)
			{
				var x = Std.int(node.x * grid.tileWidth + grid.tileWidth / 2),
					y = Std.int(node.y * grid.tileHeight + grid.tileHeight / 2);
				if (last != null)
				{
					Draw.line(Std.int(last.x * grid.tileWidth + grid.tileWidth / 2),
						Std.int(last.y * grid.tileHeight + grid.tileHeight / 2),
						Std.int(node.x * grid.tileWidth + grid.tileWidth / 2),
						Std.int(node.y * grid.tileHeight + grid.tileHeight / 2));
				}
				Draw.text(Math.round(node.g) + " " + Math.round(node.h), x, y);
				Draw.circle(x, y, 3);
				last = node;
			}
		}
		super.render();
	}

	private var start:Point;

	private var grid:Grid;
	private var graph:NodeGraph;
	private var path:Array<PathNode>;

}
