/**
 * Resource: Texture
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.content.types 
{
	import com.octadecimal.breeze.content.*;
	import com.octadecimal.breeze.resources.Resource;
	import com.octadecimal.breeze.resources.ResourceParams;
	import com.octadecimal.breeze.util.Debug;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * An object that contains a buffer to draw from. Only one Texture is created per resource loaded per Content.loadResource().
	 */
	public class Texture extends Resource
	{
		/**
		 * Resource type
		 */
		public static var type:String = "Texture";
		
		/**
		 * Texture buffer. Made public for performance bias.
		 */
		public var buffer:BitmapData;
		//private var _buffer:BitmapData;
		//public function get buffer():BitmapData	{ return _buffer; }
		
		/**
		 * Loader
		 */
		private var _loader:Loader;
		
		
		/**
		 * Constructor
		 */
		public function Texture(params:ResourceParams)
		{
			super(params);
		}
		
		/**
		 * @see com.octadecimal.breeze.content.IResource#load()
		 */
		override public function load(callback:Function):void
		{
			// Load texture
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTextureLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onTextureError);
			_loader.load(new URLRequest(params.file));
			
			super.load(callback);
		}
		
		private function onTextureLoaded(e:Event):void 
		{
			// Texture loaded, build buffer
			buffer = new BitmapData(_loader.content.width, _loader.content.height, true, 0x0);
			
			// Draw texture to buffer
			buffer.draw(_loader);
			
			// Free loader
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onTextureLoaded);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onTextureError);
			_loader.unload();
			_loader = null;
			
			// Texture ready, call onLoaded
			onLoaded();
		}
		
		private function onTextureError(e:IOErrorEvent):void 
		{
			Debug.print(this, "Error loading texture: " + params.file);
		}
		
		
		/**
		 * @see com.octadecimal.breeze.content.IResource#onLoaded()
		 */
		override public function onLoaded():void
		{
			super.onLoaded();
		}
		
		
		/**
		 * @see com.octadecimal.breeze.content.IResource#unload()
		 */
		override public function unload():void
		{
			// Dispose texture buffer
			buffer.dispose();
			
			// Nullify
			buffer = null;
			
			super.unload();
		}
		
		
		/**
		 * Static factory method.
		 * @return A new Texture instance.
		 */
		public static function factory(params:ResourceParams):Texture
		{
			return new Texture(params);
		}
	}
}