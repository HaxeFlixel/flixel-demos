package;
import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.FlxG;
import flixel.group.FlxGroup;

class Glitches extends FlxGroup
{
	public function new()
	{
		super();
		
		for (i in 0...16)
		{
			add(new Glitch());
		}
	}
	
	public function onBeat():Void
	{
		var sprite:Glitch;
		for (i in 0...length)
		{
			sprite = cast(members[i], Glitch);
			sprite.reset(Std.int(FlxRandom.float() * 16) * 16, Std.int(FlxRandom.float() * 12) * 16);
		}
	}
}