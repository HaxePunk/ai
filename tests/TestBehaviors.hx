import com.haxepunk.ai.behaviors.*;
import com.haxepunk.ai.behaviors.selectors.*;
import com.haxepunk.ai.behaviors.BehaviorStatus;

/**
 * Thanks to the Behavior Tree Starter Kit
 * https://github.com/aigamedev/btsk
 */
class MockBehavior extends Behavior
{

	public var initCalled(default, null):Int = 0;
	public var termCalled(default, null):Int = 0;
	public var updateCalled(default, null):Int = 0;
	public var termStatus(default, null):BehaviorStatus;
	public var returnStatus:BehaviorStatus;

	public function new(?status:BehaviorStatus)
	{
		super();
		returnStatus = status == null ? Running : status;
	}

	override public function initialize()
	{
		initCalled += 1;
	}

	override public function terminate(status:BehaviorStatus)
	{
		termCalled += 1;
		termStatus = status;
	}

	override public function update():BehaviorStatus
	{
		updateCalled += 1;
		return returnStatus;
	}

}

class TestBehaviors extends haxe.unit.TestCase
{
	override public function setup() { }

	public function testBehaviorInit()
	{
		var behavior = new MockBehavior();
		assertEquals(0, behavior.initCalled);

		behavior.tick();
		assertEquals(1, behavior.initCalled);
	}

	public function testBehaviorUpdate()
	{
		var behavior = new MockBehavior();
		assertEquals(0, behavior.updateCalled);

		behavior.tick();
		assertEquals(1, behavior.updateCalled);
	}

	public function testBehaviorTerminate()
	{
		var behavior = new MockBehavior();
		behavior.tick();
		assertEquals(0, behavior.termCalled);

		behavior.returnStatus = Success;
		behavior.tick();
		assertEquals(1, behavior.termCalled);
	}

	public function testSequence()
	{
		var sequence = new Sequence();
		sequence.addChild(new MockBehavior(Success));
		assertEquals(Success, sequence.tick());
	}

	public function testSelector()
	{
		var selector = new Selector();
		selector.addChild(new MockBehavior());
		selector.addChild(new MockBehavior(Success));
		assertEquals(Running, selector.tick());
		assertEquals(Success, selector.tick());
	}

	public function testRepeat()
	{
		var behavior = new MockBehavior(Success);
		var repeat = new Repeat(behavior);
		repeat.count = 4;
		assertEquals(Success, repeat.tick());
		assertEquals(4, behavior.initCalled);
	}

	public function testParallel()
	{
		var parallel = new Parallel(RequireOne, RequireAll);
		assertEquals(Failure, parallel.tick());
	}

	public function testActiveSelector()
	{
		var selector = new ActiveSelector();
		var b1 = new MockBehavior(Failure);
		selector.addChild(b1);
		var b2 = new MockBehavior(Running);
		selector.addChild(b2);

		assertEquals(Running, selector.tick());
		assertEquals(1, b1.initCalled);
		assertEquals(1, b1.termCalled);
		assertEquals(1, b2.initCalled);
		assertEquals(0, b2.termCalled);

		assertEquals(Running, selector.tick());
		assertEquals(2, b1.initCalled);
		assertEquals(2, b1.termCalled);
		assertEquals(1, b2.initCalled);
		assertEquals(0, b2.termCalled);

		b1.returnStatus = Running;
		assertEquals(Running, selector.tick());
		assertEquals(3, b1.initCalled);
		assertEquals(2, b1.termCalled);
		assertEquals(1, b2.initCalled);
		assertEquals(1, b2.termCalled);

		b1.returnStatus = Success;
		assertEquals(Success, selector.tick());
		assertEquals(3, b1.initCalled);
		assertEquals(3, b1.termCalled);
		assertEquals(1, b2.initCalled);
		assertEquals(1, b2.termCalled);
	}

}
