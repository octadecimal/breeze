/**
 * Class: ResourceCallbackList
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.util.lists 
{
	import com.octadecimal.breeze.resources.ResourceParams;
	
	/**
	 * Resource dependency list, where the key is the Resource object, and the items are an array of Resources (the dependencies).
	 */
	public class ResourceCallbackList
	{ 
		/**
		 * Key lookup table for `items`.
		 */
		public var keys:Vector.<String> = new Vector.<String>();
		
		/**
		 * Collection of callbacks.
		 */
		public var items:Vector.<Function> = new Vector.<Function>();
		
		/**
		 * Length
		 */
		public var length:uint = 0;
		
		
		
		
		/**
		 * Constructor
		 */
		public function ResourceCallbackList()
		{
			
		}
		
		
		/**
		 * Adds an item to `items` and saves the key in `keys`.
		 * @param	key		Item key.
		 * @param	item	Item reference.
		 * @return  Index
		 */
		public function add(key:*, item:*=null):uint
		{
			keys.push(key);
			items.push(item);
			length++;
			return(keys.length - 1);
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
		public function find(key:*):*
		{
			// Search through keys for match
			for (var i:uint = 0, c:uint = keys.length; i < c; i++)
				if (keys[i] == key)
					return items[i];
			
			// No matches found, return null
			return null;
		}
		
		public function toString():String 
		{
			var out:String = "";
			for (var i:uint = 0; i < length; i++) {
				out += "\t[" + i + "] " +keys[i] + "->" + items[i];
				if (i != length - 1) out += "\n";
			}
			return out;
		}
		
	}
}