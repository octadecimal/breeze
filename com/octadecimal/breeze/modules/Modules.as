/**
 * Flo Engine - http://flo.octadecimal.com
 * Copyright ©2009 Dylan Heyes
 * -----------------------------------------------------------------------------------
 * Class: Modules 
 * Usage: [empty]
 */

package com.octadecimal.breeze.modules 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.util.*;
	import com.octadecimal.breeze.util.lists.List;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Handles module registration, initialization, loading, and building.
	 */
	public class Modules
	{ 
		// List
		private var _list:List = new List();
		
		// Modules loaded callback
		private var _onLoadedCallback:Function;
		
		// Loading memory
		private var _modulesLoaded:uint = 0;
		
		
		/**
		 * Constructor.
		 */
		public function Modules() 
		{
			
		}
		
		/**
		 * Registers a module. Handles instantiation and generates a key based on the class name. Key does not include package,
		 * thus two modules of the same name should never be registered. <br /><br />
		 * <b>IMPORTANT:</b> Class must be imported somewhere in the compiled code, or else the compiler won't know where to locate
		 * the module and a compiler error will be thrown.
		 * @param	module
		 * @return  Returns a reference to the instantiated object of the passed module class. A reference can also be returned later via modules.find().
		 * @example import com.octadecimal.input.Mouse; <br />
		 * 			var mouse:Mouse = modules.register(Mouse) as Mouse;
		 */
		public function register(module:Class):Module
		{
			// Get fully qualified class name as string
			var key:String = getQualifiedClassName(module);
			if(Breeze.DEBUG) { Debug.print(this, "Registering module: "+key); }
			
			// Instantiate module
			var obj:Module = new module();
			
			// Split off the package, leaving only the class name
			key = key.split("::")[1];
			
			// Add to list
			_list.add(key, obj);
			
			// Initialize module
			//obj.initialize(); <- moved to Module
			
			// Output
			
			// Return instantiated object
			return obj;
		}
		
		
		/**
		 * Loads all registered modules.
		 */
		public function load(callback:Function):void
		{
			// Save callback
			_onLoadedCallback = callback;
			
			// Load first module in list
			loadModule(_list.items[0] as Module);
		}
		
		private function loadModule(module:Module):void
		{
			if(Breeze.DEBUG) { Debug.print(this, "Loading module: "+module); }
			module.load(onModuleLoaded);
		}
		
		/**
		 * Called by a module when it is finished loading. Loads the next module in `items`.
		 */
		private function onModuleLoaded():void
		{
			// Check if at end of list
			if (_modulesLoaded != _list.items.length-1)
			{
				// Load next module
				_modulesLoaded++; 
				loadModule(_list.items[_modulesLoaded] as Module);
			}
			else
			{
				// OnLoaded
				_onLoadedCallback();
			}
		}
		
		
		/**
		 * Builds all registered modules.
		 */
		public function build():void
		{
			for each(var module:IModule in _list.items) {
				module.build();
			}
		}
		
		
		/**
		 * Retrieves and returns the IModule object with the matching passed key. Is a _list.find() decorator.
		 */
		public function find(key:String):IModule
		{
			return _list.find(key) as IModule;
		}
	}
	
}