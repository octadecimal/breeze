/**
 * Class: BreezeToolbar
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.testland.gui 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.engine.Screen;
	import com.octadecimal.breeze.gui.widgets.*;
	import com.octadecimal.testland.gui.menus.MainMenu;
	
	public class BreezeBar extends Toolbar
	{
		// Logo container
		private var _logoContainer:Container;
		
		// Menu
		protected var _menu:MainMenu;
		
		// Debug labels
		private var _debugContainer:Container;
		public static var debugText:Label;
		public static var fpsText:Label;
		
		
		/**
		 * Constructor
		 */
		public function BreezeBar()
		{
			super("BreezeBar");
		}
		
		override public function initialize():void 
		{
			display.height = 25;
			display.width = Breeze.stage.stageWidth;
			
			makeCollidable();
			
			super.initialize();
		}
		
		override public function load(callback:Function):void 
		{
			// Logo container
			_logoContainer = requireAsset(new Container("logoContainer")) as Container;
			
			// Menu pane
			_menu = requireAsset(new MainMenu("MainMenu-Toolbar", gui.settings.data.menus.mainmenu)) as MainMenu;
			
			// Debug Container
			_debugContainer = requireAsset(new Container("debugContainer")) as Container;
			
			// Debug labels
			debugText = requireAsset(new Label("txtDebug", "This is a whole lot of blank debug text, hopefully more than enough to amount for all text", false)) as Label;
			fpsText   = requireAsset(new Label("txtFPS", "FPS: 00", false)) as Label;
			
			super.load(callback);
		}
		
		override public function build():void 
		{
			// Logo Container
			_logoContainer.display.width = 50;
			add(_logoContainer);
			
			// Menu pane
			add(_menu);
			
			// Debug Container
			_debugContainer.display.paddingY = 3;
			add(_debugContainer, true);
			
			// Debug labels
			_debugContainer.add(debugText, true);
			_debugContainer.add(fpsText);
			
			// Build (menu)
			super.build();
			
		}
		
		override public function update(change:uint):void 
		{
			super.update(change);
		}
		
		override public function draw(change:uint):void 
		{
			super.draw(change);
			
			// Draw logo
			//copyRect = gui.settings.logo.clone();
			copyRect = gui.skin.logo.clone();
			copyPoint.x = 16;
			copyPoint.y = 6;
			var breeze:Screen = Breeze.screen;
			Breeze.screen.buffer.copyPixels(gui.skin.texture.buffer, copyRect, copyPoint);
			//copyPoint.x += copyRect.width;
		}
		
		
		// Temp static call
		public static function setText(str:String):void
		{
			if(debugText != null) debugText.setText(str);
		}
		
		// Temp static call
		public static function setFPSText(str:String):void
		{
			if(fpsText != null) fpsText.setText(str);
		}
	}
}