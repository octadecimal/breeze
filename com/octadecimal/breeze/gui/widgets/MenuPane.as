/**
 * Class: MenuPane
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui.widgets 
{
	import com.octadecimal.breeze.util.lists.List;
	import com.octadecimal.breeze.engine.IDrawable;
	
	public class MenuPane extends Widget implements IDrawable
	{ 
		/**
		 * Menus list
		 */
		public function get menus():List	{ return _menus; }
		private var _menus:List = new List();
		
		/**
		 * Menu buttons list
		 */
		public function get buttons():List	{ return _buttons; }
		private var _buttons:List = new List();
		
		/** XML Menus node reference
		 */
		private var _xml:XMLList;
		
		
		/**
		 * Constructor
		 */
		public function MenuPane(name:String, xml:XMLList=null)
		{
			_xml = xml;
			
			super(name, HORIZONTAL);
		}
		
		/**
		 * Initialize
		 */
		override public function initialize():void 
		{
			makeCollidable();
			
			super.initialize();
		}
		
		/**
		 * Finds and returns the Menu with the matching passed name.
		 * @param	name	Menu name.
		 * @return
		 */
		public function getMenu(name:String):Menu
		{
			return _menus.find(name) as Menu;
		}
		
		/**
		 * Finds and returns the MenuItem. Combines MenuPane.getMenu() and MenuItem.getItem()
		 * @param	menu	Menu name.
		 * @param	item	Item name.
		 * @see com.octadecimal.breeze.gui.widgets.MenuPane#getMenu
		 * @see com.octadecimal.breeze.gui.widgets.Menu#getItem
		 * @return	Reference to the MenuItem.
		 */
		public function getMenuItem(menu:String, item:String):MenuItem
		{
			return getMenu(menu).getItem(item);
		}
		
		
		override public function load(callback:Function):void 
		{
			// If XML node was passed in constructor, load from XML
			if (_xml != null) fromXML(_xml);
			
			super.load(callback);
		}
		
		/**
		 * Creates a menu pane (and it's buttons and menus) from an XML node.
		 * @param	xml
		 */
		public function fromXML(xml:XMLList):MenuPane
		{
			var menuName:String, menuCaption:String;
			
			// Loop through menus node and create buttons and menus, and pass on XML to menu.
			for each(var menuNode:XML in xml.children())
			{
				// Because there isn't already enough on the stack
				menuName = menuNode.attribute("name");
				menuCaption = menuNode.attribute("caption");
				
				// Create menu button
				var button:MenuButton = requireAsset(new MenuButton(menuName, menuCaption, null)) as MenuButton;
				_buttons.add(menuName, button);
				
				// Create menu. Pass menuNode
				var menu:Menu = requireAsset(new Menu("Menu_"+menuName, menuNode)) as Menu;
				_menus.add(menuName, menu);
			}
			
			// Return reference to self
			return this;
		}
		
		override public function build():void 
		{
			// Add buttons and attach menus
			var button:MenuButton;
			var menu:Menu;
			for (var i:uint = 0, c:uint = _buttons.length; i < c; i++) 
			{	
				// Get references
				button = _buttons.items[i] as MenuButton;
				menu = _menus.items[i] as Menu;
				
				// Add
				add(button);
				
				// Attach to button
				button.attachMenu(menu);
			}
			
			super.build();
			
			// Generate menus (since menus aren't added to this)
			for each(menu in _menus.items)
				menu.generate();
		}
		
		/**
		 * Update
		 * @param	change
		 */
		override public function update(change:uint):void 
		{
			// A MenuButton has focus
			if (focus)
			{
				// Get menu
				var button:MenuButton = focus as MenuButton;
				var menu:Menu = button.menu;
				
				// Test if mouse is outside bounds
				if (mouse.transform.screenX < collisions.left || mouse.transform.screenY < collisions.top || mouse.transform.screenY > menu.collisions.bottom + 50) {
					focus = null;
					//gui.receivedInput = true;
				}
				else if (mouse.transform.screenX > menu.collisions.right + 50 && mouse.transform.screenX > collisions.right) {
					focus = null;
					//gui.receivedInput = true;
				}
			}
			
			super.update(change);
		}
	}
}