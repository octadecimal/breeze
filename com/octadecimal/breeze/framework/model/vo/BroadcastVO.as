package com.octadecimal.breeze.framework.model.vo 
{
	/**
	 * ...
	 * @author Dylan Heyes
	 */
	public class BroadcastVO
	{
		
		public var message:String;
		public var notification:String;
		
		public function BroadcastVO(message:String, notification:String) 
		{
			this.message = message;
			this.notification = notification;
		}
		
	}

}