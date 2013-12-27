/**
 * Class: CallbackList
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.util 
{
	import com.octadecimal.breeze.events.Event;
	/**
	 * Identical to a normal list, except the items list is strictly typed as a Function vector. Also allows an optional event object
	 * to be passed, for event propogation-like routines.
	 */
	public class CallbackList
	{ 
		/**
		 * Key lookup table for `items`.
		 */
		public var keys:Vector.<String> = new Vector.<String>();
		
		/**
		 * Collection of IListItems. 
		 */
		public var items:Vector.<Function> = new Vector.<Function>();
		
		
		/**
		 * Constructor
		 */
		public function CallbackList()
		{
			
		}
		
		
		/**
		 * Adds an item to `items` and saves the key in `keys`.
		 * @param	key		Item key.
		 * @param	item	Item reference.
		 */
		public function add(key:String, item:Function):void
		{
			keys.push(key);
			items.push(item);
		}
		
		
		/**
		 * Removes the specified IListItem from the list by key.
		 * @param	key		Item key.
		 */
		public function remove(key:String):void
		{
			
		}
		
		
		/**
		 * Finds and returns an item by key.
		 * @param	key
		 * @return	A reference to the object with a matching key.
		 */
		public function find(key:String):Function
		{
			// Search through keys for match
			for (var i:uint = 0, c:uint = keys.length; i < c; i++)
				if (keys[i] == key)
					return items[i];
			
			// No matches found, return null
			return null;
		}
		
		
		/**
		 * Executes any callbacks in `items` with a matching key, duplicates included. Allows an optional
		 * event object to be passed.
		 * @param	key		Item key.
		 */
		public function execute(key:String, event:Event=null):void
		{
			// Search through keys for match
			for (var i:uint = 0, c:uint = keys.length; i < c; i++)
				if (keys[i] == key)
					items[i](event);
		}
	}
}