package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;

class Slime extends FlxSprite
{
	public static inline var GRAVITY:Float = 600;

	public var fsm:FlxFSM<Slime>;

	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);

		loadGraphic("assets/slime.png", true, 16, 16);
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);
		facing = RIGHT;

		animation.add("standing", [0, 1], 3);
		animation.add("walking", [0, 1], 12);
		animation.add("jumping", [2]);
		animation.add("pound", [3]);
		animation.add("landing", [4, 0, 1, 0], 8, false);

		acceleration.y = GRAVITY;
		maxVelocity.set(100, GRAVITY);

		fsm = new FlxFSM(this);
		fsm.transitions.add(Idle, Jump, Conditions.jump);
		fsm.transitions.add(Jump, Idle, Conditions.grounded);
		fsm.transitions.start(Idle);
	}
	
	public function addSuperJump()
	{
		// remove regular jump now
		fsm.transitions.remove(Idle, Jump, Conditions.jump, true);
		fsm.transitions.add(Idle, SuperJump, Conditions.jump);
		// replace the rest when it's safe
		fsm.transitions.replace(Jump, SuperJump, false);
	}
	
	public function addGroundPound()
	{
		fsm.transitions.add(GroundPound, GroundPoundFinish, Conditions.grounded);
		fsm.transitions.add(GroundPoundFinish, Idle, Conditions.animationFinished);
		
		if (fsm.transitions.hasTransition(Idle, Jump))
			fsm.transitions.add(Jump, GroundPound, Conditions.groundSlam);
		
		if (fsm.transitions.hasTransition(Idle, SuperJump))
			fsm.transitions.add(SuperJump, GroundPound, Conditions.groundSlam);
		
	}

	override function update(elapsed:Float):Void
	{
		fsm.update(elapsed);
		super.update(elapsed);
	}

	override function destroy():Void
	{
		fsm.destroy();
		fsm = null;
		super.destroy();
	}
}

class Conditions
{
	public static function jump(Owner:FlxSprite):Bool
	{
		return (FlxG.keys.justPressed.UP && Owner.isTouching(DOWN));
	}

	public static function grounded(Owner:FlxSprite):Bool
	{
		return Owner.isTouching(DOWN);
	}

	public static function groundSlam(Owner:FlxSprite):Bool
	{
		return FlxG.keys.justPressed.DOWN && !Owner.isTouching(DOWN);
	}

	public static function animationFinished(Owner:FlxSprite):Bool
	{
		return Owner.animation.finished;
	}
}

class Idle extends FlxFSMState<Slime>
{
	override function enter(owner:Slime, fsm:FlxFSM<Slime>):Void
	{
		owner.animation.play("standing");
	}

	override function update(elapsed:Float, owner:Slime, fsm:FlxFSM<Slime>):Void
	{
		owner.acceleration.x = 0;
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{
			owner.facing = FlxG.keys.pressed.LEFT ? LEFT : RIGHT;
			owner.animation.play("walking");
			owner.acceleration.x = FlxG.keys.pressed.LEFT ? -300 : 300;
		}
		else
		{
			owner.animation.play("standing");
			owner.velocity.x *= 0.9;
		}
	}
}

class Jump extends FlxFSMState<Slime>
{
	override function enter(owner:Slime, fsm:FlxFSM<Slime>):Void
	{
		owner.animation.play("jumping");
		owner.velocity.y = -200;
	}

	override function update(elapsed:Float, owner:Slime, fsm:FlxFSM<Slime>):Void
	{
		owner.acceleration.x = 0;
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{
			owner.acceleration.x = FlxG.keys.pressed.LEFT ? -300 : 300;
		}
	}
}

class SuperJump extends Jump
{
	override function enter(owner:Slime, fsm:FlxFSM<Slime>):Void
	{
		owner.animation.play("jumping");
		owner.velocity.y = -300;
	}
}

class GroundPound extends FlxFSMState<Slime>
{
	var time:Float;

	override function enter(owner:Slime, fsm:FlxFSM<Slime>):Void
	{
		owner.animation.play("pound");
		owner.velocity.x = 0;
		owner.acceleration.x = 0;
		time = 0;
	}

	override function update(elapsed:Float, owner:Slime, fsm:FlxFSM<Slime>):Void
	{
		time += elapsed;
		if (time < 0.25)
		{
			owner.velocity.y = 0;
		}
		else
		{
			owner.velocity.y = Slime.GRAVITY;
		}
	}
}

class GroundPoundFinish extends FlxFSMState<Slime>
{
	override function enter(owner:Slime, fsm:FlxFSM<Slime>):Void
	{
		owner.animation.play("landing");
		FlxG.camera.shake(0.025, 0.25);
		owner.velocity.x = 0;
		owner.acceleration.x = 0;
	}
}
