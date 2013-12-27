/*
 Mediator:  ModuleMediator
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.view 
{
	import com.octadecimal.breeze.framework.ApplicationFacade;
	import com.octadecimal.breeze.framework.interfaces.IModule;
	import com.octadecimal.breeze.framework.interfaces.IModuleMediator;
	import com.octadecimal.breeze.framework.util.Debug;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import com.octadecimal.breeze.framework.view.*;
	
	/**
	 * Serves as the base for all module mediators; listens for and implements the implementation
	 * defined in IModule.
	 */
	public class ModuleMediator extends ManagedMediator implements IModuleMediator
	{
		/**
		 * Mediator constructor.
		 */
		public function ModuleMediator(name:String, module:IModule) 
		{
			// Create junction
			junction = new ManagedJunctionMediator(name+"J");
			
			// Map broadcast listeners
			broadcastListener( ApplicationFacade.MODULE_INITIALIZE,	ApplicationFacade.MODULE_INITIALIZE		);
			broadcastListener( ApplicationFacade.MODULE_LOAD,		ApplicationFacade.MODULE_LOAD			);
			broadcastListener( ApplicationFacade.MODULE_UNLOAD,		ApplicationFacade.MODULE_UNLOAD			);
			broadcastListener( ApplicationFacade.MODULE_BUILD,		ApplicationFacade.MODULE_BUILD			);
			
			// Map broadcast senders
			broadcastSender( ApplicationFacade.MODULE_INITIALIZED,	ApplicationFacade.MODULE_INITIALIZED	);
			broadcastSender( ApplicationFacade.MODULE_LOADED,		ApplicationFacade.MODULE_LOADED 		);
			broadcastSender( ApplicationFacade.MODULE_UNLOADED,		ApplicationFacade.MODULE_UNLOADED 		);
			broadcastSender( ApplicationFacade.MODULE_BUILT,		ApplicationFacade.MODULE_BUILT 			);
			
			// Super
			super(name, module);
		}
		
		
		
		// IMODULE IMPLEMENTATION
		// =========================================================================================
		
		public function initialize():void
		{
			Debug.info(this, "Initialized: "+getMediatorName());
			
			sendNotification(ApplicationFacade.MODULE_INITIALIZED, getMediatorName());
		}
		
		public function load():void
		{
			Debug.info(this, "Loading: " + getMediatorName());
			
			// Temporary immediate callback
			onLoaded();
		}
		
		public function unload():void
		{
			Debug.info(this, "Unloading: "+getMediatorName());
			
			sendNotification(ApplicationFacade.MODULE_UNLOADED, getMediatorName());
		}
		
		public function onLoaded():void
		{
			Debug.info(this, "Loaded: "+getMediatorName());
			
			sendNotification(ApplicationFacade.MODULE_LOADED, getMediatorName());
		}
		
		public function build():void
		{
			Debug.info(this, "Building: "+getMediatorName());
			
			sendNotification(ApplicationFacade.MODULE_BUILT, getMediatorName());
		}
		
		public function update():void
		{
		}
		
		public function draw():void
		{
		}
		
		
        
		// NOTIFICATIONS
		// =========================================================================================
		
		/**
		 * Notification interests.
		 */
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
			
			// Internal notifications
			//interests.push();
			
			return interests;
		}

		/**
		 * Notification handling.
		 */
		override public function handleNotification(note:INotification):void {
			
			switch (note.getName()) 
			{	
				// Handle broadcasts
				
				case ApplicationFacade.MODULE_INITIALIZE:
					initialize();
					break;
				
				case ApplicationFacade.MODULE_LOAD:
					load();
					break;
				
				case ApplicationFacade.MODULE_UNLOAD:
					unload();
					break;
				
				case ApplicationFacade.MODULE_BUILD:
					build();
					break;
				
				default:
					super.handleNotification(note);		
			}
		}
		
		
		
		
		// ACCESSORS
		// =========================================================================================
		
		/**
		 * Utility accessor: view (module)
		 */
		protected function get view():IModule { return viewComponent as IModule }

	}
}
