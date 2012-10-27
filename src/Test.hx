import com.haxepunk.World;
import com.haxepunk.masks.Grid;
import com.haxepunk.path.GridPath;
import com.haxepunk.path.PathNode;
import com.haxepunk.utils.Draw;
import com.haxepunk.utils.Input;

import nme.geom.Point;

class Test extends World
{
	public function new()
	{
		super();

	}

	public override function begin()
	{
		grid = new Grid(1024, 1024, 64, 64);
		grid.setTile(4, 4, true);
		grid.setTile(3, 3, true);
		grid.setTile(4, 3, true);
		grid.setTile(2, 5, true);
		grid.setTile(4, 5, true);
		grid.setTile(3, 2, true);
		addMask(grid, "solid");
		astar = new GridPath(grid, {
				walkDiagonal: true,
				optimizedPath: true
			});
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
				path = astar.findPath(Std.int(start.x), Std.int(start.y), Std.int(x), Std.int(y));
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
			var last = null;
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
				Draw.text(node.g + " " + node.h, x, y);
				Draw.circle(x, y, 3);
				last = node;
			}
		}
		super.render();
	}

	private var start:Point;

	private var grid:Grid;
	private var astar:GridPath;
	private var path:Array<PathNode>;
}