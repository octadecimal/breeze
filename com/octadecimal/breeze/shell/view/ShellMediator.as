/*
 Mediator:  ShellMediator
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.shell.view 
{
	import com.octadecimal.breeze.framework.view.components.Application;
	import com.octadecimal.breeze.framework.view.ManagedShellMediator;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * ShellMediator Mediator.
	 * ...
	 */
	public class ShellMediator extends ManagedShellMediator implements IMediator 
	{
		// Canonical name of the Mediator
		public static const NAME:String = "ShellMediator";
		
		/**
		 * Mediator constructor.
		 */
		public function ShellMediator(viewComponent:Object) {
			super(NAME, viewComponent);
		}	
		
		
		
		// EVENTS
		// =========================================================================================
		
		
		
		
		// VIEW MANIPULATION
		// =========================================================================================
		
		
		
		
		// ACCESSORS
		// =========================================================================================
		
		/**
		 * Utility accessor: name
		 */
		override public function getMediatorName():String 	{ return ShellMediator.NAME; }
		
		/**
		 * Utility accessor: view
		 */
		private function get view():Application { return viewComponent as Application }

	}
}
