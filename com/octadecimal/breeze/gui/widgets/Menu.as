/**
 * Class: Menu
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui.widgets 
{
	import com.octadecimal.breeze.engine.IDrawable;
	import com.octadecimal.breeze.util.lists.List;
	
	public class Menu extends Widget implements IDrawable
	{
		/**
		 * MenuItems list
		 */
		public function get items():List	{ return _items; }
		private var _items:List = new List();
		
		/** 
		 * XML Menus node reference
		 */
		private var _xml:XML;
		
		/**
		 * The widget that is responsibile (if any) for triggering if this menu should
		 * draw or not. Later on this can be abstracted into an ITriggerer interface
		 * should the Widget class not provided required functionality.
		 */
		public function set trigger(w:Widget):void { _trigger = w; }
		public function get trigger():Widget	{ return _trigger; }
		private var _trigger:Widget;
		
		/**
		 * Constructor
		 */
		public function Menu(name:String, xml:XML)
		{
			_xml = xml;
			
			super(name, VERTICAL);
		}
		
		/**
		 * Initialize
		 */
		override public function initialize():void 
		{
			display.paddingX = 0;
			display.paddingY = 0;
			
			makeCollidable();
			
			super.initialize();
		}
		
		
		public function getItem(name:String):MenuItem
		{
			return _items.find(name) as MenuItem;
		}
		
		
		/**
		 * Load. Loads the XML, if was passed in constructor.
		 * @param	callback
		 */
		override public function load(callback:Function):void 
		{
			// Load from XML
			fromXML(_xml);
			
			super.load(callback);
		}
		
		/**
		 * Creates a menu pane (and it's buttons and menus) from an XML node.
		 * @param	xml
		 */
		public function fromXML(xml:XML):Menu
		{
			// Create items from xml
			for each(var itemNode:XML in xml.children())
			{
				var item:MenuItem = requireAsset(new MenuItem("MenuItem_" + itemNode.attribute("name"), itemNode.attribute("caption"))) as MenuItem;
				_items.add(itemNode.attribute("name"), item);
			}
			
			// Return reference to self
			return this;
		}
		
		
		/**
		 * Build. Adds the MenuItems.
		 */
		override public function build():void 
		{
			// Add items
			for each(var item:MenuItem in _items.items)
				add(item, true);
			
			super.build();
		}
		
		
		/**
		 * Update
		 * @param	change
		 */
		override public function update(change:uint):void 
		{
			if (_trigger != null)
			{
				display.x = _trigger.display.x;
				display.y = _trigger.display.y + _trigger.display.height +3;
				
				//trace(parent.name, parent.display.y, parent.display.height);
				//trace(parent.name, display.y);
				
				
			
				//if (mouseState == MOUSE_OUT)
				//{
				//
					//var pane:MenuPane = menuButton.parent as MenuPane;
					//if (menuButton.mouseState == MOUSE_OUT)
					//{
						//pane.focus = null;
					//}
				//}
			}
			
			debug = false;
			
			super.update(change);
		}
	}
}