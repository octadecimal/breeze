/*
 Facade: ShellFacade
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.shell 
{
	import com.octadecimal.breeze.framework.ApplicationFacade;
	import com.octadecimal.breeze.framework.interfaces.IModule;
	import com.octadecimal.breeze.framework.view.components.Application;
	import com.octadecimal.breeze.shell.controller.StartupCommand;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	/**
	 * ShellFacade
	 * ...
	 */
	public class ShellFacade extends ApplicationFacade implements IFacade 
	{
		// Notification name constants
		public static const STARTUP:String = "startup";
		
		
		/**
		 * Constructor
		 */
		public function ShellFacade(key:String)
		{
			super(key);	
		}

        /**
         * Multiton ShellFacade Factory Method
         */
        public static function getInstance( key:String ) : ShellFacade
        {
 			if ( instanceMap[key] == null ) 
 				instanceMap[key]  = new ShellFacade(key);
 				
 			return ShellFacade(instanceMap[key]);
        }
		
		/**
		 * Register commands with the controller
		 */
		override protected function initializeController():void 
		{
			super.initializeController();
			
			registerCommand( STARTUP, StartupCommand );
		}
        
        /**
         * Application startup
         * 
         * @param app a reference to the application component 
         */  
        override public function startup(application:Application):void
        {
			super.startup(application);
			
        	sendNotification( STARTUP, application );
        }
	}
	
}