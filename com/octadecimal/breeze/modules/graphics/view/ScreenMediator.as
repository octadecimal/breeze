/*
 Mediator:  ScreenMediator
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.graphics.view 
{
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import com.octadecimal.breeze.modules.graphics.view.*;
	
	/**
	 * ScreenMediator Mediator.
	 * ...
	 */
	public class ScreenMediator extends Mediator implements IMediator 
	{
		// Canonical name of the Mediator
		public static const NAME:String = "ScreenMediator";
		
		/**
		 * Mediator constructor.
		 */
		public function ScreenMediator(viewComponent:Object) {
			super(NAME, viewComponent);
		}	
		
		
		
		// EVENTS
		// =========================================================================================
		
		
		
		
		// VIEW MANIPULATION
		// =========================================================================================
		
		
		
        
		// NOTIFICATIONS
		// =========================================================================================
		
		/**
		 * Notification interests.
		 */
		override public function listNotificationInterests():Array {
			return [];
		}

		/**
		 * Notification handling.
		 */
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {           
				default:
					break;		
			}
		}
		
		
		
		
		// ACCESSORS
		// =========================================================================================
		
		/**
		 * Utility accessor: name
		 */
		override public function getMediatorName():String 	{ return ScreenMediator.NAME; }
		
		/**
		 * Utility accessor: view
		 */
		private function get view():DisplayObject { return viewComponent as DisplayObject }

	}
}
