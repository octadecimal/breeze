/**
 * Class: Module
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.modules 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.events.*;
	import com.octadecimal.breeze.resources.*;
	import com.octadecimal.breeze.util.*;
	import com.octadecimal.breeze.util.lists.*;
	
	/**
	 * Abstract module class. Provides the framework for objects allowing them to load, build, update and draw.
	 * Also allows for seamless runtime plugging into the Breeze engine, allowing for fully extendable plugins to be
	 * created for any unique functionality specific to a particular game. <br />If module needs updating or drawing,
	 * registerAsUpdateable() and/or registerAsDrawable() must be called. <br />If a module needs to dispatch events,
	 * `eventDispatcher` should be set to true inside initialize(). <br />If a module needs to load resources,
	 * `requiresLoading` should be set to true inside initialize().
	 */
	public class Module implements IModule, IListItem
	{
		/**
		 * Flag that determines if this object should serve as an event dispatcher. Must be called in initialize().
		 */
		protected var eventDispatcher:Boolean = false;
		
		/**
		 * Event disptacher
		 */
		private var _events:EventDispatcher;
		public function get events():EventDispatcher	{ return _events; }
		
		/**
		 * Lists
		 */
		private var _assets:Vector.<ILoadable>;
		private var _resources:Vector.<Resource>;
		private var _resourceDependencies:ResourceDependencyList;
		private var _assetDependencies:ResourceDependencyList;
		private var _resourceCallbacks:ResourceCallbackList;
		private var _assetsBuild:Vector.<Boolean>;
		
		/**
		 * Counts
		 */
		private var _numRequired:uint = 0;
		private var _numLoaded:uint = 0;
		private var _numAssetsLoaded:uint = 0;
		private var _numResourcesLoaded:uint = 0;
		
		/**
		 * Loaded flag, as required by ILoadable
		 */
		public function get loaded():Boolean			{ return _loaded; }
		public function set loaded(state:Boolean):void	{ _loaded = state; }
		private var _loaded:Boolean;
		
		/**
		 * OnLoaded callback
		 */
		private var _onLoadedCallback:Function;
		
		/**
		 * Verbose mode
		 */
		public static var verbose:Boolean = true;
		
		/**
		 * Constructor
		 */
		public function Module()
		{
			initialize();
		}
		
		/**
		 * Called once after instantiation. Any initialization required before loading and building should be placed here.
		 */
		public function initialize():void
		{
			// Create event dispatcher
			if (eventDispatcher)
				_events = new EventDispatcher();
			
			if(verbose && Breeze.DEBUG) Debug.print(this, "Initialized.");
		}
		
		
		
		/**********************************************************************************************************************
		 *  Assets and Resources
		 */
		
		/**
		 * Sets an asset as required for loading.
		 * @param	obj			Required asset.
		 * @param	autoBuild	If object should auto-build.
		 * @return	Reference to obj.
		 */
		public function requireAsset(obj:ILoadable, autoBuild:Boolean=true/*, dependencies:Array=null*/):ILoadable
		{
			// This module is already loaded
			if (loaded)
			{
				// Immediately load
				obj.load(onAssetLoaded);
			}
			
			// Create lists
			if (_assets == null) {
				_assets = new Vector.<ILoadable>();
				_assetsBuild = new Vector.<Boolean>();
				_assetDependencies = new ResourceDependencyList();
			}
			
			// Register
			_numRequired++;
			_assets.push(obj);
			_assetsBuild.push(autoBuild);
			//_assetDependencies.add(obj, dependencies);
			
			// Debug
			if(verbose && Breeze.DEBUG) { Debug.print(this, "Requiring ASSET: "+obj); }
			
			// Return obj ref
			return obj;
		}
		
		/**
		 * Sets a resources as required for loading, and handles loading it and it's dependencies.
		 * @param	params			Resource params.
		 * @param	onLoaded		OnLoaded callback.
		 * @param	dependencies	Dependencies.
		 * @return
		 */
		public function requireResource(params:ResourceParams, onLoaded:Function=null, dependencies:Array=null):Resource
		{
			// This module is already loaded
			if (loaded)
			{
				/* TODO: something, dunno */
				trace("Module already loaded when requiring a resource. Should I do something here?");
			}
			
			// Create lists
			if (_resources == null) {
				_resources = new Vector.<Resource>();
				_resourceCallbacks = new ResourceCallbackList();
				_resourceDependencies = new ResourceDependencyList();
			}
			
			// Queue resource, get reference to created resource in return
			var resource:Resource = Breeze.content.queue(params);
			
			// Register
			_numRequired++;
			_resources.push(resource);
			_resourceCallbacks.add(resource.params.key, onLoaded);
			_resourceDependencies.add(resource, dependencies);
			
			// Debug
			if(verbose && Breeze.DEBUG) { Debug.print(this, "Requiring RESOURCE: "+params.file); }
			
			// Return resource
			return resource;
		}
		
		
		/**********************************************************************************************************************
		 *  Loading
		 */
		
		/**
		 * Any external resources that require loading should be placed here, using requireResource(). Any resources required
		 * will automatically be loaded upon calling super.load(). If a resource requires dependencies, pass them in the 3rd
		 * argument of requireResource().
		 * @param	callback	Function passed by Modules, to be called in onLoaded() when loading is complete.
		 * @see 	com.octadecimal.modules.Module#requireResource
		 */
		public function load(callback:Function):void
		{
			// Test if this object is already loaded
			if (_loaded) { trace("Attempted to load an object that was already loaded: " + this); return; }
			
			// Save callback
			_onLoadedCallback = callback;
			
			// Load resources all at once
			if (_resources != null)
				loadResources();
			
			// Else load first asset
			else if (_assets != null)
				loadAssets();
			
			// OnLoad if no resources nor assets required
			if (_resources == null && _assets == null)
				onLoaded();
		}
		
		/**
		 * Loads the first asset in the list, starting the asset load chain (one at a time).
		 */
		private function loadAssets():void
		{
			if(verbose && Breeze.DEBUG) Debug.print(this, "Loading assets... (" + _assets.length + " total)");
			
			// Load first assets
			_assets[0].load(onAssetLoaded);
		}
		
		/**
		 * Loads all required resources without dependencies (all at the same time.
		 */
		private function loadResources():void
		{
			if(verbose && Breeze.DEBUG) Debug.print(this,"Loading resources... (" + _resources.length + " total)");
			
			// Load resources without dependencies
			for (var i:uint = 0, c:uint = _resources.length; i < c; i++)
			{
				var resource:Resource = _resources[i];
				var dependencies:Array = _resourceDependencies.find(resource) as Array;
				
				if (dependencies == null) {
					if(verbose && Breeze.DEBUG) Debug.print(this, "Loading resource without dependencies: " + resource.params.file);
					Breeze.content.loadResource(resource.params, onResourceLoaded);
				}
				else 
					if(verbose && Breeze.DEBUG) Debug.print(this, "Skipped resource, dependencies found: " + _resourceDependencies.keys[i]+"->"+_resourceDependencies.items[i]);
			}
		}
		
		/**
		 * Loads the dependencies for a passed asset/object.
		 * @param	resource  The loaded resource.
		 */
		private function loadDependencies(resource:ILoadable):void
		{
			if (_assets != null)
			{
				// Loop through all assets
				for (var i:uint = 0, c:uint = _assets.length; i < c; i++)
				{
					var currentAsset:ILoadable = _assets[i];
					var assetDependencies:Array = _assetDependencies.find(currentAsset) as Array;
					
					// Current asset has dependencies
					if (assetDependencies != null)
					{
						for (var j:uint = 0, d:uint = assetDependencies.length; j < d; j++)
						{
							// Get current asset dependency list
							var assetDependency:ILoadable = assetDependencies[j];
							
							// Check if loaded asset dkula
							if (resource == assetDependency)
							{
								if(verbose && Breeze.DEBUG) { Debug.print(this, "Loading dependendent asset: "+currentAsset); }
								currentAsset.load(onAssetLoaded);
							}
						}
					}
				}
			}
			
			if (_resources != null)
			{
				// Loop through all resources
				for (i = 0, c = _resources.length; i < c; i++)
				{
					var currentResource:Resource = _resources[i];
					var resourceDependencies:Array = _resourceDependencies.find(currentResource) as Array;
					
					// Current resource has dependencies
					if (resourceDependencies != null)
					{
						// Look through dependency list for currentResource and see if loaded resource is in it's list
						for (j = 0, d = resourceDependencies.length; j < d; j++)
						{
							// Get current dependency list
							var resourceDependency:Resource = resourceDependencies[j];
							
							// Check if loaded resource is a dependency for this file
							if (resource == resourceDependency)
							{
								// Load current resource if not already loaded (shouldn't be)
								//if (!currentResource.loaded) currentResource.load(onResourceLoaded);
								if (!currentResource.loaded) {
									if(verbose && Breeze.DEBUG) { Debug.print(this, "Loading dependendent resource: "+currentResource.params.key); }
									Breeze.content.loadResource(currentResource.params, onResourceLoaded);
								}
								else 
									Debug.warn(this, "Attempted to automatically load a dependency when it has already been loaded.");
							}
						}
					}
				}
			}
		}
		
		
		
		/**********************************************************************************************************************
		 *  OnLoaded
		 */
		
		/**
		 * Called when an asset is loaded.
		 */
		private function onAssetLoaded():void
		{
			// Increment
			_numAssetsLoaded++;
			//Debug.print(this, "Asset loaded: " + _numAssetsLoaded + "/" + _assets.length);
			
			// Test for onLoad eligibility
			if (!_loaded && _numAssetsLoaded + _numResourcesLoaded == _numRequired)
				onLoaded();
			
			// Test if _assets is null, means the object is already loaded
			else if (_assets == null) {
				trace("Assuming _assets already loaded.");
				if(!loaded) onLoaded();
			}
			
			// Bug handling
			else if (_numAssetsLoaded > _assets.length)
				trace(this, "\tBUG: OnAssetLoaded() called more times than assets registered.");
				
			// Load next asset
			else if (_numAssetsLoaded != _assets.length)
				_assets[_numAssetsLoaded].load(onAssetLoaded);
		}
		
		/**
		 * Called when a resource is loaded.
		 * @param	resource	Reference to the loaded resource.
		 */
		private function onResourceLoaded(resource:Resource):void
		{
			// Increment
			_numResourcesLoaded++;
			if(verbose && Breeze.DEBUG) Debug.print(this, "Resource loaded: " + _numResourcesLoaded + "/" + _resources.length);
			
			// Callback
			var callback:Function = _resourceCallbacks.find(resource.params.key) as Function;
			if (callback != null) callback(resource);
			
			// Load resource dependencies
			loadDependencies(resource);
			
			// Test if all resources loaded
			if (_numResourcesLoaded == _resources.length)
			{
				// Load assets
				if(_assets != null)
					loadAssets();
				
				// No assets to load, onLoad
				else 
					onLoaded();
			}
		}
		
		/**
		 * Called when all external resources (if any) required for this object are fully loaded. If no resources are
		 * loaded, this will be called automatically. Otherwise `requiresLoading` must be set to true, and this method
		 * be called when external resources are completed loading. Calls back to the callback passed in `load()`.
		 */
		public function onLoaded():void
		{
			if (loaded) { trace(this, "\tBUG: onLoaded() called more than once; bypassing."); return; }
			
			if(verbose && Breeze.DEBUG) Debug.print(this, "Loaded.");
			
			loaded = true;
			if (_onLoadedCallback != null) _onLoadedCallback();
			else trace(this, "WARNING: null onLoaded callback.");
		}
		
		
		
		/**********************************************************************************************************************
		 *  Unloading
		 */
		
		/**
		 * Routine responsible for unloading and freeing any resources used by this object, making it a
		 * valid candidate for complete garbage collection.
		 */
		public function unload():void
		{
			Debug.print(this, "Unloaded.");
		}
		
		
		
		/**********************************************************************************************************************
		 *  Build
		 */
		
		/**
		 * Build routine, called once after all modules are fully loaded. Responsible for building anything specific
		 * to this object. Any loading code should go in load().
		 */
		public function build():void
		{
			if(_assets && verbose && Breeze.DEBUG) Debug.print(this, "Building... ("+_assets.length+" assets)");
			else if(verbose && Breeze.DEBUG) Debug.print(this, "Building...");
			
			// Loop through assets and call build() on those who are flagged as true in assetsBuild
			if (_assets != null) {
				//if(Breeze.DEBUG) { Debug.print(this, "Building assets... ("+_assets.length+" total)"); }
				for (var i:uint = 0, c:uint = _assets.length; i < c; i++)
					if (_assetsBuild[i] == true)
						_assets[i].build();
			}
			
			// Free
			//_assets = null;
			//_assetsBuild = null;
			//_resources = null;
			//_dependencies = null;
			//_resourceCallbacks = null;
			
			if(verbose && Breeze.DEBUG) Debug.print(this, "Built.");
		}
	}
	
}