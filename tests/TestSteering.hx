import com.haxepunk.ai.steer.Steer;

class TestSteering extends haxe.unit.TestCase
{
	public function testSeek()
	{
		var a = new Steer(),
			b = new Steer(5, 7);
		a.maxVelocity = 5;
		a.flee(b);
		assertTrue(true);
	}
}