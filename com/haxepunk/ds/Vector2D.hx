package com.haxepunk.ds;

class Point
{
	public var x:Float = 0;
	public var y:Float = 0;

	public function new(x:Float = 0, y:Float = 0)
	{
		this.x = x;
		this.y = y;
	}
}

abstract Vector2D(Point)
{
	public inline function new(x:Float, y:Float) { this = new Point(x, y); }

	public var x(get,never):Float;
	private inline function get_x():Float { return this.x; }

	public var y(get,never):Float;
	private inline function get_y():Float { return this.y; }

	public inline function dot(b:Vector2D):Float {
		return x * b.x + y * b.y;
	}

	public inline function cross(b:Vector2D):Float {
		return x * b.x - y * b.y;
	}

	public inline function rotate(angle:Float):Vector2D {
		var sin:Float = Math.sin(angle),
			cos:Float = Math.cos(angle);
		return new Vector2D(x * cos - y * sin, x * sin + y * cos);
	}

	public var squareLength(get,never):Float;
	private inline function get_squareLength():Float {
		return x * x + y * y;
	}

	public var length(get,never):Float;
	private inline function get_length():Float {
		return Math.sqrt(squareLength);
	}

	public var angle(get,never):Float;
	private inline function get_angle():Float {
		return Math.atan2(y, x);
	}

	public var unit(get,never):Vector2D;
	public inline function get_unit():Vector2D {
		var len = length;
		return new Vector2D(x / len, y / len);
	}

	@:op(A + B) static public function add(a:Vector2D, b:Vector2D):Vector2D {
		return new Vector2D(a.x + b.x, a.y + b.y);
	}

	@:op(A - B) static public function sub(a:Vector2D, b:Vector2D):Vector2D {
		return new Vector2D(a.x - b.x, a.y - b.y);
	}

	@:commutative @:op(A * B) static public function scalar_mult(a:Vector2D, b:Float):Vector2D {
		return new Vector2D(a.x * b, a.y * b);
	}

	@:op(A / B) static public function scalar_divide(a:Vector2D, b:Float):Vector2D {
		return new Vector2D(a.x / b, a.y / b);
	}
}