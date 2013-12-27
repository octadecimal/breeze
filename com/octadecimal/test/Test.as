/*
 View:   Test
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.test 
{
	import com.octadecimal.breeze.framework.view.components.Application;
	import com.octadecimal.breeze.modules.content.ContentModule;
	import com.octadecimal.breeze.modules.graphics.GraphicsModule;
	
	/**
	 * Test View.
	 */
	public class Test extends Application
	{
		
		public function Test() 
		{
			// Start application
			start("TestApp");
			
			// Register modules
			registerModule(ContentModule);
			registerModule(GraphicsModule);
			
			// Run application
			run();
		}
		
		
        
		// API
		// =========================================================================================
		
		
		
        
		// EVENTS
		// =========================================================================================
		
		
		
        
		// STATE
		// =========================================================================================
		
		
	}
	
}