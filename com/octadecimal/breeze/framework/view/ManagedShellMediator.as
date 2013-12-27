/*
 Medator:  ManagedShellMediator
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.view 
{
	import com.octadecimal.breeze.framework.ApplicationFacade;
	import com.octadecimal.breeze.framework.model.ModuleMapProxy;
	import com.octadecimal.breeze.framework.util.Debug;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * ManagedShellMediator Mediator.
	 * ...
	 */
	public class ManagedShellMediator extends ManagedMediator implements IMediator 
	{
		
		/**
		 * Mediator constructor.
		 */
		public function ManagedShellMediator(name:String, viewComponent:Object) 
		{
			// Shell junction
			junction = new ManagedShellJunctionMediator(getMediatorName()+"J");
			
			// Map broadcasts
			broadcastSender( ApplicationFacade.MODULE_INITIALIZE, 	ApplicationFacade.MODULES_INITIALIZE	);
			broadcastSender( ApplicationFacade.MODULE_LOAD, 		ApplicationFacade.MODULES_LOAD			);
			broadcastSender( ApplicationFacade.MODULE_UNLOAD, 		ApplicationFacade.MODULES_UNLOAD		);
			broadcastSender( ApplicationFacade.MODULE_BUILD, 		ApplicationFacade.MODULES_BUILD			);
			
			// Map interests
			broadcastListener(ApplicationFacade.MODULE_INITIALIZED);
			broadcastListener(ApplicationFacade.MODULE_LOADED);
			broadcastListener(ApplicationFacade.MODULE_UNLOADED);
			broadcastListener(ApplicationFacade.MODULE_BUILT);
			
			// Super
			super(name, viewComponent);
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
			interests.push(ApplicationFacade.APPLICATION_RUN);
			interests.push(ApplicationFacade.MODULE_REGISTERED);
			interests.push(ApplicationFacade.MODULES_INITIALIZED);
			interests.push(ApplicationFacade.MODULES_LOADED);
			interests.push(ApplicationFacade.MODULES_BUILT);
			
			return interests;
		}

		/**
		 * Notification handling.
		 */
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{   
				// Application run, initialize modules
				case ApplicationFacade.APPLICATION_RUN:
					handleApplicationRun();
					break;
				
				// Handle all modules initialized
				case ApplicationFacade.MODULES_INITIALIZED:
					handleModulesInitialized();
					break;
				
				// Handle all modules loaded
				case ApplicationFacade.MODULES_LOADED:
					handleModulesLoaded();
					break;
				
				// Handle all modules built
				case ApplicationFacade.MODULES_BUILT:
					handleModulesBuilt();
					break;
				
				
				default:
					super.handleNotification(note);		
			}
		}
		
		
		
		// HANDLERS
		// =========================================================================================
		
		private function handleApplicationRun():void
		{
			Debug.line();
			Debug.info(this, "Initializing modules...");
			Debug.line();
			sendNotification(ApplicationFacade.MODULES_INITIALIZE);
		}
		
		private function handleModulesInitialized():void
		{
			Debug.line();
			Debug.info(this, "All modules initialized, loading...");
			Debug.line();
			
			// Load modules
			sendNotification(ApplicationFacade.MODULES_LOAD);
		}
		
		private function handleModulesLoaded():void
		{
			Debug.line();
			Debug.info(this, "All modules loaded, building...");
			Debug.line();
			
			// Build modules
			sendNotification(ApplicationFacade.MODULES_BUILD);
		}
		
		private function handleModulesBuilt():void
		{
			Debug.line();
			Debug.info(this, "All modules built and ready.");
			Debug.line();
		}
	}
}
