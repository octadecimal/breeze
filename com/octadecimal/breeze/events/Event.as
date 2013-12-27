/**
 * Class: Event
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.events 
{
	
	public class Event
	{ 
		public static var COMPLETE:String = "complete";
		public static var CHANGE:String = "change";
		public static var CLICK:String = "click";
		
		/**
		 * Event type.
		 */
		public var type:String;
		
		
		/**
		 * Constructor
		 */
		public function Event(type:String)
		{
			this.type = type;
		}
		
	}
}