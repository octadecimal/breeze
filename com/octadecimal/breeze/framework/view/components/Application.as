/*
 View:   Application
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.view.components
{
	import com.octadecimal.breeze.framework.ApplicationFacade;
	import com.octadecimal.breeze.framework.util.Debug;
	import com.octadecimal.breeze.shell.ShellFacade;
	import flash.display.Sprite;
	
	/**
	 * Abstract application class. Meant to be extended and serve as the root DocumentClass for a
	 * application that uses the breeze framework.
	 */
	public class Application extends Sprite
	{
		/**
		 * Empty constructor.
		 */
		public function Application() 
		{
			Debug.print(this, "Breeze Engine: Application started...");
		}
		
		
		/**
		 * Starts the application by retrieving the framework application facade and
		 * calling its respective startup method, passing in the application name as
		 * an argument which will be used as a key for the application's core.
		 * 
		 * @param	appName		Unique application name.
		 */
		public function start(appName:String):void
		{
			Debug.info(this, "Application starting: "+appName);
			
			// Save application name
			_appName = appName;
			
			// Create shell
			_shell = ShellFacade.getInstance(appName);
			
			// Start shell
			_shell.startup(this);
		}
		
		/**
		 * Runs the application.
		 */
		public function run():void
		{
			Debug.info(this, "Application running: "+_appName);
			_shell.run();
		}
		
		
		/**
		 * Registers a module that will be loaded at runtime.
		 * 
		 * @param	moduleName
		 */
		public function registerModule(moduleName:Class):void
		{
			_shell.registerModule(moduleName);
		}
		
		
		/**
		 * Application name.
		 */
		public function get appName():String			{ return _appName; }
		private var _appName:String;
		
		
		/**
		 * Private
		 */
		private var _shell:ShellFacade;
	}
	
}