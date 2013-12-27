/**
 * Class: Controls
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.input 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.content.*;
	import com.octadecimal.breeze.content.types.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.resources.Resource;
	import com.octadecimal.breeze.resources.ResourceParams;
	import com.octadecimal.breeze.util.*;
	import flash.events.KeyboardEvent;
	
	/**
	 * Controls description.
	 */
	public class Controls extends Module
	{ 
		// Settings
		private var _settings:ControlSettings;
		
		// Bindings
		private var _bindings:Vector.<Array> = new Vector.<Array>();
		public function get bindings():Vector.<Array>	{ return _bindings; }
		
		// Lists
		private var _keycodes:Vector.<Array> = new Vector.<Array>();
		private var _controls:Vector.<Array> = new Vector.<Array>();
		
		//-- enums
		private static const KEYNAME:uint 	= 0;
		private static const KEYCODE:uint 	= 1;
		private static const PRIMARY:uint 	= 1;
		private static const SECONDARY:uint = 2;
		private static const ON_DOWN:uint 	= 3;
		private static const ON_UP:uint 	= 4;
		public static const  IS_DOWN:uint 	= 5;
		
		
		/**
		 * Constructor
		 */
		public function Controls()
		{
			
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#initialize()
		 * @see com.octadecimal.breeze.modules.Module#initialize()
		 */
		override public function initialize():void 
		{
			// Keyboard events
			Breeze.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Breeze.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			// Register keycodes for core keys
			registerKeyCode("w", 87);
			registerKeyCode("s", 83);
			registerKeyCode("a", 65);
			registerKeyCode("d", 68);
			registerKeyCode("arrow_up", 38);
			registerKeyCode("arrow_down", 40);
			registerKeyCode("arrow_left", 37);
			registerKeyCode("arrow_right", 39);
			registerKeyCode("space", 32);
			registerKeyCode("numpad_0", 96);
			registerKeyCode("numpad_1", 97);
			registerKeyCode("numpad_4", 100);
			registerKeyCode("numpad_7", 103);
			registerKeyCode("delete", 46);
			registerKeyCode("end", 35);
			registerKeyCode("page_down", 34);
			registerKeyCode("insert", 45);
			registerKeyCode("home", 36);
			registerKeyCode("page_up", 33);
			
			super.initialize();
		}
		
		/**
		 * @copy com.octadecimal.breeze.modules.Module#load()
		 * @see com.octadecimal.breeze.modules.Module#load()
		 */
		override public function load(callback:Function):void 
		{
			// Load control settings xml
			requireResource(new ResourceParams(XMLFile.type, "resources/settings/controls.xml"), onSettingsLoaded);
			
			super.load(callback);
		}
		
		private function onSettingsLoaded(resource:XMLFile):void
		{
			// Parse into settings object
			_settings = new ControlSettings(resource.data);
			
			// Parse XML and register keys
			for each(var control:XML in resource.data.children())
				registerControl(control.attribute("name"), control.attribute("primary"), control.attribute("secondary"));
			
			// Free XMLFile
			resource.unload();
			
			// Call onLoaded
			//onLoaded();
		}
		
		
		/**
		 * Pairs a keycode with a key string.
		 * 
		 * @param	name	key
		 * @param	code	keycode
		 */
		public function registerKeyCode(name:String, code:uint):void 
		{
			var keycode:Array = new Array();
			keycode.push(name);
			keycode.push(code);
			_keycodes.push(keycode);
			//Debug.print(this, "Registered keycode: " + keycode);
		}
		
		
		/**
		 * Registers a control name with a primary and secondary key.
		 * 
		 * @param	controlName		name of control (key)
		 * @param	primaryKey		primary key
		 * @param	secondaryKey	secondary key
		 */
		public function registerControl(controlName:String, primaryKey:String, secondaryKey:String):void 
		{
			var control:Array = new Array();
			control.push(controlName);
			control.push(getKeyCode(primaryKey));
			control.push(getKeyCode(secondaryKey));
			_controls.push(control);
			Debug.print(this, "Registered control: " + control[KEYNAME] + "->" +getKeyName(control[1]) + "," +getKeyName(control[2]));
		}
		
		
		/**
		 * Binds a control with an onDown and onUp callback.
		 * 
		 * @param	control	contorl name
		 * @param	onDown	onDown callback
		 * @param	onUp	onUp callback
		 * @return a reference to the bind object
		 */
		public function bind(control:String, onDown:Function, onUp:Function=null):Object 
		{
			var found:Boolean = false;
			var binding:Array = new Array();
			for each(var c:Object in _controls)
			{
				if (c[KEYNAME] == control)
				{
					binding.push(control);
					binding.push(c[PRIMARY]);
					binding.push(c[SECONDARY]);
					binding.push(onDown);
					binding.push(onUp);
					binding.push(false);
					_bindings.push(binding);
					Debug.print(this, "Binded control: " + binding);
					return binding;
				}
			}
			
			// Attempted to bind invalid control if reached here
			//Debug.warning(this, "Attemped to bind an invalid control: " + control);
			
			return binding;
		}
		
		
		/**
		 * Returns a keycode by the given key string.
		 * 
		 * @param	key
		 * @return	keycode
		 */
		public function getKeyCode(key:String):int
		{
			for each(var k:Object in _keycodes) 
				if (k[KEYNAME] == key) return int(k[KEYCODE]);
			return -1;
		}
		
		/**
		 * Returns a key string by the given keycoden.
		 * 
		 * @param	key
		 * @return	key name
		 */
		public function getKeyName(key:int):String
		{
			for (var i:uint = 0, c:uint = _keycodes.length; i < c; i++)
				if (_keycodes[i][KEYCODE] == key) return _keycodes[i][KEYNAME];
			return null;
		}
		
		
		/**
		 * KeyboardEvent.KEY_DOWN
		 */
		private function onKeyDown(e:KeyboardEvent):void
		{
			for each(var binding:Object in _bindings)
			{
				if (e.keyCode == binding[PRIMARY] || e.keyCode == binding[SECONDARY])
				{
					var callback:Function = binding[ON_DOWN];
					if(binding[IS_DOWN] == false) callback();
					binding[IS_DOWN] = true;
				}
			}
		}
		
		/**
		 * KeyboardEvent.KEY_UP
		 */
		private function onKeyUp(e:KeyboardEvent):void
		{
			for each(var binding:Object in _bindings)
			{
				if (e.keyCode == binding[PRIMARY] || e.keyCode == binding[SECONDARY])
				{
					binding[IS_DOWN] = false;
					var callback:Function = binding[ON_UP];
					if(callback != null) callback();
				}
			}
		}
		
	}
}