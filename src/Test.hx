import com.haxepunk.World;
import com.haxepunk.masks.Grid;
import com.haxepunk.path.GridPath;
import com.haxepunk.path.PathNode;
import com.haxepunk.utils.Draw;

class Test extends World
{
	public function new()
	{
		super();

	}

	public override function begin()
	{
		var grid = new Grid(128, 128, 16, 16);
		grid.setTile(4, 4, true);
		grid.setTile(3, 3, true);
		grid.setTile(2, 5, true);
		grid.setTile(4, 5, true);
		grid.setTile(3, 2, true);
		addMask(grid, "solid");
		var astar = new GridPath(grid, {
				walkDiagonal: true
			});
		path = astar.findPath(2, 2, 5, 5);
		trace(path);
	}

	public override function render()
	{
		return;
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
		super.render();
	}

	private var path:Array<PathNode>;
}