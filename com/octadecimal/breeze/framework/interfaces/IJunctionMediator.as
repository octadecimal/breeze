/*
 Interace: IJunctionMediator
 Author:   Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.interfaces 
{
	import com.octadecimal.breeze.framework.model.vo.BroadcastVO;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	
	/**
	 * ...
	 * @author Dylan Heyes
	 */
	public interface IJunctionMediator extends IMediator
	{
		function get messageInterests():Vector.<BroadcastVO>;
		function get messageBroadcasts():Vector.<BroadcastVO>;
		function sendMessage(type:String, body:Object, header:Object = null):void;
		function broadcastListener(message:String, notification:String):void;
		function broadcastSender(message:String, notification:String):void;
	}
	
}