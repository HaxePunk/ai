import com.haxepunk.World;
import com.haxepunk.masks.Grid;
import com.haxepunk.path.GridPath;

class Test extends World
{
	public function new()
	{
		super();

		var grid = new Grid(128, 128, 16, 16);
		var path = new GridPath(grid);
		path.findPath(2, 2, 5, 5);
	}
}