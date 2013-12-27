/*
 Command: StartupCommand
 Author:  Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.shell.controller 
{
	import com.octadecimal.breeze.framework.view.components.Application;
	import com.octadecimal.breeze.shell.view.ShellMediator;
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
			// Create shell
			facade.registerMediator(new ShellMediator(note.getBody() as Application));
		}
		
	}
}