package; 

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	public var level:TiledLevel;
	
	public var score:FlxText;
	public var status:FlxText;
	public var coins:FlxGroup;
	public var player:FlxSprite;
	public var floor:FlxObject;
	public var exit:FlxSprite;
	
	private static var youDied:Bool = false;
	
	override public function create():Void 
	{
		FlxG.mouse.visible = false;
		
		//super.create();
		bgColor = 0xffaaaaaa;
		
		// Load the level's tilemaps
		level = new TiledLevel("assets/tiled/level.tmx");
		
		// Add tilemaps
		add(level.foregroundTiles);
		
		// Draw coins first
		coins = new FlxGroup();
		add(coins);
		
		// Load player objects
		level.loadObjects(this);
		
		// Add background tiles after adding level objects, so these tiles render on top of player
		add(level.backgroundTiles);
		
		// Create UI
		score = new FlxText(2, 2, 80);
		score.scrollFactor.set(0, 0); 
		score.borderColor = 0xff000000;
		score.borderStyle = FlxText.BORDER_SHADOW;
		score.text = "SCORE: " + (coins.countDead() * 100);
		add(score);
		
		status = new FlxText(FlxG.width - 160 - 2, 2, 160);
		status.scrollFactor.set(0, 0);
		status.borderColor = 0xff000000;
		score.borderStyle = FlxText.BORDER_SHADOW;
		status.alignment = "right";
		
		if (youDied == false)
			status.text = "Collect coins.";
		else
			status.text = "Aww, you died!";
		
		add(status);
	}
	
	override public function update():Void 
	{
		player.acceleration.x = 0;
		if (FlxG.keys.pressed.LEFT)
		{
			player.acceleration.x = -player.maxVelocity.x * 4;
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			player.acceleration.x = player.maxVelocity.x * 4;
		}
		if (FlxG.keys.pressed.SPACE && player.isTouching(FlxObject.FLOOR))
		{
			player.velocity.y = -player.maxVelocity.y / 2;
		}
		super.update();
		
		FlxG.overlap(coins, player, getCoin);
		
		// Collide with foreground tile layer
		level.collideWithLevel(player);
		
		FlxG.overlap(exit, player, win);
		
		if (FlxG.overlap(player, floor))
		{
			youDied = true;
			FlxG.resetState();
		}
	}
	
	public function win(Exit:FlxObject, Player:FlxObject):Void
	{
		status.text = "Yay, you won!";
		score.text = "SCORE: 5000";
		player.kill();
	}
	
	public function getCoin(Coin:FlxObject, Player:FlxObject):Void
	{
		Coin.kill();
		score.text = "SCORE: " + (coins.countDead() * 100);
		if (coins.countLiving() == 0)
		{
			status.text = "Find the exit";
			exit.exists = true;
		}
	}
	
}