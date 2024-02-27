package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class GameOverState extends FlxState
{
	/**
	 * Called from PlayState, this will set our win and score variables
	 * @param  win    Whether the player beat the boss, or died
	 * @param  score  The number of coins collected
	 */
	public function new(win:Bool, score:Int)
	{
		super();
		
		#if FLX_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		// create and add each of our items
		
		var titleText = new LargeText(0, 20, if (win) "You Win!" else "Game Over!");
		titleText.screenCenter(FlxAxes.X);
		add(titleText);

		var messageText = new FlxText(0, (FlxG.height / 2) - 18, 0, "Final Score: 0", 8);
		messageText.screenCenter(FlxAxes.X);
		add(messageText);
		
		// Fade the camera from black
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		
		// Count up the points for dramatic effect
		FlxTween.num(0, score, 1.0, // from 0 to score in 1.0 second
			{
				startDelay: 0.33,// wait for the fade to complete
				ease: FlxEase.circOut,
				onComplete: function (tween:FlxTween)
				{
					// Wait 1 second and then show the highscore
					new FlxTimer().start(0.5, (_)->showHighscore(score));
				}
			},
			function updateText(tweenedScore)
			{
				messageText.text = "Final Score: " + Math.floor(tweenedScore);
			}
		);
	}
	
	function showHighscore(score:Int)
	{
		// Get previous highscore
		var highscore = 0;
		if (FlxG.save.data.highscore != null)
			highscore = FlxG.save.data.highscore;
		
		
		var highscoreText = new FlxText(0, (FlxG.height / 2) + 10, 0, "Highscore: " + highscore, 8);
		add(highscoreText);
		
		// New high score
		if (score > highscore)
		{
			FlxG.save.data.highscore = score;
			highscoreText.text = "New Highscore!";
		}
		
		highscoreText.screenCenter(FlxAxes.XY);
		
		// Wait a second then show the 
		new FlxTimer().start(1.0, (_)->showButton());
	}
	
	function showButton()
	{
		var mainMenuButton = new FlxButton(0, FlxG.height - 32, "Main Menu", switchToMainMenu);
		mainMenuButton.loadGraphic(AssetPaths.button__png, true, 80, 20);
		mainMenuButton.screenCenter(FlxAxes.X);
		mainMenuButton.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(mainMenuButton);
	}

	/**
	 * When the user hits the main menu button, it should fade out and then take them back to the MenuState
	 */
	function switchToMainMenu():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			FlxG.switchState(MenuState.new);
		});
	}
}
