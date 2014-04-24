package com.haxepunk.ai.path;

typedef HeuristicFunction = Float->Float->Float->Float->Float;

/**
 * A set of heuristic functions
 */
class Heuristic
{

	public static inline function manhattan(x:Float, y:Float, dx:Float, dy:Float):Float
	{
		return Math.abs(x - dx) + Math.abs(y - dy);
	}

	public static inline function diagonal(x:Float, y:Float, dx:Float, dy:Float):Float
	{
		return Math.max(Math.abs(x - dx), Math.abs(y - dy));
	}

	public static inline function euclidian(x:Float, y:Float, dx:Float, dy:Float):Float
	{
		return Math.sqrt((x - dx) * (x - dx) + (y - dy) * (y - dy));
	}

}