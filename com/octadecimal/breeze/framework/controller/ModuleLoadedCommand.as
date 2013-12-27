/*
 Command: ModuleInitializedCommand
 Author:  Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.controller 
{
	import com.octadecimal.breeze.framework.model.ModuleMapProxy;
	import com.octadecimal.breeze.framework.util.Debug;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
    
	/**
	 * Invoked when a module has successfully initialized by sending MODULE_INITIALIZED
	 * to the shell. Responsible for updating the ModuleMap.
	 */
	public class ModuleLoadedCommand extends SimpleCommand 
	{	
		override public function execute(note:INotification):void 
		{
			Debug.print(this, "Module loaded.");
			
			// Call ModuleMap's handleModuleInitialized()
			var moduleMap:ModuleMapProxy = facade.retrieveProxy(ModuleMapProxy.NAME) as ModuleMapProxy;
			moduleMap.handleModuleLoaded();
		}
	}
}