/**
 * Class: GUI
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.events.Event;
	import com.octadecimal.breeze.input.Controls;
	import com.octadecimal.breeze.resources.ILoadable;
	import com.octadecimal.breeze.resources.Resource;
	import com.octadecimal.breeze.resources.ResourceParams;
	import com.octadecimal.breeze.content.types.Texture;
	import com.octadecimal.breeze.content.types.XMLFile;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.gui.widgets.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.*;
	import com.octadecimal.breeze.util.lists.List;
	
	/**
	 * GUI description.
	 */
	public class GUI extends Module implements IDrawable
	{ 
		/**
		 * Reference to the display list.
		 */
		public function get displayList():DisplayList	{ return _displayList; }
		private var _displayList:DisplayList = new DisplayList();
		
		/**
		 * Reference to GUISettings object.
		 */
		public function get settings():GUISettings	{ return _settings; }
		private var _settings:GUISettings;
		
		/**
		 * Reference to skin texture. TEMPORARY
		 */
		public function get skin():Skin	{ return _skin; }
		private var _skin:Skin;
		
		/**
		 * Skins list
		 */
		private var _skins:List = new List();
		
		/**
		 * Window with current focus.
		 */
		public function get focus():Widget			{ return _focus; }
		public function set focus(a:Widget):void	{ _focus = a; }
		private var _focus:Widget;
		
		/**
		 * If the GUI received input. If true, input will not allowed to be propogated to the world.
		 */
		public function get receivedInput():Boolean		{ return _receivedInput; }
		public function set receivedInput(a:Boolean):void	{ _receivedInput = a; }
		private var _receivedInput:Boolean = false;
		
		
		/**
		 * Constructor
		 */
		public function GUI()
		{
			
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#initialize()
		 * @see com.octadecimal.breeze.modules.Module#initialize()
		 */
		override public function initialize():void 
		{
			
			super.initialize();
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#load()
		 * @see com.octadecimal.breeze.modules.Module#load()
		 */
		private var _loadCallback:Function;
		override public function load(callback:Function):void 
		{
			_loadCallback = callback;
			
			// Dependencies
			if (Breeze.modules.find("Graphics") == null) throw(new Error("Requires the Graphics module."));
			
			// Settings
			var xml:Resource = requireResource(new ResourceParams(XMLFile.type, "resources/settings/gui.xml"), onSettingsLoaded);
			
			// Skin
			_skin = requireAsset(new Skin("matte")/*, true, new Array(xml)*/) as Skin;
			_skins.add("matte", _skin);
			
			
			super.load(_loadCallback);
		}
		
		private function onSettingsLoaded(resource:XMLFile):void
		{
			// Create settings object from xml
			_settings = new GUISettings(resource.data);
			
			// Set skin xml
			_skin.skinsXML = resource.data.skins;
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#onLoaded()
		 * @see com.octadecimal.breeze.modules.Module#onLoaded()
		 */
		override public function onLoaded():void 
		{
			
			// Engine registration
			Engine(Breeze.modules.find("Engine")).registerUpdateable(this);
			//Engine(Breeze.modules.find("Engine")).registerDrawable(this);   <- manually drawn in Engine for now
			
			super.onLoaded();
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#unload()
		 * @see com.octadecimal.breeze.modules.Module#unload()
		 */
		override public function unload():void 
		{
			super.unload();
		}
		
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#build()
		 * @see com.octadecimal.breeze.modules.Module#build()
		 */
		override public function build():void 
		{
			// Add to display list
			//_displayList.add("Toolbar", _toolbar);
			//_displayList.add("ConsoleWindow", _console);
			
			// Generate windows in display list
			//for each(var window:Widget in _displayList.items)
				//window.generate();
				
			super.build();
				
			// Listen for debug keys
			var controls:Controls = Breeze.modules.find("Controls") as Controls;
			controls.bind("debug", onDebugDown, onDebugUp);
		}
		
		public function registerWindow(window:Window):void
		{
			// Require in case GUI is still loading
			if (!loaded) requireAsset(window);
			else 
			{
				window.load(onWindowLoaded);
				window.build();
				window.generate();
				
				// Center window (temp, find a better solution)
				window.display.x = (Breeze.stage.stageWidth * 0.5) - (window.display.width * 0.5);
				window.display.y = (Breeze.stage.stageHeight * 0.4) - (window.display.height * 0.5);
				
				// Set as focus
				_focus = window;
			}
		}
		
		public function changeSkin(name:String):void
		{
			trace("Changing skin: " + name);
			
			// Check if skin already loaded
			var existing:Skin = _skins.find(name) as Skin;
			if (existing)
			{
				_skin = existing;
				return;
			}
			
			// Skin hasn't been loaded, load
			var skin:Skin = new Skin(name, settings.data.skins);
			_loadingSkin = skin;
			skin.load(onNewSkinLoaded);
			skin.events.listen(Event.COMPLETE, onNewSkinLoaded2);
		}
		private var _loadingSkin:Skin;
		
		private function onNewSkinLoaded(e:Event=null):void
		{
			//trace("Replacing skin: " + _loadingSkin.name);
			// Replace skin reference with new skin
			//_skin = _loadingSkin;
		}
		
		
		private function onNewSkinLoaded2(e:Event=null):void
		{
			trace("Replacing skin: " + _loadingSkin.name);
			_skins.add(_loadingSkin.name, _loadingSkin);
			
			// Replace skin reference with new skin
			_skin = _loadingSkin;
		}
		
		private function onWindowLoaded():void
		{
			// Works
		}
		
		private function onDebugDown():void
		{
			Container.debugDraw = true;
		}
		
		private function onDebugUp():void
		{
			Container.debugDraw = false;
		}
		
		/**
		 * @copy com.octadecimal.breeze.engine.IUpdateable
		 * @see com.octadecimal.breeze.engine.IUpdateable
		 */
		public function update(change:uint):void 
		{
			
			// Update display list
			_displayList.update(change);
			
			// Update in display list
			for each(var window:Widget in _displayList.items)
				window.update(change);
		}
		
		/**
		 * @copy com.octadecimal.breeze.engine.IDrawable
		 * @see com.octadecimal.breeze.engine.IDrawable
		 */
		public function draw(change:uint):void 
		{
			// Draw windows in display list 
			for each(var window:Widget in _displayList.items)
				window.draw(change);
				
			
			// Reset receivedInput flag. Will be re-set if a widget is clicked.
			_receivedInput = false;
		}
		
	}
}