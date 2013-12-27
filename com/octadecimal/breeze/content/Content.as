/**
 * Class: Content
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.content 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.events.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.resources.*;
	import com.octadecimal.breeze.util.*;
	import com.octadecimal.breeze.content.types.*;
	
	/**
	 * Content description.
	 */
	public class Content extends Manager
	{ 
		/**
		 * Constructor
		 */
		public function Content()
		{
			
		}
		
		/**
		 * Registers default content types.
		 * @see com.octadecimal.modules.Module#initialize()
		 */
		override public function initialize():void 
		{
			// Don't allow for duplicates
			allowDuplicates = false;
			
			// Register core content types
			registerContentType(XMLFile.type, XMLFile.factory);
			registerContentType(Texture.type, Texture.factory);
			registerContentType(Tilesheet.type, Tilesheet.factory);
			
			super.initialize();
		}
	}
}