/*
 Mediator:  ManagedJunctionMediator
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.view 
{
	import com.octadecimal.breeze.framework.interfaces.IJunctionMediator;
	import com.octadecimal.breeze.framework.model.vo.BroadcastVO;
	import com.octadecimal.breeze.framework.util.Debug;
	import com.octadecimal.breeze.framework.view.components.Module;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	
	/**
	 * A managed junction mediator allows for easy access to incoming and outgoing pipe
	 * messages by mapping external pipe messages to internal notifications and vice versa.
	 */
	public class ManagedJunctionMediator extends JunctionMediator implements IMediator, IJunctionMediator
	{
		/**
		 * Junction mediator constructor.
		 * 
		 * @param	name	Name for this junction mediator.
		 */
		public function ManagedJunctionMediator(name:String) {
			_name = "[object "+name+"]";
			super(name, new Junction());
		}	
		
		
		
        
		// NOTIFICATIONS
		// =========================================================================================
		
		/**
		 * Notification interests.
		 * 
		 * @return	An array of notification types to listen for.
		 */
		override public function listNotificationInterests():Array 
		{
			var interests:Array = super.listNotificationInterests();
			
			// Map notifications to be broadcast
			for each(var interest:BroadcastVO in messageInterests)
				interests.push(interest.notification);
			
			return interests;
		}

		/**
		 * Notification handling.
		 * 
		 * @param note	Input notification.
		 */
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {           
				default:
					super.handleNotification(note);		
			}
		}
		
		
		
		// MESSAGES
		// =========================================================================================
		
		/**
		 * Sets this object to listen for messages defined by the <code>message</code> argument;
		 * when that message is received, an internal notification defined by the <code>notification
		 * </code> will be sent.
		 * 
		 * @param	message			The message type to listen for.
		 * @param	notification	The notification type to send when message is receieved.
		 */
		public function broadcastListener(message:String, notification:String):void
		{
			messageInterests.push(new BroadcastVO(message, notification));
		}
		
		/**
		 * Sets this object to broadcast the message defined by the <code>message</code> argument;
		 * when the notification is received, a message is sent to the shell over STDOUT with the
		 * type defined by the <code>notification</code> argument.
		 * 
		 * @param	message			The message type to send.
		 * @param	notification	The trigger type of the internal notification.
		 */
		public function broadcastSender(message:String, notification:String):void
		{
			messageBroadcasts.push(new BroadcastVO(message, notification));
		}
		
		/**
		 * Handles incoming pipe messages.
		 * 
		 * @param	message		Input pipe message.
		 */
		override public function handlePipeMessage(message:IPipeMessage):void
		{
			Debug.data(_name, "STDIN:  " + message.getType() + ((message.getBody()) ? (" (" + message.getBody()+")") : ""));
			
			// Super
			super.handlePipeMessage(message);
			
			// Send notification for matching message interest
			for each(var interest:BroadcastVO in messageInterests) {
				if (interest.message == message.getType()) {
					Debug.data(_name, "BROADCAST->NOTIFICATION: " + interest.notification + ((message.getBody()) ? (" (" + message.getBody() + ")") : ""));
					sendNotification(interest.notification, message.getBody());
				}
			}
		}
		
		/**
		 * Sends a message through the STDOUT pipe, with a message type and body
		 * defined by the passed arguments.
		 * 
		 * @param	type	Message type.
		 * @param	body	Message body.
		 * @param	body	Message header. (optional)
		 */
		public function sendMessage(type:String, body:Object, header:Object=null):void
		{
			Debug.data(_name, "STDOUT: " + type + ((body) ? (" (" + body + ")") : ""));
			junction.sendMessage(Module.STDOUT, new Message(type, header, body)); 
		}
		
		
		
		// ACCESSORS
		// =========================================================================================
		
		/**
		 * Message interests array.
		 */
		public function get messageInterests():Vector.<BroadcastVO> { return _messageInterests; }
		private var _messageInterests:Vector.<BroadcastVO>  = new Vector.<BroadcastVO>();
		
		/**
		 * Message broadcasts Vector.<BroadcastVO>.
		 */
		public function get messageBroadcasts():Vector.<BroadcastVO> { return _messageBroadcasts; }
		private var _messageBroadcasts:Vector.<BroadcastVO> = new Vector.<BroadcastVO>();
		
		
		
		// INTERNAL
		// =========================================================================================
		
		/**
		 * Name.
		 */
		private var _name:String;

	}
}
