/**
 * Class: Mouse
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.input 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.world.TransformNode;
	import com.octadecimal.breeze.world.World;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * Mouse description.
	 */
	public class Mouse extends Module implements IUpdateable
	{
		/**
		 * True if the mouse is down.
		 */
		public function get isDown():Boolean	{ return _isDown; }
		private var _isDown:Boolean;
		
		/**
		 * True on the update when a mouse was up after being down.
		 */
		public function get isClicked():Boolean	{ return _isClicked; }
		private var _isClicked:Boolean;
		
		/**
		 * Delta X
		 */
		public function get deltaX():int		{ return Breeze.stage.mouseX - _lastX; }
		
		/**
		 * Delta Y
		 */
		public function get deltaY():int		{ return Breeze.stage.mouseY - _lastY; }
		
		/**
		 * Transform node object.
		 */
		public var transform:TransformNode = new TransformNode();
		
		/**
		 * Collision node object.
		 */
		public var collisions:CollisionNode = new CollisionNode();
		
		/**
		 * State memory
		 */
		private var _lastX:int, _lastY:int;
		private var _lastIsDown:Boolean = false;
		private var _watchClick:Boolean = false;
		
		
		/**
		 * Constructor
		 */
		public function Mouse()
		{
			
		}
		
		/**
		 * Tests if the passed collision node collides with the current mouse coordinates.
		 * @param	input Input CollisionNode
		 * @return	True if collision.
		 */
		public function isOver(input:CollisionNode):Boolean
		{
			if(input != null)
				return input.collidesPoint(transform.screenX, transform.screenY);
			else return false;
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#initialize()
		 * @see com.octadecimal.breeze.modules.Module#initialize()
		 */
		override public function initialize():void 
		{
			
			super.initialize();
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#load()
		 * @see com.octadecimal.breeze.modules.Module#load()
		 */
		override public function load(callback:Function):void 
		{
			super.load(callback);
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#onLoaded()
		 * @see com.octadecimal.breeze.modules.Module#onLoaded()
		 */
		override public function onLoaded():void 
		{
			super.onLoaded();
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#unload()
		 * @see com.octadecimal.breeze.modules.Module#unload()
		 */
		override public function unload():void 
		{
			super.unload();
		}
		
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#build()
		 * @see com.octadecimal.breeze.modules.Module#build()
		 */
		override public function build():void 
		{
			// Stage events
			Breeze.stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			Breeze.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			Breeze.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			// Engine registration
			Engine(Breeze.modules.find("Engine")).registerUpdateable(this);
			
			super.build();
		}
		
		private function onDown(e:MouseEvent):void
		{
			_isDown = true;
		}
		private function onUp(e:MouseEvent):void
		{
			_isDown = false;
		}
		private function onMove(e:MouseEvent):void
		{
			transform.x = e.stageX;
			transform.y = e.stageY;
		}
		
		/**
		 * @copy com.octadecimal.breeze.engine.IUpdateable#update()
		 * @see com.octadecimal.breeze.engine.IUpdateable#update()
		 */
		public function update(change:uint):void 
		{
			var stage:Stage = Breeze.stage;
			
			// Test click
			if (_isDown) {
				_isClicked = false;
				_watchClick = true;
			}
			else if (!_isDown && _watchClick)
			{
				_watchClick = false;
				_isClicked = true;
			}
			else _isClicked = false;
			
			// Update transform
			transform.screenX = stage.mouseX;
			transform.screenY = stage.mouseY;
			
			// Project camera (if exists)
			var world:World = Breeze.modules.find("World") as World;
			if (world != null && world.camera != null) world.camera.deproject(transform);
			
			// Update collisions
			collisions.left = transform.x - 1;
			collisions.right = transform.x + 1;
			collisions.top = transform.y - 1;
			collisions.bottom = transform.y + 1;
			
			// Save
			_lastX = Breeze.stage.mouseX;
			_lastY = Breeze.stage.mouseY;
			_lastIsDown = _isDown;
			
			
			//Breeze.screen.buffer.fillRect(new Rectangle(Breeze.stage.mouseX - 1, Breeze.stage.mouseY - 1, 2, 2), 0xFF0000);
		}
		
		/**
		 * @copy com.octadecimal.breeze.engine.IDrawable#draw()
		 * @see com.octadecimal.breeze.engine.IDrawable#draw()
		 */
		public function draw(change:uint):void 
		{
			//Breeze.screen.buffer.fillRect(new Rectangle(collisions.left, collisions.top, collisions.right-collisions.left, collisions.bottom-collisions.top), 0x0000FF); 
			//Breeze.screen.buffer.fillRect(new Rectangle(Breeze.stage.mouseX - 1, Breeze.stage.mouseY - 1, 2, 2), 0xFF0000);
		}
		
	}
}