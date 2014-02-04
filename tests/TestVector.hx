import com.haxepunk.ds.Vector2D;

/**
 * Tests vector functionality
 */
class TestVector extends haxe.unit.TestCase
{

	public function testAdd()
	{
		var a = new Vector2D(2.2, 7.14),
			b = new Vector2D(6, 5.512),
			c:Vector2D = a + b;
		assertEquals(8.2, c.x);
		assertEquals(12.652, c.y);
	}

	public function testSubtract()
	{
		var a = new Vector2D(2.2, 5),
			b = new Vector2D(6, 2),
			c = a - b;
		assertEquals(-3.8, c.x);
		assertEquals(3.0, c.y);
	}

	public function testScalar()
	{
		var a = new Vector2D(3.3, 4.2),
			b:Float = 2.0,
			c = a * b,
			d = a / b;
		assertEquals(6.6, c.x);
		assertEquals(8.4, c.y);

		assertEquals(1.65, d.x);
		assertEquals(2.1, d.y);
	}

	public function testDot()
	{
		var a = new Vector2D(1.2, 2),
			b = new Vector2D(2, 1);
		assertEquals(4.4, a.dot(b));
	}

	public function testCross()
	{
		var a = new Vector2D(1, 2),
			b = new Vector2D(2, 1);
		assertEquals(0.0, a.cross(b));
	}

	public function testLength()
	{
		var a = new Vector2D(1, 6);
		assertTrue(a.length > 6.05 && a.length < 6.1);
	}

	public function testUnit()
	{
		var a = new Vector2D(1, 6),
			u = a.unit;
		assertEquals(1.0, u.length);
	}

	public function testAngle()
	{
		var a = new Vector2D(0, 1),
			b = a.rotate(90.0 * (Math.PI / 180));
		assertEquals(90.0, a.angle * (180 / Math.PI));
		assertEquals(a.squareLength, b.squareLength);
	}

}
