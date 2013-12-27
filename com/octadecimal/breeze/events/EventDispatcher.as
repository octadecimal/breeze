/**
 * Class: EventDispatcher
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.events 
{
	import com.octadecimal.breeze.util.CallbackList;
	
	/**
	 * A light-weight event dispatcher that doesn't create an object per dispatched event.
	 * Used for all events used widthin Breeze instead of the default Flash event dispatcher.
	 */
	public class EventDispatcher
	{ 
		/**
		 * Callback list
		 */
		private var _callbacks:CallbackList = new CallbackList();
		
		
		/**
		 * Binds an event to the passed callback method.
		 * 
		 * @param	event		The event type.
		 * @param	callback	The callback method.
		 */
		public function listen(event:String, callback:Function):void
		{
			_callbacks.add(event, callback);
		}
		
		
		/**
		 * Invokes CallbackList.execute() for the passed event.
		 * 
		 * @param	event	The dispatched event name.
		 */
		public function dispatch(event:Event):void
		{
			_callbacks.execute(event.type, event);
		}
	}
}