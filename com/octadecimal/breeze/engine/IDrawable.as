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
	 * Implementation for objects that are drawable by Engine.
	 */
	public interface IDrawable extends IUpdateable
	{
		/**
		 * Draw thread. Called every frame, at a variable framerate. Only drawing routines should go here, any other code should
		 * go in update() where possible.
		 * @param	change	Milliseconds passed since last frame drawn.
		 */
		function draw(change:uint):void;
	}
	
}