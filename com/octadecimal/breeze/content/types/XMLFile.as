/**
 * Resource: XMLFile
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.content.types 
{
	import com.octadecimal.breeze.content.*;
	import com.octadecimal.breeze.resources.Resource;
	import com.octadecimal.breeze.resources.ResourceParams;
	import com.octadecimal.breeze.util.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * An external XML file.
	 */
	public class XMLFile extends Resource
	{
		/**
		 * Resource type.
		 */
		public static var type:String = "XMLFile";
		
		/**
		 * XML Data
		 */
		private var _data:XML;
		public function get data():XML	{ return _data; }
		
		
		/**
		 * Constructor
		 */
		public function XMLFile(params:ResourceParams)
		{
			super(params);
		}
		
		/**
		 * @see com.octadecimal.breeze.content.IResource#load()
		 */
		override public function load(callback:Function):void
		{
			// Load external xml file
			var loader:URLLoader = new URLLoader(new URLRequest(params.file));
			
			// Listen for events
			loader.addEventListener(Event.COMPLETE, onXMLLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onXMLError);
			
			super.load(callback);
		}
		
		private function onXMLLoaded(e:Event):void 
		{
			// Save xml
			_data = new XML(e.target.data);
			
			// Load complete
			onLoaded();
		}
		
		private function onXMLError(e:IOErrorEvent):void 
		{
			Debug.error(this, "Error loading XML: "+params.file);
		}
		
		/**
		 * @see com.octadecimal.breeze.content.IResource#onLoaded()
		 */
		override public function onLoaded():void
		{
			super.onLoaded();
		}
		
		/**
		 * @see com.octadecimal.breeze.content.IResource#unload()
		 */
		override public function unload():void
		{
			super.unload();
		}
		
		/**
		 * Static factory method.
		 * @return A new XMLFile instance.
		 */
		public static function factory(params:ResourceParams):XMLFile
		{
			return new XMLFile(params);
		}
	}
}