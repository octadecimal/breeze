/**
 * Class: Game
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.testland 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.events.Event;
	import com.octadecimal.testland.gui.GUI;
	import com.octadecimal.breeze.graphics.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.*;
	import com.octadecimal.breeze.input.*;
	import com.octadecimal.breeze.world.*;
	import com.octadecimal.breeze.world.entities.Actor;
	import com.octadecimal.breeze.world.entities.Character;
	import com.octadecimal.breeze.world.entities.NPC;
	import com.octadecimal.breeze.world.entities.Player;
	import com.octadecimal.testland.gui.windows.WorldControls;
	import com.octadecimal.testland.gui.windows.WorldLoader;
	import flash.display.Stage;
	
	/**
	 * Game description.
	 */
	public class Game extends Breeze
	{ 
		/**
		 * GUI module reference.
		 */
		public static var gui:GUI;
		
		/**
		 * Mouse module reference.
		 */
		public static var mouse:Mouse;
		
		/**
		 * Controls module reference.
		 */
		public static var controls:Controls;
		
		/**
		 * Graphics module reference.
		 */
		public static var graphics:Graphics;
		
		/**
		 * World module reference.
		 */
		public static var world:World;
		
		
		/**
		 * Constructor
		 */
		public function Game(stage:Stage)
		{
			super(stage);
		}
		
		/**
		 * @see com.octadecimal.breeze.Breeze#load()
		 */
		override protected function load():void 
		{
			// Load modules
			Game.graphics 	= Breeze.modules.register(Graphics) as Graphics;
			Game.controls	= Breeze.modules.register(Controls) as Controls;
			//Game.world		= Breeze.modules.register(World) as World;
			Game.mouse		= Breeze.modules.register(Mouse) as Mouse;
			Game.gui 		= Breeze.modules.register(GUI) as GUI;
			
			super.load();
		}
		
		protected function onLoaded():void 
		{
			
		}
		
		override public function start():void 
		{
			gui.registerWindow(new WorldLoader("WorldLoader"));
			
			super.start();
		}
	}
}