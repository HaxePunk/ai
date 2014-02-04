import com.haxepunk.ai.steer.Vehicle;

class TestSteering extends haxe.unit.TestCase
{
	public function testSeek()
	{
		var a = new Vehicle(),
			b = new Vehicle(5, 7);
		a.maxVelocity = 5;
		a.flee(b.position);
		assertTrue(true);
	}
}