/**
 * Class: Label
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui.widgets 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.gui.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.*;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	//[Embed(source="resources/fonts/arial.ttf", fontWeight="bold", fontName="Arial", fontFamily="Arial", mimeType="application/x-font")]
	/**
	 * Label description.
	 */
	public class Label extends Widget implements IDrawable
	{
		private var _text:TextField;
		private var _string:String;
		private var _buffer:BitmapData;
		private var _cache:Boolean;
		
		/**
		 * Constructor
		 */
		public function Label(name:String, string:String, cache:Boolean=true, bold:Boolean = false, shadow:Boolean = false, color:uint = 0xAcAcAc, shadowColor:uint = 0xFFFFFF, font:String = "Arial")
		{
			// Args
			_string = string;
			_cache = cache;
			
			// Textfield (flash.text.TextField)
			_text = new TextField();
			_text.selectable = false;
			_text.autoSize = TextFieldAutoSize.LEFT;
			//_text.antiAliasType = AntiAliasType.ADVANCED;
			
			// Textformat
			var i:int = 11;
			var tf:TextFormat = new TextFormat(font, i, color, bold);
			tf.letterSpacing = 0;
			_text.defaultTextFormat = tf;
			
			// Set text
			_text.text = _string;
			
			//_text.embedFonts = true;
			
			// Draw as cached
			if (cache)
			{
				
				_buffer = new BitmapData(_text.width, _text.height, true, 0x0);
				
				if (shadow)
				{
					// Matrix
					var m:Matrix = new Matrix();
					
					// Draw shadow
					tf.color = shadowColor;
					_text.defaultTextFormat = tf;
					_text.text = _string;
					m.tx = 1;
					m.ty = 1;
					_buffer.draw(_text, m);
					
					// Reset
					m.tx = 0;
					m.ty = 0;
				}
				
				// Draw text
				tf.color = color;
				_text.defaultTextFormat = tf;
				_text.text = _string;
				tf.color = color;
				_buffer.draw(_text);
				
				// Free textfield
				
			}
			
			
			super(name);
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Widget#initialize()
		 * @see com.octadecimal.breeze.modules.Widget#initialize()
		 */
		override public function initialize():void 
		{
			if (_cache)
			{
				display.width = _buffer.width;
				display.height = _buffer.height;
			
				copyRect.width = _buffer.width;
				copyRect.height = _buffer.height;
			}
			else
			{
				Breeze.stage.addChild(_text);
				display.width = _text.width;
				display.height = _text.height;
			}
			
			super.initialize();
		}
		
		public function setText(str:String):void
		{
			/* TODO: Make cached version rebuild and redraw */
			
			if (!_cache)
			{
				_text.text = str;
			}
		}
		
		/**
		 * @copy com.octadecimal.breeze.engine.IDrawable#draw()
		 * @see com.octadecimal.breeze.engine.IDrawable#draw()
		 */
		override public function draw(change:uint):void 
		{
			if (!_cache)
			{
				_text.x = display.x;
				_text.y = display.y;
			}
			
			copyPoint.x = display.x;
			copyPoint.y = display.y;
			
			if(_cache) Breeze.screen.buffer.copyPixels(_buffer, copyRect, copyPoint);
			
			super.draw(change);
		}
		
	}
}