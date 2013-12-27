package com.octadecimal.breeze.modules.content.model.vo 
{
	/**
	 * ...
	 * @author Dylan Heyes
	 */
	public class ContentTypeVO
	{
		public var name:String;
		public var definition:Class;
		
		public function ContentTypeVO(name:String, definition:Class) 
		{
			this.name = name;
			this.definition = definition;
		}
		
	}

}