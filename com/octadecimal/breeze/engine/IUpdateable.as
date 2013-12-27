/**
 * Flo Engine - http://flo.octadecimal.com
 * Copyright ©2009 Dylan Heyes
 * -----------------------------------------------------------------------------------
 * Class: Module 
 * Usage: [empty]
 */

 package com.octadecimal.breeze.engine 
{
	
	/**
	 * Implementation for objects that are updateable by Engine.
	 */
	public interface IUpdateable 
	{
		/**
		 * Update thread. Called every tick at a fixed rate, as defined by Engine.updateSpeed. Only logic code should go here.
		 * @param	change	Milliseconds passed since last update.
		 */
		function update(change:uint):void;
	}
	
}