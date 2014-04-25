package scenes;

import com.haxepunk.*;

class Behaviors extends Scene
{

	override public function begin()
	{
		add(new entities.AIEntity());
		HXP.camera.x = -HXP.halfWidth;
		HXP.camera.y = -HXP.halfHeight;
	}

}
