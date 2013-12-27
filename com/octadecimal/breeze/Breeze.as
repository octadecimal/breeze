/**
 * Class: Breeze
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes
 */

package com.octadecimal.breeze 
{
	import com.octadecimal.breeze.content.*;
	import com.octadecimal.breeze.content.types.*;
	import com.octadecimal.breeze.events.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.util.*;
	import com.octadecimal.breeze.world.World;
	import flash.display.Stage;
	import flash.ui.Mouse;
	
	/**
	 * Core Breeze class. Creates the module class and contains static references to core modules.
	 */
	public class Breeze
	{
		/**
		 * Debug mode. During release builds, this is replaced with a compiler constant.
		 */
		public static const DEBUG:Boolean = true;
		
		
		/**
		 * Modules list.
		 */
		private var _modules:Modules;
		public static function get modules():Modules { return Breeze.ref._modules; }
		
		/**
		 * Event dispatcher.
		 */
		public static var events:EventDispatcher = new EventDispatcher();
		
		/**
		 * Static reference to the instantiated Breeze object.
		 */
		public static var ref:Breeze;
		
		/**
		 * Stage static reference.
		 */
		public static var stage:Stage;
		
		
		/**
		 * Debug module reference.
		 */
		public static var debug:Debug;
		
		/**
		 * Screen module reference.
		 */
		public static var screen:Screen;
		
		/**
		 * Content module reference.
		 */
		public static var content:Content;
		
		/**
		 * Engine module reference.
		 */
		public static var engine:Engine;
		
		/**
		 * Loaded
		 */
		public var started:Boolean = false;
		
		
		/**
		 * Event dispatcher.
		 */
		public var events:EventDispatcher = new EventDispatcher();
		
		
		/**
		 * Constructor.
		 */
		public function Breeze(stage:Stage)
		{
			// Save static reference
			Breeze.ref = this;
			
			// Save static stage reference
			Breeze.stage = stage;
			
			// Initialize
			initialize();
		}
		
		/**
		 * Creates the Modules manager and registers core modules.
		 * @see com.octadecimal.breeze.modules.Module#initialize()
		 */
		private function initialize():void 
		{
			// Instantiate modules
			_modules = new Modules();
			
			// Register core modules
			if(Breeze.DEBUG) { Debug.info(this, "Core modules INITIALIZING..."); }
			Breeze.engine	= _modules.register(Engine) as Engine;
			Breeze.debug 	= _modules.register(Debug) as Debug;
			Breeze.screen	= _modules.register(Screen) as Screen;
			Breeze.content	= _modules.register(Content) as Content;
			
			// Load (allows custom loading of modules)
			if(Breeze.DEBUG) { Debug.info(this, "User modules INITIALIZING..."); }
			load();
		}
		
		protected function load():void
		{
			// Load modules
			if(Breeze.DEBUG) { Debug.info(this, "Modules LOADING..."); }
			_modules.load(onModulesLoaded);
		}
		
		/**
		 * Called when all modules are loaded.
		 */
		private function onModulesLoaded():void
		{
			if (Breeze.DEBUG) { Debug.info(this, "All modules LOADED."); }
			
			// Build modules
			if (Breeze.DEBUG) { Debug.info(this, "Modules BUILDING..."); }
			_modules.build();
			if (Breeze.DEBUG) { Debug.info(this, "All modules BUILT."); }
			
			// Add screen to stage
			Breeze.stage.addChildAt(Breeze.screen.bitmap, 0);
			
			// Dispatch complete event
			events.dispatch(new Event(Event.COMPLETE));
			start();
		}
		
		public function start():void
		{
			if (Breeze.DEBUG) { Debug.info(this, "Breeze started."); }
			
			engine.start();
			
			started = true;
		}
		
		private var _world:World;
		public function createWorldFromMap(mapName:String):World
		{
			_world = Breeze.modules.find("World") as World;
			
			if (_world != null) return _world;
			
			_world = Breeze.modules.register(World) as World;
			_world.load(onWorldLoaded);
			return _world;
		}
		
		private function onWorldLoaded():void
		{
			_world.build();
		}
		
		public static function hideMouse():void
		{
			Mouse.hide();
		}
		
		public static function showMouse():void
		{
			Mouse.show();
		}
	}
}