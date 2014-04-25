package behaviors;

import com.haxepunk.*;
import com.haxepunk.ai.behaviors.*;

class FollowMouse extends Behavior
{

	public function new(target:Entity)
	{
		super();
		this.target = target;
	}



	private var target:Entity;

}