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

	override public function update(context:Dynamic):BehaviorStatus
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

	public function testBehaviorXml()
	{
		var xml = '<?xml version="1.0"?>
<tree>
	<action>doAction</action>
	<sequence>
		<action>followMouse</action>
		<parallel success="one" failure="all">
			<repeat count="4">
				<action>doStuff</action>
			</repeat>
			<selector>
				<action>lookHere</action>
				<action>lookThere</action>
			</selector>
		</parallel>
	</sequence>
	<action>performAction</action>
</tree>';
		var selector = BehaviorTree.fromXml(xml);
		assertEquals(Failure, selector.tick());
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

	public function testRepeat()
	{
		var behavior = new MockBehavior(Success);
		var repeat = new Repeat(behavior, 4);
		assertEquals(Success, repeat.tick());
		assertEquals(4, behavior.initCalled);
	}

	public function testSequenceTwoChildrenFails()
	{
		var b1 = new MockBehavior();
		var b2 = new MockBehavior();
		var sequence = new Sequence();
		sequence.addChild(b1);
		sequence.addChild(b2);

		assertEquals(Running, sequence.tick());
		assertEquals(0, b1.termCalled);

		b1.returnStatus = Failure;
		assertEquals(Failure, sequence.tick());
		assertEquals(1, b1.termCalled);
		assertEquals(0, b2.initCalled);
	}

	public function testSequenceTwoChildrenContinues()
	{
		var b1 = new MockBehavior();
		var b2 = new MockBehavior();
		var sequence = new Sequence();
		sequence.addChild(b1);
		sequence.addChild(b2);

		assertEquals(Running, sequence.tick());
		assertEquals(0, b1.termCalled);
		assertEquals(0, b2.initCalled);

		b1.returnStatus = Success;
		assertEquals(Running, sequence.tick());
		assertEquals(1, b1.termCalled);
		assertEquals(1, b2.initCalled);
	}

	public function testSequenceOneChildPassThrough()
	{
		for (status in [Success, Failure])
		{
			var b1 = new MockBehavior();
			var sequence = new Sequence();
			sequence.addChild(b1);

			assertEquals(Running, sequence.tick());
			assertEquals(0, b1.termCalled);

			b1.returnStatus = status;
			assertEquals(status, sequence.tick());
			assertEquals(1, b1.termCalled);
		}
	}

	public function testSelectorTwoChildrenContinues()
	{
		var b1 = new MockBehavior();
		var selector = new Selector();
		selector.addChild(b1);
		selector.addChild(new MockBehavior());

		assertEquals(Running, selector.tick());
		assertEquals(0, b1.termCalled);

		b1.returnStatus = Failure;
		assertEquals(Running, selector.tick());
		assertEquals(1, b1.termCalled);
	}

	public function testSelectorTwoChildrenSucceeds()
	{
		var b1 = new MockBehavior();
		var selector = new Selector();
		selector.addChild(b1);
		selector.addChild(new MockBehavior());

		assertEquals(Running, selector.tick());
		assertEquals(0, b1.termCalled);

		b1.returnStatus = Success;
		assertEquals(Success, selector.tick());
		assertEquals(1, b1.termCalled);
	}

	public function testSelectorOneChildPassThrough()
	{
		for (status in [Success, Failure])
		{
			var b1 = new MockBehavior();
			var selector = new Selector();
			selector.addChild(b1);

			assertEquals(Running, selector.tick());
			assertEquals(0, b1.termCalled);

			b1.returnStatus = status;
			assertEquals(status, selector.tick());
			assertEquals(1, b1.termCalled);
		}
	}

	public function testParallelSucceedRequireAll()
	{
		var b1 = new MockBehavior();
		var b2 = new MockBehavior();
		var parallel = new Parallel(RequireAll, RequireOne);
		parallel.addChild(b1);
		parallel.addChild(b2);

		assertEquals(Running, parallel.tick());
		b1.returnStatus = Success;
		assertEquals(Running, parallel.tick());
		b2.returnStatus = Success;
		assertEquals(Success, parallel.tick());
	}

	public function testParallelSucceedRequireOne()
	{
		var b1 = new MockBehavior();
		var b2 = new MockBehavior();
		var parallel = new Parallel(RequireOne, RequireAll);
		parallel.addChild(b1);
		parallel.addChild(b2);

		assertEquals(Running, parallel.tick());
		b1.returnStatus = Success;
		assertEquals(Success, parallel.tick());
	}

	public function testParallelFailureRequireAll()
	{
		var b1 = new MockBehavior();
		var b2 = new MockBehavior();
		var parallel = new Parallel(RequireOne, RequireAll);
		parallel.addChild(b1);
		parallel.addChild(b2);

		assertEquals(Running, parallel.tick());
		b1.returnStatus = Failure;
		assertEquals(Running, parallel.tick());
		b2.returnStatus = Failure;
		assertEquals(Failure, parallel.tick());
	}

	public function testParallelFailureRequireOne()
	{
		var b1 = new MockBehavior();
		var b2 = new MockBehavior();
		var parallel = new Parallel(RequireAll, RequireOne);
		parallel.addChild(b1);
		parallel.addChild(b2);

		assertEquals(Running, parallel.tick());
		b1.returnStatus = Failure;
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
