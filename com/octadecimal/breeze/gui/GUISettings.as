/**
 * Class: GUISettings
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui 
{
	import com.octadecimal.breeze.util.Settings;
	import flash.geom.Rectangle;
	
	public class GUISettings extends Settings
	{ 
		/**
		 * Name of skin to use.
		 */
		public var skin:String;
		
		/**
		 * Skin color.
		 */
		public var color:uint;
		
		/**
		 * Reference to menus node
		 */
		public var menus:XMLList;
		
		
		/*************************************************************
		 * Skin coordinates
		 */
		
		/**
		 * Window copy boundary.
		 */
		public var window:Rectangle;
		
		/**
		 * Toolbar copy boundary.
		 */
		public var toolbar:Rectangle;
		
		/**
		 * Menu copy boundary.
		 */
		public var menu:Rectangle;
		
		/**
		 * Button (large) copy boundary.
		 */
		public var buttonLarge:Rectangle;
		
		/**
		 * Button (small copy boundary.
		 */
		public var buttonSmall:Rectangle;
		
		/**
		 * Button large side width.
		 */
		public var buttonLargeSide:Number;
		
		/**
		 * Button small side width.
		 */
		public var buttonSmallSide:Number;
		
		/**
		 * Logo copy boundary
		 */
		public var logo:Rectangle;
		
		
		/**
		 * Constructor
		 */
		public function GUISettings(xml:XML)
		{
			// Skin and window fill color
			skin = xml.attribute("skin");
			color = xml.skin.attribute("color");
			
			// Reference to menus node
			menus = xml.menus;
			
			
			// Texture path (not currently used)
			var textures:XMLList = xml.skin.textures;
			
			// Window boundary
			with (textures.window) 
				window = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
			
			// Toolbar boundary
			with (textures.toolbar) 
				toolbar = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
			
			// Menu boundary
			with (textures.menu) 
				menu = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
			
			// Button large boundary
			with (textures.buttonLarge) {
				buttonLarge = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
				buttonLargeSide = attribute("s");
			}
			
			// Button small boundary
			with (textures.buttonSmall) {
				buttonSmall = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
				buttonSmallSide = attribute("s");
			}
				
			
			// Logo boundary
			with (textures.logo) 
				logo = new Rectangle(attribute("x"), attribute("y"), attribute("w"), attribute("h"));
			
			
			super(xml);
		}
		
	}
}