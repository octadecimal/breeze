/*
 View:   IsometricPlane
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.world.view.components 
{
	import com.octadecimal.breeze.modules.world.model.IsometricPosition;
	import com.octadecimal.breeze.modules.world.model.ScreenPosition;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	/**
	 * IsometricPlane View.
	 */
	public class IsometricPlane extends Sprite
	{
		
		public function IsometricPlane(width:uint=20, depth:uint=20, tileSize:uint=32, tilePossibilities:uint=16) 
		{
			_width = width;
			_depth = depth;
			_tileSize = tileSize;
			_possibilities = tilePossibilities;
		}
		
		
        
		// API
		// =========================================================================================
		
		public function draw():void
		{
			for each(var tile:IsometricTile in _tiles)
				tile.draw();
		}
		
		public function addTile(color:uint, x:Number, y:Number, z:Number):void
		{
			// Create and position tile
			var tile:IsometricTile = new IsometricTile(_tileSize-1, color);
			tile.position = new IsometricPosition(x/* * _tileSize*/, y/* * _tileSize*/, z /** _tileSize*/);
			
			_tiles.push(tile);
			addChildAt(tile, 0);
		}
		
		public function getTileFromScreen(x:Number, y:Number):IsometricTile
		{
			// Project to isometric
			var projected:IsometricPosition = IsometricPosition.toIsometric(x, y);
			
			// Scale to tilesize and round to nearest tile
			var ix:int = /*Math.round(*/projected.x/* / _tileSize)*/; 
			var iz:int = /*Math.round(*/projected.z/* / _tileSize)*/; 
			
			trace(ix, iz, "*");
			
			// Return tile
			return _tiles[(_width * ix) + iz];
		}
		
		public function hoverTile(tile:IsometricTile):IsometricTile
		{
			// Hover tile
			if(_hoveredTile) _hoveredTile.dehover();
			tile.hover();
			_hoveredTile = tile;
			
			// Return tile to allow for chaining of commands
			return tile;
		}
		
		public function selectTile(tile:IsometricTile):IsometricTile
		{
			// Select tile
			if (!tile.selected)
			{
				tile.select(_possibilities);
				_selectedTile = tile;
			}
			//else
			//{
				//tile.deselect();
			//}
			
			// Return tile to allow for chaining of commands
			return tile;
		}
		
		public function deselectTile(tile:IsometricTile):IsometricTile
		{
			tile.deselect();
			return tile;
		}
		
		/**
		 * Adds a level to the plane by adding surrounding tiles to each
		 */
		public function addLevel():void
		{
			_levels++;
			calculateTileTypes();
		}
		
		public function reset():void
		{
			for (var i:uint = 0; i < _tiles.length; i++)
				_tiles[i].reset(false);
		}
		
        
		
		// INTERNAL
		// =========================================================================================
		
		/**
		 * Loops through each individual tiles and "bubbles" values to it's neighbors, based on its
		 * respective direction, and does so recursively for as many levels this isometric plane 
		 * is set to have.
		 */
		public function calculateTileTypes2():void
		{
			var tile:IsometricTile;
			var pointer:uint;
			
			// Reset all
			for (var i:uint = 0; i < _tiles.length; i++) 
				_tiles[i].type = 0;
			
			// Calculate edges
			for (i = 0; i < _tiles.length; i++)
			{
				// Grab current tile
				tile = _tiles[i];
				
				// Only process filled tiles
				if (tile.filled)
				{
					// Above
					pointer = i - 1;
					for (var j:uint = 1; j <= _levels; j++)
					{
						// Stop at filled tiles
						if (_tiles[pointer].filled) break;
						
						// Branch
						for (var k:int = int(-(j * 2 - 1)/2); k <= int((j * 2 - 1)/2); k++)
							_tiles[pointer + (k*_width)].type += ((j-1) * _possibilities * 2) + 1;
						
						// Move pointer
						pointer -= 1;
					}
					
					// Below
					pointer = i + 1;
					for (j = 1; j <= _levels; j++)
					{
						// Stop at filled tiles
						if (_tiles[pointer].filled) break;
						
						// Branch
						for (k = int(-(j * 2 - 1)/2); k <= int((j * 2 - 1)/2); k++)
							_tiles[pointer + (k*_width)].type += ((j-1) * _possibilities * 2) + 4;
						
						// Move pointer
						pointer += 1;
					}
					
					// Right
					pointer = i + _width;
					for (j = 1; j <= _levels; j++)
					{
						// Stop at filled tiles
						if (_tiles[pointer].filled) break;
						
						// Branch
						for (k = int(-(j*2-1)/2); k <= int((j*2-1)/2); k++)
							_tiles[pointer + (k)].type += ((j-1) * _possibilities * 2) + 2;
						
						// Move pointer
						pointer += _width;
					}
					
					// Right
					pointer = i - _width;
					for (j = 1; j <= _levels; j++)
					{
						// Stop at filled tiles
						if (_tiles[pointer].filled) break;
						
						// Branch
						for (k = int(-(j * 2 - 1)/2); k <= int((j * 2 - 1)/2); k++)
							_tiles[pointer + (k)].type += ((j-1) * _possibilities * 2) + 8;
						
						// Move pointer
						pointer -= _width;
					}
				}
			}
			
			// Calculate corners
		}
		
		public function calculateTileTypes():void
		{
			var tile:IsometricTile;
			var neighbor:IsometricTile;
			
			// Reset all, this should be temp?
			for (var i:uint = 0; i < _tiles.length; i++)
				_tiles[i].type = 0;
			
			// Calculate edge neighbors (sides)
			for (i = 0; i < _tiles.length; i++)
			{
				// Grab current tile
				tile = _tiles[i];
				
				// Check filled state
				if (tile.filled)
				{
					// Add to top
					if(i>_width) _tiles[i-1].type						+= 1;
					
					// Add to right
					if(i<_tiles.length-_width) _tiles[i+_width].type	+= 2;
					
					// Add to bottom
					if(i<_tiles.length-_width)_tiles[i+1].type			+= 4;
					
					// Add to left
					if(i>_width) _tiles[i-_width].type					+= 8;
				}
			}
			
			// Calculate corner neighbors (diagonal)
			for (i = _width+1; i < _tiles.length - _width-1; i++)
			{
				// Grab current tile
				tile = _tiles[i];
				
				// Check if empty
				if (tile.type == 0)
				{
					// Add to top right
					if (_tiles[i-_width+1].filled)
					{
						if (tile.type < _possibilities) 
							tile.type = _possibilities;
						tile.type += 1;
					}
					
					// Add to bottom right
					if (_tiles[i-_width-1].filled)
					{
						if (tile.type < _possibilities) 
							tile.type = _possibilities;
						tile.type += 2;
					}
					
					// Add to bottom left
					if (_tiles[i + _width - 1].filled) 
					{
						if (tile.type < _possibilities) 
							tile.type = _possibilities;
						tile.type += 4;
					}
					
					// Add to top left
					if (_tiles[i+_width+1].filled)
					{
						if (tile.type < _possibilities) 
							tile.type = _possibilities;
						tile.type += 8;
					}
				}
			}
		}
		
        
		
		// ACCESSORS
		// =========================================================================================
		
		/**
		 * Levels
		 */
		public function get levels():uint { return _levels; }
		public function set levels(value:uint):void 
		{
			_levels = value;
		}
		
		
        
		// PRIVATE
		// =========================================================================================
		
		// Tiles collection
		private var _tiles:Vector.<IsometricTile> = new Vector.<IsometricTile>();
		
		// Tile size
		private var _tileSize:uint;
		
		// Number of total tile possibilities (per level)
		private var _possibilities:uint;
		
		// Accessors
		private var _levels:uint = 1;
		
		// Dimensions
		private var _width:uint;
		private var _depth:uint;
		
		// State
		private var _selectedTile:IsometricTile;
		private var _hoveredTile:IsometricTile;
	}
	
}