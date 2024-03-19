package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxDirectionFlags;
import flixel.addons.display.FlxSliceSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;

import openfl.filters.ColorMatrixFilter;
import openfl.geom.Matrix;
import openfl.geom.Point;

enum CombatOutcome
{
	ESCAPED;
	VICTORY;
	DEFEAT;
}

private enum Choice
{
	FIGHT;
	FLEE;
}

/**
 * A SubState that pauses the main game to show the combat UI
 */
class CombatSubState extends flixel.FlxSubState
{
	/** The UI handling the actual battling */
	var ui:CombatUI;
	
	public function new (player:Player, enemy:Enemy, callback:(CombatOutcome)->Void)
	{
		super();
		
		// Adds a neat wave effect to the game, this helps separate the game from the UI
		var waveEffect = new CombatWaveEffect(4, 4);
		add(waveEffect);
		
		/** Called when the UI determines an outcome of the battle */
		function outcomeReceived(outcome:CombatOutcome)
		{
			// disable the UI, tween it away, then pass the outcome to the callback
			ui.active = false;
			FlxTween.tween(ui, { y:FlxG.height }, 0.5, { ease: FlxEase.backIn, onComplete: 
				function (_)
				{
					// send the result to the play state and close
					callback(outcome);
					close();
				}
			});
			waveEffect.fadeOut(0.5);
		}
		
		// Create the UI
		ui = new CombatUI(player, enemy, outcomeReceived);
		ui.screenCenter();
		// ignore camera scroll to maintain screen position
		ui.scrollFactor.set(0, 0);
		add(ui);
		
		// store target y and then hide UI below the screen
		var targetY = ui.y;
		ui.y = FlxG.height;
		
		// disable the UI, tween it up from the bottom, then enable it
		ui.active = false;
		function onTweenComplete(tween:FlxTween)
		{
			ui.active = true;
		}
		FlxG.camera.flash(FlxColor.WHITE, .2);
		FlxTween.tween(ui, { y:targetY }, 0.5,
			{
				startDelay: 0.2,// wait for flash
				ease: FlxEase.backOut,
				onComplete: onTweenComplete
			}
		);
		waveEffect.fadeIn(1.0);
	}
}

/**
 * The UI that controls combat, extends `FlxSpriteGroup` which changes its members
 * when certain properties are changed, namely `x`, `y`, `alpha` and `scrollFactor`.
 */
class CombatUI extends FlxSpriteGroup
{
	/** A function that handles the outcome of this match */
	var callback:(CombatOutcome)->Void;
	
	/** A reference to the player sprite in the main game */
	var player:Player;
	/** A sprite representing our hero */
	var playerIcon:FlxSprite;
	/** Used to show the result of attacks */
	var playerDmg:FlxText;
	/** Displays the player's health */
	var playerHealthBar:FlxBar;
	
	/** A reference to our current opponent in the main game */
	var enemy:Enemy;
	/** A sprite representing our enemy */
	var enemyIcon:FlxSprite;
	/** Used to show the result of attacks */
	var enemyDmg:FlxText;
	/** Displays the enemy's health */
	var enemyHealthBar:FlxBar;
	
	/** A group of texts that show damage or missed attacks */
	var attackResults:FlxTypedGroup<FlxText>;
	
	/** Shows the currently selected option (FIGHT or FLEE). */
	var pointer:FlxSprite; 
	/** Tracks which option is selected */
	var selected:Choice = FIGHT; 
	/** Contains text displaying our 2 options: FIGHT and FLEE */
	var choices:Map<Choice, FlxSprite>; 
	
	public function new (player:Player, enemy:Enemy, callback:(CombatOutcome)->Void)
	{
		this.callback = callback;
		this.player = player;
		this.enemy = enemy;
		super();
		
		// Make a background to visially separate the ui from the game underneath
		var bg = new FlxSliceSprite(AssetPaths.uiback__png, new FlxRect(16, 16, 16, 16), 128, 128);
		// Stretch the sections rather than tiling for better performance
		bg.stretchTop
			= bg.stretchRight
			= bg.stretchLeft
			= bg.stretchBottom
			= bg.stretchCenter
			= true;
		add(bg);
		
		final border = 6;
		var section = new FlxSliceSprite(AssetPaths.ui_section__png, new FlxRect(16, 16, 16, 16), bg.width - border * 2, 72);
		section.x = border;
		section.y = bg.height - section.height - border;
		// Stretch the sections rather than tiling for better performance
		section.stretchTop
			= bg.stretchRight
			= bg.stretchLeft
			= bg.stretchBottom
			= section.stretchCenter
			= true;
		add(section);
		
		// Make a 'dummy' player and health bar
		playerIcon = createAvatar(24, 8, player, player.maxHP);
		playerIcon.facing = RIGHT;
		
		// Make a 'dummy' enemy and health bar
		enemyIcon = createAvatar(80, 8, enemy, enemy.maxHP);
		enemyIcon.facing = LEFT;
		
		attackResults = new FlxTypedGroup();
		for (i in 0...2)
		{
			var text = new FlxText(0, 0);
			// Use same color as the pointer
			text.color = 0xFFe5e5e5;
			text.setBorderStyle(SHADOW, FlxColor.RED);
			attackResults.add(text);
			add(text);
			text.kill();
		}
		
		// create our choices and add them to the group.
		choices = new Map();
		choices[FIGHT] = new LargeText(40, 64, "FIGHT", 2);
		choices[FLEE] = new LargeText(40, choices[FIGHT].y + choices[FIGHT].height + 10, "FLEE", 2);
		add(choices[FIGHT]);
		add(choices[FLEE]);
		
		pointer = new FlxSprite(16, choices[FIGHT].y + (choices[FIGHT].height / 2) - 8, AssetPaths.pointer__png);
		add(pointer);
	}
	
	/**
	 * Creates and adds an Icon and health bar for the target fighter
	 */
	function createAvatar(x:Float, y:Float, target:FlxSprite, maxHealth:Float)
	{
		// Create an "dummy" icon of the target
		var icon = new FlxSprite(x, y);
		// Use the target's graphic to have the same frames
		icon.loadGraphicFromSprite(target);
		icon.animation.play("lr_idle");
		
		icon.setFacingFlip(LEFT, true, false);
		icon.setFacingFlip(RIGHT, false, false);
		add(icon);
		
		// create a health bar
		var bar = new FlxBar(0, icon.y + icon.height + 2, LEFT_TO_RIGHT, 30, 10);
		bar.createFilledBar(0xffdc143c, FlxColor.YELLOW, true, FlxColor.YELLOW);
		bar.setRange(0, maxHealth);
		// tracks the target's health automatically
		bar.parent = target;
		bar.parentVariable = "hp";
		bar.update(0);//redraw
		// yellow bar, yellow border, red underneath
		centerOn(bar, icon, X);
		add(bar);
		
		return icon;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		// Only check input between turns when the pointer is showing
		if (pointer.exists)
		{
			#if FLX_KEYBOARD
			updateKeyboardInput();
			#end
			
			#if FLX_TOUCH
			updateTouchInput();
			#end
		}
	}
	
	/**
	 * Call this function to place the pointer next to the currently selected choice
	 */
	inline function hilightChoice(choice:Choice)
	{
		selected = choice;
		centerOn(pointer, choices[selected], Y);
	}
	
	#if FLX_KEYBOARD
	function updateKeyboardInput()
	{
		// Create helper func with shorter name
		var justPressed = FlxG.keys.anyJustPressed;
		var justReleased = FlxG.keys.anyJustReleased;
		if (justPressed([SPACE, X, ENTER]))
		{
			FlxG.sound.play(AssetPaths.select__wav);
			onChoose(selected);
		}
		// if the playerSprite presses up or down (but not both)
		else if (justReleased([W, UP]) != justReleased([S, DOWN]))
		{
			FlxG.sound.play(AssetPaths.select__wav);
			// Move the cursor up or down (with wrapping)
			hilightChoice(selected == FIGHT ? FLEE : FIGHT);
		}
	}
	#end

	#if FLX_TOUCH
	function updateTouchInput()
	{
		for (touch in FlxG.touches.justReleased())
		{
			for (choice in choices.keys())
			{
				var text = choices[choice];
				if (touch.overlaps(text))
				{
					FlxG.sound.play(AssetPaths.select__wav);
					hilightChoice(choice);
					onChoose(choice);
					return;
				}
			}
		}
	}
	#end
	
	function onChoose(selected:Choice)
	{
		// kill texts from last round
		attackResults.killMembers();
		// hide our pointer
		pointer.exists = false;
		// check which item was selected when the playerSprite picked it
		switch (selected)
		{
			case FIGHT:
				playerAttack();
				
			case FLEE:
				// 50% chance to flee
				if (FlxG.random.bool(50))
				{
					// Success
					FlxG.sound.play(AssetPaths.fled__wav);
					showOutcome(ESCAPED);
				}
				else
				{
					// Failure, enemy gets a free attack
					enemyAttack();
				}
		}
	}
	
	function showAttackResult(icon:FlxSprite, msg:String, ?onComplete:()->Void)
	{
		// recycle dead text
		var text = attackResults.recycle();
		text.text = msg;
		centerOn(text, icon, XY);
		// text.alpha = 0;
		
		var callback = onComplete != null ? (_)->onComplete() : null;
		FlxTween.tween(text, { alpha: 2 }, 0.5, { ease: FlxEase.circOut, onComplete: callback });
		FlxTween.tween(text, { y: text.y - 12 }, 1, { ease: FlxEase.circOut, onComplete:(_)->text.kill() });
	}
	
	function playerAttack()
	{
		// Move the player towards the enemy then back
		FlxTween.tween(playerIcon, {x: playerIcon.x + 12}, 0.1)
			.then(FlxTween.tween(playerIcon, {x: playerIcon.x}, 0.1));
	
		var result:String;
		// 85% chance for player to hit
		if (FlxG.random.bool(85))
		{
			// Success
			FlxG.sound.play(AssetPaths.hurt__wav);
			// Move the enemy, then move it back
			FlxTween.tween(enemyIcon, {x: enemyIcon.x + 4}, 0.1, {startDelay: 0.1})
				.then(FlxTween.tween(enemyIcon, {x: enemyIcon.x}, 0.1));
			
			// Deal 1 damage to the enemy
			enemy.hurt(1);
			result = "1";
		}
		else
		{
			// We missed
			FlxG.sound.play(AssetPaths.miss__wav);
			result = "MISS!";
		}
		
		// Show the attack result then it's the enemy's turn
		if (enemy.hp > 0)
			showAttackResult(enemyIcon, result, enemyAttack);
		else
			showAttackResult(enemyIcon, result, roundEnd);
	}
	
	function enemyAttack()
	{
		// Move the enemy towards the player, then move it back
		FlxTween.tween(enemyIcon, {x: enemyIcon.x - 12}, 0.1)
			.then(FlxTween.tween(enemyIcon, {x: enemyIcon.x}, 0.1));
		
		var result:String;
		// 30% chance to hit
		if (FlxG.random.bool(30))
		{
			// Flash the screen white
			FlxG.camera.flash(FlxColor.WHITE, .2);
			FlxG.camera.shake(0.01, 0.2);
			
			// Move the enemy, then move it back
			FlxTween.tween(playerIcon, {x: playerIcon.x - 4}, 0.1, {startDelay: 0.1})
				.then(FlxTween.tween(playerIcon, {x: playerIcon.x}, 0.1));
			// Deal 1 damage
			player.hurt(1);
			FlxG.sound.play(AssetPaths.hurt__wav);
			result = "1";
		}
		else
		{
			// Missed
			FlxG.sound.play(AssetPaths.miss__wav);
			result = "MISS!";
		}
		
		showAttackResult(playerIcon, result, roundEnd);
	}
	
	function roundEnd()
	{
		if (player.hp <= 0)
			showOutcome(DEFEAT);
		else if (enemy.hp <= 0)
			showOutcome(VICTORY);
		else
		{
			// Enables UI for net turn
			pointer.exists = true;
		}
	}
	
	function showOutcome(outcome:CombatOutcome)
	{
		var text = new LargeText(0, 0, outcome.getName(), 3);
		text.color = FlxColor.YELLOW;
		text.setBorderStyle(SHADOW, FlxColor.GRAY);
		// Adding a sprite to a sprite group will change the x/y by the group's, so add first
		add(text);
		text.screenCenter();
		
		// Store desired y, then tween to it
		var targetY = text.y;
		text.y = -text.height;
		FlxTween.tween(text, { y: targetY }, 1, { ease: FlxEase.backOut, onComplete:
			function (_)
			{
				// Hold it there for a sec, then start the outro
				new FlxTimer().start(1.0, (_)->callback(outcome));
			}
		});
	}
	
	/**
	 * Centers the first sprite's so it's center x mathes the center x of the target
	 */
	static inline function centerOn(sprite:FlxSprite, target:FlxSprite, axes:FlxAxes = XY)
	{
		if (axes.x)
			sprite.x = target.x + (target.width - sprite.width) / 2;
		if (axes.y)
			sprite.y = target.y + (target.height - sprite.height) / 2;
	}
}

/**
 * Helper class that handles the wave effect
 */
private class CombatWaveEffect extends FlxEffectSprite
{
	/**
	 * [Description]
	 * @param  strength  How strong you want the effect
	 * @param  speed     How fast you want the effect to move, higher values = faster
	 */
	public function new(strength = 10, speed = 3.0)
	{
		var screen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		super(screen, [new FlxWaveEffect(FlxWaveMode.ALL, strength, -1, speed)]);
		scrollFactor.set(0, 0);
		
		// Draw the camera to a bitmap
		screen.drawFrame();
		var screenPixels = screen.framePixels;
		if (FlxG.renderBlit)
			screenPixels.copyPixels(FlxG.camera.buffer, FlxG.camera.buffer.rect, new Point());
		else
			screenPixels.draw(FlxG.camera.canvas, new Matrix(1, 0, 0, 1, 0, 0));
		
		// Apply desaturating color matrix
		var rc:Float = 1 / 3;
		var gc:Float = 1 / 2;
		var bc:Float = 1 / 6;
		screenPixels.applyFilter(screenPixels, screenPixels.rect, new Point(),
			new ColorMatrixFilter([rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]));
	}
	
	/**
	 * Tweens the `alpha` and `strength` from 0
	 * @param   time  The duration of the fade
	 */
	public function fadeIn(time:Float)
	{
		var waveEffect:FlxWaveEffect = cast this.effects[0];
		var strength = waveEffect.strength;
		// Fade effect in
		// alpha = 0;
		FlxTween.num(0.0, 1.0, time, (n)->
		{
			alpha = n;
			waveEffect.strength = Math.floor(strength * FlxEase.circOut(Math.max(n - 0.5, 0) * 2));
		});
	}
	
	/**
	 * Tweens the `alpha` and `strength` to 0
	 * @param   time  The duration of the fade
	 */
	public function fadeOut(time:Float)
	{
		var waveEffect:FlxWaveEffect = cast this.effects[0];
		var strength = waveEffect.strength;
		// Fade effect in
		// alpha = 1.0;
		FlxTween.num(1.0, 0.0, time, (n)->
		{
			alpha = n;
			waveEffect.strength = Math.floor(strength * FlxEase.circOut(Math.max(n - 0.5, 0) * 2));
		});
	}
}