/*
 Module: GraphicsModule
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.graphics 
{
	import com.octadecimal.breeze.framework.view.components.Module;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
    
	/**
	 * Module: GraphicsModule
	 * ...
	 */
	public class GraphicsModule extends Module
	{
		/**
		 * Module name.
		 */
		public static const NAME:String = "GraphicsModule";
		
		/**
		 * View components.
		 */
		
		
		/**
		 * Constructor
		 */
		public function GraphicsModule() 
		{
			// Instantiate and start application facade.
			super(GraphicsFacade.getInstance(NAME));
			GraphicsFacade(facade).startup(this);
		}
		
	}

}