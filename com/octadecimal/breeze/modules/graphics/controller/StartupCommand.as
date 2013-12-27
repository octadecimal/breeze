/*
 Command: StartupCommand
 Author:  Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.graphics.controller 
{
	import com.octadecimal.breeze.framework.interfaces.IModule;
	import com.octadecimal.breeze.modules.graphics.view.components.Screen;
	import com.octadecimal.breeze.modules.graphics.view.GraphicsModuleMediator;
	import com.octadecimal.breeze.modules.graphics.view.ScreenMediator;
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
			facade.registerMediator(new GraphicsModuleMediator(note.getBody() as IModule));
			
			// Create screen
			facade.registerMediator(new ScreenMediator(new Screen()));
		}
		
	}
}