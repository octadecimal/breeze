package com.octadecimal.breeze.modules.content.model.vo 
{
	/**
	 * ...
	 * @author Dylan Heyes
	 */
	public class ContentVO
	{
		/**
		 * Resource type.
		 */
		public var type:String;
		
		/**
		 * Fully qualified filename.
		 */
		public var file:String;
		
		/**
		 * Key. Uses file by default. Uses the file if null.
		 */
		public var key:String;
		
		
		/**
		 * Constructor.
		 * 
		 * @param	type	Content type.
		 * @param	file	Fully qualified filename.
		 * @param	key		Individual content lookup key, uses <code>file</code> if null.
		 */
		public function ContentVO(type:String, file:String, key:String=null)
		{
			this.type = type;
			this.file = file;
			
			if (key == null) this.key = file;
			else this.key = key;
		}
		
		public function output():String
		{
			return "type: " + type + "  file: " + file + "  key: " + key;
		}
	}

}