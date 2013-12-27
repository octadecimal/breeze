/*
Simple Command - PureMVC
 */
package com.octadecimal.breeze.framework.controller 
{
	import com.octadecimal.breeze.framework.model.ModuleMapProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
    
	/**
	 * SimpleCommand
	 */
	public class ApplicationStartupCommand extends SimpleCommand 
	{	
		override public function execute(note:INotification):void 
		{
			// Create module map
			facade.registerProxy(new ModuleMapProxy());
		}
		
	}
}