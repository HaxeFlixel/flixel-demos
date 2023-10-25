package;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.animation.FlxAnimation;
import flixel.graphics.FlxAsepriteUtil;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

/**
 * @author MondayHopscotch
 */
class PlayState extends FlxState
{
	static inline var POINTER_VERTICAL_OFFSET = 3;
	static inline var ANIM_NAME_LINE_SPACING = 10;

	var loadTitle:FlxText;
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
		add(player);

		loadTitle = new FlxText();
		add(loadTitle);

		loadedAnimations = new FlxText(20);
		add(loadedAnimations);

		pointer = new FlxSprite("assets/pointer.png");
		add(pointer);

		currentAnimationLabel = new FlxText(0, 0, 0, player.animation.name);
		currentAnimationLabel.alignment = CENTER;
		currentAnimationLabel.y = FlxG.height - currentAnimationLabel.height;
		add(currentAnimationLabel);

		previousButton = new FlxButton(0, 0, "Previous", () -> {
			setPlayerAnim(curAnimIndex-1);
		});
		previousButton.setPosition(0, FlxG.height - previousButton.height);
		add(previousButton);

		nextButton = new FlxButton(0, 0, "Next", () -> {
			setPlayerAnim(curAnimIndex+1);
		});
		nextButton.setPosition(FlxG.width - nextButton.width, FlxG.height - nextButton.height);
		add(nextButton);

		loadAnims();
	}

	function loadAnims() {
		loadTitle.text = "Anims by Index";
		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(player, "assets/player.png", "assets/player.json");
		// Can also call FlxAsepriteUtil.loadAseAtlasAndTagsByPrefix(player, "assets/player.png", "assets/player.json");

		player.screenCenter();

		animList = player.animation.getAnimationList();

		loadedAnimations.text = animList.map((a) -> { a.name; }).join("\n");
		loadedAnimations.screenCenter(Y);

		setPlayerAnim(0);
	}

	function setPlayerAnim(index:Int) {
		curAnimIndex = FlxMath.wrap(index, 0, animList.length - 1);
		player.animation.play(animList[curAnimIndex].name);

		pointer.setPosition(0, POINTER_VERTICAL_OFFSET + loadedAnimations.y + ANIM_NAME_LINE_SPACING * curAnimIndex);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		currentAnimationLabel.text = 'Current Animation: ${player.animation.name}';
		currentAnimationLabel.screenCenter(X);
	}
}
