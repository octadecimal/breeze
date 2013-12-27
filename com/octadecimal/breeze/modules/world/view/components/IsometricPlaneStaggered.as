/*
 View:   IsometricStaggeredPlane
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.world.view.components 
{
	import com.octadecimal.breeze.modules.world.interfaces.IIsometricPlane;
	import com.octadecimal.breeze.modules.world.model.IsometricPosition;
	import com.octadecimal.breeze.modules.world.model.ScreenPosition;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * IsometricStaggeredPlane View.
	 */
	public class IsometricPlaneStaggered extends Sprite implements IIsometricPlane
	{
		/**
		 * Directions [x, y, stagger]
		 */
		public static const HERE:Vector.<int>		= Vector.<int>([  0,  0,  0 ]);
		public static const NORTH:Vector.<int>		= Vector.<int>([  0, -2,  0 ]);
		public static const EAST:Vector.<int>		= Vector.<int>([  1,  0,  0 ]);
		public static const SOUTH:Vector.<int>		= Vector.<int>([  0,  2,  0 ]);
		public static const WEST:Vector.<int>		= Vector.<int>([ -1,  0,  0 ]);
		public static const NORTH_EAST:Vector.<int>	= Vector.<int>([  0, -1,  1 ]);
		public static const SOUTH_EAST:Vector.<int>	= Vector.<int>([  0,  1,  1 ]);
		public static const SOUTH_WEST:Vector.<int>	= Vector.<int>([ -1,  1,  1 ]);
		public static const NORTH_WEST:Vector.<int>	= Vector.<int>([ -1, -1,  1 ]); 
		
		/**
		 * Constructor
		 */
		public function IsometricPlaneStaggered(width:Number, depth:Number, tileSize:Number) 
		{
			// Save
			_instance = this;
			_width = width;
			_depth = depth;
			_tileSize = tileSize;
			_tileHeight = tileSize;
			_tileWidth = tileSize * 2;
			
			// Create tiles
			for (var i:uint = 0; i < _width; i++)
				for (var j:uint = 0; j < _depth; j++) 
					addTile(i, 0, j, 0, i * _depth + j);
			
			// Initial generation
			generate();
			
			// Debug text
			addChild(debug);
			debug.defaultTextFormat = new TextFormat("Arial", 11, 0xFFFFFF, true);
			debug.selectable = false;
			debug.autoSize = TextFieldAutoSize.LEFT;
			//debug.x = 40;
			//debug.y = 140;
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void 
		{
			if(_selectionMethod == SELECTIONMETHOD_STAGGERED) graphics.clear();
		}
		
		
		
        
		// API
		// =========================================================================================
		
		/**
		 * Generates the types for all tiles.
		 */
		public function generate():void
		{
			var tile:IsometricTile;
			var n:IsometricTile;
			var h:uint = _combinations / 2;
			
			// Reset tiles
			for (var i:uint = 0, c:uint = _tiles.length; i < c; i++)
				_tiles[i].reset(true);
			
			// Edges Pass
			for (i = 0; i < c; i++)
			{
				// Grab current tile
				tile = _tiles[i];
				
				// Process filled tiles only
				if (tile.filled)
				{
					// Move to tile
					_pointer.x = int(i / _depth);
					_pointer.z = int(i % _depth);
					
					// Northeast
					n = neighbor(NORTH_EAST);
					if(n) n.type	+= 1;
					
					// Southeast
					n = neighbor(SOUTH_EAST);
					if(n) n.type	+= 2;
					
					// Southwest
					n = neighbor(SOUTH_WEST);
					if(n) n.type	+= 4;
					
					// Northwest
					n = neighbor(NORTH_WEST);
					if(n) n.type	+= 8;
				}
			}
			
			// Corners pass
			for (i = 0; i < c; i++)
			{
				// Grab current tile
				tile = _tiles[i];
				
				// Move pointer to tile
				_pointer.x = int(i / _depth);
				_pointer.z = int(i % _depth);
				
				// Process empty tiles only
				if (tile.type == 0)
				{
					// North corner
					n = neighbor(SOUTH);
					if (n) if (n.filled)
					{
						if (tile.type < h) tile.type = h;
						tile.type += 8;
					}
					
					// East corner
					n = neighbor(WEST);
					if (n) if (n.filled)
					{
						if (tile.type < h) tile.type = h;
						tile.type += 1;
					}
					
					// South corner
					n = neighbor(NORTH);
					if (n) if (n.filled)
					{
						if (tile.type < h) tile.type = h;
						tile.type += 2;
					}
					
					// West corner
					n = neighbor(EAST);
					if (n) if (n.filled)
					{
						if (tile.type < h) tile.type = h;
						tile.type += 4;
					}
				}
			}
		}
		
		/**
		 * Draws each tile.
		 */
		public function draw():void
		{
			for each(var tile:IsometricTile in _tiles)
				tile.draw();
		}
		
		/**
		 * Retrieves a tiles using 2d screen-space coordinates as input.
		 */
		public function retrieveTile(x:Number, y:Number):IsometricTile
		{
			// Project input coordinates to isometric
			var projected:IsometricPosition = toIsometric(x, y);
			
			// Derive index
			var i:uint = _depth * projected.x + projected.z;
			
			// Return if within bounds
			if(i >=0 && i < _tiles.length) return _tiles[i];
			else return null;
		}
		
		/**
		 * Moves the tiles array pointer by the amount passed in by the pattern argument.
		 */
		public function to(pattern:Vector.<int>, steps:uint=1, reset:Boolean=false):IsometricTile
		{
			// Save pointer if set to reset
			if (reset) var original:IsometricPosition = _pointer.clone();
			
			// Walk
			for (var i:uint = 0, start:int; i < steps; i++)
			{
				// Save start z
				start = _pointer.z;
				
				// Shift pointer
				_pointer.x += pattern[0];
				_pointer.z += pattern[1];
				
				// Stagger pointer
				if (pattern[2] == 1) _pointer.x += start & 1;
			}
			
			// Return
			if (reset) 
			{
				// Save
				var p:IsometricPosition = _pointer;
				
				// Replace pointer with original
				_pointer = original;
				
				// Ensure tile exists at location
				var offset:int = _depth * p.x + p.z;
				if (offset >=0 && offset < _tiles.length) return _tiles[offset];
				else return null;
			}
			else 
			{
				return _tiles[_depth * _pointer.x + _pointer.z];
			}
		}
		
		/**
		 * Shorthand method for using to() when only wishing to retrieve a reference
		 * without moving the pointer.
		 */
		public function neighbor(pattern:Vector.<int>):IsometricTile
		{
			return to(pattern, 1, true);
		}
		
		/**
		 * Projects isometric coordinates to screen coordinates.
		 */
		public function toScreen(iso:IsometricPosition):ScreenPosition
		{
			var x:Number = iso.x * _tileWidth + (iso.z & 1) * (_tileWidth / 2);
			var y:Number = iso.z * (_tileHeight / 2);
			
			return new ScreenPosition(int(x), int(y));
		}
		
		private function toIsometric(x:Number, y:Number):IsometricPosition
		{
			if (_selectionMethod == SELECTIONMETHOD_PRECISE)
				return toIsometric3(x, y);
			else
				return toIsometric2(x, y);
		}
		
		/**
		 * Projects screen coordinates to isometric.
		 */
		public function toIsometric2(x:Number, y:Number):IsometricPosition
		{
			x += _tileWidth/4;
			y += _tileHeight/2;
			var ix:Number = x / _tileWidth + (y & 1) * (_tileWidth / 2);
			var iz:Number = y / (_tileHeight / 2);
			
			return new IsometricPosition(int(ix), 0, int(iz));
		}
		
		/**
		 * A more accurate version of projecting fine coordinates to coarse
		 * isometric coordinates using boolean logic.
		 */
		public function toIsometric3(x:Number, y:Number):IsometricPosition
		{
			var perspective:Number = _tileWidth / _tileHeight;
			var offsetX:Number = 0;
			var offsetY:Number = -(_tileHeight / 2);
			
			// Derive position in 2d gridspace
			var gx:int = (x+offsetX) / _tileWidth;
			var gy:int = (y+offsetY) / _tileHeight;
			var ix:int = gx;
			var iz:int = gy;
			
			// Wrap input coordinates to grid-cell-space
			var cx:Number = (x - offsetX) % _tileWidth;
			var cy:Number = (y - offsetY) % _tileHeight;
			
			// Derive cell quadrant (with perspective and isometric angle)
			var a:Boolean = cx < cy * perspective;
			var b:Boolean = cx < _tileWidth - cy * perspective;
			
			// Left
			if ( a &&  b) iz = gy * 2;
			
			// Lower
			if ( a && !b) iz = gy * 2 + 1;
			
			// Upper
			if (!a &&  b) iz = gy* 2 - 1;
			
			// Right
			if (!a && !b) { ix = gx + 1; iz = gy * 2; }
			
			// Debug stuff
			graphics.clear();
			if (a && b) graphics.beginFill(0xFF0000, 0.75);
			if (a && !b) graphics.beginFill(0x00FF00, 0.75);
			if (!a && b) graphics.beginFill(0xFFFF00, 0.75);
			if (!a && !b) graphics.beginFill(0x0000FF, 0.75);
			graphics.drawRect(offsetX, offsetY, _tileWidth, _tileHeight);
			graphics.endFill();
			graphics.beginFill(0x000000, 0.5);
			graphics.drawRect(cx - 5 + offsetX, cy - 5 + offsetY, 10, 10);
			graphics.endFill();
			debug.text = gx + "," + gy + "\n" + a + "," + b;
			
			// Return
			return new IsometricPosition(ix, 0, iz + 2);
		}
		
		public function addTexture(width:int, height:int, source:String, index:uint):void
		{
			var texture:TextureTile = new TextureTile(width, height, source);
			_textures[index] = texture;
			trace("Added texture: " + _textures[index] + " -> " + source);
		}
		
		public function reset():void
		{
			for (var i:uint = 0; i < _tiles.length; i++)
				_tiles[i].reset(false);
		}
		
		
		
        
		// ACCESSORS
		// =========================================================================================
		
		override public function get width():Number 	{ return _width; }
		override public function set width(value:Number):void 
		{
			super.width = value;
			_width = value;
		}
		
		override public function get height():Number 	{ return _height; }
		override public function set height(value:Number):void 
		{
			super.height = value;
			_height = value;
		}
		
		public function get depth():uint 				{ return _depth; }
		public function set depth(value:uint):void 
		{
			_depth = value;
		}
		
		public function get selectionMethod():String { return _selectionMethod; }
		public function set selectionMethod(value:String):void 
		{
			_selectionMethod = value;
		}
		
		public function get textures():Array { return _textures; }
		public function set textures(value:Array):void 
		{
			_textures = value;
		}
		
		public function get showGrid():Boolean { return _showGrid; }
		public function set showGrid(value:Boolean):void 
		{
			_showGrid = value;
			
			for each(var tile:IsometricTile in _tiles) {
				tile.showGrid = value;
			}
		}
		
		
        
		// INTERNAL
		// =========================================================================================
		
		private function addTile(x:Number, y:Number, z:Number, color:uint=0x00FF00, index:uint=0):void
		{
			// Instantiate tile
			var tile:IsometricTile = new IsometricTile(_tileWidth/2, color, 0, index);
			
			// Set tile position
			tile.position = new IsometricPosition(x, y, z);
			tile.screenPosition = toScreen(tile.position);
			
			// Post process
			_tiles.push(tile);
			addChild(tile);
			tile.draw(true);
			//trace("added: " + index+" -> "+x+","+z);
		}
		
		
		
        
		// STATE
		// =========================================================================================
		
		// Tiles
		private var _tiles:Vector.<IsometricTile> = new Vector.<IsometricTile>();
		
		// Textures
		//private var _textures:Vector.<TextureTile> = new Vector.<TextureTile>();
		private var _textures:Array = new Array();
		
		// Dimensions
		private var _width:Number;
		private var _height:Number;
		private var _depth:Number;
		private var _tileSize:Number;
		private var _tileWidth:Number;
		private var _tileHeight:Number;
		
		// Tiles array pointer
		private var _pointer:IsometricPosition = new IsometricPosition();
		
		// Number of tile combinations
		private var _combinations:uint = 32;
		
		// Show grid (debug)
		private var _showGrid:Boolean = false;
		
		// Selection method
		private var _selectionMethod:String = SELECTIONMETHOD_PRECISE;
		
		public static const SELECTIONMETHOD_STAGGERED:String = "staggered";
		public static const SELECTIONMETHOD_PRECISE:String = "staggeredPrecise";
		
		
		// Templol
		public static function getInstance():IsometricPlaneStaggered
		{
			if (_instance) return _instance;
			else return null;
		}
		private static var _instance:IsometricPlaneStaggered;
		
		var debug:TextField = new TextField();
	}
	
}