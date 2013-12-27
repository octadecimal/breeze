/**
 * Class: TransformNode
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.world 
{
	
	public class TransformNode
	{ 
		// Constraint
		public var constraint:TransformNode;
		
		// World Position
		public var x:Number=0, y:Number=0;
		
		// Screen Position
		public var screenX:Number=0, screenY:Number=0;
		
		// Angle
		public var angle:Number = 0;
		
		
		/**
		 * Constructor
		 */
		public function TransformNode(x:Number=0,y:Number=0,angle:Number=0,constraint:TransformNode=null) 
		{
			this.x = x;
			this.y = y;
			this.angle = angle;
			this.constraint = constraint;
		}
		
		/**
		 * Angle between
		 */
		public function angleBetween(input:TransformNode):Number
		{
			return Math.atan2(input.y - y, input.x - x);
		}
		
		/**
		 * Distance between
		 */
		public function magnitude(input:TransformNode):Number
		{
			return Math.sqrt(Math.pow(input.x - x, 2) + Math.pow(input.y - y, 2));
		}
		
		/**
		 * Linear interpolation
		 * @param	a
		 * @param	b
		 * @param	weight
		 * @return
		 */
		public function lerp(input:TransformNode, weight:Number=1.0):TransformNode
		{
			x = weight * (input.x - x) + x;
			y = weight * (input.y - y) + y;
			return input;
		}
		
		/**
		 * ToString()
		 * @return
		 */
		public function toString():String 
		{
			return "x: "+x+" y: "+y+" angle: "+angle+" screenX: "+screenX+" screenY: "+screenY+" constraint: "+constraint;
		}
	}
}