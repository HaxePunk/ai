import haxe.unit.TestRunner;

class TestMain
{
	public static function main()
	{
		var r = new TestRunner();
		r.add(new TestVector());
		r.add(new TestSteering());
		r.run();
	}
}
