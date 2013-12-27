/**
 * Class: Zone
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.world 
{
	import com.octadecimal.breeze.util.Settings;
	
	public class Zone extends Settings
	{ 
		public var name:String;
		
		public var startX:uint = 0;
		public var startY:uint = 0;
		
		public var endX:uint = 0;
		public var endY:uint = 0;
		
		public var width:uint = 0;
		public var height:uint = 0;
		
		
		/**
		 * Constructor
		 */
		public function Zone(xml:XML)
		{
			name = xml.attribute("name");
			
			var start:Array;
			start = String(xml.attribute("start")).split(",");
			startX = start[0];
			startY = start[1];
			
			var end:Array;
			end = String(xml.attribute("end")).split(",");
			endX = end[0];
			endY = end[1];
			
			width = endX - startX;
			height = endY - startY;
			
			super(xml);
		}
		
	}
}