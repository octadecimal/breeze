/**
 * Class: Engine
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.engine 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.gui.GUI;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * The core engine class of Breeze. Manages updating and drawing ticks and calls all
	 * registered objects.
	 */
	public class Engine extends Module
	{
		// Lists
		private var _updateList:Vector.<IUpdateable>, _drawList:Vector.<IDrawable>;
		
		// Update timer
		private var _updateTimer:Timer;
		
		// Time memory
		private var _lastUpdateTime:int;
		private var _lastDrawTime:int;
		
		
		/**
		 * Creates the update and draw lists.
		 * @copy com.octadecimal.breeze.modules.Module#initialize()
		 * @see com.octadecimal.breeze.modules.Module#initialize()
		 */
		override public function initialize():void 
		{
			// Create lists
			_updateList = new Vector.<IUpdateable>();
			_drawList = new Vector.<IDrawable>();
			
			super.initialize();
		}
		
		/**
		 * Starts the engine.
		 */
		public function start():void
		{
			// Create update timer
			//_updateTimer = new Timer(1000/60);
			//_updateTimer.start();
			//_updateTimer.addEventListener(TimerEvent.TIMER, update);
			
			// Listen for stage events
			Breeze.stage.addEventListener(Event.ENTER_FRAME, update);
			Breeze.stage.addEventListener(Event.RENDER, draw);
		}
		
		override public function load(callback:Function):void 
		{
			super.load(callback);
		}
		
		
		/**
		 * Registers an object with the implementation of IUpdateable for updating.
		 * @param	obj		Object to register.
		 */
		public function registerUpdateable(obj:IUpdateable):void
		{
			_updateList.push(obj);
			if(Breeze.DEBUG) { Debug.print(this, "Object registered as updateable: " + obj); }
		}
		
		
		/**
		 * Registers an object with the implementation of IDrawable for drawing.
		 * @param	obj		Object to register.
		 */
		public function registerDrawable(obj:IDrawable):void
		{
			_drawList.push(obj);
			if(Breeze.DEBUG) { Debug.print(this, "Object registered as drawable: " + obj); }
		}
		
		
		/**
		 * Calculates the time since last update. Loops through _updateList and calls IUpdateable.update() for each object.
		 * @copy com.octadecimal.breeze.modules.Module#update()
		 * @see com.octadecimal.breeze.modules.Module#update()
		 */
		private function update(e:Event):void 
		{
			// Begin profiling
			if (Breeze.DEBUG) Debug.profile.endProfiling();
			if (Breeze.DEBUG) Debug.profile.beginProfiling();
			
			if (Breeze.DEBUG) Debug.profile.begin("breeze");
			if (Breeze.DEBUG) Debug.profile.begin("update_"+this);
			
			
			// Get time
			var time:int = getTimer();
			var c:int = time - _lastUpdateTime;
			
			
			// Temporary HACK, draws gui on top of everything else, implement proper display list later
			//var gui:GUI = GUI(Breeze.modules.find("GUI")) as GUI;
			//if (Breeze.DEBUG) Debug.profile.begin("update_"+gui);
			//gui.update(c);
			//if (Breeze.DEBUG) Debug.profile.end("update_"+gui);
			
			
			// Update objects
			for each(var obj:IUpdateable in _updateList) {
				if (Breeze.DEBUG) Debug.profile.begin("update_"+obj);
				obj.update(c);
				if (Breeze.DEBUG) Debug.profile.end("update_"+obj);
			}
				
			// Save time
			_lastUpdateTime = time;
			
			// Profiling
			if (Breeze.DEBUG) Debug.profile.end("update_"+this);
			
			
			// Invalidate stage
			Breeze.stage.invalidate();
			//draw();
			//Debug.setText("update time "+ c.toFixed(2) + "ms");
			//if (c < 1000/30 && (1000 / 30) * (time-_lastDrawTime) > 100) Breeze.stage.invalidate();
			//else Breeze.screen.buffer.fillRect(new Rectangle(0, 0, Breeze.stage.stageWidth, Breeze.stage.stageHeight), 0xFF0000); 
			//else Debug.setText("Frame skipped: " + time);
			
		}
		
		
		/**
		 * Loops through _drawList and calls IDrawable.draw() for each object and calculates the time since last frame draw.
		 * @copy com.octadecimal.breeze.modules.Module#draw()
		 * @see com.octadecimal.breeze.modules.Module#draw()
		 */
		private function draw(e:Event=null):void 
		{
			if (Breeze.DEBUG) Debug.profile.begin("draw_" + this);
			
			Breeze.screen.buffer.lock();
			
			// Clear screen
			Breeze.screen.clear();
			
			
			// Get time
			var time:int = getTimer();
			var c:int = time - _lastDrawTime;
			
			// Draw objects
			for each(var obj:IDrawable in _drawList) {
				if (Breeze.DEBUG) Debug.profile.begin("draw_" + obj);
				obj.draw(c);
				if (Breeze.DEBUG) Debug.profile.end("draw_" + obj);
			}
			
			// Temporary HACK, draws gui on top of everything else, implement proper display list later
			var gui:GUI = GUI(Breeze.modules.find("GUI")) as GUI;
			if (Breeze.DEBUG) Debug.profile.begin("draw_"+gui);
			gui.draw(c);
			if (Breeze.DEBUG) Debug.profile.end("draw_"+gui);
			
			
			Debug.setFPSText("FPS: "+ Number((1000 / c)).toFixed(0));
				
			// Save time
			_lastDrawTime = time;
			
			Breeze.screen.buffer.unlock();
			
			// End profiling
			if (Breeze.DEBUG) Debug.profile.end("draw_"+this);
			if (Breeze.DEBUG) Debug.profile.end("breeze");
		}
	}
}