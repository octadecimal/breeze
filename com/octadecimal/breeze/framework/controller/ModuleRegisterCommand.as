/*
 Command: ModuleRegisterCommand
 Author:  Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.controller 
{
	import com.octadecimal.breeze.framework.ApplicationFacade;
	import com.octadecimal.breeze.framework.interfaces.IModule;
	import com.octadecimal.breeze.framework.model.ModuleMapProxy;
	import com.octadecimal.breeze.framework.model.vo.ModuleVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import flash.utils.getQualifiedClassName;
    
	/**
	 * SimpleCommand
	 */
	public class ModuleRegisterCommand extends SimpleCommand 
	{	
		override public function execute(note:INotification):void 
		{
			// Get module class definition
			var module:Class = Class(note.getBody());
			
			// Instantiate module
			var instance:IModule = new module();
			
			// Get fully qualified class name as a string
			var key:String = getQualifiedClassName(module);
			
			// Split off the package name, leaving only the class name
			key = key.split("::")[1];
			
			// Save pair in module map
			var map:ModuleMapProxy = facade.retrieveProxy(ModuleMapProxy.NAME) as ModuleMapProxy;
			map.registerModule(new ModuleVO(key, instance));
			
			// Send MODULE_REGISTERED
			sendNotification(ApplicationFacade.MODULE_REGISTERED, instance);
		}
	}
}