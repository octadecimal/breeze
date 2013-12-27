/*
 View:   Topographer
 Author: Dylan Heyes
 Copyright 2010, Dylan Heyes
*/
package com.octadecimal.topographer 
{
	import com.octadecimal.breeze.modules.graphics.view.components.Screen;
	import com.octadecimal.breeze.modules.world.interfaces.IIsometricPlane;
	import com.octadecimal.breeze.modules.world.view.components.IsometricPlaneStaggered;
	import com.octadecimal.breeze.modules.world.view.components.IsometricTile;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.RadioButton;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Topographer View.
	 */
	public class Topographer extends Sprite
	{
		
		public function Topographer() 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var screenWidth:uint = stage.stageWidth;
			var screenHeight:uint = stage.stageHeight;
			var tileSize = 64;
			
			var gridWidth:uint  = screenWidth / (tileSize * 2) + 1;
			var gridHeight:uint = screenHeight / (tileSize / 2) - 1;
			
			screen = new Screen();
			screen.bitmapData = new BitmapData(screenWidth, screenHeight, true, 0x0);
			
			
			_plane = new IsometricPlaneStaggered(gridWidth, gridHeight, tileSize);
			addChildAt(_plane, 0);
			//_plane.x = 0;
			//_plane.y = 32;
			
			addChildAt(screen, 0);
			
			//for (var i:uint = 0; i < 1; i++)
				//_plane.addTexture(64, 64, "data/textures/test/0", i);
				
			_plane.addTexture(tileSize, tileSize, "data/textures/test64/0",  0);
			_plane.addTexture(tileSize, tileSize, "data/textures/test/1",  1);
			_plane.addTexture(tileSize, tileSize, "data/textures/test/2",  2);
			_plane.addTexture(tileSize, tileSize, "data/textures/test/4",  4);
			_plane.addTexture(tileSize, tileSize, "data/textures/test/8",  8);
			_plane.addTexture(tileSize, tileSize, "data/textures/test/16", 16);
			_plane.addTexture(tileSize, tileSize, "data/textures/test/17", 17);
			_plane.addTexture(tileSize, tileSize, "data/textures/test/18", 18);
			_plane.addTexture(tileSize, tileSize, "data/textures/test/20", 20);
			_plane.addTexture(tileSize, tileSize, "data/textures/test/24", 24);
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.addEventListener(MouseEvent.MOUSE_UP  , onUp);
			
			RadioButton(radPrecise).addEventListener(MouseEvent.CLICK, onRadPrecise);
			RadioButton(radStaggered).addEventListener(MouseEvent.CLICK, onRadStaggered);
			CheckBox(chkShowGrid).addEventListener(MouseEvent.CLICK, onShowGrid);
			Button(btnReset).addEventListener(MouseEvent.CLICK, btnResetClick);
		}
		
		
		
        
		// EVENTS
		// =========================================================================================
		
		private function onUpdate(e:Event):void 
		{
			updatePlane();
		}
		
		private function onMove(e:MouseEvent):void 
		{
			// Get tile under mouse
			var tile:IsometricTile = _plane.retrieveTile(_plane.mouseX, _plane.mouseY);
			
			if (tile)
			{				
				// Hover tile
				if (_hoveredTile) _hoveredTile.unhover();
				_hoveredTile = tile;
				tile.hover();
				
				// Fill tile if mouse is down
				if (_mouseDown) {
					tile.fill(16);
					_plane.generate();
				}
			}
			
		}
		
		private function onDown(e:MouseEvent):void 
		{
			// Save mouse state
			_mouseDown = true;
			
			// Get tile under mouse
			var tile:IsometricTile = _plane.retrieveTile(_plane.mouseX, _plane.mouseY);
			
			// Fill tile
			if (tile) {
				tile.fill(16);
				_plane.generate();
			}
		}
		
		private function onUp(e:MouseEvent):void 
		{
			// Save mouse state
			_mouseDown = false;
		}
		
		private function btnResetClick(e:MouseEvent):void 
		{
			_plane.reset();
		}
		
		private function onRadPrecise(e:MouseEvent):void 
		{
			_plane.selectionMethod = IsometricPlaneStaggered.SELECTIONMETHOD_PRECISE;
		}
		
		private function onRadStaggered(e:MouseEvent):void 
		{
			_plane.selectionMethod = IsometricPlaneStaggered.SELECTIONMETHOD_STAGGERED;
		}
		
		private function onShowGrid(e:MouseEvent):void 
		{
			(_plane.showGrid) ? _plane.showGrid = false : _plane.showGrid = true;
		}
		
		
		
        
		// INTERNAL
		// =========================================================================================
		
		private function updatePlane():void
		{
			_plane.draw();
		}
		
		
		
        
		// PRIVATE
		// =========================================================================================
		
		// Plane
		private var _plane:IsometricPlaneStaggered;
		
		public static var screen:Screen = new Screen();
		
		// State
		private var _mouseDown:Boolean = false;
		private var _hoveredTile:IsometricTile;
	}
	
}