package;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public static inline var TILE_SIZE = 16;

	public var tilemap:FlxTilemap;
	public var distmap:DistanceTilemap;

	public var mcguffin:TileSprite;
	public var mouseState:MouseState = NONE;

	public var seekers:FlxTypedGroup<Seeker>;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		bgColor = FlxColor.WHITE;
		super.create();
		makeTiles();

		openSubState(new InstructionState());
	}

	function makeTiles():Void
	{
		tilemap = new FlxTilemap();
		distmap = new DistanceTilemap(tilemap);
		tilemap.scale.set(TILE_SIZE, TILE_SIZE);
		distmap.scale.set(TILE_SIZE, TILE_SIZE);

		final cols = Std.int(FlxG.width / TILE_SIZE);
		final rows = Std.int(FlxG.height / TILE_SIZE);
		final mapData = [for (i in 0...cols * rows) 0];
		
		FlxTypedTilemap.defaultFramePadding = 0;
		
		distmap.createEmptyHeatmap(cols, rows);
		add(distmap);
		
		final tileSize = 16;
		tilemap.loadMapFromArray(mapData, cols, rows, FlxGraphic.fromClass(GraphicAutoFull), tileSize, tileSize, FULL, 0, 0, 1);
		add(tilemap);
		tilemap.scale.set(TILE_SIZE / tileSize, TILE_SIZE / tileSize);

		seekers = new FlxTypedGroup<Seeker>();
		add(seekers);

		mcguffin = new TileSprite(0, 0, "assets/images/mcguffin.png");
		add(mcguffin);

		mcguffin.setTile(0, 0);
		updateDistanceMap();
		
		placeInactiveSeeker();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		updateInput(elapsed);
		updateSeekers(elapsed);
	}
	
	function updateInput(elapsed:Float)
	{
		final mouse = FlxG.mouse.getWorldPosition();
		
		if (FlxG.mouse.justPressed)
		{
			if (mcguffin.tileOverlaps(mouse.x, mouse.y))
				mouseState = DRAG(mcguffin);
			else
			{
				for (seeker in seekers)
				{
					if (seeker.tileOverlaps(mouse.x, mouse.y))
					{
						mouseState = DRAG(seeker);
						break;
					}
				}
			}

			if (mouseState.match(NONE))
			{
				final tile = getTileAt(mouse.x, mouse.y);
				mouseState = tile == 0 ? PLACING_WALLS : REMOVING_WALLS;
			}
		}

		if (FlxG.mouse.justReleased)
		{
			switch (mouseState)
			{
				case DRAG(obj) if (obj is Seeker):
					obj.active = true;
				default:
			}
			mouseState = NONE;
		}

		if (FlxG.mouse.pressed)
		{
			switch (mouseState)
			{
				case DRAG(obj):
					obj.setNearestTile(mouse.x, mouse.y);
					if (obj == mcguffin)
						updateDistanceMap();
					else if (obj is Seeker && obj.active == false)
					{
						// add a new seeker to be placed
						if (obj.active == false)
							placeInactiveSeeker();
						
						obj.active = false;
						
						// add a new seeker to be placed
						placeInactiveSeeker();
					}
				case REMOVING_WALLS:
					setTileAt(mouse.x, mouse.y, 0);
				case PLACING_WALLS:
					setTileAt(mouse.x, mouse.y, 1);
				case NONE:
					throw "Unexpected mouseState: NONE";
			}
		}
	}

	function updateSeekers(elapsed:Float):Void
	{
		final targetX = mcguffin.tileX;
		final targetY = mcguffin.tileY;
		for (seeker in seekers)
		{
			if (seeker.exists && seeker.active && !seeker.moves)
			{
				if (seeker.tileX == targetX && seeker.tileY == targetY)
				{
					seeker.kill();
				}
				else
				{
					final toIndex = distmap.getIndexOfBestNeighbor(seeker.tileX, seeker.tileY);
					final tileX = toIndex % distmap.widthInTiles;
					final tileY = Std.int(toIndex / distmap.widthInTiles);
					seeker.moveToTile(tileX, tileY);
				}
			}
		}
	}

	function placeInactiveSeeker():Void
	{
		final seeker = seekers.recycle(Seeker.new);
		seeker.resetToTile(distmap.widthInTiles - 2, distmap.heightInTiles - 2);
		seeker.active = false;
	}

	function updateDistanceMap():Void
	{
		distmap.redraw(mcguffin.tileX, mcguffin.tileY);
	}

	function getTileAt(x:Float, y:Float):Int
	{
		return tilemap.getTile(Std.int(x / TILE_SIZE), Std.int(y / TILE_SIZE));
	}

	function setTileAt(x:Float, y:Float, value:Int):Void
	{
		tilemap.setTile(Std.int(x / TILE_SIZE), Std.int(y / TILE_SIZE), value, true);

		updateDistanceMap();
	}
}

enum MouseState
{
	PLACING_WALLS;
	REMOVING_WALLS;
	DRAG(obj:TileSprite);
	NONE;
}
