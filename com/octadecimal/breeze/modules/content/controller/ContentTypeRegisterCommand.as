/*
Simple Command - PureMVC
 */
package com.octadecimal.breeze.modules.content.controller 
{
	import com.octadecimal.breeze.modules.content.model.StorageProxy;
	import com.octadecimal.breeze.modules.content.model.vo.ContentTypeVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
    
	/**
	 * SimpleCommand
	 */
	public class ContentTypeRegisterCommand extends SimpleCommand 
	{	
		override public function execute(note:INotification):void 
		{
			// Get passed vo
			var vo:ContentTypeVO = note.getBody() as ContentTypeVO;
			
			// Get storage
			var storage:StorageProxy = facade.retrieveProxy(StorageProxy.NAME) as StorageProxy;
			
			// Register type
			storage.registerContentType(vo.name, vo.definition);
		}
		
	}
}