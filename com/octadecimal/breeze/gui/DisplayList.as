/**
 * Class: DisplayList
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.gui.widgets.*;
	import com.octadecimal.breeze.input.Mouse;
	import com.octadecimal.breeze.util.Debug;
	
	public class DisplayList
	{ 
		/**
		 * Key lookup table for `items`.
		 */
		public var keys:Vector.<String> = new Vector.<String>();
		
		/**
		 * Collection of IListItems. 
		 */
		public var items:Vector.<Widget> = new Vector.<Widget>();
		
		
		/**
		 * Constructor
		 */
		public function DisplayList()
		{
			
		}
		
		public function update(change:Number):void
		{
			if (items.length < 1) return;
			
			var gui:GUI = Breeze.modules.find("GUI") as GUI;
			var mouse:Mouse = Breeze.modules.find("Mouse") as Mouse;
			
			// Check for focus change
			if (mouse.isDown)
			{
				// Loop backwards through display list
				for (var i:int = items.length - 1; i >= 0; i--)
				{
					var child:Widget = items[i];
					
					// Check if mouse is within window
					if (mouse.isOver(child.collisions))
					{
						// Save focus target
						gui.focus = child;
						
						// Move to top of display list
						items.splice(i, 1);
						items.push(child);
						
						break;
					}
				}
			}
		}
		
		
		/**
		 * Adds an item to `items` and saves the key in `keys`.
		 * @param	key		Item key.
		 * @param	item	Item reference.
		 */
		public function add(key:String, item:*):void
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
			var index:uint;
			
			// Search through keys for match
			for (var i:uint = 0, c:uint = keys.length; i < c; i++)
				if (keys[i] == key) index = i;
				
			// Remove
			if(Breeze.DEBUG) { Debug.print(this, "Removing: "+i+" - "+keys[index]+"->"+items[index]); }
			keys.splice(index, 1);
			items.splice(index, 1);
		}
		
		
		/**
		 * Finds and returns an item by key.
		 * @param	key
		 * @return	A reference to the object with a matching key.
		 */
		public function find(key:String):*
		{
			// Search through keys for match
			for (var i:uint = 0, c:uint = keys.length; i < c; i++)
				if (keys[i] == key)
					return items[i];
			
			// No matches found, return null
			return null;
		}
		
	}
}