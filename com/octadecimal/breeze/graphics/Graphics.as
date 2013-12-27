/**
 * Class: Graphics
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.graphics 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.resources.Manager;
	import com.octadecimal.breeze.util.lists.List;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Graphics manager. Serves as the interface to the entire graphics library.
	 */
	public class Graphics extends Manager
	{ 
		/**
		 * Copy direction enumeration (VERTICAL)
		 */
		public static const VERTICAL:uint 	= 0;
		
		/**
		 * Copy direction enumeration (HORIZONTAL)
		 */
		public static const HORIZONTAL:uint = 1;
		
		/**
		  * Texture path
		  */
		public static var TEXTURE_PATH:String = "resources/textures/";
		
		/**
		 * List
		 */
		private var _sprites:List = new List();
		
		 
		/**
		 * Constructor
		 */
		public function Graphics()
		{
			
		}
		
		
		/**
		 * Creates and returns a new Sprite
		 */
		public function createSpriteBasic(file:String, autodraw:Boolean=false):SpriteBasic
		{
			// Instantiate
			var sprite:SpriteBasic = new SpriteBasic(file, autodraw);
			
			// Load
			sprite.load(onSpriteLoaded);
			
			// Return
			return sprite;
		}
		
		private function onSpriteLoaded():void
		{
			trace("OH HEY");
			
			onLoaded();
		}
		
		/**
		 * Creates and returns a new Sprite4D
		 */
		public function createSprite4D(node:XML, autodraw:Boolean=false, callback:Function=null):Sprite4D
		{
			// Instantiate
			var sprite:Sprite4D = new Sprite4D(node, autodraw);
			
			// Load
			//sprite.load(node, callback);
			
			// Return
			return sprite;
		}
		
		private function onSprite4DLoaded():void
		{
			trace("Speeerite4D loaded");
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
		 * @copy com.octadecimal.breeze.engine.IUpdateable#update
		 * @see com.octadecimal.breeze.engine.IUpdateable#update
		 */
		public function update(change:uint):void 
		{
			
		}
		
		/**
		 * @copy com.octadecimal.breeze.engine.IDrawable#draw
		 * @see com.octadecimal.breeze.engine.IDrawable#draw
		 */
		public function draw(change:uint):void 
		{
			
		}
		
		public function drawStrip(screen:BitmapData, skin:BitmapData, length:int, used:int, copyRect:Rectangle, copyPoint:Point, copyDirection:uint=HORIZONTAL):void
		{
			var originalLength:Number = (copyDirection == HORIZONTAL) ? copyRect.width : copyRect.height;
			
			// Calculate center width
			var centerWidth:uint = length - used;
			var iterations:uint = Math.ceil(centerWidth / originalLength);
			var iterationsWidth:uint = iterations * originalLength;
			var leftover:int = originalLength - (iterationsWidth - centerWidth);
			
			if (iterations > 100) return;
			
			// Center (DRAW)
			for (var i:uint = 0; i < iterations; i++)
			{
				if (i == iterations - 1) copyRect.width = leftover;
				screen.copyPixels(skin, copyRect, copyPoint);
				copyPoint.x += copyRect.width;
			}
			
			copyRect.width = originalLength;
		}
		
	}
}