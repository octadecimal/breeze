/*
 View:   XMLFile
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.content.view.components 
{
	import com.octadecimal.breeze.framework.util.Debug;
	import com.octadecimal.breeze.modules.content.events.ContentEvent;
	import com.octadecimal.breeze.modules.content.interfaces.IContent;
	import com.octadecimal.breeze.modules.content.model.vo.ContentVO;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * XMLFile View.
	 */
	public class XMLFile extends EventDispatcher implements IContent
	{
		public static var type:String = "XMLFile";
		
		/**
		 * XMLFile content constructor.
		 * 
		 * @param	file	Fully qualified path plus filename to the location of this resource.
		 * @example			new XMLFile("../data/sample.xml");
		 */
		public function XMLFile(vo:ContentVO) 
		{
			// Immediately load upon instantiation
			load(vo.file);
		}
		
		
        
		// LOADING
		// =========================================================================================
		
		private function load(file:String):void
		{
			Debug.info(this, "Loading: " + file);
			
			_loader = new URLLoader();
			
			// Listen for events
			_loader.addEventListener(Event.COMPLETE, onLoaded);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			// Load
			_loader.load(new URLRequest(file));
		}
		
		private function clean():void
		{
			// Remove event handlers
			_loader.removeEventListener(Event.COMPLETE, onLoaded);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_loader = null;
		}
		
		
        
		// HANDLERS
		// =========================================================================================
		
		private function onLoaded(e:Event):void 
		{
			Debug.info(this, "Loaded.");
			
			// Set state
			_loaded = true;
			
			// Dispatch
			dispatchEvent(new ContentEvent(ContentEvent.LOADED, new XML(e.target.data)));
			
			// Cleanup
			clean();
		}
		
		private function onError(e:Event):void 
		{
			// Dispatch
			dispatchEvent(new ContentEvent(ContentEvent.FAILED));
			
			// Cleanup
			clean();
		}
		
		
		
        
		// ACCESSORS
		// =========================================================================================
		
		/**
		 * XML data, as implemented by IContent.
		 */
		public function get data():Object { return _data; }
		private var _data:Object;
		
		/**
		 * Loaded state, as implemented by IContent.
		 */
		public function get loaded():Boolean		{ return _loaded; }
		private var _loaded:Boolean = false;
		
		
		// Private
		private var _loader:URLLoader;
	}
	
}