/**
 * Class: Skin
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.content.types.Texture;
	import com.octadecimal.breeze.events.Event;
	import com.octadecimal.breeze.modules.Module;
	import com.octadecimal.breeze.resources.ResourceParams;
	import com.octadecimal.breeze.util.Debug;
	import flash.geom.Rectangle;
	
	/**
	 * Skin
	 */
	public class Skin extends Module
	{
		/**
		 * Skins XML
		 */
		public var skinsXML:XMLList;
		
		/**
		* XMLList to build from
		*/
		public function set xml(a:XMLList):void		{ _xml = a; }
		public function get xml():XMLList			{ return _xml; }
		private var _xml:XMLList;
		
		/**
		 * Name
		 */
		public var name:String;
		
		/**
		* Skin texture
		*/
		public function get texture():Texture		{ return _texture; }
		private var _texture:Texture;
		
		/**
		 * Color
		 */
		public var color:uint;
		
		/**
		 * Window
		 */
		public var window:Rectangle;
		public var windowOffset:Rectangle;
		
		/**
		 * Menu
		 */
		public var menu:Rectangle;
		
		/**
		 * Toolbar
		 */
		public var toolbar:Rectangle;
		public var toolbarSide:int;
		
		/**
		 * Button (large)
		 */
		public var buttonLarge:Rectangle;
		public var buttonLargeSide:int;
		public var buttonLargeDirection:String;
		
		/**
		 * Button (small)
		 */
		public var buttonSmall:Rectangle;
		public var buttonSmallSide:int;
		public var buttonSmallDirection:String;
		
		/**
		 * Fill (horizontal)
		 */
		public var fillHorizontal:Rectangle;
		public var fillHorizontalSide:int;
		
		/**
		 * Fill (vertical)
		 */
		public var fillVertical:Rectangle;
		public var fillVerticalSide:int;
		
		/**
		 * Check
		 */
		public var check:Rectangle;
		
		/**
		 * Arrow (up)
		 */
		public var arrowUp:Rectangle;
		
		/**
		 * Arrow (down)
		 */
		public var arrowDown:Rectangle;
		
		/**
		 * Scroll box
		 */
		public var scrollBox:Rectangle;
		public var scrollBoxSide:int;
		
		/**
		 * Logo
		 */
		public var logo:Rectangle;

		
		/**
		 * Constructor
		 */
		public function Skin(skinName:String, skinsXML:XMLList=null) 
		{
			this.name = skinName;
			this.skinsXML = skinsXML;
			
			super();
		}
		
		override public function initialize():void 
		{
			// Make an event dispatcher because i'm lazy
			eventDispatcher = true;
			
			super.initialize();
		}
		
		
		/**
		 * Load
		 * @param	callback
		 */
		override public function load(callback:Function):void 
		{
			// Check for null skin xml
			if (!skinsXML) { Debug.error(this, "Attempted to load skin from null skins xml."); return; }
			
			// Get xml for this xml
			_xml = skinsXML[name];
			
			// Load texture
			_texture = requireResource(new ResourceParams(Texture.type, "resources/textures/" + _xml.attribute("skin"))) as Texture;
			
			// Parse xml
			parseXML();
			
			super.load(callback);
		}
		
		override public function onLoaded():void 
		{
			events.dispatch(new Event(Event.COMPLETE));
			super.onLoaded();
		}
		
		private function parseXML():void
		{
			// Check if set to inherit
			var inheritFrom:String = _xml.attribute("inherit-from");
			if (inheritFrom.length > 0)
			{
				if (Breeze.DEBUG) { Debug.print(this, "Inheriting from: " + inheritFrom); } 
				
				// Replace _xml with reference to node to inherit from.
				_xml = skinsXML[inheritFrom];
			}
			
			// _xml.attribute("inherit-from")
			// Color
			color = _xml.attribute("color");
			
			// Window
			with (_xml.window) {
				window = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
				windowOffset = new Rectangle(0, 0, attribute("offsetRight"), attribute("offsetBottom"));
			}
			
			// Menu
			with (_xml.menu) {
				menu = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
			}
			
			// Toolbar
			with (_xml.toolbar) {
				toolbar = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
				toolbarSide = attribute("side");
			}
			
			// Button (large)
			with (_xml.buttonLarge) {
				buttonLarge = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
				buttonLargeSide = attribute("side");
				buttonLargeDirection = attribute("direction");
			}
			
			// Button (small)
			with (_xml.buttonSmall) {
				buttonSmall = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
				buttonSmallSide = attribute("side");
				buttonSmallDirection = attribute("direction");
			}
			
			// Fill (horizontal)
			with (_xml.fillHorizontal) {
				fillHorizontal = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
				fillHorizontalSide = attribute("side");
			}
			
			// Fill (vertical)
			with (_xml.fillVertical) {
				fillVertical = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
				fillVerticalSide = attribute("side");
			}
			
			// Check
			with (_xml.check) {
				check = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
			}
			
			// Arrow (up)
			with (_xml.arrowUp) {
				arrowUp = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
			}
			
			// Arrow (down)
			with (_xml.arrowDown) {
				arrowDown = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
			}
			
			// ScrollBox
			with (_xml.scrollBox) {
				scrollBox = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
			}
			
			// Logo
			with (_xml.logo) {
				logo = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
			}
		}
	}
	
}