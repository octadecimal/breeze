/*
 Medator:  GraphicsModuleMediator
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.graphics.view 
{
	import com.octadecimal.breeze.framework.interfaces.IModule;
	import com.octadecimal.breeze.framework.view.ModuleMediator;
	import com.octadecimal.breeze.modules.graphics.interfaces.IDrawable;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * GraphicsModuleMediator Mediator.
	 * ...
	 */
	public class GraphicsModuleMediator extends ModuleMediator implements IMediator 
	{
		// Canonical name of the Mediator
		public static const NAME:String = "GraphicsModuleMediator";
		
		/**
		 * Mediator constructor.
		 */
		public function GraphicsModuleMediator(module:IModule) 
		{
			// Super
			super(NAME, module);
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
			switch (note.getName()) {           
				default:
					super.handleNotification(note);		
			}
		}
		
		
		
		
		// ACCESSORS
		// =========================================================================================
		
		/**
		 * Utility accessor: name
		 */
		override public function getMediatorName():String 	{ return GraphicsModuleMediator.NAME; }

	}
}
