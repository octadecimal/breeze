/*
 View:   IsometricTile
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.breeze.modules.world.view.components 
{
	import com.octadecimal.topographer.Topographer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * IsometricTile View.
	 */
	public class IsometricTile extends IsometricObject
	{
		
		public function IsometricTile(size:Number, color:uint, height:Number=0, index:uint=0) 
		{
			// Initialize
			super(size);
			_color = color;
			_height = height;
			_index = index;
			
			//addChild(_debugLabel2);
			_debugLabel2.selectable = false;
			_debugLabel2.x -= 11;
			_debugLabel2.y -= 14;
			_debugLabel2.defaultTextFormat = new TextFormat("Arial", 11, 0x000000, true);
			
			addChild(_debugLabel);
			_debugLabel.selectable = false;
			_debugLabel.x -= 12;
			_debugLabel.y -= 15;
			_debugLabel.defaultTextFormat = new TextFormat("Arial", 11, 0xCCCCCC, true);
			
			// Initial Draw
			draw();
		}
		
		
        
		// API
		// =========================================================================================
		
		/**
		 * Draw.
		 */
		public function draw(force:Boolean=false):void
		{
			var texture:TextureTile = IsometricPlaneStaggered.getInstance().textures[type];
			
			if (texture) 
			{
				if (texture.a) texture.draw(screenPosition.x, screenPosition.y);
			}
			else
			{
				if(IsometricPlaneStaggered.getInstance().textures[0])
					IsometricPlaneStaggered.getInstance().textures[0].draw(screenPosition.x, screenPosition.y);
			}
			
			
			if (_invalidate || force)
			{
				var half:Number = size * .5;
				var g:Graphics = this.graphics;
				
				// Clear
				g.clear();
				
				// Fill
				if (_filled && _showGrid) g.beginFill(0xFF0000, 0.25);
				//else g.beginFill(_color, 0.5);
				//else g.beginFill(type * type * type * 503);
				
				// Stroke
				if (_hovered) 
					g.lineStyle(2, 0x00FF00, .5)
				else if (_showGrid) 
					g.lineStyle(.5, 0xFFFFFF, 0.1);
				else 
					g.lineStyle(0, 0xFFFFFF, 0);
				
				// Draw
				g.moveTo( -size,	0		);
				g.lineTo( 0,		-half	);
				g.lineTo( size,		0		);
				g.lineTo( 0,		half	);
				g.lineTo( -size,	0		);
				
				// End Fill
				g.endFill();
				
				// Debug text
				if (_showGrid) _debugLabel.text = _debugLabel2.text = x + "," + z + "\n" + _index;
				//else _debugLabel.text = _debugLabel2.text = _type.toString();
				
				// Post-process
				_invalidate = false;
			}
		}
		
		/**
		 * Hover
		 */
		public function hover():void
		{
			_hovered = true;
			_invalidate = true;
		}
		
		/**
		 * Unhover
		 */
		public function unhover():void
		{
			_hovered = false;
			_invalidate = true;
		}
		
		/**
		 * Fill
		 */
		public function fill(type:uint=16):void
		{
			_type = type;
			_filled = true;
			_invalidate = true;
		}
		
		/**
		 * Unfill
		 */
		public function unfill():void
		{
			_filled = false;
			_invalidate = true;
		}
		
		public function reset(keepFills:Boolean=true):void
		{
			if (!keepFills || !_filled) 
			{
				unfill();
				_type = 0;
				_invalidate = true;
			}
		}
		
        
		// ACCESSORS
		// =========================================================================================
		
		/**
		 * Tile height.
		 */
		override public function get height():Number	{ return _height; }
		override public function set height(value:Number):void 
		{
			_height = value;
			_invalidate = true;
		}
		
		/**
		 * Tile color.
		 */
		public function get color():uint				{ return _color; }
		public function set color(value:uint):void 
		{
			_color = value;
			_invalidate = true;
		}
		
		/**
		 * Tile type.
		 */
		public function get type():uint					{ return _type; }
		public function set type(value:uint):void 
		{
			if (!_filled)_type = value;
			_invalidate = true;
		}
		
		/**
		 * Filled state.
		 */
		public function get filled():Boolean			{ return _filled; }
		
		/**
		 * Hovered state.
		 */
		public function get hovered():Boolean			{ return _hovered; }
		
		/**
		 * Index
		 */
		public function get index():uint { return _index; }
		public function set index(value:uint):void 
		{
			_index = value;
		}
		
		public function get showGrid():Boolean { return _showGrid; }
		public function set showGrid(value:Boolean):void 
		{
			_showGrid = value;
			if (_showGrid) addChild(_debugLabel);
			else removeChild(_debugLabel);
			_invalidate = true;
		}
		
		
        
		// STATE
		// =========================================================================================
		
		// Tile type
		private var _type:uint;
		
		// Filled state
		private var _filled:Boolean = false;
		
		// Hovered
		private var _hovered:Boolean = false;
		
		// Index (debugging)
		private var _index:uint;
		
		// Tile height (virtual)
		protected var _height:Number;
		
		// Tile color (for debugging)
		protected var _color:uint;
		
		private var _showGrid:Boolean = false;
		
		// Invalidation
		private var _invalidate = true;
		
		private var _debugLabel:TextField = new TextField();
		private var _debugLabel2:TextField = new TextField();
		
	}
	
}