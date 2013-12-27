/**
 * Class: Window
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
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Window description.
	 */
	public class Window extends Widget implements IDrawable
	{
		/**
		 * Titlebar container
		 */
		public function get titlebar():Container	{ return _titlebar; }
		private var _titlebar:Container;
		
		/**
		 * Menu container
		 */
		public function get menubar():Container	{ return _menubar; }
		private var _menubar:Container;
		
		/**
		 * Content container
		 */
		public function get content():Container	{ return _content; }
		private var _content:Container;
		
		/**
		 * Window title.
		 */
		public function get title():String	{ return _title; }
		private var _title:String;
		
		/**
		 * Private drawing memory
		 */
		private var _iterationsX:uint, _iterationsY:uint;
		private var _leftoverWidth:uint, _leftoverHeight:uint;
		
		
		/**
		 * Constructor
		 */
		public function Window(name:String, title:String="")
		{
			_title = title;
			
			trace("WINDOW NAME: " + name);
			
			super(name, Container.VERTICAL);
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Widget#initialize()
		 */
		override public function initialize():void 
		{
			// Set container direction
			direction = Container.VERTICAL;
			
			// Set as collidable
			makeCollidable();
			
			super.initialize();
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Widget#load()
		 */
		override public function load(callback:Function):void 
		{
			// Titlebar
			_titlebar = requireAsset(new Titlebar("Titlebar", _title)) as Titlebar;
			
			// Menubar
			_menubar = requireAsset(new Container("Menubar", Container.HORIZONTAL)) as Container;
			
			// Content
			_content = requireAsset(new Container("Content", Container.HORIZONTAL)) as Container;
			
			super.load(callback);
		}
		
		
		/**
		 * Close. Calls GUI and removes window form display list.
		 */
		public function close():void
		{
			// Remove from display list
			gui.displayList.remove(name);
		}
		
		
		/**
		 * @see com.octadecimal.breeze.modules.Widget#build()
		 */
		override public function build():void 
		{
			// Titlebar
			_titlebar.display.paddingX = 8;
			_titlebar.display.paddingY = 8;
			add(_titlebar, true);
			
			// menubar
			_menubar.display.paddingX = 0;
			_menubar.display.paddingY = 0;
			add(_menubar, true);
			
			// Content
			_content.display.paddingX = 10;
			_content.display.paddingY = 10;
			add(_content, true);
			
			// Add to GUI display list
			gui.displayList.add(name, this);
			
			super.build();
			
			// Workaround, add menupane to end of display list
			// so it renders on top of content		
			children.splice(1, 1);
			children.push(menubar);
		}
		
		override public function generate():void 
		{
			super.generate();
			
			// Shadow hack
			display.width += 5;
			display.height += 5;
		}
		
		
		/**
		 * @see com.octadecimal.breeze.engine.IUpdateable#update()
		 */
		override public function update(change:uint):void 
		{
			var bounds:Rectangle = gui.settings.window;
			
			// Calculate leftover width/height (for drawing top|right|bottom|left)
			var centerWidth:int = display.width - bounds.width * 2;
			var centerHeight:int = display.height - bounds.height * 2;
			
			// Calculate number of iterations to draw center objects
			_iterationsX = Math.ceil(centerWidth / bounds.width);
			_iterationsY = Math.ceil(centerHeight / bounds.height);
			if (_iterationsX > 100) _iterationsX = 0;	//hack
			if (_iterationsY > 100) _iterationsY = 0;	//hack
			
			// Calculate iteration width/height
			var iterationW:int = _iterationsX * bounds.width;
			var iterationH:int = _iterationsY * bounds.height;
			
			// Calculate leftover space to draw on final copy
			_leftoverWidth = bounds.width  - (iterationW - centerWidth);
			_leftoverHeight = bounds.height - (iterationH - centerHeight);
				
			display.x = Math.max(display.x, 0);
			display.y = Math.max(display.y, 24);
			
			
			super.update(change);
		}
		
		/**
		 * @see com.octadecimal.breeze.engine.IDrawable#draw()
		 */
		override public function draw(change:uint):void 
		{
			drawBackground();
			
			super.draw(change);
		}
		
		private function drawBackground():void
		{
			var screen:BitmapData = Breeze.screen.buffer;
			var skin:BitmapData = gui.skin.texture.buffer;
			var bounds:Rectangle= gui.settings.window;
			var point:Point = this.copyPoint;
			var rect:Rectangle = this.copyRect;
			
			// Wrap
			display.width = Math.max(bounds.width * 2, display.width);
			display.height = Math.max(bounds.height * 2, display.height);
			
			// Reset
			rect = bounds.clone();
			
			// Inherit display node
			point.x = display.x;
			point.y = display.y;
			
			// Top Left (DRAW)
			screen.copyPixels(skin, rect, point);
			
			// Top (MOVE)
			rect.x += bounds.width;
			point.x += bounds.width;
			
			// Top (DRAW)
			graphics.drawStrip(screen, skin, display.width-bounds.width, bounds.width, rect, point);
			for (var i:uint = 0, c:uint = _iterationsX; i < c; i++)
			{
				//if (i == c - 1) rect.width = _leftoverWidth;
				//screen.copyPixels(skin, rect, point);
				//point.x += rect.width;
			}
			
			// Top Right (MOVE)
			rect.x += bounds.width;
			rect.width = bounds.width;
			
			// Top Right (DRAW)
			screen.copyPixels(skin, rect, point);
			
			// Right (MOVE)
			rect.y += bounds.height;
			point.y += bounds.height;
			
			// Right (DRAW)
			for (i = 0, c = _iterationsY; i < c; i++)
			{
				if (i == c - 1) rect.height = _leftoverHeight;
				screen.copyPixels(skin, rect, point);
				point.y += rect.height;
			}
			
			// Bottom Right (MOVE)
			rect.height = bounds.height;
			rect.y += bounds.height;
			
			// Bottom Right (DRAW)
			screen.copyPixels(skin, rect, point);
			
			// Bottom (MOVE)
			rect.x -= bounds.width;
			
			// Bottom (DRAW)
			for (i = 0, c = _iterationsX; i < c; i++)
			{
				if (i == c - 1) rect.width = _leftoverWidth;
				point.x -= rect.width;
				screen.copyPixels(skin, rect, point);
			}
			
			// Bottom Left (MOVE)
			rect.x -= bounds.width;
			rect.width = bounds.width;
			point.x -= bounds.width;
			
			// Bottom Left (DRAW)
			screen.copyPixels(skin, rect, point);
			
			// Left (MOVE)
			rect.y -= bounds.height;
			
			// Left (DRAW)
			for (i = 0, c = _iterationsY; i < c; i++)
			{
				if (i == c - 1) rect.height = _leftoverHeight;
				point.y -= rect.height;
				screen.copyPixels(skin, rect, point);
			}
			
			// Center (DRAW)
			// TAKE NOTE: Added 1 pixel to left and right
			screen.fillRect(new Rectangle(display.x + bounds.width - 1, display.y + bounds.height - 1, display.width - (bounds.width * 2) + 1, display.height - (bounds.height * 2) + 1), gui.skin.color);
		}
	}
}