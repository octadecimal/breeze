/**
 * Class: Sprite4D
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.graphics 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.content.types.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.resources.ILoadable;
	import com.octadecimal.breeze.util.Debug;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * A sprite that draws from a tilesheet buffer to simulate 3 dimensions of space plus time.
	 */
	public class Sprite4D implements IDrawable, ILoadable
	{
		/**
		 * Loaded flag, as required by ILoadable
		 */
		public function get loaded():Boolean			{ return _loaded; }
		public function set loaded(state:Boolean):void	{ _loaded = state; }
		private var _loaded:Boolean;
		
		/**
		 * Reference to Tilesheet to draw from.
		 */
		public function get tilesheet():Tilesheet		{ return _tilesheet; }
		private var _tilesheet:Tilesheet;
		
		/**
		 * DisplayNode object.
		 */
		public function get display():DisplayNode		{ return _display; }
		private var _display:DisplayNode = new DisplayNode();
		
		/**
		 * Determines if the Sprite is repsonsible for drawing itself.
		 */
		public function get autodraw():Boolean			{ return _autodraw; }
		private var _autodraw:Boolean;
		
		/**
		 * Controls whether the clip is currently animating or not.
		 */
		public function get play():Boolean				{ return _play; }
		public function set play(a:Boolean):void		{ _play = a; }
		private var _play:Boolean = true;
		
		/**
		 * The speed to play at.
		 */
		public function get playSpeed():Number			{ return _playSpeed; }
		public function set playSpeed(a:Number):void	{ _playSpeed = a; }
		private var _playSpeed:Number = 1.0;
		
		/**
		 * Controls whether the clip loops or not.
		 */
		public function get loop():Boolean				{ return _loop; }
		public function set loop(a:Boolean):void		{ _loop = a; }
		private var _loop:Boolean = true;
		
		//-- Callback that's called when the sprite has finished playing.
		private var _onComplete:Function;
		public function get onComplete():Function		{ return _onComplete; }
		public function set onComplete(a:Function):void	{ _onComplete = a; }
		
		/**
		 * Controls whether the sprite is drawn or not.
		 */
		public function get visible():Boolean			{ return _visible; }
		public function set visible(a:Boolean):void		{ _visible = a; }
		private var _visible:Boolean = true;
		
		/**
		 * The numeric index of the currently playing clip.
		 */
		public function get clip():uint	{ return _clip; }
		private var _clip:uint = 0;
		
		/**
		 * The internal time for the sprite, from 0->totalFrames-1.
		 */
		public function get time():Number				{ return _time; }
		public function set time(a:Number):void			{ _time = a; }
		private var _time:Number = 0;
		
		/**
		 * Current frame being drawn.
		 */
		public function get currentFrame():uint			{ return _currentFrame; }
		private var _currentFrame:uint;
		
		/**
		 * Debug draw mode, must be compiled in debug mode to work.
		 */
		public function get debugDraw():Boolean			{ return _debugDraw; }
		public function set debugDraw(a:Boolean):void	{ _debugDraw = a; }
		private var _debugDraw:Boolean;
		
		
		/**
		 * Copy geoms
		 */
		private var _copyRect:Rectangle = new Rectangle();
		private var _copyPoint:Point = new Point();
		
		/**
		 * Row and column offset state memory
		 */
		private var _offsetCols:uint=0, _offsetRows:uint=0;
		
		/**
		 * Loaded callback
		 */
		private var _onLoadedCallback:Function;
		
		/**
		 * OnClipComplete callback
		 */
		private var _onClipComplete:Function;
		
		private var _node:XML;
		
		
		/**
		 * Constructor. Accepts an XML node that contains tilesheet information.
		 * 
		 * @param	node		The XML node to build from.
		 * @param	autodraw	If the sprite should auto-register with the engine.
		 * @param	onComplete	On load complete callback.
		 */
		public function Sprite4D(node:XML=null, autodraw:Boolean=false)
		{
			// Args
			_node = node;
			_autodraw = autodraw;
		}
		
		/**
		 * Plays the clip that matches the passed simulated angle.
		 */
		public function set angle(a:Number):void
		{
			if (_tilesheet == null) return; // Kind of hacky, don't like
			
			// Tilesheet params
			var p:TilesheetParams = _tilesheet.params as TilesheetParams;
			
			// Save
			_angle = a;
			
			// Point to true geometric 0
			a += 90;
			
			// Center and save
			a += (p.angleStep * 0.5);
			
			// Wrap
			if (a < 0) a += 360;
			if (a >= 360) a -= 360;
			if (_angle < 0) _angle += 360;
			if (_angle >= 360) _angle -= 360;
			
			// Derive clip
			_clip = a / p.angleStep;
		}
		public function get angle():Number				{ return _angle; }
		private var _angle:Number = 270;
		
		
		/**
		 * Plays the clip of the passed index.
		 * @param	index		Clip to play (0->numClips-1)
		 * @param	onComplete	Optional callback that's triggered when the clip is finished playing.
		 */
		public function playClip(index:uint, onComplete:Function=null):void
		{
			// Tilesheet params
			var p:TilesheetParams = _tilesheet.params as TilesheetParams;
			
			// Save onComplete
			_onClipComplete = onComplete;
			
			// Derive clip
			_clip = index * p.tilesPerClip;
			
			// Reset time
			_time = 0;
		}
		
		
		/**
		 */
		public function load(callback:Function):void 
		{
			// Save callback
			_onLoadedCallback = callback;
			
			// Load tilesheet
			Breeze.content.loadResource(new TilesheetParams(_node), onTilesheetLoaded);
		}
		
		private function onTilesheetLoaded(resource:Tilesheet):void
		{
			// Save tilesheet reference
			_tilesheet = resource;
			
			// Dispatch onLoaded
			onLoaded();
		}
		
		/**
		 */
		public function onLoaded():void 
		{
			// Cast params to tilesheetparams
			var p:TilesheetParams = _tilesheet.params as TilesheetParams;
			
			// Initialize copy geoms
			_copyRect.width = p.tileWidth;
			_copyRect.height = p.tileHeight;
			
			// Autodraw
			if (_autodraw) 
			{
				Engine(Breeze.modules.find("Engine")).registerUpdateable(this);
				Engine(Breeze.modules.find("Engine")).registerDrawable(this);
			}
			
			// Set initial angle;
			angle = angle;
			
			// Load complete
			if(_onLoadedCallback != null) _onLoadedCallback();
		}
		
		/**
		 */
		public function unload():void 
		{
			
		}
		
		/**
		 * Build
		 */
		public function build():void
		{
			
		}
		
		/**
		 * @copy com.octadecimal.breeze.engine.IUpdateable
		 * @see com.octadecimal.breeze.engine.IUpdateable
		 */
		public function update(change:uint):void 
		{
			if (_tilesheet == null) return;
			
			// Cast params to tilesheetparams
			var p:TilesheetParams = _tilesheet.params as TilesheetParams;
			
			// Update time
			updateTime(p);
			
			// Update buffer offsets
			updateBufferOffsets(p);
			
			// Update copy geoms
			updateBufferGeoms(p);
		}
		
		private function updateTime(p:TilesheetParams):void
		{
			// Increment, if playing
			if (_play) _time += _playSpeed;
			
			// Check if at end of clip
			if (_time >= p.tilesPerClip - 1)
			{
				// If set to loop
				if (_loop) 
				{
					// Reset time
					_time = 0;
				}
				else
				{
					// Stop
					_play = false;
					
					// Callback
					if (_onComplete != null) {
						_onComplete();
						_onComplete = null;
					}
				}
			}
			
			// Derive current frame
			_currentFrame = _clip * p.tilesPerClip + uint(_time);
		}
		
		private function updateBufferOffsets(p:TilesheetParams):void
		{
			// Dervie row and column indices
			_offsetRows = _currentFrame / p.cols;
			_offsetCols = _currentFrame % p.cols;
		}
		
		private function updateBufferGeoms(p:TilesheetParams):void
		{
			// Inherit from display node and center
			_copyPoint.x = _display.x - (p.tileWidth  * .5);
			_copyPoint.y = _display.y - (p.tileHeight * .5);
			
			// Anchor
			_copyPoint.x += _display.anchorX;
			_copyPoint.y += _display.anchorY;
			
			// Position copy rect
			_copyRect.x = _offsetCols * p.tileWidth;
			_copyRect.y = _offsetRows * p.tileHeight;
		}
		
		
		/**
		 * @see com.octadecimal.breeze.engine.IDrawable
		 */
		public function draw(change:uint):void 
		{
			if (_tilesheet == null) return;
			
			// If visible
			if (_visible && _tilesheet != null) 
			{
				// Draw to screen
				Breeze.screen.buffer.copyPixels(_tilesheet.texture.buffer, _copyRect, _copyPoint);
			
				// Debug draw
				if (Breeze.DEBUG) 
				{
					if (_debugDraw)
					{
						// Draw location
						Breeze.screen.buffer.fillRect(_copyRect, 0xFF0000);
						
						// Draw full sprite
						var rect:Rectangle = new Rectangle(0, 0, _tilesheet.texture.buffer.width, _tilesheet.texture.buffer.height);
						var point:Point = new Point();
						Breeze.screen.buffer.copyPixels(_tilesheet.texture.buffer, rect, point);
					}
				}
			}
		}
		
		
	}
}