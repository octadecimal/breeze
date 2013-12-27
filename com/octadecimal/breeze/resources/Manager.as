/**
 * Class: Manager
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.resources 
{
	import com.octadecimal.breeze.events.Event;
	import com.octadecimal.breeze.modules.Module;
	import com.octadecimal.breeze.util.*;
	import com.octadecimal.breeze.util.lists.List;
	
	/**
	 * Abstract resource manager class.
	 */
	public class Manager extends Module
	{ 
		/**
		 * If the manager allows for duplicates, or if the same resource will always be used.
		 */
		protected var allowDuplicates:Boolean = true;
		
		/**
		 * Queue length
		 */
		private var _queueLength:uint = 0;
		public function get queueLength():uint	{ return _queueLength; }
		
		/**
		 * Lists
		 */
		private var _resources:List = new List();
		private var _callbacks:List = new List();
		private var _factories:List = new List();
		private var _queue:Object = new Object();
		
		
		/**
		 * Constructor
		 */
		public function Manager()
		{
			
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#initialize()
		 * @see com.octadecimal.breeze.modules.Module#initialize()
		 */
		override public function initialize():void 
		{
			// Set as event dispatcher
			eventDispatcher = true;
			
			super.initialize();
		}
		
		/**
		 * Registers a manageable resource type that implements IResource at run-time by creating a link between 
		 * the managed object key and the factory method defined within the IResource. New types may be created 
		 * by the user, so long as the custom typed implements IResource.
		 * 
		 * @param	name		The name (key) of the managed resource type.
		 * @param	factory		The factory method responsible for instantiating and returning new objects for the type.
		 * @see		IResource
		 */
		public function registerContentType(name:String, factory:Function):void
		{
			// Ensure content type has not already been registered
			if (_factories.find(name) == null)
			{
				// Save factory
				_factories.add(name, factory);
				
				// Debug
				Debug.print(this, "Resource type REGISTERED: " + name);
			}
		}
		
		public function queue(params:ResourceParams, onComplete:Function=null):Resource
		{
			// Create resource
			var factory:Function = _factories.find(params.type) as Function;
			var resource:Resource = factory(params);
			
			// Add to queue
			_queue[params.file] = resource;
			
			// Return object reference
			return resource;
		}
		
		
		/**
		 * Loads an IResource. If the resource has already been loaded, a reference to it is immediately returned. Otherwise, it is
		 * immediatley loaded and the caller will be notified of load completion via the passed `ResourceSettings.onLoadedCallback`.
		 * 
		 * @param	settings
		 * @return	A reference to the resource. Will be null until the resource is loaded, so use the onLoadedCallback when necessary.
		 */
		public function loadResource(params:ResourceParams, onComplete:Function=null):Resource
		{
			// Get resource from resources list
			var resource:Resource = _resources.find(params.file) as Resource;
			
			// Check if resource was found
			if (!allowDuplicates && resource != null)
			{
				// Resource was found and is already loaded, callback
				if (resource.loaded) 
					if(onComplete != null) onComplete(resource);
				
				// Resource was found but is still loading, queue callback
				else if (onComplete != null)
					Vector.<Function>(_callbacks.find(params.file)).push(onComplete);
				
				// Return existing resource
				return resource;
			}
			
			// Resource not found, create and load
			else
			{
				// Create callback list for resource
				var resourceCallbacks:Vector.<Function> = new Vector.<Function>();
				
				// Queue callback if passed
				if (onComplete != null) resourceCallbacks.push(onComplete);
				
				// Add resource callback list to callbacks list.
				_callbacks.add(params.file, resourceCallbacks);
				
				// If resource object already exists in queue
				if (_queue[params.file] != null)
				{
					// Already created via queue, use reference
					resource = _queue[params.file];
				}
				else
				{
					// Use resource factory to create resource
					var factory:Function = _factories.find(params.type) as Function;
					resource = factory(params);
				}
				
				// Save resource to resources list
				_resources.add(params.file, resource);
				
				// Call resource.load()
				resource.load(onResourceLoaded);
				
				// Update queue
				_queueLength++;
				
				// Return newly created, unloaded resource
				return resource;
			}
		}
		
		
		/**
		 * Called when an individual resource has completed loading. Calls any accumulated callbacks for the resource.
		 * 
		 * @param	resource
		 */
		private function onResourceLoaded(resource:IResource):void
		{
			Debug.print(this, "Resource loaded: " + resource.params.type + "[" + resource.params.file +"]");
			
			// Call all accumulated callbacks for resource
			for each(var callback:Function in _callbacks.find(resource.params.file)) {
				callback(resource);
			}
			
			// Update queue
			_queueLength--;
			
			// Dispatch queue change event
			events.dispatch(new Event(Event.CHANGE));
			
			// Dispatch queue empty event
			if(_queueLength == 0) events.dispatch(new Event(Event.COMPLETE));
		}
		
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#load()
		 * @see com.octadecimal.breeze.modules.Module#load()
		 */
		override public function load(callback:Function):void 
		{
			super.load(callback);
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#onLoaded()
		 * @see com.octadecimal.breeze.modules.Module#onLoaded()
		 */
		override public function onLoaded():void 
		{
			super.onLoaded();
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#unload()
		 * @see com.octadecimal.breeze.modules.Module#unload()
		 */
		override public function unload():void 
		{
			super.unload();
		}
		
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#build()
		 * @see com.octadecimal.breeze.modules.Module#build()
		 */
		override public function build():void 
		{
			super.build();
		}
		
	}
}