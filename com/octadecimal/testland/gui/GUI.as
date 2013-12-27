/**
 * Class: GUI
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.testland.gui 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.gui.GUI
	
	public class GUI extends com.octadecimal.breeze.gui.GUI
	{ 
		/**
		 * Toolbar
		 */
		public function get toolbar():BreezeBar	{ return _toolbar; }
		private var _toolbar:BreezeBar;
		
		
		/**
		 * Constructor
		 */
		public function GUI()
		{
			super();
		}
		
		override public function load(callback:Function):void 
		{
			// Create main toolbar
			_toolbar = requireAsset(new BreezeBar()) as BreezeBar;
			
			
			super.load(callback);
		}
		
		override public function build():void 
		{
			super.build();
			
			// Generate
			_toolbar.generate();
		}
		
		override public function update(change:uint):void 
		{
			_toolbar.update(change);
			
			super.update(change);
		}
		
		override public function draw(change:uint):void 
		{
			
			super.draw(change);
			
			_toolbar.draw(change);
		}
	}
}