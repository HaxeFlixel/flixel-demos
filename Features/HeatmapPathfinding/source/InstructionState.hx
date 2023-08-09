package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;

class InstructionState extends FlxSubState
{
	override public function create():Void
	{
		bgColor = 0xAA000000;

		var t = new FlxText(0, 10, FlxG.width, "Heatmap\nPathfinding", 36);
		t.alignment = CENTER;
		add(t);

		var t2 = new FlxText(0, 120, FlxG.width, "Click to drag objects\n or place / erase walls\nElephants seek when placed", 16);
		t2.alignment = CENTER;
		add(t2);

		var closeButton = new FlxButton(0, 0, "Ok", function() close());
		closeButton.y = FlxG.height - closeButton.height - 4;
		closeButton.screenCenter(FlxAxes.X);
		add(closeButton);
	}
}
