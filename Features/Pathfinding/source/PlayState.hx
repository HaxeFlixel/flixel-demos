package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;
import flixel.path.FlxPath;
import flixel.path.FlxPathfinder;
import flixel.math.FlxPoint;
import openfl.Assets;

class PlayState extends FlxState
{
	/**
	 * Unit move speed
	 */
	static inline var MOVE_SPEED:Int = 50;

	static inline var INSTRUCTIONS = "Click in map to place or remove a tile.";
	static inline var NO_PATH_FOUND = "No path found!";
	static inline var MOVE_TO_GOAL = "Move To Goal";
	static inline var STOP_UNIT = "Stop unit";

	/**
	 * Map
	 */
	var map:Tilemap;

	/**
	 * Goal sprite
	 */
	var goal:FlxSprite;

	/**
	 * Unit sprite
	 */
	var unit:FlxSprite;

	/**
	 * Unit action
	 */
	var action:Action = IDLE;

	// pathfinder settings
	var pathfinder = new BigMoverPathfinder(2, 2, WIDE);
	var diagonalPolicy:FlxTilemapDiagonalPolicy = WIDE;
	var simplify = FlxPathSimplifier.LINE;

	/**
	 * Button to move unit to Goal
	 */
	var startStopButton:FlxButton;

	/**
	 * Button to reset unit to start point
	 */
	var resetUnitButton:FlxButton;
	
	/**
	 * Button to set the unit to immovable
	 */
	var immovableButton:FlxButton;

	/**
	 * Instructions
	 */
	var instructions:FlxText;
	
	/**
	 * Whether the user is adding tiles or removing them
	 */
	var isPlacing = false;

	override public function create():Void
	{
		// FlxG.camera.bgColor = 0xFF639bff;

		// Load the map data to map and add to PlayState
		map = new Tilemap("assets/map2.png");
		add(map);

		// Add a visual seperation between map and GUI
		var seperator:FlxSprite = new FlxSprite(map.width, 0);
		seperator.makeGraphic(Std.int(FlxG.width - seperator.width), FlxG.height, FlxColor.GRAY);
		add(seperator);

		// Set goal coordinate and add goal to PlayState
		goal = new FlxSprite();
		goal.makeGraphic(map.tileSize, map.tileSize, 0xffffff00);
		goal.x = map.width - map.tileSize * 2;
		goal.y = map.height - map.tileSize * 2;
		add(goal);

		// Set and add unit to PlayState
		unit = new FlxSprite(0, 0);
		unit.makeGraphic(map.tileSize, map.tileSize, 0xffff0000);
		action = IDLE;
		unit.maxVelocity.x = unit.maxVelocity.y = MOVE_SPEED;
		unit.path = new FlxPath();
		unit.path.immovable = false;
		add(unit);

		var buttonX = FlxG.width - 90;
		var uiY = 10;

		// Add button move to goal to PlayState
		startStopButton = new FlxButton(buttonX, uiY, MOVE_TO_GOAL, startStopPress);
		add(startStopButton);
		uiY += 20;

		// Add button reset unit to PlayState
		resetUnitButton = new FlxButton(buttonX, uiY, "Reset Unit", resetUnit);
		add(resetUnitButton);
		uiY += 20;

		// Add button reset unit to PlayState
		immovableButton = new FlxButton(buttonX, uiY, "Immovable", ()->{ unit.path.immovable = !unit.path.immovable; });
		add(immovableButton);
		uiY += 20;

		// Add some texts
		var textWidth:Int = 85;
		var textX:Int = FlxG.width - textWidth - 5;
		uiY += 20;// gap between buttons and text

		instructions = new FlxText(textX, uiY, textWidth, INSTRUCTIONS);
		add(instructions);
		uiY += 20;

		var legends:FlxText = new FlxText(textX, 0, textWidth, "Legends:\nRed: Unit\nYellow: Goal\nGreen: Wall\nWhite: Path");
		legends.y = FlxG.height - legends.height - 8;
		add(legends);
	}

	override public function destroy():Void
	{
		super.destroy();

		map = null;
		goal = null;
		unit = null;
		startStopButton = null;
		resetUnitButton = null;
		instructions = null;
	}

	override public function draw():Void
	{
		super.draw();

		// To draw path
		if (unit.path != null && !unit.path.finished)
		{
			unit.drawDebug();
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Set unit to collide with map
		FlxG.collide(unit, map);

		var mapChanged = false;

		// Check mouse pressed and unit action
		if (FlxG.mouse.pressed)
		{
			var index = map.getTileIndexByCoords(FlxG.mouse.getWorldPosition());
			if (index != -1)
			{
				var tileEmpty = map.getTileByIndex(index) == 0;
				if (FlxG.mouse.justPressed)
				{
					// start toggle tiles
					isPlacing = tileEmpty;
					map.setTileByIndex(index, isPlacing ? 1 : 0, true);

					mapChanged = true;
				}
				else if (tileEmpty == isPlacing)
				{
					// continue toggling tiles on mouse drag
					map.setTileByIndex(index, isPlacing ? 1 : 0, true);

					mapChanged = true;
				}
			}
		}

		if (action == GO)
		{
			// Check if reach goal
			if (unit.path.finished)
			{
				resetUnit();
				stopUnit();
			}
			// update the path when the map changes
			else if (mapChanged)
			{
				stopUnit();
				moveToGoal();
			}
		}
	}

	function startStopPress()
	{
		switch (action)
		{
			case IDLE:
				moveToGoal();
			case GO:
				stopUnit();
		}
	}

	function moveToGoal():Void
	{
		// Find path to goal from unit to goal
		pathfinder.diagonalPolicy = diagonalPolicy;
		var pathPoints:Array<FlxPoint> = pathfinder.findPath(
			cast map,
			FlxPoint.get(unit.x + unit.width / 2, unit.y + unit.height / 2),
			FlxPoint.get(goal.x + goal.width / 2, goal.y + goal.height / 2),
			simplify
		);

		// Tell unit to follow path
		if (pathPoints != null)
		{
			unit.path.start(pathPoints);
			action = GO;
			instructions.text = INSTRUCTIONS;
		}
		else
		{
			instructions.text = INSTRUCTIONS + "\n\n" + NO_PATH_FOUND;
		}
		
		startStopButton.text = STOP_UNIT;
	}

	function stopUnit():Void
	{
		startStopButton.text = MOVE_TO_GOAL;
		// Stop unit and destroy unit path
		action = IDLE;
		unit.path.cancel();
		unit.velocity.x = unit.velocity.y = 0;
	}

	function resetUnit():Void
	{
		// Reset unit position
		unit.x = 0;
		unit.y = 0;

		// Stop unit
		if (action == GO)
		{
			stopUnit();
		}
	}
}

@:forward
private abstract Tilemap(FlxTilemap) from FlxTilemap to FlxTilemap
{
	/**
	 * Tile width and height
	 */
	static inline var TILE_SIZE:Int = 16;
	
	public var tileSize(get, never):Int;
	inline function get_tileSize()
	{
		return TILE_SIZE;
	}
	
	inline public function new (mapData:String)
	{
		this = new FlxTilemap();
		this.loadMapFromGraphic(
			mapData,
			false, // invert
			1, // scale
			null, // colorMap
			FlxGraphic.fromClass(GraphicAutoFull),
			TILE_SIZE, // tile_width
			TILE_SIZE, // tile_height
			FULL, // autoTile
			0, // startingIndex
			1 // drawIndex
		);
	}
}

enum abstract Action(Int)
{
	var IDLE = 0;
	var GO = 1;
}

class BigMoverPathfinder extends FlxDiagonalPathfinder
{
	public var widthInTiles:Int;
	public var heightInTiles:Int;
	
	public function new(widthInTiles:Int, heightInTiles:Int, diagonalPolicy:FlxTilemapDiagonalPolicy = NONE)
	{
		this.widthInTiles = widthInTiles;
		this.heightInTiles = heightInTiles;
		super(diagonalPolicy);
	}
	
	override function getInBoundDirections(data:FlxPathfinderData, from:Int)
	{
		var x = data.getX(from);
		var y = data.getY(from);
		return FlxDirectionFlags.fromBools
		(
			x > 0,
			x < data.map.widthInTiles - widthInTiles,
			y > 0,
			y < data.map.heightInTiles - widthInTiles
		);
	}
	
	override function canGo(data:FlxPathfinderData, to:Int, dir:FlxDirectionFlags)
	{
		var cols = data.map.widthInTiles;
		return super.canGo(data, to           , dir)
			&& super.canGo(data, to + 1       , dir)
			&& super.canGo(data, to + cols    , dir)
			&& super.canGo(data, to + cols + 1, dir);
	}
	
	override function hasValidInitialData(data:FlxPathfinderData):Bool
	{
		var cols = data.map.widthInTiles;
		var maxX = data.map.widthInTiles - widthInTiles;
		var maxY = data.map.heightInTiles - heightInTiles;
		return data.hasValidStartEnd()
			&& data.getX(data.startIndex) <= maxX
			&& data.getY(data.startIndex) <= maxY
			&& data.getX(data.endIndex) <= maxX
			&& data.getY(data.endIndex) <= maxY
			&& data.getTileCollisionsByIndex(data.startIndex) == NONE
			&& data.getTileCollisionsByIndex(data.startIndex + 1) == NONE
			&& data.getTileCollisionsByIndex(data.startIndex + cols) == NONE
			&& data.getTileCollisionsByIndex(data.startIndex + cols + 1) == NONE
			&& data.getTileCollisionsByIndex(data.endIndex) == NONE
			&& data.getTileCollisionsByIndex(data.endIndex + 1) == NONE
			&& data.getTileCollisionsByIndex(data.endIndex + cols) == NONE
			&& data.getTileCollisionsByIndex(data.endIndex + cols + 1) == NONE;
	}
}