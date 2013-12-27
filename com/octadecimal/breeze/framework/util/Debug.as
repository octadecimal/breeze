package com.octadecimal.breeze.framework.util
{
	/**
	 * ...
	 */
	public class Debug
	{
		private static const INDENT_LENGTH:uint = 38;
		private static const SEPERATOR:String = " ";
		
		
		public static function print(origin:Object, msg:String):void
		{
			output(String(origin), msg, "    ");
		}
		
		public static function info(origin:Object, msg:String):void
		{
			output(String(origin), msg, "  > ");
		}
		
		public static function warn(origin:Object, msg:String):void
		{
			output(String(origin), msg, "  ! WARNING: ");
		}
		
		public static function error(origin:Object, msg:String):void
		{
			output(String(origin), msg, " !! ERROR: ");
		}
		
		public static function data(origin:Object, msg:String):void
		{
			//output(String(origin), msg, "      ~");
		}
		
		public static function line():void
		{
			trace("--------------------------------------------------------------------------------------------------");
		}
		
		
		private static function output(origin:String, msg:String, sep:String):void
		{
			// Create output string buffer
			var out:String = "";
			
			// Append seperators for uniform output margins
			for (var i:uint = origin.length; i < INDENT_LENGTH; i++)
				out += SEPERATOR;
			
			// Remove "[Object" and "]" 
			var formattedOrigin:String = "";
			formattedOrigin += origin.split("[object ")[1];
			formattedOrigin = formattedOrigin.slice(0, formattedOrigin.length-1);
			out += formattedOrigin;
			
			// Append output message
			out += sep + msg;
			
			// Trace final output
			trace(out);
		}
	}

}