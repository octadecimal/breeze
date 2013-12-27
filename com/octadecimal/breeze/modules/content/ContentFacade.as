/*
 Facade: ContentFacade
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.content 
{
	import com.octadecimal.breeze.framework.interfaces.IModule;
	import com.octadecimal.breeze.modules.content.controller.*;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	/**
	 * ContentFacade
	 * ...
	 */
	public class ContentFacade extends Facade implements IFacade 
	{
		// Notification name constants
		public static const STARTUP:String = "startup";
		
		// Inidividual content loading
		public static const CONTENT_LOAD:String		= "ContentLoad";
		public static const CONTENT_LOADED:String	= "ContentLoaded";
		
		// Content type registration
		public static const CONTENTTYPE_REGISTER:String = "ContentTypeRegister";
		
		
		/**
		 * Constructor
		 */
		public function ContentFacade(key:String)
		{
			super(key);	
		}

        /**
         * Multiton ContentFacade Factory Method
         */
        public static function getInstance( key:String ) : ContentFacade
        {
 			if ( instanceMap[key] == null ) 
 				instanceMap[key]  = new ContentFacade(key);
 				
 			return ContentFacade(instanceMap[key]);
        }
		
		/**
		 * Register commands with the controller
		 */
		override protected function initializeController():void 
		{
			super.initializeController();
			
			registerCommand( STARTUP, 				StartupCommand				);
			registerCommand( CONTENT_LOAD, 			ContentLoadCommand			);
			registerCommand( CONTENTTYPE_REGISTER, 	ContentTypeRegisterCommand	);
		}
        
        /**
         * Application startup
         * 
         * @param app a reference to the application component 
         */  
        public function startup(module:IModule):void
        {
        	sendNotification( STARTUP, module );
        }
	}
	
}