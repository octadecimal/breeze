/**
 * Class: CollisionNode
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.engine 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.graphics.DisplayNode;
	import flash.geom.Rectangle;
	
	public class CollisionNode
	{
		/**
		 * Left edge
		 */
		public var left:int = 0;
		
		/**
		 * Top edge
		 */
		public var top:int = 0;
		
		/**
		 * Right edge
		 */
		public var right:int = 0;
		
		/**
		 * Bottom edge
		 */
		public var bottom:int = 0;
		
		
		/**
		 * Constructor
		 */
		public function CollisionNode(left:int=0, top:int=0, right:int=0, bottom:int=0)
		{
			this.left = left; this.top = top; this.right = right; this.bottom = bottom;
		}
		
		
		/**
		 * Tests if this node collides with the passed point.
		 * @param	x	point x
		 * @param	y	point y
		 * @return	True if collision, false if none.
		 */
		public function collidesPoint(x:int, y:int):Boolean
		{
			//trace(y +">"+ top, x +"<"+ right,"|", y +"<"+ bottom, x +">"+ left);
			if (y > top)
				if (x < right)
					if (y < bottom)
						if (x > left)
							return true;
			
			return false;
		}
		
		
		
		/**
		 * Sets the collision bounds.
		 * @param	left	Left edge
		 * @param	top		Top edge
		 * @param	right	Right edge
		 * @param	bottom	Bottom edge
		 */
		public function setBounds(left:int = 0, top:int = 0, right:int = 0, bottom:int = 0):void
		{
			this.left = left; this.top = top; this.right = right; this.bottom = bottom;
		}
		
		/**
		 * Sets the collision bounds from a display node.
		 * @param	display
		 */
		public function fromDisplayNode(display:DisplayNode):void
		{
			this.left = display.x;
			this.right = display.x + display.width;
			this.top = display.y;
			this.bottom = display.y + display.height;
		}
		
		/**
		 * Sets the collision bounds from a rectangle.
		 * @param	rect
		 */
		public function fromRect(rect:Rectangle):void
		{
			this.left = rect.left;
			this.right = rect.right;
			this.top = rect.top;
			this.bottom = rect.bottom;
		}
		
		/**
		 * Outputs bounds.
		 */
		public function toString():String 
		{
			return "left:" + left + " right:" + right + " top:" + top + " bottom:"+bottom;
		}
		
		
		// temp debug draw
		public function debugDraw():void
		{
			Breeze.screen.buffer.fillRect(new Rectangle(left, top, right - left, bottom - top), uint.MAX_VALUE * Math.random());
		}
	}
}