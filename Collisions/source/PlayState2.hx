package;
import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

	
class PlayState2 extends FlxState
{
	var _fps:FlxText;
	var _focus:FlxSprite;
	
	public var blocks:FlxGroup;
	public var dispenser:FlxEmitter;
	
	public function new()
	{
		super();
	}
	
	override public function create():Void
	{
		//Background
		FlxG.state.bgColor = 0xffacbcd7;

		//A bunch of blocks
		var block:FlxSprite;
		blocks = new FlxGroup();
		for (i in 0...300)
		{
			block = new FlxSprite(Math.floor(FlxRandom.float() * 40) * 16, Math.floor(FlxRandom.float() * 30) * 16).makeGraphic(16, 16, 0xff233e58);
			block.immovable = true;
			block.moves = false;
			block.active = false;
			blocks.add(block);
		}
		add(blocks);

		//Shoot nuts and bolts all over
		dispenser = new FlxEmitter();
		dispenser.gravity = 0;
		dispenser.setSize(640,480);
		dispenser.setXSpeed(-100,100);
		dispenser.setYSpeed(-100,100);
		dispenser.bounce = 0.65;
		dispenser.makeParticles("assets/gibs.png", 300, 16, true, 0.8);
		dispenser.start(false,10,0.05);
		add(dispenser);
		
		//Camera tracker
		_focus = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic("assets/gibs.png", true);
		_focus.frame = 3;
		_focus.solid = false;
		add(_focus);
		FlxG.camera.follow(_focus);
		FlxG.camera.setBounds(0, 0, 640, 480, true);
		
		//Instructions and stuff
		var tx:FlxText;
		tx = new FlxText(2, FlxG.height - 12, FlxG.width, "Interact with ARROWS + SPACE, or press ENTER for next demo.");
		tx.scrollFactor.x = tx.scrollFactor.y = 0;
		tx.color = 0x49637a;
		add(tx);
	}
	
	override public function update():Void
	{
		//camera controls
		_focus.velocity.x = 0;
		_focus.velocity.y = 0;
		var focusSpeed:Float = 200;
		if(FlxG.keys.LEFT)
			_focus.velocity.x -= focusSpeed;
		if(FlxG.keys.RIGHT)
			_focus.velocity.x += focusSpeed;
		if(FlxG.keys.UP)
			_focus.velocity.y -= focusSpeed;
		if(FlxG.keys.DOWN)
			_focus.velocity.y += focusSpeed;
		
		super.update();
		FlxG.collide();
		if(FlxG.keys.justReleased("ENTER"))
		{
			FlxG.switchState(new PlayState3());
		}
	}
}