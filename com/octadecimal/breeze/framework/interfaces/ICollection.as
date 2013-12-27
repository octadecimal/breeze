/*
 Interface: IMap
 Author:    Dylan Heyes
 Copyright: 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.interfaces 
{
	
	/**
	 * ...
	 */
	public interface ICollection 
	{
		function add(key:String, item:*):uint;
		function remove(key:String):void;
		function find(key:String):*;
	}
	
}