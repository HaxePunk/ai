package com.haxepunk.ai;

typedef HeuristicFunction = Int->Int->Int->Int->Float;

/**
 * A set of heuristic functions
 */
class Heuristic
{

	public static inline function manhattan(x:Int, y:Int, dx:Int, dy:Int):Float
	{
		return Math.abs(x - dx) + Math.abs(y - dy);
	}

	public static inline function diagonal(x:Int, y:Int, dx:Int, dy:Int):Float
	{
		return Math.max(Math.abs(x - dx), Math.abs(y - dy));
	}

	public static inline function euclidian(x:Int, y:Int, dx:Int, dy:Int):Float
	{
		return Math.sqrt((x - dx) * (x - dx) + (y - dy) * (y - dy));
	}

}