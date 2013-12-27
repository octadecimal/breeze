/**
 * Class: PointSprite
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.graphics 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.content.*;
	import com.octadecimal.breeze.content.types.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.resources.Resource;
	import com.octadecimal.breeze.resources.ResourceParams;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * A basic sprite that draws from a texture buffer and has a position on the screen.
	 */
	public class SpriteBasic implements IDrawable
	{ 
		/**
		 * Texture to draw from.
		 */
		public function get texture():Texture		{ return _texture; }
		private var _texture:Texture;
		
		/**
		 * DisplayNode object.
		 */
		public function get display():DisplayNode	{ return _display; }
		private var _display:DisplayNode = new DisplayNode();
		
		/**
		 * Fully qualified path to file.
		 */
		private var _file:String;
		public function get file():String			{ return _file; }
		
		/**
		 * Determines if the Sprite is repsonsible for drawing itself.
		 */
		public function get autodraw():Boolean		{ return _autodraw; }
		private var _autodraw:Boolean;
		
		/**
		 * Copy geoms
		 */
		private var _copyRect:Rectangle = new Rectangle();
		private var _copyPoint:Point = new Point();
		
		/**
		 * Loaded callback
		 */
		private var _onLoadedCallback:Function;
		
		
		/**
		 * Constructor
		 */
		public function SpriteBasic(file:String, autodraw:Boolean=false)
		{
			// Save fully qualified filename
			_file = file;
			
			// Save autodraw flag
			_autodraw = autodraw;
		}
		
		
		/**
		 * Loads the texture.
		 */
		public function load(callback:Function):void 
		{
			// Save callback
			_onLoadedCallback = callback;
			
			// Load texture
			Breeze.content.loadResource(new ResourceParams(Texture.type, "resources/characters/snake/textures/idle_color.png"), onTextureLoaded);
		}
		
		
		/**
		 * Called when a texture has been loaded.
		 * @param	resource	Reference to the loaded texture.
		 */
		protected function onTextureLoaded(resource:Resource):void
		{
			// Save texture reference
			_texture = resource as Texture;
			
			// Set boundary width and height
			_copyRect.width = _texture.buffer.width;
			_copyRect.height = _texture.buffer.height;
			
			// Dispatch onLoaded
			onLoaded();
		}
		
		
		/**
		 * Called when Sprite is fully loaded and ready to be drawn.
		 */
		protected function onLoaded():void 
		{
			// Autodraw
			if (_autodraw) {
				Engine(Breeze.modules.find("Engine")).registerUpdateable(this);
				Engine(Breeze.modules.find("Engine")).registerDrawable(this);
			}
			
			// Callback
			if(_onLoadedCallback != null) _onLoadedCallback();
		}
		
		
		/**
		 * Frees the sprite and makes it eligable for garbage collection.
		 */
		public function unload():void
		{
			_texture.unload();
			_texture = null;
		}
		
		
		/**
		 * @copy com.octadecimal.breeze.engine.IUpdateable
		 * @see com.octadecimal.breeze.engine.IUpdateable
		 */
		public function update(change:uint):void 
		{
			// Inherit display node
			_copyPoint.x = _display.x;
			_copyPoint.y = _display.y;
			
			// Anchor
			_copyPoint.x += _display.anchorX;
			_copyPoint.y += _display.anchorY;
		}
		
		
		/**
		 * @copy com.octadecimal.breeze.engine.IDrawable
		 * @see com.octadecimal.breeze.engine.IDrawable
		 */
		public function draw(change:uint):void 
		{
			// Draw to screen
			Breeze.screen.buffer.copyPixels(_texture.buffer, _copyRect, _copyPoint);
		}
		
	}
}