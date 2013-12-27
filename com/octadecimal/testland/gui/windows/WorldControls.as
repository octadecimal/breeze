/**
 * Class: WorldControls
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.testland.gui.windows 
{
	import com.octadecimal.breeze.engine.IDrawable;
	import com.octadecimal.breeze.gui.widgets.Button;
	import com.octadecimal.breeze.gui.widgets.Window;
	import com.octadecimal.breeze.util.Debug;
	import com.octadecimal.testland.gui.menus.MainMenu;
	
	public class WorldControls extends Window implements IDrawable
	{ 
		private var _btnLoadWorld:Button;
		private var _btnSpawnNPC1:Button;
		private var _btnSpawnNPC5:Button;
		private var _btnSpawnNPC25:Button;
		
		/**
		 * Menu pane
		 */
		public function get menupane():MainMenu	{ return _menupane; }
		private var _menupane:MainMenu;
		
		
		/**
		 * Constructor
		 */
		public function WorldControls()
		{
			super(name, "World Controls");
		}
		
		override public function initialize():void 
		{
			display.paddingX = 2;
			display.paddingY = 2;
			
			super.initialize();
		}
		
		override public function load(callback:Function):void 
		{
			// Menu pane
			//_menu = requireAsset(new MainMenu()) as MainMenu;
			_menupane = requireAsset(new MainMenu("MainMenu", gui.settings.data.menus.mainmenu)) as MainMenu;
			
			// Create buttons
			_btnLoadWorld  = requireAsset(new Button("btnLoadWorld", "Load World")) as Button;
			_btnSpawnNPC1  = requireAsset(new Button("btnSpawnNPC1", "Spawn NPC (1)")) as Button;
			_btnSpawnNPC5  = requireAsset(new Button("btnLoadWorld", "Spawn NPC (5)")) as Button;
			_btnSpawnNPC25 = requireAsset(new Button("btnLoadWorld", "Spawn NPC (25)")) as Button;
			
			super.load(callback);
		}
		
		override public function build():void 
		{
			// Add menu
			_menupane.display.paddingX = 0;
			_menupane.display.paddingY = 0;
			menubar.add(_menupane);
			
			// Add buttons 
			content.add(_btnLoadWorld);
			content.add(_btnSpawnNPC1, true);
			content.add(_btnSpawnNPC5, true);
			content.add(_btnSpawnNPC25, true);
			
			super.build();
		}
		
		override public function update(change:uint):void 
		{
			super.update(change);
		}
	}
}