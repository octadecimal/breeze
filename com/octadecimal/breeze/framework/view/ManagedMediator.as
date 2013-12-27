/*
 Mediator:  ManagedMediator
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.view 
{
	import com.octadecimal.breeze.framework.interfaces.IJunctionMediator;
	import com.octadecimal.breeze.framework.model.vo.BroadcastVO;
	import com.octadecimal.breeze.framework.util.Debug;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import com.octadecimal.breeze.framework.view.*;
	
	/**
	 * A managed mediator, in conjunction with a <code>ManagedJunctionMediator</code>, allows for
	 * easy access to standard input and output types by automatically providing functionality
	 * for subclasses to map external pipe messages to internal notifications and vice versa.
	 * Note that a direct descendent of <code>ManagedMediator</code> must manually create and supply
	 * a <code>ManagedJunctionMediator</code> before this mediator is registered with the facade,
	 * preferably in its constructor.
	 */
	public class ManagedMediator extends Mediator implements IMediator 
	{
		/**
		 * Mediator constructor.
		 */
		public function ManagedMediator(name:String, viewComponent:Object) {
			super(name, viewComponent);
		}	
		
		override public function onRegister():void 
		{
			super.onRegister();
			
			// Register junction
			facade.registerMediator(junction);
		}
		
		
        
		// NOTIFICATIONS
		// =========================================================================================
		
		/**
		 * Notification interests.
		 */
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
			
			// Map notifications to be broadcast
			for each(var broadcast:BroadcastVO in junction.messageBroadcasts)
				interests.push(broadcast.notification);
			
			// Map broadcasts to be wrapped as notifications
			for each(var interest:BroadcastVO in junction.messageInterests)
				interests.push(interest.notification);
			
			return interests;
		}

		/**
		 * Notification handling.
		 */
		override public function handleNotification(note:INotification):void 
		{
			// Broadcast if interested notifications
			for each(var interest:BroadcastVO in junction.messageBroadcasts) 
			{
				if (interest.notification == note.getName()) 
				{
					Debug.data(this, "NOTIFICATION->BROADCAST: " + interest.notification + ((note.getBody()) ? (" (" + note.getBody() + ")") : ""));
					junction.sendMessage(interest.message, note.getBody());
					break;
				}
			}
			
			// Default
			switch (note.getName()) {
				default:
					super.handleNotification(note);		
			}
		}
		
		
		
		// MESSAGES
		// =========================================================================================
		
		/**
		 * Saves a relationship between the passed <code>message</code> and <code>notification</code>
		 * types, in that when a respective message type is receieved over a pipe, the corresponding
		 * notification will be sent internally through the core.
		 * 
		 * @param	message
		 * @param	notification
		 */
		protected function broadcastListener(message:String, notification:String=null):void
		{
			if (!notification) notification = message;
			junction.broadcastListener(message, notification);
			Debug.data(this, "LSTN: m:" + message + " -> i:" + notification);
		}
		
		/**
		 * Saves a relationship between the passed <code>message</code> and <code>notification</code>
		 * types, in that when a respective notification type is receieved, the notification will be
		 * sent as a message through the output pipe.
		 * 
		 * @param	message
		 * @param	notification
		 */
		protected function broadcastSender(message:String, notification:String=null):void
		{
			if (!notification) notification = message;
			junction.broadcastSender(message, notification);
			Debug.data(this, "SEND: m:" + message + " <- i:" + notification);
		}
		
		
		
		// PRIVATE STATE
		// =========================================================================================
		
		protected var junction:IJunctionMediator;

	}
}
