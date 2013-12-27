/**
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes
 * -----------------------------------------------------------------------------------
 * Class: 			Singleton
 * Dependencies:	None.
 */

package com.octadecimal.breeze.util 
{
	/**
	 * An abstract class used for building singleton enforced objects. Currently not using a SingletonEnforcer so
	 * that this class may be extended. Thus, it is important to watch the debug log and make sure inadvertant
	 * extra objects are being created.
	 * @example var singleton:Singleton = Singleton.ref();
	 */
	public class Singleton
	{
		// Singleton reference
		private static var _instance:Singleton;
		
		/**
		 * Singleton constructor.
		 * @param	enforcer	SingletonEnforcer object, ensures only this object may instantiate objects, via ref().
		 */
		public function Singleton(/*enforcer:SingletonEnforcer*/)
		{
			
		}
		
		/**
		 * Singleton object getter. Returns the object instantiated by the singleton object.
		 * @return The singleton instantiated object.
		 */
		public static function ref():Singleton
		{
			// Instantiate if doesn't exist
			if (Singleton._instance == null) {
				Singleton._instance = new Singleton(/*new SingletonEnforcer()*/);
				Singleton._instance.initialize();
			}
			
			// Return instance reference
			return Singleton._instance;
		}
		
		
		/**
		 * Empty initilaize method. Called once after instantiation. Intended to be overridden.
		 */
		protected function initialize():void
		{
			
		}
	}
}

class SingletonEnforcer
{
	public function SingletonEnforcer()
	{
	}
}