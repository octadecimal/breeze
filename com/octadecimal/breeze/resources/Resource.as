/**
 * Resource: Resource
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.resources 
{
	import com.octadecimal.breeze.util.lists.IListItem;
	
	public class Resource implements IResource
	{
		/**
		 * @copy com.octadecimal.breeze.content.IResource#params()
		 */
		public function get params():ResourceParams	{ return _params; }
		private var _params:ResourceParams;
		
		/**
		 * @copy com.octadecimal.breeze.content.IResource#loaded()
		 */
		private var _loaded:Boolean = false;
		public function get loaded():Boolean	{ return _loaded; }
		public function set loaded(state:Boolean):void	{ _loaded = state; }
		
		/**
		 * Saved load() callback.
		 */
		private var _onLoadedCallback:Function;
		
		
		/**
		 * Constructor
		 */
		public function Resource(params:ResourceParams)
		{
			_params = params;
		}
		
		public function replaceParams(params:ResourceParams):void
		{
			_params = params;
		}
		
		
		/**
		 * @copy com.octadecimal.breeze.content.IResource#load()
		 */
		public function load(callback:Function):void
		{
			// Save callback
			_onLoadedCallback = callback;
		}
		
		/**
		 * @copy com.octadecimal.breeze.content.IResource#onLoaded()
		 */
		public function onLoaded():void
		{
			// Set loaded flag
			_loaded = true;
			
			// Callback
			_onLoadedCallback(this);
		}
		
		/**
		 * @copy com.octadecimal.breeze.content.IResource#unload()
		 */
		public function unload():void
		{
			
		}
		
		public function build():void {}
	}
}