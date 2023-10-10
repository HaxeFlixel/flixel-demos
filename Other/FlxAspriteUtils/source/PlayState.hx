package;

import flixel.animation.FlxAnimation;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.graphics.FlxAsepriteUtil;
import flixel.FlxSprite;
import flixel.FlxState;

using flixel.util.FlxSpriteUtil;

/**
 * @author MondayHopscotch
 */
class PlayState extends FlxState
{
	static inline var POINTER_VERTICAL_OFFSET = 3;
	static inline var ANIM_NAME_LINE_SPACING = 10;

	var loadedAnimations:FlxText;
	var animList:Array<FlxAnimation>;
	var currentAnimationLabel:FlxText;
	var player:FlxSprite;

	var curAnimIndex = 0;
	var pointer:FlxSprite;

	var nextButton:FlxButton;
	var previousButton:FlxButton;

	override public function create():Void
	{
		player = new FlxSprite();
		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(player, "assets/player.png", "assets/player.json");
		player.screenCenter();
		add(player);

		animList = player.animation.getAnimationList();

		loadedAnimations = new FlxText(20);
		loadedAnimations.text = animList.map((a) -> { a.name; }).join("\n");
		loadedAnimations.screenCenter(Y);
		add(loadedAnimations);

		pointer = new FlxSprite("assets/pointer.png");
		add(pointer);

		currentAnimationLabel = new FlxText(player.animation.name);
		currentAnimationLabel.alignment = CENTER;
		currentAnimationLabel.y = FlxG.height - currentAnimationLabel.height;
		add(currentAnimationLabel);

		previousButton = new FlxButton("Previous", () -> {
			setPlayerAnim(curAnimIndex-1);
		});
		previousButton.setPosition(0, FlxG.height - previousButton.height);
		add(previousButton);


		nextButton = new FlxButton("Next", () -> {
			setPlayerAnim(curAnimIndex+1);
		});
		nextButton.setPosition(FlxG.width - nextButton.width, FlxG.height - nextButton.height);
		add(nextButton);

		setPlayerAnim(0);
	}

	function setPlayerAnim(index:Int) {
		curAnimIndex = index % animList.length;
		player.animation.play(animList[curAnimIndex].name);

		pointer.setPosition(0, POINTER_VERTICAL_OFFSET + loadedAnimations.y + ANIM_NAME_LINE_SPACING * curAnimIndex);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		currentAnimationLabel.text = 'Current Animation: ${player.animation.name}';
		currentAnimationLabel.screenCenter(X);
	}
}
