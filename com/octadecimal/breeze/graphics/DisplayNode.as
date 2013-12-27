/**
 * Class: DisplayNode
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.graphics 
{
	import flash.geom.Point;
	
	/**
	 * A node with a position in screen space.
	 */
	public class DisplayNode
	{
		public var x:Number = 0;
		public var y:Number = 0;
		
		public var width:Number = 0;
		public var height:Number = 0;
		
		public var anchorX:Number = 0;
		public var anchorY:Number = 0;
		
		public var paddingX:int = 5;
		public var paddingY:int = 5;
		
		
		public function toString():String 
		{
			return "x=" + x + " y=" + y + ", w=" + width + " h=" + height + ", pX=" + paddingX + " pY=" + paddingY + " x=" + x;
		}
		
		
		///**
		 //* X margin. The spacing along x outside of this container.
		 //*/
		//public function get marginX():int						{ return _marginX; }
		//public function set marginX(a:int):void					{ _marginX = a; }
		//private var _marginX:int=5;
		//
		///**
		 //* Y margin. The spacing alony y outside of this container.
		 //*/
		//public function get marginY():int						{ return _marginY; }
		//public function set marginY(a:int):void					{ _marginY = a; }
		//private var _marginY:int=5;
		//
		///**
		 //* X padding. The spacing along x inside of this container.
		 //*/
		//public function get paddingX():int						{ return _paddingX; }
		//public function set paddingX(a:int):void					{ _paddingX = a; }
		//private var _paddingX:int=5;
		//
		///**
		 //* Y padding. The spacing along y inside of this container.
		 //*/
		//public function get paddingY():int						{ return _paddingY; }
		//public function set paddingY(a:int):void					{ _paddingY = a; }
		//private var _paddingY:int=5;
	}
}