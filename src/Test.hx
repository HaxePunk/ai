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
		grid = new Grid(128, 128, 16, 16);
		grid.setTile(4, 4, true);
		grid.setTile(3, 3, true);
		grid.setTile(4, 3, true);
		grid.setTile(2, 5, true);
		grid.setTile(4, 5, true);
		grid.setTile(3, 2, true);
		addMask(grid, "solid");
		astar = new GridPath(grid, {
				walkDiagonal: true
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
		if (path != null)
		{
			var tileWidth = 16, tileHeight = 16, last = null;
			for (node in path)
			{
				if (last != null)
				{
					Draw.line(Std.int(last.x * tileWidth + tileWidth / 2),
						Std.int(last.y * tileHeight + tileHeight / 2),
						Std.int(node.x * tileWidth + tileWidth / 2),
						Std.int(node.y * tileHeight + tileHeight / 2));
				}
				Draw.circle(Std.int(node.x * tileWidth + tileWidth / 2),
					Std.int(node.y * tileHeight + tileHeight / 2), 3);
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