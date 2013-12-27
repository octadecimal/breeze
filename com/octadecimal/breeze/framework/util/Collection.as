package com.octadecimal.breeze.framework.util 
{
	import com.octadecimal.breeze.framework.interfaces.ICollection;
	
	/**
	 * ...
	 */
	public class Collection implements ICollection
	{
		/**
		 * Key lookup.
		 */
		public var keys:Vector.<String> = new Vector.<String>();
		
		/**
		 * Items lookup.
		 */
		public var items:Array = new Array();
		
		/**
		 * Length
		 */
		public var length:uint = 0;
		
		
		/**
		 * Adds an item by key to the map.
		 * 
		 * @param	key
		 * @param	item
		 * @return	Index of the added item.
		 */
		public function add(key:String, item:*):uint
		{
			// Add key
			keys.push(key);
			
			// Add item
			if (item != null) 
				items.push(item);
			
			// Increment
			length++;
			
			// Return
			return (keys.length - 1);
		}
		
		
		/**
		 * Removes an item with a key that matches the
		 * passed 'key' argument.
		 * 
		 * @param	key		Key of item to remove.
		 */
		public function remove(key:String):void
		{
			
		}
		
		
		/**
		 * Finds and returns an item by key.
		 * 
		 * @param	key	Item to search for by key.
		 * @return	Reference to the item with the matching key.
		 */
		public function find(key:String):*
		{
			// Search
			for (var i:uint = 0, c:uint = keys.length; i < c; i++)
				if (keys[i] == key)
					return items[i];
			
			// No matches
			return null;
		}
		
		
		/**
		 * Returns a formatted string of all contents
		 * of this map.
		 * 
		 * @return
		 */
		public function output():String 
		{
			var out:String = "";
			for (var i:uint = 0; i < length; i++) {
				out += "[" + i + "] " +keys[i] + "->" + items[i];
				if (i != length - 1) out += "\n";
			}
			return out;
		}
	}

}