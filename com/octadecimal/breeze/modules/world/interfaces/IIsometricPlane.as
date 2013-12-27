/*
 Interace: IIsometricPlane
 Author:   Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.world.interfaces 
{
	import com.octadecimal.breeze.modules.world.view.components.IsometricTile;
	
	/**
	 * ...
	 */
	public interface IIsometricPlane 
	{
		function generate():void;
		
		function to(pattern:Vector.<int>, steps:uint=0, reset:Boolean=false):IsometricTile;
	}
	
}