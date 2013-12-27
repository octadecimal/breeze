/*
 Facade: ApplicationFacade
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework 
{
	import com.octadecimal.breeze.framework.controller.*;
	import com.octadecimal.breeze.framework.util.Debug;
	import com.octadecimal.breeze.framework.view.components.Application;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	/**
	 * ApplicationFacade
	 * ...
	 */
	public class ApplicationFacade extends Facade implements IFacade 
	{
		// Generic startup command
		public static const STARTUP:String 					= "Startup";
		
		// Application startup command
		public static const APPLICATION_STARTUP:String 		= "ApplicationStartup";
		
		// Application run command
		public static const APPLICATION_RUN:String 			= "ApplicationRun";
		
		// Module registration
		public static const MODULE_REGISTER:String 			= "ModuleRegister";
		public static const MODULE_REGISTERED:String 		= "ModuleRegistered";
		
		// Module registration
		public static const MODULE_CONNECTED:String 		= "ModuleConnected";
		
		// Initializes an individual module
		public static const MODULE_INITIALIZE:String 		= "ModuleInitialize";
		public static const MODULE_INITIALIZED:String 		= "ModuleInitialized";
		
		// Load module
		public static const MODULE_LOAD:String 				= "ModuleLoad";
		public static const MODULE_LOADED:String 			= "ModuleLoaded";
		
		// Load module
		public static const MODULE_UNLOAD:String 			= "ModuleUnload";
		public static const MODULE_UNLOADED:String 			= "ModuleUnloaded";
		
		// Initializes an individual module
		public static const MODULE_BUILD:String 			= "ModuleBuild";
		public static const MODULE_BUILT:String 			= "ModuleBuilt";
		
		// Initialize all modules
		public static const MODULES_INITIALIZE:String 		= "ModulesInitialize";
		public static const MODULES_INITIALIZED:String 		= "ModulesInitialized";
		
		// Load all modules
		public static const MODULES_LOAD:String 			= "ModulesLoad";
		public static const MODULES_LOADED:String 			= "ModulesLoaded";
		
		// Unload all modules
		public static const MODULES_UNLOAD:String 			= "ModulesUnload";
		public static const MODULES_UNLOADED:String 		= "ModulesUnloaded";
		
		// Build all modules
		public static const MODULES_BUILD:String 			= "ModulesBuild";
		public static const MODULES_BUILT:String 			= "ModulesBuilt";
		
		
		/**
		 * Constructor
		 */
		public function ApplicationFacade(key:String)
		{
			super(key);	
		}

        /**
         * Multiton ApplicationFacade Factory Method
         */
        public static function getInstance( key:String ) : ApplicationFacade
        {
 			if ( instanceMap[key] == null ) 
 				instanceMap[key]  = new ApplicationFacade(key);
 				
 			return ApplicationFacade(instanceMap[key]);
        }
		
		/**
		 * Register commands with the controller
		 */
		override protected function initializeController():void 
		{
			super.initializeController();
			
			registerCommand( STARTUP, 				ApplicationStartupCommand	);
			registerCommand( MODULE_REGISTER,		ModuleRegisterCommand		);
			registerCommand( MODULE_INITIALIZED,	ModuleInitializedCommand	);
			registerCommand( MODULE_LOADED,			ModuleLoadedCommand			);
			registerCommand( MODULE_BUILT,			ModuleBuiltCommand			);
		}
		
		public function registerModule(module:Class):void
		{
			sendNotification(MODULE_REGISTER, module);
		}
        
        /**
         * Application startup
         * 
         * @param app a reference to the application component 
         */  
        public function startup(app:Application):void
        {
			Debug.print(this, "Starting up...");
        	sendNotification( STARTUP, app );
			Debug.print(this, "Started up.");
        }
		
		/**
		 * Runs the application.
		 */
		public function run():void
		{
			sendNotification(APPLICATION_RUN);
		}
	}
	
}