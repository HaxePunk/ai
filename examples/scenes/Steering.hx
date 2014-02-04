package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.ai.steer.Vehicle;
import com.haxepunk.ds.Vector2D;
import com.haxepunk.graphics.Image;

class Character extends Vehicle
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		graphic = Image.createRect(4, 4);
		maxVelocity = 3;
	}
}

class Steering extends Scene
{
	public function new()
	{
		super();
		steer = new Character(HXP.halfWidth, HXP.halfHeight);
		add(steer);

		mouse = new Vector2D(mouseX, mouseY);
	}

	public override function update()
	{
		mouse.x = mouseX; mouse.y = mouseY;

		steer.seek(mouse);

		super.update();
	}

	private var mouse:Vector2D;
	private var steer:Vehicle;
}