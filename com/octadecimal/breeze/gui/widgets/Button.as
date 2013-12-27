/**
 * Class: Button
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui.widgets 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.graphics.Graphics;
	import com.octadecimal.breeze.gui.*;
	import com.octadecimal.breeze.input.Mouse;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.*;
	import com.octadecimal.breeze.world.World;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * Button description.
	 */
	public class Button extends Widget implements IDrawable
	{
		/**
		 * Button size enumeration to draw as a large button.
		 */
		public static const LARGE:uint = 0;
		
		/**
		 * Button size enumeration to draw as a small button.
		 */
		public static const SMALL:uint = 1;
		
		/**
		 * Button caption
		 */
		public function get caption():String	{ return _caption; }
		private var _caption:String;
		
		/**
		 * Label reference
		 */
		private var _label:Label;
		
		/**
		 * Private state memory
		 */
		private var _size:uint;
		private var _side:Number;
		private var _boundary:Rectangle = new Rectangle();
		private var _copyDirection:String;
		
		
		/**
		 * Constructor
		 */
		public function Button(name:String, caption:String=null, size:uint=LARGE)
		{
			direction = HORIZONTAL;
			
			// Save button size
			_size = size;
			
			// Save button caption
			_caption = caption;
			
			super("button_"+name);
		}
		
		override protected function onMouseUp():void 
		{
			//var world:World = Breeze.modules.find("World") as World;
			//if(world.map == null) world.loadMap("resources/maps/trio.xml");
			
			super.onMouseUp();
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Widget#initialize()
		 * @see com.octadecimal.breeze.modules.Widget#initialize()
		 */
		override public function initialize():void 
		{
			// Make collidable
			makeCollidable();
			
			// Make event dispatcher
			eventDispatcher = true;
			
			super.initialize();
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Widget#load()
		 * @see com.octadecimal.breeze.modules.Widget#load()
		 */
		override public function load(callback:Function):void 
		{
			// Label
			_label = requireAsset(new Label("ButtonLabel", _caption, true, true)) as Label;
			
			super.load(callback);
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Widget#onLoaded()
		 * @see com.octadecimal.breeze.modules.Widget#onLoaded()
		 */
		override public function onLoaded():void 
		{
			super.onLoaded();
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Widget#unload()
		 * @see com.octadecimal.breeze.modules.Widget#unload()
		 */
		override public function unload():void 
		{
			super.unload();
		}
		
		
		/**
		 * @copy com.octadecimal.breeze.modules.Widget#build()
		 * @see com.octadecimal.breeze.modules.Widget#build()
		 */
		override public function build():void 
		{
			// Save boundary reference by size
			_boundary = (_size == LARGE) ? gui.skin.buttonLarge : gui.skin.buttonSmall;
			
			// Save side width by size
			_side = (_size == LARGE) ? gui.skin.buttonLargeSide : gui.skin.buttonSmallSide;
			
			// Copy direction
			_copyDirection = (_size == LARGE) ? gui.skin.buttonLargeDirection : gui.skin.buttonSmallDirection;
			
			// Save button height
			display.height = _boundary.height;
			//display.height = 22;
			
			/* TODO: Temporary, probably want to remove this */
			//display.width = 48;
			
			// Initialize copy geoms to boundary origin
			copyPoint.x = display.x;
			copyPoint.y = display.y;
			copyRect = _boundary.clone();
			
			// Label
			add(_label, false, CENTER, CENTER);
			
			super.build();
		}
		
		/**
		 * @see com.octadecimal.breeze.engine.IDrawable#draw()
		 */
		override public function draw(change:uint):void 
		{
			var screen:BitmapData = Breeze.screen.buffer;
			var skin:BitmapData = gui.skin.texture.buffer;
			
			// Inherit display node
			copyPoint.x = display.x;
			copyPoint.y = display.y;
			
			if (root != null) {
				//copyPoint.x += root.display.x;
				//copyPoint.y += root.display.y;
			}
			
			// Left (MOVE)
			copyRect.x = _boundary.x;
			copyRect.y = _boundary.y;
			copyRect.width = _side;
			
			if (mouseState == Widget.MOUSE_OVER) { 
				if(_copyDirection == "horizontal") copyRect.x += 1 * (_boundary.width + _side * 2);
				if(_copyDirection == "vertical") copyRect.y += _boundary.height;
			}
			else if(mouseState == Widget.MOUSE_DOWN) {
				if(_copyDirection == "horizontal") copyRect.x += 2 * (_boundary.width + _side * 2);
				if(_copyDirection == "vertical") copyRect.y +=  2 * _boundary.height;
				_label.display.y += 1;
			}
			
			// Left (DRAW)
			screen.copyPixels(skin, copyRect, copyPoint);
			
			// Center (MOVE)
			copyRect.x += _side;
			copyRect.width = _boundary.width;
			copyPoint.x += _side;
			
			// Center (DRAW)
			graphics.drawStrip(screen, skin, display.width, _side * 2, copyRect, copyPoint);
			
			
			// Right (MOVE)
			copyRect.x += _boundary.width;
			copyRect.width = _side;
			
			// Right (DRAW)
			screen.copyPixels(skin, copyRect, copyPoint);
			
			super.draw(change);
		}
		
	}
}