package com.haxepunk.ds;

private typedef PriorityItem<T> = {
	public var value:T;
	public var priority:Int;
};

/**
 * A priority queue class (stores items in priority order)
 */
class PriorityQueue<T>
{

	public function new()
	{
		_items = new Array<PriorityItem<T>>();
	}

	/**
	 * Adds an item with a priority  O(log n)
	 */
	public function enqueue(item:T, priority:Int)
	{
		var obj = {
			value: item,
			priority: priority
		};

		if (length == 0)
		{
			_items.push(obj);
		}
		else
		{
			_items.insert(search(priority), obj);
		}
	}

	/**
	 * Removes the lowest priority item  O(1)
	 */
	public function dequeue():T
	{
		var item =  _items.shift();
		return (item == null) ? null : item.value;
	}

	/**
	 * Check if an item exists in the queue  O(n)
	 */
	public function remove(value:T):Void
	{
		for (item in _items)
		{
			if (item.value == value)
			{
				_items.remove(item);
				break;
			}
		}
	}

	/**
	 * Removes all items from the queue
	 */
	public function clear():Void
	{
#if (cpp || php)
		_items.splice(0, _items.length);
#else
		untyped _items.length = 0;
#end
	}

	/**
	 * Converts values to a string format
	 */
	public function toString():String
	{
		var items = new Array<String>();
		for (item in _items)
		{
			items.push(Std.string(item.priority));
		}
		return "[" + items.join(", ") + "]";
	}

	/**
	 * Returns the number of items in the queue
	 */
	public var length(get_length, never):Int;
	private inline function get_length():Int
	{
		return _items.length;
	}

	/**
	 * Search for the index to insert a specific priority  O(log n)
	 */
	private function search(priority:Int):Int
	{
		var mid:Int, min:Int = 0, max:Int = length - 1;
		while (max >= min)
		{
			mid = min + Std.int((max - min) / 2);
			if (_items[mid].priority < priority)
				min = mid + 1;
			else if (_items[mid].priority > priority)
				max = mid - 1;
			else
				return mid;
		}

		return min;
	}

	private var _items:Array<PriorityItem<T>>;

}
