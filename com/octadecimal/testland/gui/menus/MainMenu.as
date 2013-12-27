/**
 * Class: MainMenu
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.testland.gui.menus 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.engine.IDrawable;
	import com.octadecimal.breeze.events.Event;
	import com.octadecimal.breeze.gui.widgets.Menu;
	import com.octadecimal.breeze.gui.widgets.MenuButton;
	import com.octadecimal.breeze.gui.widgets.MenuItem;
	import com.octadecimal.breeze.gui.widgets.MenuPane;
	import com.octadecimal.breeze.world.World;
	import com.octadecimal.testland.gui.windows.WorldControls;
	
	public class MainMenu extends MenuPane
	{ 
		
		/**
		 * Constructor
		 */
		public function MainMenu(name:String, _xml:XMLList=null)
		{
			super(name, _xml);
		}
		
		override public function initialize():void 
		{
			display.paddingX = 0;
			display.paddingY = 0;
			
			super.initialize();
		}
		
		override public function load(callback:Function):void 
		{
			
			super.load(callback);
		}
		
		override public function build():void 
		{
			super.build();
			
			// Load -> Trio
			var itemTrio:MenuItem = getMenuItem("load", "trio");
			itemTrio.events.listen(Event.CLICK, onTrioClick);
			
			// Window -> World Controls
			var itemWorldControls:MenuItem = getMenuItem("windows", "worldControls");
			itemWorldControls.events.listen(Event.CLICK, onWorldControlsClick);
			
			// Actions -> Spawn NPC
			var itemSpawnNPC1:MenuItem = getMenuItem("actions", "spawn1");
			var itemSpawnNPC5:MenuItem = getMenuItem("actions", "spawn5");
			var itemSpawnNPC25:MenuItem = getMenuItem("actions", "spawn25");
			itemSpawnNPC1.events.listen(Event.CLICK, onSpawnNPC1Click);
			itemSpawnNPC5.events.listen(Event.CLICK, onSpawnNPC5Click);
			itemSpawnNPC25.events.listen(Event.CLICK, onSpawnNPC25Click);
			
			// Skins
			var skinShiny:MenuItem = getMenuItem("skins", "shiny");
			var skinMatte:MenuItem = getMenuItem("skins", "matte");
			var skinSlate:MenuItem = getMenuItem("skins", "slate");
			var skinPearl:MenuItem = getMenuItem("skins", "pearl");
			skinShiny.events.listen(Event.CLICK, onShinyClicked);
			skinMatte.events.listen(Event.CLICK, onMatteClicked);
			skinSlate.events.listen(Event.CLICK, onSlateClicked);
			skinPearl.events.listen(Event.CLICK, onPearlClicked);
		}
		
		private function onShinyClicked(e:Event):void
		{
			gui.changeSkin("shiny");
		}
		
		private function onMatteClicked(e:Event):void
		{
			
			gui.changeSkin("matte");
		}
		
		private function onSlateClicked(e:Event):void
		{
			gui.changeSkin("slate");
		}
		
		private function onPearlClicked(e:Event):void
		{
			gui.changeSkin("pearl");
		}
		
		private function onSpawnNPC1Click(e:Event):void
		{
			var world:World = Breeze.modules.find("World") as World;
			if (world != null)
			{
				world.spawnNPC("snake");
			}
		}
		
		private function onSpawnNPC5Click(e:Event):void
		{
			var world:World = Breeze.modules.find("World") as World;
			if (world != null)
			{
				for (var i:uint = 0; i < 5; i++)
					world.spawnNPC("snake");
			}
		}
		
		private function onSpawnNPC25Click(e:Event):void
		{
			var world:World = Breeze.modules.find("World") as World;
			if (world != null)
			{
				for (var i:uint = 0; i < 25; i++)
					world.spawnNPC("snake");
			}
		}
		
		private function onTrioClick(e:Event):void
		{
			Breeze.ref.createWorldFromMap("resources/maps/trio.xml"); 
		}
		
		private function onWorldControlsClick(e:Event):void
		{
			trace("OMG LOL!");
			
			gui.registerWindow(new WorldControls()); 
		}
		
		override public function update(change:uint):void 
		{
			
			super.update(change);
		}
		
		override public function draw(change:uint):void 
		{
				
			super.draw(change);
		}
	}
}