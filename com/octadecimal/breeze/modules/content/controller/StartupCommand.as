/*
 Command: StartupCommand
 Author:  Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.content.controller 
{
	import com.octadecimal.breeze.framework.interfaces.IModule;
	import com.octadecimal.breeze.modules.content.model.StorageProxy;
	import com.octadecimal.breeze.modules.content.view.ContentModuleMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
    
	/**
	 * SimpleCommand
	 */
	public class StartupCommand extends SimpleCommand 
	{	
		override public function execute(note:INotification):void 
		{
			// Create module mediator
			facade.registerMediator(new ContentModuleMediator(note.getBody() as IModule));
			
			// Create storage proxy
			facade.registerProxy(new StorageProxy());
		}
		
	}
}