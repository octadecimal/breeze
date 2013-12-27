/*
 Proxy:  ModuleMapProxy
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.model 
{
	import com.octadecimal.breeze.framework.ApplicationFacade;
	import com.octadecimal.breeze.framework.interfaces.IModule;
	import com.octadecimal.breeze.framework.model.vo.ModuleVO;
	import com.octadecimal.breeze.framework.util.Collection;
	import com.octadecimal.breeze.framework.util.Debug;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * ModuleMapProxy Proxy.
	 * ...
	 */
	public class ModuleMapProxy extends Proxy implements IProxy {
		
		// Canonical name of the Proxy
		public static const NAME:String = "ModuleMapProxy";
		
		/**
		 * Proxy constructor.
		 */
		public function ModuleMapProxy() 
		{
			super(NAME, new Collection());
			Debug.print(this, "Created.");
		}
		
		
		
		// DATA MANIPULATION
		// =========================================================================================
		
		/**
		 * Registers and instantiates a module with the passed class definition.
		 * 
		 * @param	module	The module class definition.
		 */
		public function registerModule(vo:ModuleVO):void
		{
			// Increment number of registered modules
			_numRegisteredModules++;
			
			// Save vo key->instance pair
			map.add(vo.key, vo.instance);
			
			// Debug
			Debug.print(this, "Module registered: " + vo.key + " -> " + vo.instance);
		}
		
		
		
		// HANDLERS
		// =========================================================================================
		
		public function handleModuleInitialized():void
		{
			// Increment number of ready modules
			_numInitializedModules++;
			
			// Debug
			Debug.print(this, "Modules initialized: " + _numInitializedModules + "/" + _numRegisteredModules);
			
			// Check if all modules loaded
			if (_numInitializedModules == _numRegisteredModules)
				sendNotification(ApplicationFacade.MODULES_INITIALIZED);
		}
		
		public function handleModuleLoaded():void
		{
			// Increment number of ready modules
			_numLoadedModules++;
			
			// Debug
			Debug.print(this, "Modules loaded: " + _numLoadedModules + "/" + _numRegisteredModules);
			
			// Check if all modules loaded
			if (_numLoadedModules == _numRegisteredModules)
				sendNotification(ApplicationFacade.MODULES_LOADED);
		}
		
		public function handleModuleBuilt():void
		{
			// Increment number of ready modules
			_numBuiltModules++;
			
			// Debug
			Debug.print(this, "Modules built: " + _numBuiltModules + "/" + _numRegisteredModules);
			
			// Check if all modules loaded
			if (_numBuiltModules == _numRegisteredModules)
				sendNotification(ApplicationFacade.MODULES_BUILT);
		}
		
		
		
		// ACCESSORS
		// =========================================================================================
		
		/**
		 * Utility accessor: name
		 */
		override public function getProxyName():String 			{ return ModuleMapProxy.NAME; }
		
		/**
		 * Utility accessor: data
		 */
		public function get map():Collection 					{ return Collection(getData()); }
		
		/**
		 * Number of registered modules.
		 */
		public function get numRegisteredModules():uint 		{ return _numRegisteredModules; }
		private var _numRegisteredModules:uint = 0;
		
		/**
		 * Number of initialized modules.
		 */
		public function get numInitializedModules():uint 		{ return _numInitializedModules; }
		private var _numInitializedModules:uint = 0;
		
		/**
		 * Number of loaded modules.
		 */
		public function get numLoadedModules():uint 			{ return _numLoadedModules; }
		private var _numLoadedModules:uint = 0;
		
		/**
		 * Number of built modules.
		 */
		public function get numBuiltModules():uint 				{ return _numBuiltModules; }
		private var _numBuiltModules:uint = 0;
	}
}