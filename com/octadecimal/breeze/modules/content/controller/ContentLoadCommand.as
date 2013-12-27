/*
 Command: ContentLoadCommand
 Author:  Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.content.controller 
{
	import com.octadecimal.breeze.modules.content.model.StorageProxy;
	import com.octadecimal.breeze.modules.content.model.vo.ContentVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
    
	/**
	 * SimpleCommand
	 */
	public class ContentLoadCommand extends SimpleCommand 
	{	
		override public function execute(note:INotification):void 
		{
			// Pass to StorageProxy.loadContent()... maybe move that into here?
			var storage:StorageProxy = facade.retrieveProxy(StorageProxy.NAME) as StorageProxy;
			storage.loadContent(note.getBody() as ContentVO);
		}
		
	}
}