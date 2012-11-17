## How to use
```haxe
import com.haxepunk.ai.GridPath;
import com.haxepunk.Entity;
import com.haxepunk.masks.Grid;
import com.haxepunk.tweens.LinearMotion;

class PathEntity extends Entity
{
	public function new(grid:Grid)
	{
		super();
		path = new GridPath(grid, {
			walkDiagonal: false,
			optimize: true
		});
		nodes = path.search(1, 1, 2, 2); // start(1, 1) dest(2, 2)

		linear = var LinearTween(moveToNextNode, TweenType.PERSIST);
		addTween(linear);
		moveToNextNode();// move to first node
	}

	public function moveToNextNode()
	{
		if (nodes != null && nodes.length)
		{
			current = nodes.shift();
			linear.setMotionSpeed(x, y, current.x, current.y, 2);
		}
	}

	public override function update()
	{
		x = linear.x;
		y = linear.y;
		super.update();
	}

	var linear:LinearTween;
	var current:PathNode;
	var nodes:Array<PathNode>;
}
```