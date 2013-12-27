/*
 Facade: GraphicsFacade
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.graphics 
{
	import com.octadecimal.breeze.framework.interfaces.IModule;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import com.octadecimal.breeze.modules.graphics.model.*;
	import com.octadecimal.breeze.modules.graphics.view.*;
	import com.octadecimal.breeze.modules.graphics.controller.*;
	
	/**
	 * GraphicsFacade
	 * ...
	 */
	public class GraphicsFacade extends Facade implements IFacade 
	{
		// Notification name constants
		public static const STARTUP:String = "startup";
		
		// Creation commands
		public static const SPRITE2D_CREATE:String		= "Sprite2DCreate";
		public static const SPRITE3D_CREATE:String		= "Sprite3DCreate";
		public static const SPRITEGRID_CREATE:String	= "SpriteGridCreate";
		
		
		/**
		 * Constructor
		 */
		public function GraphicsFacade(key:String)
		{
			super(key);	
		}

        /**
         * Multiton GraphicsFacade Factory Method
         */
        public static function getInstance( key:String ) : GraphicsFacade
        {
 			if ( instanceMap[key] == null ) 
 				instanceMap[key]  = new GraphicsFacade(key);
 				
 			return GraphicsFacade(instanceMap[key]);
        }
		
		/**
		 * Register commands with the controller
		 */
		override protected function initializeController():void 
		{
			super.initializeController();
			
			registerCommand( STARTUP, 			StartupCommand			);
			registerCommand( SPRITE2D_CREATE, 	Sprite2DCreateCommand	);
			registerCommand( SPRITE3D_CREATE, 	Sprite3DCreateCommand	);
			registerCommand( SPRITEGRID_CREATE,	SpriteGridCreateCommand	);
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