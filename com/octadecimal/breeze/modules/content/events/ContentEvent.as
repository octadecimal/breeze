/*
 Event:  ContentEvent
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.content.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 */
	public class ContentEvent extends Event 
	{
		/**
		 * Content has successfully loaded.
		 */
		public static const LOADED:String	=	"Loaded";
		
		/**
		 * Content has failed to load.
		 */
		public static const FAILED:String	=	"failed";
		
		/**
		 * Content data.
		 */
		public function get data():Object		{ return _data; }
		private var _data:Object;
		
		
		/**
		 * ContentEvent constructor.
		 * 
		 * @param	type			Event type.
		 * @param	data			Content data.
		 */
		public function ContentEvent(type:String, data:Object=null) 
		{ 
			_data = data;
			super(type, false, false);
		} 
		
		
		/**
		 * Event clone method override.
		 */
		public override function clone():Event 
		{ 
			return new ContentEvent(type, data);
		} 
		
		
		/**
		 * Event toString method override.
		 */
		public override function toString():String 
		{ 
			return formatToString("ContentEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}