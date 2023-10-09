package;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.graphics.FlxAsepriteUtil;
import flixel.FlxSprite;
import flixel.FlxState;

using flixel.util.FlxSpriteUtil;

/**
 * @author Zaphod
 */
class PlayState extends FlxState
{
	var currentAnimationLabel:FlxText;
	var player:FlxSprite;

	var nextButton:FlxButton;
	var previousButton:FlxButton;

	override public function create():Void
	{
		player = new FlxSprite();
		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(player, "assets/player.png", "assets/player.json");
		player.screenCenter();
		add(player);

		currentAnimationLabel = new FlxText(player.animation.name);
		currentAnimationLabel.alignment = CENTER;
		currentAnimationLabel.y = FlxG.height - currentAnimationLabel.height;
		add(currentAnimationLabel);

		previousButton = new FlxButton("Previous", () -> {

		});
		previousButton.setPosition(0, FlxG.height - previousButton.height);
		add(previousButton);


		nextButton = new FlxButton("Next", () -> {

		});
		nextButton.setPosition(FlxG.width - nextButton.width, FlxG.height - nextButton.height);
		add(nextButton);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		currentAnimationLabel.text = 'Current Animation: ${player.animation.name}';
		currentAnimationLabel.screenCenter(X);
	}
}
