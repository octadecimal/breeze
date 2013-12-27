/*
 Mediator:  ContentMediator
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.content.view 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.octadecimal.breeze.framework.util.Debug;
	import com.octadecimal.breeze.modules.content.ContentFacade;
	import com.octadecimal.breeze.modules.content.events.ContentEvent;
	import com.octadecimal.breeze.modules.content.interfaces.IContent;
	import com.octadecimal.breeze.modules.content.model.vo.ContentVO;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * A ContentMediator serves as a generic wrapper for all content types provided by Breeze
	 * or defined by the user.
	 */
	public class ContentMediator extends Mediator implements IMediator 
	{
		/**
		 * Mediator constructor.
		 */
		public function ContentMediator(vo:ContentVO, content:IContent) 
		{
			// Save vo
			_vo = vo;
			
			// Super
			super(vo.key, content);
			
			// Debug
			Debug.print(this, "Created. "+content);
		}
		
		override public function onRegister():void 
		{
			super.onRegister();
			
			// Listen for view events
			view.addEventListener(ContentEvent.LOADED, handleContentLoaded);
		}
		
		
		
		// EVENTS
		// =========================================================================================
		
		private function handleContentLoaded(e:Event):void 
		{
			// View dispatched complete event, meaning it was successfully loaded, send note.
			sendNotification(ContentFacade.CONTENT_LOADED, this, vo.file);
		}
		
		
		
		// NOTIFICATIONS
		// =========================================================================================
		
		/**
		 * Notification interests.
		 */
		override public function listNotificationInterests():Array {
			return [];
		}

		/**
		 * Notification handling.
		 */
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {           
				default:
					break;		
			}
		}
		
		
		
		// ACCESSORS
		// =========================================================================================
		
		/**
		 * Utility accessor: view
		 */
		private function get view():EventDispatcher { return viewComponent as EventDispatcher }
		
		/**
		 * ContentVO
		 */
		public function get vo():ContentVO		{ return _vo; }
		private var _vo:ContentVO;
		
		/**
		 * State: Loaded
		 */
		public function get loaded():Boolean		{ return _loaded; }
		private var _loaded:Boolean = false;

	}
}
