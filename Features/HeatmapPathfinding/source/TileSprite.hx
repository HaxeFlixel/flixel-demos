class TileSprite extends flixel.FlxSprite
{
	static inline var TILE_SIZE = PlayState.TILE_SIZE;

	static inline function toTile(value:Float):Int
	{
		return Std.int(value / TILE_SIZE);
	}

	static inline function fromTile(value:Int):Float
	{
		return value * TILE_SIZE;
	}

	public var tileX(get, set):Int;
	public var tileY(get, set):Int;

	inline function get_tileX()
	{
		return toTile(this.x - this.offset.x);
	}

	inline function set_tileX(value:Int)
	{
		this.x = fromTile(value) + this.offset.x;
		return value;
	}

	inline function get_tileY()
	{
		return toTile(this.y - this.offset.y);
	}

	inline function set_tileY(value:Int)
	{
		this.y = fromTile(value) + this.offset.y;
		return value;
	}

	public function new(x = 0.0, y = 0.0, simpleGraphic)
	{
		super(x, y, simpleGraphic);
	}

	public inline function resetToTile(tileX:Int, tileY:Int)
	{
		setTile(tileX, tileY);
		this.last.set(this.x, this.y);
		velocity.set(0, 0);
	}

	public inline function resetToNearestTile(x:Float, y:Float)
	{
		resetToTile(toTile(x), toTile(y));
	}

	public inline function setNearestTile(x:Float, y:Float)
	{
		setTile(toTile(x), toTile(y));
	}

	public inline function setTile(tileX:Int, tileY:Int)
	{
		set_tileX(tileX);
		set_tileY(tileY);
	}

	public inline function tileOverlaps(x:Float, y:Float)
	{
		return toTile(x) == tileX && toTile(y) == tileY;
	}
}
