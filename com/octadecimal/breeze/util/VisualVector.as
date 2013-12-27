/**
 * Class: VisualVector
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.util 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.world.TransformNode;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	/**
	 * Debug utility to help visualize the vectors derived from a TransformNode by drawing them visually on the screen.
	 */	
	public class VisualVector extends Shape
	{ 
		private var _input:TransformNode;
		
		public function VisualVector(input:TransformNode)
		{
			_input = input;
			
			// Add to breeze stage
			Breeze.stage.addChild(this);
		}
		
		public function clear():void
		{
			graphics.clear();
		}
		
		public function draw(target:TransformNode):void
		{
			var g:Graphics = this.graphics;
			var t:TransformNode = this._input;
			
			g.clear();
			
			// Draw origin
			g.beginFill(0xCC0000, .25);
			g.drawCircle(t.screenX, t.screenY, 4);
			g.endFill();
			
			// Draw angle
			var rad:Number = _input.angle * (Math.PI / 180);
			
			var mag:Number = _input.magnitude(target);
			g.lineStyle(mag*.01, 0xFF0000);
			g.moveTo(t.screenX, t.screenY);
			g.lineTo(t.screenX + Math.cos(rad) * mag, t.screenY + Math.sin(rad) * mag);
		}
	}
}