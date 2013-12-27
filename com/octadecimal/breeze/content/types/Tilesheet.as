/**
 * Resource: Tilesheet
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.content.types 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.content.*;
	import com.octadecimal.breeze.graphics.*;
	import com.octadecimal.breeze.resources.*;
	import com.octadecimal.breeze.util.*;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Acts like a texture, but has an additional alpha buffer that is merged with the color buffer when
	 * both textures have been loaded.
	 */
	public class Tilesheet extends Resource
	{
		/**
		 * Resource type.
		 */
		public static var type:String = "Tilesheet";
		
		/**
		 * Color texture.
		 */
		public function get texture():Texture	{ return _texture; }
		private var _texture:Texture;
		
		/**
		 * Alpha texture.
		 */
		public function get alpha():Texture	{ return _alpha; }
		private var _alpha:Texture;
		
		
		/**
		 * Constructor
		 */
		public function Tilesheet(params:TilesheetParams)
		{
			super(params);
		}
		
		
		/**
		 * @see com.octadecimal.breeze.content.IResource#load()
		 */
		override public function load(callback:Function):void
		{
			var p:TilesheetParams = params as TilesheetParams;
			
			// Load color
			_texture = Breeze.content.loadResource(new ResourceParams(Texture.type, Graphics.TEXTURE_PATH + p.name + "_color.png"), onTextureLoaded) as Texture;
			
			// Load alpha
			_alpha = Breeze.content.loadResource(new ResourceParams(Texture.type, Graphics.TEXTURE_PATH + p.name + "_alpha.png"), onTextureLoaded) as Texture;
			
			super.load(callback);
		}
		
		
		/**
		 * Called when a texture has been loaded.
		 */
		private var _texturesLoaded:uint = 0;
		private var _texturesToLoad:uint = 2;
		
		private function onTextureLoaded(resource:Texture):void
		{
			_texturesLoaded++;
			
			// If all textures have been loaded
			if (_texturesLoaded == _texturesToLoad)
			{
				// Merge channels
				mergeChannels();
				
				// Dispatch onComplete
				onLoaded();
			}
		}
		
		
		/**
		 * @see com.octadecimal.breeze.content.IResource#unload()
		 */
		override public function unload():void
		{
			// Free color texture
			if (_texture != null) 
			{
				_texture.unload();
				_texture = null;
			}
			
			// Free alpha texture
			if (_alpha != null) 
			{
				_alpha.unload()
				_alpha = null;
			}
			
			super.unload();
		}
		
		
		/**
		 * Merges the alpha channel with the color channel then frees the alpha texture.
		 */
		private function mergeChannels():void
		{
			// Copy channel
			_texture.buffer.copyChannel(_alpha.buffer, new Rectangle(0, 0, _texture.buffer.width, _texture.buffer.height), new Point(0, 0), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			if(Breeze.DEBUG) { Debug.print(this, "Channels merged."); }
			
			// Free alpha
			_alpha.unload();
			_alpha = null;
		}
		
		
		/**
		 * Static factory method.
		 * @return A new Tilesheet instance.
		 */
		public static function factory(params:TilesheetParams):Tilesheet
		{
			return new Tilesheet(params);
		}
	}
}