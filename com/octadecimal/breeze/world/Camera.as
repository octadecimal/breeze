/**
 * Class: Camera
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.world 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.input.Controls;
	import com.octadecimal.breeze.modules.*;
	
	/**
	 * Camera description.
	 */
	public class Camera extends Module implements IDrawable
	{ 
		/**
		 * Transform node
		 */
		public function get transform():TransformNode	{ return _transform; }
		private var _transform:TransformNode = new TransformNode();
		
		// Temp
		private var _leftDown:Boolean = false, _rightDown:Boolean = false, _upDown:Boolean = false, _downDown:Boolean = false;
		
		
		/**
		 * Constructor
		 */
		public function Camera()
		{
			
		}
		
		/**
		 * Project input's world coords -> input's screen coords relative to camera world position.
		 */
		public function project(input:TransformNode):void
		{
			input.screenX = /*Math.round(*/input.x - _transform.x + Breeze.stage.stageWidth * 0.5/*)*/;
			input.screenY = /*Math.round(*/input.y - _transform.y + Breeze.stage.stageHeight * 0.5/*)*/;
		}
		
		/**
		 * Transform input's screen coords -> input's world coords relative to camera world position.
		 */
		public function deproject(input:TransformNode):void
		{ 
			input.x = input.screenX + _transform.x - Breeze.stage.stageWidth * 0.5;
			input.y = input.screenY + _transform.y - Breeze.stage.stageHeight * 0.5;;
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#initialize()
		 * @see com.octadecimal.breeze.modules.Module#initialize()
		 */
		override public function initialize():void 
		{
			
			// Engine registration
			//Engine(Breeze.modules.find("Engine")).registerUpdateable(this);
			//Engine(Breeze.modules.find("Engine")).registerDrawable(this);
			
			super.initialize();
		}
		
		private function leftDown():void {
			_leftDown = true;
		}
		
		private function rightDown():void {
			_rightDown = true;
		}
		
		private function upDown():void {
			_upDown = true;
		}
		
		private function downDown():void {
			_downDown = true;
		}
		
		private function leftUp():void {
			_leftDown = false;
		}
		
		private function rightUp():void {
			_rightDown = false;
		}
		
		private function upUp():void {
			_upDown = false;
		}
		
		private function downUp():void {
			_downDown = false;
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#load()
		 * @see com.octadecimal.breeze.modules.Module#load()
		 */
		override public function load(callback:Function):void 
		{
			
			// Debug binds
			var controls:Controls = Breeze.modules.find("Controls") as Controls;
			//if (controls != null)
			//{
				controls.bind("move_left", leftDown, leftUp);
				controls.bind("move_right", rightDown, rightUp);
				controls.bind("move_up", upDown, upUp);
				controls.bind("move_down", downDown, downUp);
			//}
			
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
			
			super.build();
		}
		
		/**
		 * @copy com.octadecimal.breeze.engine.IUpdateable#update()
		 * @see com.octadecimal.breeze.engine.IUpdateable#update()
		 */
		public function update(change:uint):void 
		{
			// Temp constrain to player
			var world:World = Breeze.modules.find("World") as World;
			if (world)
			{
				// Lerp towards player
				transform.lerp(world.player.transform, 0.015);
				
				// Workaround to prevent "jumping"
				transform.x = Math.round(transform.x);
				transform.y = Math.round(transform.y);
			}
			
			
			var n:Number = 3;
			if (_leftDown) _transform.x -= n;
			if (_rightDown) _transform.x += n;
			if (_upDown) _transform.y -= n;
			if (_downDown) _transform.y += n;
			
			// Temp wrap
			_transform.x = Math.max(0, _transform.x);
			_transform.y = Math.max(0, _transform.y);
			_transform.x = Math.min((world.map.settings.tilesWide-1) * world.map.settings.tileWidth - Breeze.stage.stageWidth, _transform.x);
			_transform.y = Math.min(world.map.settings.tilesHigh * world.map.settings.tileHeight - Breeze.stage.stageHeight, _transform.y);
		}
		private var _lastPlayerX:Number;
		private var _lastPlayerY:Number;
		
		/**
		 * @copy com.octadecimal.breeze.engine.IDrawable#draw()
		 * @see com.octadecimal.breeze.engine.IDrawable#draw()
		 */
		public function draw(change:uint):void 
		{
			
		}
		
	}
}