/**
 * Flo Engine - http://flo.octadecimal.com
 * Copyright ©2009 Dylan Heyes
 * -----------------------------------------------------------------------------------
 * Class: TilesheetParams 
 * Usage: [empty]
 */

package com.octadecimal.breeze.content.types 
{
	import com.octadecimal.breeze.resources.ResourceParams;
	
	public class TilesheetParams extends ResourceParams
	{
		/**
		 * Name of tilesheet.
		 */
		public var name:String;
		
		/**
		 * Number of rows in the tilesheet.
		 */
		public var rows:uint;
		
		/**
		 * Number of columns in the tilesheet.
		 */
		public var cols:uint;
		
		/**
		 * The width of an individual tile.
		 */
		public var tileWidth:uint;
		
		/**
		 * The height of an individual tile.
		 */
		public var tileHeight:uint;
		
		/**
		 * Total number of tiles in the tilesheet.
		 */
		public var tilesTotal:uint;
		
		/**
		 * Number of clips in the tilesheet.
		 */
		public var clipsTotal:uint;
		
		/**
		 * Number of tiles per clip.
		 */
		public var tilesPerClip:uint;
		
		/**
		 * The angle stepping between each frame.
		 */
		public var angleStep:Number;
		
		
		public function TilesheetParams(node:XML)
		{
			// Node name
			this.name = node.name();
			
			// Filename not needed for tilesheet, so generate a unique fey
			this.file = "tilesheet_" + name;
			
			// Get XML
			this.rows = node.attribute("rows");
			this.cols = node.attribute("cols");
			this.tileWidth = node.attribute("tileWidth");
			this.tileHeight = node.attribute("tileHeight");
			this.tilesPerClip = node.attribute("tilesPerClip");
			
			// Derive 
			this.tilesTotal = rows * cols;
			this.clipsTotal = (cols * rows) / tilesPerClip;
			this.angleStep = 360 * (tilesPerClip / tilesTotal);
			
			// Super
			super(Tilesheet.type, "tilesheet_"+name);
		}
		
	}
	
}