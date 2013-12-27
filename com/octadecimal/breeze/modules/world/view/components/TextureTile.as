/*
 View:   TextureTile
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.world.view.components 
{
	import com.octadecimal.topographer.Topographer;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	/**
	 * TextureTile View.
	 */
	public class TextureTile 
	{
		public static const srcRectangle:Rectangle = new Rectangle(0, 0, 256, 256);
		
		public function TextureTile(width:int, height:int, source:String, extension:String="png") 
		{
			// Initialize
			_width = width;
			_height = height;
			_halfWidth = width * .5;
			_halfHeight = height * .5;
			
			// Create buffers
			_a = new BitmapData(_halfWidth, _halfHeight, false, 0x0);
			_b = new BitmapData(_halfWidth, _halfHeight, false, 0x0);
			_c = new BitmapData(_halfWidth, _halfHeight, false, 0x0);
			_d = new BitmapData(_halfWidth, _halfHeight, false, 0x0);
			
			// Event listeners
			_aLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, aLoaded);
			_bLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bLoaded);
			_cLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, cLoaded);
			_dLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, dLoaded);
			
			// Load
			_aLoader.load(new URLRequest(source + "a." + extension));
			_bLoader.load(new URLRequest(source + "b." + extension));
			_cLoader.load(new URLRequest(source + "c." + extension));
			_dLoader.load(new URLRequest(source + "d." + extension));
		}
		
		
        
		// API
		// =========================================================================================
		
		public function draw(x:Number, y:Number):void
		{
			Topographer.screen.bitmapData.copyPixels(_a, srcRectangle, new Point(x, y));
			Topographer.screen.bitmapData.copyPixels(_b, srcRectangle, new Point(x+_halfWidth, y));
			Topographer.screen.bitmapData.copyPixels(_c, srcRectangle, new Point(x, y+_halfHeight));
			Topographer.screen.bitmapData.copyPixels(_d, srcRectangle, new Point(x+_halfWidth, y+_halfHeight));
		}
		
		
        
		// EVENT HANDLERS
		// =========================================================================================
		
		private function aLoaded(e:Event):void 
		{
			_a.draw(_aLoader);
			_aLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, aLoaded);
			_aLoader.unload();
		}
		
		private function bLoaded(e:Event):void 
		{
			_b.draw(_bLoader);
			_bLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bLoaded);
			_bLoader.unload();
		}
		
		private function cLoaded(e:Event):void 
		{
			_c.draw(_cLoader);
			_cLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, cLoaded);
			_cLoader.unload();
		}
		
		private function dLoaded(e:Event):void 
		{
			_d.draw(_dLoader);
			_dLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, dLoaded);
			_dLoader.unload();
		}
		
		
        
		// ACCESSORS
		// =========================================================================================
		
		public function get a():BitmapData { return _a; }
		public function set a(value:BitmapData):void 
		{
			_a = value;
		}
		
		public function get b():BitmapData { return _b; }
		public function set b(value:BitmapData):void 
		{
			_b = value;
		}
		
		public function get c():BitmapData { return _c; }
		public function set c(value:BitmapData):void 
		{
			_c = value;
		}
		
		public function get d():BitmapData { return _d; }
		public function set d(value:BitmapData):void 
		{
			_d = value;
		}
		
		public function get width():Number { return _width; }
		public function set width(value:Number):void 
		{
			_width = value;
		}
		
		public function get height():Number { return _height; }
		public function set height(value:Number):void 
		{
			_height = value;
		}
		
		
        
		// PRIVATE
		// =========================================================================================
		
		// Buffers
		private var _a:BitmapData;
		private var _b:BitmapData;
		private var _c:BitmapData;
		private var _d:BitmapData;
		
		// Loaders
		private var _aLoader:Loader = new Loader();
		private var _bLoader:Loader = new Loader();
		private var _cLoader:Loader = new Loader();
		private var _dLoader:Loader = new Loader();
		
		// Dimensions
		private var _width:Number;
		private var _height:Number;
		
		// Memory
		private var _halfWidth:Number;
		private var _halfHeight:Number;
	}
	
}