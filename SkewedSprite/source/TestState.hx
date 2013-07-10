package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flash.ui.Mouse;
import openfl.Assets;
import flash.Lib;
import flixel.ui.FlxButton;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTileblock;
import flixel.text.FlxBitmapTextField;
import flixel.text.pxText.PxBitmapFont;
import flixel.text.pxText.PxTextAlign;

/**
 * ...
 * @author Zaphod
 */
class TestState extends FlxState
{
	public function new()
	{
		super();
	}
	
	override public function create():Void 
	{
		#if flash
		FlxG.framerate = 30;
		FlxG.flashFramerate = 30;
		#else
		FlxG.framerate = 60;
		FlxG.flashFramerate = 60;
		#end
		
		FlxG.state.bgColor = 0xffffffff;
		
		var grass1:Grass = new Grass(0, 0, 0, 0);
		var grass2:Grass = new Grass(0, 0, 1, -5);
		var grass3:Grass = new Grass(0, 0, 2, 5);
		
		add(grass1);
		add(grass2);
		add(grass3);
	}
	
}