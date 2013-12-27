/**
 * Class: Map
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.world 
{
	import com.octadecimal.breeze.content.types.Texture;
	import com.octadecimal.breeze.resources.Resource;
	import com.octadecimal.breeze.resources.ResourceParams;
	import com.octadecimal.breeze.util.Debug;
	import com.octadecimal.breeze.util.lists.List;
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.modules.*;
	
	/**
	 * Loads and builds the resources and settings for a map.
	 */
	public class Map extends Module
	{ 
		/**
		 * Map settings object
		 */
		public function get settings():MapSettings	{ return _settings; }
		private var _settings:MapSettings;
		
		/**
		 * Tile grid
		 */
		public function get grid():Array	{ return _grid; }
		private var _grid:Array;
		
		/**
		 * Zones
		 */
		public function get zones():Vector.<Zone>	{ return _zones; }
		private var _zones:Vector.<Zone>;
		
		/**
		 * Tile textures
		 */
		public function get tileTextures():Vector.<Texture>	{ return _tileTextures; }
		private var _tileTextures:Vector.<Texture> = new Vector.<Texture>();
		
		/**
		 * Lookup
		 */
		private var _lookup:List = new List();
		
		/**
		 * Constructor
		 */
		public function Map(settings:MapSettings)
		{
			_settings = settings;
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#initialize()
		 */
		override public function initialize():void 
		{
			
			super.initialize();
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#load()
		 */
		override public function load(callback:Function):void 
		{
			if (Breeze.DEBUG) { Debug.print(this, "Loading map: "+_settings.name); }
			
			// Initialize grid
			_grid = new Array();
			for (var i:uint = 0; i < settings.tilesWide; i++)
				_grid.push(new Array());
				
			// Load zones
			loadZones();
			
			super.load(callback);
		}
		
		private function loadZones():void
		{
			if (Breeze.DEBUG) { Debug.print(this, "Building zones..."); }
			
			_tileTextures = new Vector.<Texture>();
			
			// Loop through map xml and push to grid
			for each (var node:XML in settings.data.children())
				loadZone(node);
			
			// Debug
			debugOutput();
		}
		
		/**
		 * Loads a zone from the passed zone xml node.
		 * @param	node
		 */
		private function loadZone(node:XML):void
		{
			var zoneX:uint, zoneY:uint;
			
			// Create zone object
			var zone:Zone = new Zone(node);
			
			// Load zone default
			registerTexture(node.tiles.attribute("default"));
				
			
			// Fill grid with zone default
			fillZoneDefault(zone, node);
			
			// Extract textures
			for each(var tile:XML in node.tiles.children())
				extractZoneTexture(zone, tile);
				
			// Output
			if (Breeze.DEBUG) { Debug.print(this, "Zone: " + node.attribute("name")); }
		}
		
		/**
		 * Fills the grid cells defined by the zone with the default texture id spefified.
		 * by `deafult` in the passed zone xml node.
		 * @param	zone	Reference to zone object.
		 * @param	node	Zone XML node.
		 */
		private function fillZoneDefault(zone:Zone, node:XML):void
		{
			for (var i:uint = 0; i < zone.width; i++)
				for (var j:uint = 0; j < zone.height; j++)
					registerTexture(node.tiles.attribute("default"), zone.startX + i, zone.startY + j);
		}
		
		/**
		 * Extracts and registers the textures from the passed zone tile xml node.
		 * @param	zone	Reference to zone object.
		 * @param	node	Tile node xml.
		 */
		private function extractZoneTexture(zone:Zone, node:XML):void
		{
			var str:Array, x:uint, y:uint;
				
			// Extract tile position
			str = String(node.attribute("pos")).split(",");
			x = uint(zone.startX) + uint(str[0]);
			y = uint(zone.startY) + uint(str[1]);
			
			// Extract texture id
			var texture:uint = node.attribute("texture");
			
			// Set tile texture
			registerTexture(texture, x, y);
		}
			
		/**
		 * Registers a tile texture within the grid by key.
		 * @param	col		Grid column
		 * @param	row		Grid row
		 * @param	texture	Texture key
		 * @return	True if a new value was found, or else if reusing.
		 */
		private function registerTexture(texture:uint, col:int=-1, row:int=-1):void
		{
			// Find texture
			var key:String = _lookup.find(texture.toString());
			
			// Texture doesn't exist
			if (key == null)
			{
				var id:uint = _lookup.add(texture.toString());
				if (row != -1) _grid[col][row] = uint(id);
				
				// Load texture
				var resource:Resource = requireResource(new ResourceParams(Texture.type, "resources/textures/" + settings.texturePrefix + texture + ".jpg"), onTextureLoaded);
				_tileTextures.push(resource as Texture);
			}
			// Texture exists
			else
			{
				if (row != -1) _grid[col][row] = uint(key);
			}
		}
		
		/**
		 * onTextureLoaded
		 */
		private var _texturesLoaded:uint = 0;
		private function onTextureLoaded(resource:Texture):void
		{
			_texturesLoaded++;
			
			//if (_texturesLoaded == _tileTextures.length) onLoaded();
		}
		
		private function debugOutput():void
		{
			// Debug output
			if (Breeze.DEBUG) 
			{
				for (var out:String = "", xx:uint = 0, cc:uint = _settings.tilesHigh; xx < cc; xx++)
				{
					for (var yy:uint = 0, dd:uint = _settings.tilesWide; yy < dd; yy++)
						out += _grid[yy][xx] + "\t";
					if(xx != cc-1) out += "\n";
				}
				Debug.print(this, "Generated texture lookup table ("+settings.tilesWide+"x"+settings.tilesHigh+", textures: " + _tileTextures.length+")\n"+out);
			}
		}
		
	}
}