package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * A colored line segment, made up of a starting point and a magnitude + direction vector
 * @author MSGHero
 */
class Segment
{
	public var start:FlxPoint;
	public var vector:FlxPoint;
	public var color:Color;

	public var graphic:FlxSprite;

	public function new(start:FlxPoint, vector:FlxPoint, color:Color)
	{
		this.start = start;
		this.vector = vector;
		this.color = color;
	}

	public function setEnd(end:FlxPoint):Void
	{
		vector.set(end.x - start.x, end.y - start.y);
	}

	public function getEnd():FlxPoint
	{
		return FlxPoint.get(start.x + vector.x, start.y + vector.y);
	}

	public function findIntersection(segment:Segment, ?intersection:FlxPoint):FlxPoint
	{
		// check if collinear and intersecting: this is if the player clicks the same location multiple times with multiple colors
		if (isCollinearIntersection(segment))
		{
			// the entire line is intersecting, so just return the first point
			return start.clone(intersection);
		}

		// otherwise, check if the segments are intersecting at all
		return vector.findIntersectionInBounds(start, segment.start, segment.vector, intersection);
	}

	function isCollinearIntersection(segment:Segment):Bool
	{
		// have to be parallel to be collinear
		if (!vector.isParallel(segment.vector))
			return false;

		var v1 = segment.start.clone();
		v1.subtractPoint(start);

		if (v1.crossProductLength(vector) > FlxPoint.EPSILON_SQUARED)
		{
			// not collinear: perfectly parallel and non-intersecting
			return false;
		}

		var t0 = v1.dotProduct(vector) / vector.dotProduct(vector);
		var t1 = segment.vector.dotProduct(vector) / vector.dotProduct(vector) + t0;

		// true -> overlapping collinear; false -> not overlapping but still collinear
		return t0 >= 0 && t0 <= 1 || t1 >= 0 && t1 <= 1;
	}

	public function toString():String
	{
		return start.toString() + "," + vector.toString() + "," + Std.string(color);
	}

	public static inline function fromEndpoints(start:FlxPoint, end:FlxPoint, color:Color):Segment
	{
		return new Segment(start, end.subtractNew(start), color);
	}
}
