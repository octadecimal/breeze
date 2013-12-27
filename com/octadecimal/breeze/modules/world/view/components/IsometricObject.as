/*
 View:   IsometricObject
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.world.view.components 
{
	import com.octadecimal.breeze.modules.world.model.IsometricPosition;
	import com.octadecimal.breeze.modules.world.model.ScreenPosition;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * IsometricObject View.
	 */
	public class IsometricObject extends Sprite
	{
		
		public function IsometricObject(size:Number) 
		{
			_size = size;
			_position = new IsometricPosition();
			
			// temporary
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		
        
		// API
		// =========================================================================================
		
		/**
		 * Updates.
		 */
		public function update(e:Event=null):void
		{
			if (_invalidate)
			{
				// Get screen position
				var projected:ScreenPosition = IsometricPlaneStaggered.getInstance().toScreen(_position);
				
				// Update screen position
				super.x = projected.x;
				super.y = projected.y
				
				// Validated
				_invalidate = false;
			}
		}
		
		/**
		 * Overrides DisplayObject.x with internal isometric position.
		 */
		override public function get x():Number { return _position.x; }
		
		/**
		 * Sets the isometric position, overriding DisplayObject.x screen position.
		 */
		override public function set x(value:Number):void 
		{
			_position.x = value;
			//super.x = value;
			_invalidate = true;
		}
		
		/**
		 * Overrides DisplayObject.y with internal isometric position.
		 */
		override public function get y():Number { return _position.y; }
		
		/**
		 * Sets the isometric position, overriding DisplayObject.y screen position.
		 */
		override public function set y(value:Number):void 
		{
			_position.y = value;
			//super.y = value;
			_invalidate = true;
		}
		
		/**
		 * Overrides DisplayObject.z with internal isometric position.
		 */
		override public function get z():Number { return _position.z; }
		
		/**
		 * Sets the isometric position z position.
		 */
		override public function set z(value:Number):void 
		{
			_position.z = value;
			_invalidate = true;
		}
		
		public function get position():IsometricPosition { return _position; }
		
		/**
		 * Sets the isometric position object.
		 */
		public function set position(value:IsometricPosition):void
		{
			_position = value;
			_invalidate = true;
		}
		
		public function get screenPosition():ScreenPosition { return _screenPosition; }
		public function set screenPosition(value:ScreenPosition):void 
		{
			_screenPosition = value;
			_invalidate = true;
		}
		
		/**
		 * Calculates and returns the isometric depth of this object.
		 */
		public function get depth():Number
		{
			return (_position.x + _position.z) * .866 - _position.y * .707;
		}
		
		/**
		 * Returns the size (or radius) of this object.
		 */
		public function get size():Number
		{
			return _size;
		}
		
		/**
		 * Returns the isometric rectangle bounds for this object.
		 */
		public function rect():Rectangle
		{
			return new Rectangle(x - size / 2, z - size / 2, size, size);
		}
		
		
        
		// EVENTS
		// =========================================================================================
		
		
		
		
		
        
		// PRIVATE
		// =========================================================================================
		
		// Isometric position, overrides screen x and y when accessing this class.
		private var _position:IsometricPosition;
		
		// Screen position
		private var _screenPosition:ScreenPosition;
		
		// Isometric size, or radius.
		private var _size:Number;
		
		// Invalidate flag, causes a redraw next update
		private var _invalidate:Boolean = true;
	}
	
}