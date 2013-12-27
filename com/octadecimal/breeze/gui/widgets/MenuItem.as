/**
 * Class: MenuItem
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
	
	public class MenuItem extends Widget implements IDrawable
	{ 
		private var _label:Label;
		private var _caption:String;
		
		private var _boundary:Rectangle;
		
		/**
		 * Constructor
		 */
		public function MenuItem(name:String, caption:String)
		{
			_caption = caption;
			
			super(name, HORIZONTAL);
		}
		
		override public function initialize():void 
		{
			makeCollidable();
			eventDispatcher = true;
			
			super.initialize();
		}
		
		override public function load(callback:Function):void 
		{
			display.paddingX = 16;
			display.paddingY = 7;
			
			_label = requireAsset(new Label(name+"_Label", _caption, true, false, false, 0xFFFFFF)) as Label;
			
			super.load(callback);
		}
		
		override public function build():void 
		{
			//_boundary = gui.settings.menu.clone();
			_boundary = gui.skin.menu.clone();
			//_boundary.width -= gui.skin.buttonLargeSide * 2;
			//_boundary.x += gui.skin.buttonLargeSide;
			
			add(_label); 
			
			super.build();
		}
		
		override public function update(change:uint):void 
		{
			verbose = false;
			
			super.update(change);
		}
		
		override public function draw(change:uint):void 
		{
			var menu:Menu = parent as Menu;
			
			// Temp hack, this should happen automatically
			collisions.setBounds(display.x, display.y, display.x + display.width, display.y + display.height);
			
			// Inherit display node
			copyPoint.x = display.x;
			copyPoint.y = display.y;
			
			// Mouse is over
			if (mouse.isOver(collisions))
			{
				if (parent)
				{
					var pane:MenuPane = menu.trigger.parent as MenuPane;
					pane.focus = menu.trigger;
					_boundary.x += _boundary.width;
					//_boundary.y += _boundary.height;
					graphics.drawStrip(Breeze.screen.buffer, gui.skin.texture.buffer, display.width, 0, _boundary, copyPoint);
					//_boundary.y -= _boundary.height;
					_boundary.x -= _boundary.width;
					
					if (mouse.isClicked)
					{
						pane.focus = null;
					}
				}
			}
			// Mouse is out
			else
			{
				graphics.drawStrip(Breeze.screen.buffer, gui.skin.texture.buffer, display.width, 0, _boundary, copyPoint);
			}
			
			super.draw(change);
			//collisions.debugDraw();
			//trace(collisions.toString());
		}
		
		override protected function onMouseUp():void 
		{
			super.onMouseUp();
		}
	}
}