/*
 Mediator:  ContentModuleMediator
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.content.view 
{
	import com.octadecimal.breeze.framework.interfaces.IModule;
	import com.octadecimal.breeze.framework.util.Debug;
	import com.octadecimal.breeze.framework.view.ModuleMediator;
	import com.octadecimal.breeze.modules.content.ContentFacade;
	import com.octadecimal.breeze.modules.content.model.StorageProxy;
	import com.octadecimal.breeze.modules.content.model.vo.ContentTypeVO;
	import com.octadecimal.breeze.modules.content.model.vo.ContentVO;
	import com.octadecimal.breeze.modules.content.view.components.XMLFile;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import com.octadecimal.breeze.modules.content.view.*;
	
	/**
	 * ContentModuleMediator Mediator.
	 * ...
	 */
	public class ContentModuleMediator extends ModuleMediator implements IMediator 
	{
		// Canonical name of the Mediator
		public static const NAME:String = "ContentModuleMediator";
		
		/**
		 * Mediator constructor.
		 */
		public function ContentModuleMediator(module:IModule) {
			super(NAME, module);
		}	
		
		
		
		// MODULE IMPLEMENTATION
		// =========================================================================================
		
		override public function initialize():void 
		{
			// Register content types
			sendNotification(ContentFacade.CONTENTTYPE_REGISTER, new ContentTypeVO("XMLFile", XMLFile));
			
			super.initialize();
		}
		
		override public function load():void 
		{
			// Test content load
			sendNotification(ContentFacade.CONTENT_LOAD, new ContentVO("XMLFile", "data/test.xml"));
			
			super.load();
			
			// Temp
			//onLoaded();
		}
		
		
		
		// NOTIFICATIONS
		// =========================================================================================
		
		/**
		 * Notification interests.
		 */
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
			
			// Internal notifications
			interests.push(ContentFacade.CONTENT_LOADED);
			
			return interests;
		}

		/**
		 * Notification handling.
		 */
		override public function handleNotification(note:INotification):void 
		{
			switch (note.getName()) 
			{
				// Individual content successfully loaded
				case ContentFacade.CONTENT_LOADED:
					trace(note.getType());
					handleContentLoaded(note.getBody() as ContentMediator);
					break;
				
				default:
					super.handleNotification(note);
			}
		}
		
		
		
		// HANDLERS
		// =========================================================================================
		
		private function handleContentLoaded(content:ContentMediator):void
		{
			Debug.print(this, "Content loaded: " + content);
		}
		
		
		
		
		// ACCESSORS
		// =========================================================================================
		
		/**
		 * Utility accessor: name
		 */
		override public function getMediatorName():String 	{ return ContentModuleMediator.NAME; }

	}
}
