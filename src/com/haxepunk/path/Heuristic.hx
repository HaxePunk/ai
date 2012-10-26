package com.haxepunk.path;

typedef HeuristicFunction = Int->Int->Int->Int->Float;

/**
 * A set of heuristic functions
 */
class Heuristic
{

	public static function manhattan(x:Int, y:Int, dx:Int, dy:Int):Float
	{
		return Math.abs(x - dx) + Math.abs(y - dy);
	}

	public static function diagonal(x:Int, y:Int, dx:Int, dy:Int):Float
	{
		return Math.max(Math.abs(x - dx), Math.abs(y - dy));
	}

	public static function euclidian(x:Int, y:Int, dx:Int, dy:Int):Float
	{
		return Math.sqrt((x - dx) * (x - dx) + (y - dy) * (y - dy));
	}

}