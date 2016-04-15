package;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxAxes;

/**
 * A FlxState which is shown when the player wins.
 */
class VictoryState extends FlxState
{
	private var _timer:Float = 0;
	private var _fading:Bool = false;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.cameras.flash(0xffd8eba2);
		
		// Gibs emitted upon death
		var gibs = new FlxEmitter(0, -50);
		gibs.width = FlxG.width;
		gibs.velocity.set(0, 0, 0, 100);
		gibs.angularVelocity.set( -360, 360);
		gibs.acceleration.set(0, 80);
		gibs.loadParticles(Reg.SPAWNER_GIBS, 800, 32, true);
		add(gibs);
		gibs.start(false, 0.005);
		
		var text = new FlxText(0, 0, FlxG.width, "VICTORY\n\nSCORE: " + Reg.score, 16);
		text.alignment = CENTER;
		text.color = 0xffD8EBA2;
		text.screenCenter(FlxAxes.Y);
		add(text);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		if (!_fading)
		{
			_timer += elapsed;
			
			if (_timer > 0.35 && (_timer > 10
				#if !FLX_NO_KEYBOARD || FlxG.keys.anyJustPressed([X, C]) #end ))
			{
				_fading = true;
				FlxG.sound.play("MenuHit2");
				FlxG.cameras.fade(0xff131c1b, 2, false, function()
				{
					FlxG.switchState(new PlayState());
				});
			}
		}
		
		super.update(elapsed);
	}
}