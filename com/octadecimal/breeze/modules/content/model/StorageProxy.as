/*
 Proxy:  StorageProxy
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.content.model 
{
	import com.octadecimal.breeze.framework.util.Collection;
	import com.octadecimal.breeze.framework.util.Debug;
	import com.octadecimal.breeze.modules.content.ContentFacade;
	import com.octadecimal.breeze.modules.content.interfaces.IContent;
	import com.octadecimal.breeze.modules.content.model.vo.ContentVO;
	import com.octadecimal.breeze.modules.content.view.ContentMediator;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * The StorageProxy class stores and provides access to all content declared throughout
	 * the entire application.
	 */
	public class StorageProxy extends Proxy implements IProxy 
	{
		// Canonical name of the Proxy
		public static const NAME:String = "StorageProxy";
		
		/**
		 * Proxy constructor.
		 */
		public function StorageProxy(data:Object = null) {
			super(NAME, data);
			
		}
		
		
		
		// DATA MANIPULATION
		// =========================================================================================
		
		/**
		 * Registers a manageable content type that implents IContentType at run-time by creating an
		 * association between the managed object key and the factory method defined within IContentType.
		 * New types may be created and registered by the user, so long as IContentType is implemented.
		 * 
		 * @param	name		Content type name, used as key for this type.
		 * @param	definition	Content type class.
		 */
		public function registerContentType(name:String, definition:Class):void
		{
			// Ensure content type not already registered
			if (!_factories.find(name))
			{
				// Save factory
				_factories.add(name, definition);
				
				// Debug
				Debug.info(this, "Content type registered: " + name + " -> " + definition);
			}
		}
		
		public function loadContent(vo:ContentVO):void
		{
			// Get (unknown to exist) content from resource list
			var content:IContent = _resources.find(vo.key) as IContent;
			
			// Check if content was found
			if (content)
			{
				Debug.print(this, "Content already loaded: " + vo.file);
				
				// If content already exists and is loaded, immediately notify
				if(content.loaded)
					sendNotification(ContentFacade.CONTENT_LOADED, content, vo.key);
				
				// Resource was found but it still loading, queue callback (?)
			}
			
			// Content not found, create and load
			else
			{
				// Create
				content = createContent(vo);
				
				// Add to resource list
				_resources.add(vo.key, content);
			}
		}
		
		public function createContent(vo:ContentVO):IContent
		{
			// Get content type class definition
			var type:Class = _factories.find(vo.type) as Class;
			
			// Instantiate content type if exists
			if (type) 
			{
				var content:IContent = new type(vo);
				facade.registerMediator(new ContentMediator(vo, content));
				return content;
			}
			else 
			{
				Debug.warn(this, "Error creating content type of: " + vo.key);
				return null;
			}
		}
		
		
		
		// ACCESSORS
		// =========================================================================================
		
		/**
		 * Utility accessor: name
		 */
		//override public function getMediatorName():String 	{ return StorageProxy.NAME; }
		
		/**
		 * Resources
		 */
		public function get resources():Collection		{ return _resources; }
		private var _resources:Collection = new Collection();
		
		/**
		 * Factories
		 */
		public function get factories():Collection		{ return _factories; }
		private var _factories:Collection = new Collection();
		
		/**
		 * Resource queue
		 */
		public function get queue():Object		{ return _queue; }
		private var _queue:Object = new Object();
	}
}