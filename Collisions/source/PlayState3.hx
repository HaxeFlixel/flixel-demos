package;
import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;



class PlayState3 extends FlxState
{
	var _fps:FlxText;
	
	var _platform:FlxSprite;
	
	public function new()
	{
		super();
	}
	
	override public function create():Void
	{
		//Limit collision boundaries to just this screen (since we don't scroll in this one)
		FlxG.worldBounds.make(0, 0, FlxG.width, FlxG.height);
		
		//Background
		FlxG.state.bgColor = 0xffacbcd7;
		
		//The thing you can move around
		_platform = new FlxSprite((FlxG.width - 64) / 2, 200).makeGraphic(64, 16, 0xff233e58);
		_platform.immovable = true;
		add(_platform);
		
		//Pour nuts and bolts out of the air
		var dispenser:FlxEmitter = new FlxEmitter((FlxG.width - 64) / 2, -64);
		dispenser.gravity = 200;
		dispenser.setSize(64,64);
		dispenser.setXSpeed(-20,20);
		dispenser.setYSpeed(50,100);
		dispenser.setRotation(-720,720);
		//dispenser.bounce = 0.1;
		dispenser.makeParticles("assets/gibs.png", 300, 16, true, 0.5);
		dispenser.start(false, 5, 0.025);
		add(dispenser);
		
		//Instructions and stuff
		var tx:FlxText;
		tx = new FlxText(2, FlxG.height - 12, FlxG.width, "Interact with ARROWS + SPACE, or press ENTER for next demo.");
		tx.scrollFactor.x = tx.scrollFactor.y = 0;
		tx.color = 0x49637a;
		add(tx);
	}
	
	override public function update():Void
	{
		//Platform controls
		var v:Float = 50;
		if(FlxG.keys.SPACE)
			v *= 3;
		_platform.velocity.x = 0;
		if(FlxG.keys.LEFT)
			_platform.velocity.x -= v;
		if(FlxG.keys.RIGHT)
			_platform.velocity.x += v;
		
		super.update();
		FlxG.collide();
		if(FlxG.keys.justReleased("ENTER"))
			FlxG.switchState(new PlayState());
	}
}