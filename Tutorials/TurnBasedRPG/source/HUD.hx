package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	var healthCounter:FlxText;
	var moneyCounter:FlxText;

	public function new()
	{
		super();
		
		var healthIcon = new FlxSprite(4, 4, AssetPaths.health__png);
		healthCounter = new FlxText(0, 0, 0, "3 / 3", 8);
		healthCounter.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		healthCounter.x = healthIcon.x + healthIcon.width;
		healthCounter.y = healthIcon.y + (healthIcon.height - healthCounter.height) / 2;
		add(healthIcon);
		add(healthCounter);
		
		var moneyIcon = new Coin(0, 4);
		moneyIcon.solid = false;
		moneyCounter = new FlxText(0, 0, 0, "00", 8);
		moneyCounter.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		moneyIcon.x = FlxG.width - 4 - moneyIcon.width - moneyCounter.width;
		moneyCounter.x = moneyIcon.x + moneyIcon.width;
		moneyCounter.y = moneyIcon.y + (moneyIcon.height - moneyCounter.height) / 2;
		moneyCounter.text = "0";
		add(moneyIcon);
		add(moneyCounter);
		
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}

	public function updateHealth(health:Int)
	{
		healthCounter.text = health + " / 3";
	}
	
	public function updateMoney(money:Int)
	{
		moneyCounter.text = Std.string(money);
	}
}
