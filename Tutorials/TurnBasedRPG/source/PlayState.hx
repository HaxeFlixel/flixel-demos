package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.sound.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
#if mobile
import flixel.ui.FlxVirtualPad;
#end
import ui.CombatSubState;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	var player:Player;
	var walls:FlxTilemap;
	var coins:FlxTypedGroup<Coin>;
	var enemies:FlxTypedGroup<Enemy>;

	var hud:HUD;
	var money:Int = 0;

	#if mobile
	public static var virtualPad:FlxVirtualPad;
	#end

	override public function create()
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end

		var map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_001__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.follow();
		walls.setTileProperties(0, NONE, null, null, 16);
		walls.setTileProperties(16, ANY, null, null, 20);
		add(walls);

		coins = new FlxTypedGroup<Coin>();
		add(coins);

		enemies = new FlxTypedGroup<Enemy>();
		add(enemies);

		player = new Player();
		map.loadEntities(placeEntities, "entities");
		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);

		hud = new HUD();
		add(hud);

		#if mobile
		virtualPad = new FlxVirtualPad(FULL, NONE);
		add(virtualPad);
		#end

		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

		super.create();
	}

	function placeEntities(entity:EntityData)
	{
		var x = entity.x;
		var y = entity.y;

		switch (entity.name)
		{
			case "player":
				player.setPosition(x, y);

			case "coin":
				coins.add(new Coin(x + 4, y + 4));

			case "enemy":
				enemies.add(new Enemy(x + 4, y, REGULAR));

			case "boss":
				enemies.add(new Enemy(x + 4, y, BOSS));
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		FlxG.collide(player, walls);
		FlxG.overlap(player, coins, playerTouchCoin);
		FlxG.collide(enemies, walls);
		enemies.forEachAlive(checkEnemyVision);
		FlxG.overlap(player, enemies, playerTouchEnemy);
	}

	function playerTouchCoin(player:Player, coin:Coin)
	{
		if (player.alive && player.exists && coin.alive && coin.exists)
		{
			coin.kill();
			money++;
			hud.updateMoney(money);
			FlxG.sound.play(AssetPaths.coin__wav);
		}
	}

	function checkEnemyVision(enemy:Enemy)
	{
		enemy.checkVision(player, walls);
	}

	function playerTouchEnemy(player:Player, enemy:Enemy)
	{
		if (player.alive && player.exists && enemy.alive && enemy.exists && !enemy.isFlickering())
		{
			startCombat(enemy);
		}
	}

	function startCombat(enemy:Enemy)
	{
		#if mobile
		virtualPad.visible = false;
		#end
		
		FlxG.sound.play(AssetPaths.combat__wav);
		openSubState(new CombatSubState(player, enemy, (outcome)->handleCombatOutcome(outcome, enemy)));
	}
	
	function handleCombatOutcome(outcome:CombatOutcome, enemy:Enemy)
	{
		hud.updateHealth(player.hp);
		switch(outcome)
		{
			case VICTORY:
				enemy.kill();
				if (enemy.type == BOSS)
					fadeToGameOver(true);
			case ESCAPED:
				enemy.flicker();
			case DEFEAT:
				player.alive = false;
				
				fadeToGameOver(false);
		}
	}
	
	function fadeToGameOver(won:Bool)
	{
		function onComplete()
		{
			FlxG.switchState(()->new GameOverState(won, money));
		}
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, onComplete);
	}
}
