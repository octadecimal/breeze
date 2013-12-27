/**
 * Class: Titlebar
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui.widgets 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.events.Event;
	import com.octadecimal.breeze.gui.*;
	import com.octadecimal.breeze.input.Mouse;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.*;
	
	/**
	 * Titlebar description.
	 */
	public class Titlebar extends Widget implements IDrawable
	{
		/**
		 * Close button
		 */
		public function get close():Button	{ return _close; }
		private var _close:Button;
		
		/**
		 * Minimize button
		 */
		public function get minimize():Button	{ return _minimize; }
		private var _minimize:Button;
		
		/**
		 * Caption container
		 */
		public function get caption():Container	{ return _caption; }
		private var _caption:Container;
		
		/**
		 * Title
		 */
		private var _title:String;
		
		/**
		 * State memory
		 */
		private var _dragging:Boolean = false;
		
		
		/**
		 * Constructor
		 */
		public function Titlebar(name:String, caption:String="")
		{
			_title = caption;
			
			super(name);
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Widget#initialize()
		 * @see com.octadecimal.breeze.modules.Widget#initialize()
		 */
		override public function initialize():void 
		{
			// Make collidable
			makeCollidable();
			
			super.initialize();
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Widget#load()
		 * @see com.octadecimal.breeze.modules.Widget#load()
		 */
		override public function load(callback:Function):void 
		{
			
			// Direction
			direction = HORIZONTAL;
			
			// Caption
			//_caption.display.paddingX = 5;
			_caption = requireAsset(new Label("TitleCaption", _title, true, true, true, 0x0, 0x888888)) as Label;
			
			// Minimize
			_minimize = requireAsset(new Button("Minimize", "_", Button.SMALL)) as Button;
			_minimize.display.paddingY = 0;
			//_minimize.display.width = 16;
			
			// Close
			_close = requireAsset(new Button("Close", "x", Button.SMALL)) as Button;
			_close.display.paddingY = 0;
			//_close.display.width = 16;
			
			super.load(callback);
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Widget#unload()
		 * @see com.octadecimal.breeze.modules.Widget#unload()
		 */
		override public function unload():void 
		{
			super.unload();
		}
		
		override public function build():void 
		{
			// Add
			add(_caption, true);
			add(_minimize);
			add(_close);
			
			// Button events
			_close.events.listen(Event.CLICK, onCloseClick);
			
			super.build();
		}
		
		private function onCloseClick(e:Event):void
		{
			var window:Window = parent as Window;
			
			if (window)
			{
				window.close();
			}
		}
		
		
		/**
		 * @copy com.octadecimal.breeze.engine.IUpdateable#update()
		 * @see com.octadecimal.breeze.engine.IUpdateable#update()
		 */
		override public function update(change:uint):void 
		{
			// Test collision
			var mouse:Mouse = Breeze.modules.find("Mouse") as Mouse;
			var gui:GUI = Breeze.modules.find("GUI") as GUI;
			
			// If root (window) has focus
			if (gui.focus == root)
			{
				// If mouse is down
				if (mouse.isDown)
				{
					// If mouse collides
					if (mouse.isOver(collisions) || _dragging)
					{
						// Force drag until mouse is up
						_dragging = true;
						
						// Offset by mouse delta
						root.display.x += mouse.deltaX;
						root.display.y += mouse.deltaY;
						
						// Hide cursor
						Breeze.hideMouse();
					}	
				}
				else
				{
					// Show cursor
					Breeze.showMouse();
					
					// Un-force drag
					_dragging = false;
				}
			}
			
			super.update(change);
		}
		
		/**
		 * @copy com.octadecimal.breeze.engine.IDrawable#draw()
		 * @see com.octadecimal.breeze.engine.IDrawable#draw()
		 */
		override public function draw(change:uint):void 
		{
			super.draw(change);
		}
		
	}
}