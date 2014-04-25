package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.*;
import com.haxepunk.ai.behaviors.*;

class AIEntity extends Entity
{

	public function new()
	{
		super();
		behavior = BehaviorTree.fromXml(openfl.Assets.getText("assets/behaviors/example.xml"));
	}

	override public function added()
	{
		var image = Image.createCircle(8);
		image.centerOrigin();
		graphic = image;
	}

	override public function update()
	{
		behavior.tick(this);
		super.update();
	}

	public function followMouse():BehaviorStatus
	{
		var x = scene.mouseX,
			y = scene.mouseY;

		if (this.x == x && this.y == y) return Success;

		moveTowards(x, y, 12);
		return Running;
	}

	public function keyPressed():BehaviorStatus
	{
		return Input.check(Key.SPACE) ? Success : Failure;
	}

	private var behavior:Selector;
}