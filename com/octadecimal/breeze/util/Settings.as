/**
 * Class: Settings
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.util 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.modules.*;
	
	/**
	 * An object that parses raw xml and saves it in a friendly format specific to it's purpose, intended to be extended to add further functionality.
	 */
	public class Settings
	{ 
		public var data:XML;
		
		/**
		 * Constructor
		 */
		public function Settings(xml:XML)
		{
			data = xml;
		}
	}
}