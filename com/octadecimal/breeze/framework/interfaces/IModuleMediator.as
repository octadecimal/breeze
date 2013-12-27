/*
 Interace: IModuleMediator
 Author:   Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.interfaces 
{
	import org.puremvc.as3.multicore.interfaces.IMediator;
	
	/**
	 * ...
	 * @author Dylan Heyes
	 */
	public interface IModuleMediator extends IMediator
	{
		function initialize():void;
		function load():void;
		function unload():void;
		function onLoaded():void;
		function build():void;
		function update():void;
		function draw():void;
	}
	
}