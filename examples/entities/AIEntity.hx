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
		behavior = new Selector();
	}

	override public function added()
	{
		var image = Image.createCircle(8);
		image.centerOrigin();
		graphic = image;

		var sequence = new Sequence();
		sequence.addChild(new Action(keyPressed));
		sequence.addChild(new Action(followMouse));
		behavior.addChild(sequence);
	}

	override public function update()
	{
		behavior.tick();
		super.update();
	}

	public function followMouse():BehaviorStatus
	{
		var x = HXP.scene.mouseX,
			y = HXP.scene.mouseY;

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