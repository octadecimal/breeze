/*
 Module: ContentModule
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.content 
{
	import com.octadecimal.breeze.framework.interfaces.IModule;
	import com.octadecimal.breeze.framework.view.components.Module;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
    
	/**
	 * Module: ContentModule
	 * ...
	 */
	public class ContentModule extends Module implements IModule
	{
		/**
		 * Module name.
		 */
		public static const NAME:String = "ContentModule";
		
		
		/**
		 * Constructor
		 */
		public function ContentModule() 
		{
			super(ContentFacade.getInstance(NAME));
			
			// Instantiate and start application facade.
			ContentFacade.getInstance(NAME).startup(this);
		}
		
	}

}