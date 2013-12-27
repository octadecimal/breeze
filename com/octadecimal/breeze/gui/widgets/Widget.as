/**
 * Class: Widget
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui.widgets 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.events.Event;
	import com.octadecimal.breeze.graphics.Graphics;
	import com.octadecimal.breeze.gui.*;
	import com.octadecimal.breeze.input.Mouse;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Widget description.
	 */
	public class Widget extends Container implements IDrawable
	{
		/**
		 * Mouse state enumerations
		 */
		public static const MOUSE_OUT:uint = 0;
		public static const MOUSE_OVER:uint = 1;
		public static const MOUSE_DOWN:uint = 2;
		public static const MOUSE_UP:uint = 4;
		
		/**
		 * Mouse state
		 */
		public function get mouseState():uint	{ return _mouseState; }
		private var _mouseState:uint;
		
		/**
		 * GUI Reference
		 */
		protected var gui:GUI;
		
		/**
		 * Graphics reference
		 */
		protected var graphics:Graphics;
		
		/**
		 * Collision node, widget set to collidable via makeCollidable().
		 */
		public var collisions:CollisionNode;
		
		/**
		 * Mouse reference (null if module not loaded)
		 */
		protected var mouse:Mouse;
		
		/** Copy point
		 */
		protected var copyPoint:Point = new Point();
		protected var copyRect:Rectangle = new Rectangle();
		
		
		/**
		 * Constructor
		 */
		public function Widget(name:String, direction:uint=HORIZONTAL)
		{
			// Save GUI reference
			gui = Breeze.modules.find("GUI") as GUI;
			
			// Save mouse reference
			mouse = Breeze.modules.find("Mouse") as Mouse;
			
			// Save graphics reference
			graphics = Breeze.modules.find("Graphics") as Graphics;
			
			// Super
			super(name, direction);
		}
		
		protected function makeCollidable():void
		{
			collisions = new CollisionNode(display.x, display.y, display.x + display.width, display.y + display.height);
			if (Module.verbose && Breeze.DEBUG) { Debug.print(this, "Widget made collidable: "+collisions.toString()); }
		}
		
		
		/**
		 * @copy com.octadecimal.breeze.engine.IUpdateable#update()
		 * @see com.octadecimal.breeze.engine.IUpdateable#update()
		 */
		override public function update(change:uint):void 
		{
			// Update collisions
			if (collisions != null)
			{
				// Update collision node
				collisions.setBounds(display.x, display.y, display.x + display.width, display.y + display.height);
				
				// Get mouse state
				if (mouse)
				{
					// Mouse is over
					if (mouse.isOver(collisions))
					{
						// Up
						if (mouse.isClicked)
							onMouseUp();
						
						// Down
						else if (mouse.isDown)
							onMouseDown();
						
						// Over
						else 
							onMouseOver();
					}
					// Out
					else _mouseState = MOUSE_OUT;
				}
			}
			
			// Update copy geoms
			if (root != this && root != null)
			{
				copyPoint.x = root.display.x + display.x;
				copyPoint.y = root.display.y + display.y;
			}
			else
			{
				copyPoint.x = display.x;
				copyPoint.y = display.y;
			}
			
			super.update(change);
		}
		
		protected function onMouseOver():void
		{
			_mouseState = MOUSE_OVER;
			gui.receivedInput = true;
		}
		
		protected function onMouseDown():void
		{
			_mouseState = MOUSE_DOWN;
			gui.receivedInput = true;
		}
		
		protected function onMouseUp():void
		{
			if (Breeze.DEBUG) Debug.print(this, "Clicked: " + name);
			_mouseState = MOUSE_UP;
			gui.receivedInput = true;
			if (eventDispatcher) events.dispatch(new Event(Event.CLICK));
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