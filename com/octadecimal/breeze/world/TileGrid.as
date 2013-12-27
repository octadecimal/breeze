/**
 * Class: TileGrid
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.world 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.content.types.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.graphics.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Draws a tile grid of the dimensions viewWidth and viewHeight from the textures loaded in in map.tileTextures.
	 */
	public class TileGrid extends Module implements IDrawable
	{ 
		/**
		 * Map reference
		 */
		private var _map:Map;
		
		/**
		 * Attached camera reference
		 */
		private var _camera:Camera;
		
		/**
		 * View width (amount visible on screen)
		 */
		private var _viewWidth:uint;
		private var _viewHeight:uint;
		
		/**
		 * Grid dimensions
		 */
		private var _tilesWide:uint;
		private var _tilesHigh:uint;
		
		/**
		 * Offsets
		 */
		private var _offsetX:uint, _offsetY:uint;
		private var _offsetCols:uint=0, _offsetRows:uint=0;
		
		/**
		 * Copy geoms
		 */
		private var _copyRect:Rectangle = new Rectangle();
		private var _copyPoint:Point = new Point();
		
		/**
		 * Display node
		 */
		public function get display():DisplayNode	{ return _display; }
		private var _display:DisplayNode = new DisplayNode();
		
		
		/**
		 * Constructor
		 */
		public function TileGrid(map:Map, viewWidth:uint, viewHeight:uint)
		{
			_map = map;
			_viewWidth = viewWidth;
			_viewHeight = viewHeight;
		}
		
		/**
		 * Attach camera.
		 * @param	camera	Camera to attach to.
		 */
		public function attachCamera(camera:Camera):void
		{
			if (Breeze.DEBUG) { Debug.print(this, "Attached camera: " + camera); } 
			_camera = camera;
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#load()
		 */
		override public function load(callback:Function):void 
		{
			// Derive grid width and height
			_tilesWide = Math.ceil(Breeze.stage.stageWidth / _map.settings.tileWidth) + 1;
			_tilesHigh = Math.ceil(Breeze.stage.stageHeight / _map.settings.tileHeight) + 1;
			display.width = _tilesWide * _map.settings.tileWidth;
			display.height = _tilesHigh * _map.settings.tileHeight;
			
			// Set copy rect
			_copyRect.width = _map.settings.tileWidth;
			_copyRect.height = _map.settings.tileHeight;
			
			super.load(callback);
		}
		
		/**
		 * @see com.octadecimal.breeze.engine.IUpdateable#update()
		 */
		public function update(change:uint):void 
		{
			_tilesWide = Math.ceil(Breeze.stage.stageWidth / _map.settings.tileWidth) + 1;
			_tilesHigh = Math.ceil(Breeze.stage.stageHeight / _map.settings.tileHeight) + 1;
			
			// If a camera is attached
			if (_camera != null)
			{
				// Derive offsets
				_offsetCols = _camera.transform.x / _map.settings.tileWidth;
				_offsetRows = _camera.transform.y / _map.settings.tileHeight;
				_offsetX = _camera.transform.x - (_offsetCols * _map.settings.tileWidth);
				_offsetY = _camera.transform.y - (_offsetRows * _map.settings.tileHeight);
			}
		}
		
		/**
		 * @see com.octadecimal.breeze.engine.IDrawable#draw()
		 */
		public function draw(change:uint):void 
		{
			if (Breeze.DEBUG) Debug.profile.begin("draw_"+this);
			
			// Draw tiles
			for (var row:uint = 0; row < _tilesHigh; row++)
				for (var col:uint = 0; col < _tilesWide; col++)
				{
					// Offset copy origin
					_copyPoint.x = (col * _map.settings.tileWidth) - _offsetX;
					_copyPoint.y = (row * _map.settings.tileHeight) - _offsetY;
					
					// Get tile index
					var tile:uint = _map.grid[_offsetCols + col][_offsetRows + row];
					
					// Draw
					Breeze.screen.buffer.copyPixels(_map.tileTextures[tile].buffer, _copyRect, _copyPoint);
				}
				
			if (Breeze.DEBUG) Debug.profile.end("draw_"+this);
		}
		
	}
}