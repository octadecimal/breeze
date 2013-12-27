/**
 * Class: Toolbar
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui.widgets 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.gui.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.*;
	import flash.geom.Point;
	
	/**
	 * Toolbar description.
	 */
	public class Toolbar extends Widget implements IDrawable
	{
		/**
		 * Constructor
		 */
		public function Toolbar(name:String)
		{
			super(name);
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Widget#initialize()
		 */
		override public function initialize():void 
		{
			display.paddingX = 16;
			display.paddingY = 0;
			display.height = 25;
			
			super.initialize();
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Widget#load()
		 */
		override public function load(callback:Function):void 
		{
			// Super
			super.load(callback);
		}
		
		override public function update(change:uint):void 
		{
			super.update(change);
		}
		
		
		/**
		 * Draws the toolbar background
		 * @see com.octadecimal.breeze.engine.IDrawable#draw()
		 * @param	change
		 */
		override public function draw(change:uint):void 
		{
			// Draw background
			var logoWidth:int = copyRect.width;
			copyRect = gui.skin.toolbar.clone();
			graphics.drawStrip(Breeze.screen.buffer, gui.skin.texture.buffer, Breeze.stage.stageWidth, 0, copyRect, copyPoint); 
			
			super.draw(change);
		}
	}
}