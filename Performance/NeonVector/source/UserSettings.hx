package;

import flixel.FlxG;

/**
 * @author Masadow
 */
class UserSettings
{
	/** Whether bind() was successful */
	static var _saveLoaded(get, never):Bool;

	static var _highScore:UInt = 0;
	static var _tempHighScore:UInt;
	public static var highScore(get, set):UInt;

	public static function get_highScore():UInt
	{
		if (_saveLoaded)
			return FlxG.save.data.highScore;
		else
			return _highScore;
	}

	public static function set_highScore(value:UInt):UInt
	{
		if (_saveLoaded)
			FlxG.save.data.highScore = value;
		else
			_tempHighScore = value;
		return value;
	}

	public static function load():Void
	{
		if (_saveLoaded)
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
				FlxG.save.data.highScore = UserSettings.highScore;
				PlayerShip.highScore = UserSettings.highScore;
			}
		}
	}

	public static function save():Void
	{
		FlxG.save.flush();
	}

	static inline function get__saveLoaded()
	{
		return FlxG.save.status == SUCCESS;
	}
}
