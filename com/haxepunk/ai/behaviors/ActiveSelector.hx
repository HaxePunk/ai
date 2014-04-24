package com.haxepunk.ai.behaviors;

class ActiveSelector extends Selector
{
	override private function initialize()
	{
		current = children.iterator();
	}
}