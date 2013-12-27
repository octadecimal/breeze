/*
 Module: Module
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.framework.view.components
{
	import com.octadecimal.breeze.framework.interfaces.IModule;
	import com.octadecimal.breeze.framework.util.Debug;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
    
	/**
	 * Module: Module
	 * ...
	 */
	public class Module implements IModule
	{
		/**
		 * Unique identifier (read-only) 
		 */
		public function get id():uint { return _id; }
		
		/**
		 * Standard output pipe.
		 */
		public static const STDOUT:String = "stdout";
		
		/**
		 * Standard input pipe.
		 */
		public static const STDIN:String = "stdin";
		
		
		/**
		 * Constructor
		 */
		public function Module(facade:IFacade) 
		{
			// Save facade reference
			this.facade = facade;
			
			// Generate uid
			_id = _numModules++;
			
			// Debug
			Debug.print(this, "Created (guid: " + _id +")");
		}
		
		/**
		 * Accepts an input pipe.
		 */
		public function acceptInputPipe(name:String, pipe:IPipeFitting):void
		{
			facade.sendNotification(JunctionMediator.ACCEPT_INPUT_PIPE, pipe, name);
			Debug.print(this, "Accepted input pipe:\t -> " + name/* + "::" + pipe*/);
		}
		
		/**
		 * Accepts an output pipe.
		 */
		public function acceptOutputPipe(name:String, pipe:IPipeFitting):void
		{
			facade.sendNotification(JunctionMediator.ACCEPT_OUTPUT_PIPE, pipe, name);
			Debug.print(this, "Accepted output pipe:\t <- " + name/* + "::" + pipe*/);
		}
		
		
		// Facade
		protected var facade:IFacade;
		
		// GUID
		private var _id:uint;
		
		// Temporary guid generation.
		private static var _numModules:uint;
		
	}

}