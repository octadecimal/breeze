/**
 * Class: Screen
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.engine 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.Debug;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * Screen description.
	 */
	public class Screen extends Module
	{ 
		/**
		 * Screen buffer. The buffer that all graphics are drawn on. Changed to public for performance bias.
		 */
		//private var _buffer:BitmapData;
		//public function get buffer():BitmapData	{ return _buffer; }
		public var buffer:BitmapData;
		
		/**
		 * Screen bitmap.
		 */
		private var _bitmap:Bitmap;
		public function get bitmap():Bitmap	{ return _bitmap; }
		
		/**
		 * Screen resolution
		 */
		private var _resolutionX:uint, _resolutionY:uint;
		public function get resolutionX():uint				{ return _resolutionX; }
		public function get resolutionY():uint				{ return _resolutionY; }
		public function set resolutionX(x:uint):void		{ _resolutionX = x; }
		public function set resolutionY(y:uint):void		{ _resolutionY = y; }
		
		/**
		 * Screen transparency. Allows for a transparent screen, in cases where you may want to
		 * overlay it over something else.
		 */
		private var _transparent:Boolean = false;
		public function get transparent():Boolean			{ return _transparent; }
		public function set transparent(a:Boolean):void		{ _transparent = a; }
		
		/**
		 * Background color to initially screen with every frame.
		 */
		private var _backgroundColor:uint = 0x888888;
		public function get backgroundColor():uint			{ return _backgroundColor; } 
		public function set backgroundColor(a:uint):void	{ _backgroundColor = a; }
		
		/**
		 * Fit to stage
		 */
		public function get fitToStage():Boolean		{ return _fitToStage; }
		public function set fitToStage(a:Boolean):void	{ _fitToStage = a; }
		private var _fitToStage:Boolean = true;
		
		
		/**
		 * Constructor
		 */
		public function Screen()
		{
		}
		
		
		/**
		 * Clears the screen.
		 */
		public function clear():void
		{
			buffer.fillRect(new Rectangle(0, 0, _resolutionX, _resolutionY), _backgroundColor);
		}
		
		
		/**
		 * Builds the screen bitmap and screen buffer.
		 * @see com.octadecimal.breeze.modules.Module#build()
		 */
		override public function initialize():void 
		{
			// Create bitmap
			_bitmap = new Bitmap();
			
			// Set bitmap params
			_bitmap.pixelSnapping = "never";
			_bitmap.smoothing = false;
			
			// Set resolution
			_resolutionX = Breeze.stage.stageWidth;
			_resolutionY = Breeze.stage.stageHeight;
			
			// Create buffer
			buildBuffer();
			
			// Listen for stage resize events
			Breeze.stage.addEventListener(Event.RESIZE, resize);
			
			super.build();
		} 
		
		private function resize(e:Event):void 
		{
			if (_fitToStage)
			{
				if (Breeze.DEBUG) { Debug.print(this, "Resizing screen..."); }
				_resolutionX = e.target.stageWidth;
				_resolutionY = e.target.stageHeight;
				
				buildBuffer();
			}
		}
		
		
		/**
		 * Builds the screen buffer. If one already exists, it is disposed of and
		 * replaced with the new buffer. This is a relatively expensive operation, so never
		 * call this method every frame.
		 */
		public function buildBuffer():void
		{
			// Save old buffer
			var oldBuffer:BitmapData = buffer;
			
			// Create buffer
			buffer = new BitmapData(_resolutionX, _resolutionY, _transparent, _backgroundColor);
			if (Breeze.DEBUG) { Debug.print(this, "Buffer built: "+_resolutionX+"x"+_resolutionY); }
			
			// Set as bitmap buffer
			_bitmap.bitmapData = buffer;
			
			// Dispose buffer if already exists
			if (oldBuffer != null) oldBuffer.dispose();
		}
	}
}