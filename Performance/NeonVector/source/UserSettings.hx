package;

import flixel.FlxG;

/**
 * @author Masadow
 */
class UserSettings
{
	static var _highScore:UInt = 0;
	public static var highScore(get, set):UInt;

	public static function get_highScore():UInt
	{
		if (FlxG.save.data.highScore != null)
			return FlxG.save.data.highScore;
		else
			return _highScore;
	}

	public static function set_highScore(value:UInt):UInt
	{
		FlxG.save.data.highScore = value;
		return _highScore = value;
	}

	public static function load():Void
	{
		// if (FlxG.save.data.levels == null) FlxG.save.data.levels = 0;
		if (FlxG.save.data.highScore == null)
		{
			// FlxG.log("loading default high score of 0 ...");
			FlxG.save.data.highScore = 0;
			PlayerShip.highScore = 0;
		}
		else
		{
			// FlxG.log("loading previous high score ...");
			FlxG.save.data.highScore = highScore;
			PlayerShip.highScore = highScore;
		}
	}

	public static function save():Void
	{
		FlxG.save.flush();
	}
}
