/**
 * Class: MenuButton
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.gui.widgets 
{
	import com.octadecimal.breeze.Breeze;
	import com.octadecimal.breeze.engine.IDrawable;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MenuButton extends Widget implements IDrawable
	{ 
		/**
		 * Draw menu
		 */
		public function get drawMenu():Boolean		{ return _drawMenu; }
		public function set drawMenu(a:Boolean):void	{ _drawMenu = a; }
		private var _drawMenu:Boolean;
		
		/**
		 * Label
		 */
		private var _label:Label;
		private var _caption:String;
		
		/**
		 * Reference to attached Menu (if any). Set via attachMenu().
		 */
		public function get menu():Menu		{ return _menu; }
		private var _menu:Menu;
		
		/**
		 * Private
		 */
		private var _watchUp:Boolean = false;
		private var _boundary:Rectangle = new Rectangle();
		
		
		/**
		 * Constructor
		 */
		public function MenuButton(name:String, caption:String, menu:Menu=null)
		{
			_caption = caption;
			_menu = menu;
			
			super("MenuButton_" + name, HORIZONTAL);
		}
		
		override public function initialize():void 
		{
			display.paddingX = 12;
			display.paddingY = 3;
			
			makeCollidable();
			
			super.initialize();
		}
		
		/**
		 * Attachs a menu
		 * @param	menu
		 */
		public function attachMenu(menu:Menu):void
		{
			// Save reference
			_menu = menu;
			
			// Make trigger of menu
			_menu.trigger = this;
		}
		
		/**
		 * Load
		 * @param	callback
		 */
		override public function load(callback:Function):void 
		{
			// Labels
			_label = requireAsset(new Label(name + "_Label", _caption, true, true)) as Label;
			
			super.load(callback);
		}
		
		/**
		 * Build
		 */
		override public function build():void 
		{
			_boundary = gui.skin.toolbar.clone();
			_boundary.x += gui.skin.toolbar.width;
			_boundary.width = gui.skin.toolbarSide;
			
			add(_label);
			
			super.build();
			
			//_menu.generate();
			
		}
		
		override public function update(change:uint):void 
		{
			if (parent.focus == this)
			{
				//_menu.update(change);
			}
			
			super.update(change);
		}
		
		/**
		 * Draw
		 * @param	change
		 */
		override public function draw(change:uint):void 
		{
			if (mouseState == MOUSE_DOWN)
			{
				if (parent) parent.focus = this;
				_label.display.y += 1;
			}
			
			if (mouseState == MOUSE_OVER)
			{
				// Focus exists
				if (parent.focus != null) {
					parent.focus = this;
					_label.display.y += 1;
				}
			}
			
			if (mouseState == MOUSE_OUT)
			{
				_watchUp = false;
				if (parent.focus == this) _label.display.y += 1;
			}
			if (mouseState == MOUSE_UP && _watchUp)
			{
				_watchUp = false;
				if (parent.focus == this) parent.focus = null;
				_label.display.y += 1;
			}
			
			else  if (mouseState == MOUSE_UP)
			{
				_watchUp = true;
				_label.display.y += 1;
			}
			
			// Draw if focus
			if (parent.focus == this)
			{
				copyPoint.x = display.x; // <-- These are hacks
				copyPoint.y = display.y; // <-- :(
			
				// Over graphic
				graphics.drawStrip(Breeze.screen.buffer, gui.skin.texture.buffer, display.width, 0, _boundary, copyPoint);
				
				// Draw menu
				_menu.update(change); // <-- Horrible hack. Here to prevent menu from being drawn at 0,0 on first frame. Oh dear. For some reason the menu seems to be updating or drawing one frame behind, which is what i think causes the 0,0 issue.
				_menu.draw(change);
			}
				
			super.draw(change);
		}
	}
}