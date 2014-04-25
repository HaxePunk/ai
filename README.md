## How to use
```haxe
import com.haxepunk.ai.NodeGraph;
import com.haxepunk.ai.PathNode;
import com.haxepunk.Entity;
import com.haxepunk.masks.Grid;
import com.haxepunk.tweens.LinearMotion;

class PathEntity extends Entity
{
	public function new(grid:Grid)
	{
		super();

		// create the ai node graph
		var graph = new NodeGraph({ optimize: SlopeMatch });
		graph.fromGrid(grid, true /* allow diagonals */);

		// tween to handle path movement
		pathTween = var LinearTween(moveToNextNode, TweenType.PERSIST);
		pathTween.addEventListener(TweenEvent.UPDATE, function(_) {
			this.x = pathTween.x;
			this.y = pathTween.y;
		});
		addTween(pathTween);

		// normally this would be in AI code or on a mouse event
		path = graph.search(1, 1, 2, 2); // start(1, 1) dest(2, 2)
		moveToNextNode(); // move to first node
	}

	public function moveToNextNode()
	{
		if (path != null && path.length > 0)
		{
			targetNode = path.shift();
			pathTween.setMotionSpeed(x, y, targetNode.worldX, targetNode.worldY, 150);
		}
	}

	var pathTween:LinearTween;
	var targetNode:PathNode;
	var path:Array<PathNode>;
}
```