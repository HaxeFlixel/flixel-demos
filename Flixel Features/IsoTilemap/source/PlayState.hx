package;

import flixel.addons.tile.isoXel.FlxTilemapIso;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.FlxObject;
import flixel.util.FlxPath;
import openfl.Assets;
import flixel.util.FlxPoint;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	/**
	 * Some static constants for the size of the tilemap tiles
	 */
	inline static private var TILE_WIDTH:Int = 50;
	inline static private var TILE_HEIGHT:Int = 25;
	
	private var _hero: Character;
	private var _isoTilemap: FlxTilemapIso;
	private var _path: FlxPath;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		super.create();
		
		//Load our tilemap and add it
		_isoTilemap = new FlxTilemapIso();
		_isoTilemap.loadMap(Assets.getText("data/map.csv"),
				"images/iso_tileset2.png",
				TILE_WIDTH, TILE_HEIGHT, FlxTilemapIso.OFF,
				0, 0);
		add(_isoTilemap);
		
		//Tile 4 is a tile of water
		_isoTilemap.setTileProperties(1, FlxObject.NONE, 3);
		_isoTilemap.setTileProperties(4, FlxObject.ANY);
		
		//Create a character
		_hero = new Character(64, 32);
		add(_hero);
		_hero.animation.play("stop0");
		
		//Create the path
		_path = FlxPath.recycle();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		if (FlxG.keyboard.pressed("LEFT"))
			FlxG.camera.x += 300 * FlxG.elapsed;
		if (FlxG.keyboard.pressed("RIGHT"))
			FlxG.camera.x -= 300 * FlxG.elapsed;
		if (FlxG.keyboard.pressed("UP"))
			FlxG.camera.y += 300 * FlxG.elapsed;
		if (FlxG.keyboard.pressed("DOWN"))
			FlxG.camera.y -= 300 * FlxG.elapsed;

		if (FlxG.keys.pressed.I)
			FlxG.camera.zoom *= 1.1;
		if (FlxG.keys.pressed.O)
			FlxG.camera.zoom /= 1.1;

		if (FlxG.mouse.justPressed)
		{
			var mouse = FlxG.mouse.getWorldPosition();
			mouse.y -= 16;
			var path : Array<FlxPoint> = _isoTilemap.findPath(_hero.getFeetpoint(), mouse);

			if (path != null)
				_path.run(_hero, path);
		}
	}	
}
