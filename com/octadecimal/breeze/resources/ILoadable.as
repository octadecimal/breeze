/**
 * Interface: IResource
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.resources 
{
	/**
	 * ILoadable description.
	 */
	public interface ILoadable
	{
		/**
		 * Returns true if this object has been loaded.
		 */
		function get loaded():Boolean;
		function set loaded(state:Boolean):void;
		
		/**
		 * Any external resources that require loading should be placed here. When all resources are fully loaded,
		 * onLoaded() should be called. Callback reference should be saved and called when all resources are loaded.
		 * @param	callback	Function passed by Modules, to be called in onLoaded() when loading is complete.
		 */
		function load(callback:Function):void;
		
		/**
		 * Routine responsible for unloading and freeing any resources used by this object, making it a
		 * valid candidate for complete garbage collection.
		 */
		function unload():void;
		
		/**
		 * Called when this object has been fully loaded.
		 */
		function onLoaded():void;
		
		/**
		 * Build routine, called once after all modules are fully loaded. Responsible for building anything specific
		 * to this object. Any loading code should go in load().
		 */
		function build():void;
	}	
}