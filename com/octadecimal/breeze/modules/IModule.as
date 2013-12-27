/**
 * Flo Engine - http://flo.octadecimal.com
 * Copyright ©2009 Dylan Heyes
 * -----------------------------------------------------------------------------------
 * Class: Module 
 * Usage: [empty]
 */

 package com.octadecimal.breeze.modules 
{
	import com.octadecimal.breeze.resources.ILoadable;
	
	/**
	 * Implementation for a module that is able to plug in seamlessly to Breeze.
	 */
	public interface IModule extends ILoadable
	{
		/**
		 * Called once upon instantation. Any initializing that doesn't require any external resource loading
		 * should be placed here. Will not be called when an invalid singleton override is detected.
		 */
		function initialize():void;
	}
	
}