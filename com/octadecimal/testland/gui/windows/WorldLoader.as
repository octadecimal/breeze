/**
 * Class: WorldLoader
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.testland.gui.windows 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.events.Event;
	import com.octadecimal.breeze.gui.widgets.Button;
	import com.octadecimal.breeze.gui.widgets.Label;
	import com.octadecimal.breeze.gui.widgets.Window;
	
	public class WorldLoader extends Window
	{ 
		// Widgets
		private var _labelIntro:Label;
		private var _btnLoadTrio:Button;
		
		
		/**
		 * Constructor
		 */
		public function WorldLoader(name:String)
		{	
			super(name, "Breeze 0.1.1");
		}
		
		/**
		 * Initialize
		 */
		override public function initialize():void 
		{
			//display.paddingX = 2;
			//display.paddingY = 2;
			
			super.initialize();
		}
		
		/**
		 * Load
		 */
		override public function load(callback:Function):void 
		{
			_labelIntro = requireAsset(new Label("IntroLabel", "Welcome to the Breeze Engine tech demo.\n\nClick to move, spacebar to attack.\nUse the Menu above to spawn NPCs.")) as Label;
			_btnLoadTrio = requireAsset(new Button("btnLoadTrio", "Load trio.xml")) as Button;
			
			super.load(callback);
		}
		
		/**
		 * Build
		 */
		override public function build():void 
		{
			content.direction = VERTICAL;
			
			//_labelIntro.display.paddingY = 0;
			
			// Add
			content.add(_labelIntro);
			content.add(_btnLoadTrio, true);
			
			// Center
			display.x = (Breeze.stage.stageWidth * 0.5) - (display.width * 0.5);
			display.y = (Breeze.stage.stageHeight * 0.5) - (display.height * 0.5);
			
			// Events
			_btnLoadTrio.events.listen(Event.CLICK, onLoadTrioClick);
			
			super.build();
		}
		
		private function onLoadTrioClick(e:Event):void
		{
			Breeze.ref.createWorldFromMap("resources/maps/trio.xml"); 
			close();
		}
	}
}