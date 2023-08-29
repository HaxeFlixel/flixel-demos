package ui;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

/**
 * Sprite used to draw a representation of the current follow styles.
 * For most styles, it draws the deadzone.
 */
class DeadzoneOverlay extends FlxSprite
{
	public function new ()
	{
		super();
		
		scrollFactor.set(0, 0);// move with the camera
		
		#if debug
		ignoreDrawDebug = true;
		#end
	}
	
	public function redraw(targetCamera:FlxCamera)
	{
		if (targetCamera.style == SCREEN_BY_SCREEN)
		{
			// just hide it, otherwise we'd need to redraw it with zoom changes
			visible = false;
			return;
		}
		visible = true;
		
		final lineLength = 12;
		final padding = 2;
		final thickness = 3 + padding;
		final halfThickness = thickness / 2;
		final lineStyle:LineStyle = {color: FlxColor.WHITE, thickness: thickness - padding};
		
		if (targetCamera.style == NO_DEAD_ZONE)
		{
			// No deadzone, draw a simple crosshair in the center of the camera's view
			final reticalSize = 20;
			// pad the graphic a little, for thick lines
			makeGraphic(reticalSize + thickness, reticalSize + thickness, FlxColor.TRANSPARENT, true);
			x = (camera.width - frameWidth) / 2;
			y = (camera.height - frameHeight) / 2;
			
			final centerX = frameWidth / 2;
			final centerY = frameHeight / 2;
			final reticalHalfSize = reticalSize / 2;
			this.drawLine(centerX, centerY - reticalHalfSize, centerX, centerY + reticalHalfSize, lineStyle);
			this.drawLine(centerX - reticalHalfSize, centerY, centerX + reticalHalfSize, centerY, lineStyle);
			return;
		}
		
		// draw the deadzone's corners
		final dz:FlxRect = targetCamera.deadzone;
		x = dz.x - halfThickness;
		y = dz.y - halfThickness;
		// pad the graphic a little, for thick lines
		makeGraphic(Std.int(dz.width + thickness), Std.int(dz.height + thickness), FlxColor.TRANSPARENT, true);
		
		// Top-Left
		this.drawLine(dz.left - x, dz.top - y, dz.left - x + lineLength, dz.top - y, lineStyle);
		this.drawLine(dz.left - x, dz.top - y, dz.left - x, dz.top + lineLength - y, lineStyle);
		// Top-Right
		this.drawLine(dz.right - x, dz.top - y, dz.right - x - lineLength, dz.top - y, lineStyle);
		this.drawLine(dz.right - x, dz.top - y, dz.right - x, dz.top + lineLength - y, lineStyle);
		// Bottom-Left
		this.drawLine(dz.left - x, dz.bottom - y, dz.left - x + lineLength, dz.bottom - y, lineStyle);
		this.drawLine(dz.left - x, dz.bottom - y, dz.left - x, dz.bottom - lineLength - y, lineStyle);
		// Bottom-Right
		this.drawLine(dz.right - x, dz.bottom - y, dz.right - x - lineLength, dz.bottom - y, lineStyle);
		this.drawLine(dz.right - x, dz.bottom - y, dz.right - x, dz.bottom - lineLength - y, lineStyle);
	}
}