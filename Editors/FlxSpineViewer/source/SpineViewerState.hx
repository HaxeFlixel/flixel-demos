package;

import openfl.display.FPS;

import spinehaxe.SkeletonData;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.addons.editors.spine.FlxSpine;
import flixel.addons.ui.FlxSlider;


class SpineViewerState extends FlxState
{
	var spineSprite:FlxSpine;
    var fps:FPS;
    var fpsText:FlxText;

	override public function create():Void
	{
		FlxG.cameras.bgColor = FlxColor.WHITE;

        #if !FLX_NO_MOUSE
        FlxG.mouse.visible = true;
        #end
		
        var skeletonData:SkeletonData = FlxSpine.readSkeletonData("spineboy", "assets", 0.5);

		spineSprite = new FlxSpine(skeletonData, 0, 0);
        spineSprite.antialiasing = true;

        spineSprite.cameras = [FlxG.camera];

        var instructions = new FlxText(20, 20, 250, "Flip: touches \n\n Vertical Swipe: Debug toggle", 12);
        #if !FLX_NO_KEYBOARD
        instructions.text = "Flip: D, A or Arrows";
        instructions.text += "\n\n SPACE: Debug toggle";
        instructions.text += "\n\n Time Scale: W, S";
        #end
        instructions.color = FlxColor.BLACK;
        instructions.ignoreDrawDebug = true;
        instructions.setFormat(null, 16, 0xd8eba2, CENTER, OUTLINE, 0x131c1b);
        instructions.scrollFactor.set(0, 0);
        add(instructions);

        var anim_text:FlxText = new FlxText(20, instructions.y + instructions.height + 100, 250, "Animations:", 16);
        anim_text.setFormat(null, 16, 0xd8eba2, LEFT, OUTLINE, 0x131c1b);
        anim_text.scrollFactor.set(0, 0);
        anim_text.ignoreDrawDebug = true;
        add(anim_text);

        var count:Int = 0;
        var temp_btn:FlxButton = null;
        for (animation in skeletonData.animations) {
            temp_btn = new FlxButton(20, (instructions.y + instructions.height + 135) + 30 * count, animation.name, changeAnimation.bind(animation.name));
            temp_btn.ignoreDrawDebug = true;
            add(temp_btn);
            count ++;
        }

        fps = new FPS(0, 0, FlxColor.WHITE);
        fpsText = new FlxText(FlxG.width - 60, 20, 250);
        fpsText.color = FlxColor.BLACK;
        fpsText.size = 16;
        fpsText.ignoreDrawDebug = true;
        fpsText.scrollFactor.set(0, 0);
        add(fpsText);
        FlxG.camera.focusOn(new FlxPoint(spineSprite.x - xInPercent(10.0), spineSprite.y - 200));

        //Added SpineSprite in top layer of scene
		add(spineSprite);

        #if !FLX_NO_DEBUG
        FlxG.watch.add(spineSprite, "state.timeScale", "Time scale");
        FlxG.watch.add(spineSprite, "state", "state");
        #end

        FlxG.addChildBelowMouse(fps = new FPS(FlxG.width - 60, 5, FlxColor.WHITE));
		
		super.create();
	}

    private inline function xInPercent(x:Float):Int {
        return Std.int(FlxG.width / 100 * x);
    }

    private inline function yInPercent(y:Float):Int {
        return Std.int(FlxG.width / 100 * y);
    }

    private function changeAnimation(name:String):Void {
		spineSprite.state.setAnimationByName(0, name, true);
    }

	override public function update(elapsed:Float):Void
	{
        fpsText.text = fps.currentFPS + "";
		
        #if !FLX_NO_TOUCH
        // Touches for switch flip of Spine Sprite
        for (touch in FlxG.touches.list)
        {
            if (touch.pressed)
            {
                if (touch.x > 10 && touch.x < FlxG.width - 10) {
                  if (touch.x > spineSprite.x) {
                      spineSprite.skeleton.flipX = false;
                  } else {
                      spineSprite.skeleton.flipX = true;
                  }
                
                }
            }
        }
        #end
        // Vertical long swipe up or down toggle debug mode
        #if (!FLX_NO_DEBUG && !FLX_NO_TOUCH)
        for (swipe in FlxG.swipes)
        {
            if (swipe.distance > 300)
            {
                if ((swipe.angle < 10 && swipe.angle > -10) || (swipe.angle > 170 || swipe.angle < -170))
                {
			        FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
                }
            }
        }
        #end

        #if !FLX_NO_KEYBOARD
        if (FlxG.keys.anyPressed([W, UP]))
        {
            spineSprite.state.timeScale += 0.1;
        }
        else if (FlxG.keys.anyPressed([S, DOWN]))
        {
            spineSprite.state.timeScale -= 0.1;
        }

        if (FlxG.keys.anyPressed([D, RIGHT]))
        {
            spineSprite.skeleton.flipX = false;
        }
        else if (FlxG.keys.anyPressed([A, LEFT]))
        {
            spineSprite.skeleton.flipX = true;
        }
        #end

        #if (!FLX_NO_DEBUG && !FLX_NO_KEYBOARD)
        if (FlxG.keys.justPressed.SPACE)
            FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
        #end
        
		super.update(elapsed);
	}
}
