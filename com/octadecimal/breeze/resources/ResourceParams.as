/**
 * Class: ResourceParams
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.resources  
{
	/**
	 * Contains parameters required by a resource for loading.
	 */
	public class ResourceParams
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
		 * @param	type	Resource type.
		 * @param	file	Fully qualified filename.
		 */
		public function ResourceParams(type:String, file:String, key:String=null)
		{
			this.type = type;
			this.file = file;
			
			if (key == null) this.key = file;
			else this.key = key;
		}
		
	}
}