package com.chipacabra.jumper;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import openfl.Assets;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author David Bell
 */
class Coin extends FlxSprite 
{
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
		
		loadGraphic("assets/art/coinspin.png", true, false);
		addAnimation("spinning", [0, 1, 2, 3, 4, 5], 10, true);
		play("spinning");
	}
	
	override public function kill():Void 
	{
		super.kill();
		FlxG.sound.play(Assets.getSound("assets/sounds/coin" + Jumper.SoundExtension), 3, false);
		Reg.score++;
	}
}