/**
 * Class: MapSettings
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.world 
{
	import com.octadecimal.breeze.util.Settings;
	
	public class MapSettings extends Settings
	{
		public var name:String;
		
		public var tilesWide:uint = 0;
		public var tilesHigh:uint = 0;
		
		public var tileWidth:uint = 0;
		public var tileHeight:uint = 0;
		
		public var texturePrefix:String;
		
		public var zones:Array = new Array();
		
		
		/**
		 * Constructor
		 */
		public function MapSettings(xml:XML)
		{
			name = xml.attribute("name");
			tilesWide = xml.attribute("tiles-wide");
			tilesHigh = xml.attribute("tiles-high");
			tileWidth = xml.attribute("tile-width");
			tileHeight = xml.attribute("tile-height");
			texturePrefix = xml.attribute("texture-prefix");
			
			super(xml);
		}
		
	}
}