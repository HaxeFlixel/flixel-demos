package;

import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEvent;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * The "main menu" state for the player to select their color palette.
 * @author MSGHero
 */
class MenuState extends FlxSubState
{
	var title:FlxText;

	var playRYB:FlxSprite;
	var playRGB:FlxSprite;
	var playCMY:FlxSprite;

	override public function create():Void
	{
		title = new FlxText(50 * 2, 10 * 2, (512 - 50) * 2, "FlxLightPuzzle", 20 * 2);
		title.color = FlxColor.WHITE;
		title.alignment = "center";
		add(title);

		// barsHorizontal.png from Kenney.nl were colored to make them more appropriate for this game

		playRYB = new FlxSprite(300 * 2, (72 - 25) * 2, AssetPaths.ryb__png);
		playRYB.setGraphicSize(Std.int(playRYB.width * 2));
		playRYB.updateHitbox();
		FlxMouseEvent.add(playRYB, null, onSelect, onMOver, onMOut, false, true, false);
		FlxMouseEvent.setMouseClickCallback(playRYB, onSelect);
		add(playRYB);

		playRGB = new FlxSprite(300 * 2, (144 - 25) * 2, AssetPaths.rgb__png);
		playRGB.setGraphicSize(Std.int(playRGB.width * 2));
		playRGB.updateHitbox();
		FlxMouseEvent.add(playRGB, null, onSelect, onMOver, onMOut, false, true, false);
		FlxMouseEvent.setMouseClickCallback(playRGB, onSelect);
		add(playRGB);

		playCMY = new FlxSprite(300 * 2, (216 - 25) * 2, AssetPaths.cmy__png);
		playCMY.setGraphicSize(Std.int(playCMY.width * 2));
		playCMY.updateHitbox();
		FlxMouseEvent.add(playCMY, null, onSelect, onMOver, onMOut, false, true, false);
		FlxMouseEvent.setMouseClickCallback(playCMY, onSelect);
		add(playCMY);
	}

	override public function destroy():Void
	{
		if (title != null)
		{
			title.destroy();
			title = null;
		}

		if (playRYB != null)
		{
			playRYB.destroy();
			playRYB = null;
		}

		if (playRGB != null)
		{
			playRGB.destroy();
			playRGB = null;
		}

		if (playCMY != null)
		{
			playCMY.destroy();
			playCMY = null;
		}
	}

	function onSelect(target:FlxSprite):Void
	{
		ColorMaps.defaultColorMap = if (target == playRYB) ColorMaps.rybMap else if (target == playRGB) ColorMaps.rgbMap else ColorMaps.cmyMap;

		FlxMouseEvent.remove(playRYB); // onMOut will trigger after the menu substate is removed (and after the play buttons are destroyed) without this, causing an error
		FlxMouseEvent.remove(playRGB);
		FlxMouseEvent.remove(playCMY);

		close(); // close the menu state and let the game commence
	}

	function onMOver(target:FlxSprite):Void
	{
		// make the buttons more noticeable by expanding them on mouse over
		target.setGraphicSize(Std.int(target.width * 1.25));
	}

	function onMOut(target:FlxSprite):Void
	{
		target.setGraphicSize(Std.int(target.width));
	}
}
