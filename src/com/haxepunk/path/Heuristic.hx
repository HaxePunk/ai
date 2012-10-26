package com.haxepunk.path;

typedef HeuristicFunction = Int->Int->Int->Int->Int;

class Heuristic
{
	public static function manhattanMethod(x:Int, y:Int, dx:Int, dy:Int):Int
	{
		x = x - dx;
		y = y - dy;
		return (x < 0 ? -x : x) + (y < 0 ? -y : y);
	}
}