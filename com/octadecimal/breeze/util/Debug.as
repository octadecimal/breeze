/**
 * Class: Debug
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.util 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.gui.widgets.Toolbar;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.testland.gui.BreezeBar;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import profiler.*;
	
	
	/**
	 * Debug description.
	 */
	public class Debug extends Module implements IUpdateable
	{
		private static const INDENT:uint = 15;
		
		public static var profile:Profiler = new Profiler(62);
		
		public function Debug():void
		{
			Breeze.stage.addChild(profile);
			profile.y = 22;
			//ProfilerConfig.ShowMinMax = true;
			ProfilerConfig.TreeColumnWidthChr = 32;
			ProfilerConfig.ItemHeight = 10;
			ProfilerConfig.Width = 580;
			
			//profile.alpha = 0.5;
			
			//Breeze.engine.registerUpdateable(this);
			
			profile.addEventListener(MouseEvent.ROLL_OVER, onProfilerOver);
			profile.addEventListener(MouseEvent.ROLL_OUT, onProfileOut);
			profile.addEventListener(MouseEvent.MOUSE_UP, onProfileClick);
			profile.addEventListener(Event.ENTER_FRAME, onProfileUpdate);
			super();
		}
		
		private function onProfileClick(e:MouseEvent):void 
		{
			trace("CLICK");
			if (_lockAlpha == true) _lockAlpha = false;
			else _lockAlpha = true;
			trace(_lockAlpha);
		}
		
		private var _isOver:Boolean = false;
		private var _lockAlpha:Boolean = false;
		
		private function onProfileUpdate(e:Event):void 
		{
			if (_lockAlpha)
				profile.alpha += 0.1;
			else if (profile.alpha > 0.15 && !_isOver)
				profile.alpha *= .99;
			else if (profile.alpha < 0.9 && _isOver)
				profile.alpha += 0.1;
			profile.y = Breeze.stage.stageHeight - profile.height - 4;
			
			profile.alpha = Math.min(profile.alpha, 1.0);
			profile.alpha = Math.max(profile.alpha, 0.0);
		}
		
		private function onProfilerOver(e:MouseEvent):void 
		{
			_isOver = true;
		}
		
		private function onProfileOut(e:MouseEvent):void 
		{
			_isOver = false;
		}
		
		public function update(change:uint):void
		{
			ProfilerConfig.Width = 640;
			//ProfilerConfig.Width = Breeze.stage.stageWidth - 1;
			profile.y = Breeze.stage.stageHeight - profile.height - 4;
		}
		
		
		/**
		 * Prints an informational message to the debug buffer.
		 * @param	msg		Information message.
		 * @example Debug.info(this, "Game started.");
		 */
		public static function info(caller:Object, msg:String):void
		{
			if (Breeze.DEBUG)
			{
				setText(caller + " :: " +msg);
				var msg:String = (caller.toString().length > INDENT) ? ("" + caller + "\t>>  " + msg) : ("" + caller + "\t\t>>  " + msg);
				trace(msg);
			}
		}
		
		/**
		 * Prints a debug message to the debug buffer.
		 * @param	msg		Debug message.
		 * @example Debug.print(this, "Module loaded.");
		 */
		public static function print(caller:Object, msg:String):void
		{
			//if (Breeze.DEBUG)
			//{
				setText(caller + " :: " +msg);
				var msg:String = (caller.toString().length > INDENT) ? ("" + caller + "\t >  " + msg) : ("" + caller + "\t\t >  " + msg);
				trace(msg);
			//}
		}
		
		/**
		 * Prints a warning message to the debug buffer.
		 * @param	msg		Warning message.
		 * @example Debug.warn(this, "Drawing an off-screen object.");
		 */
		public static function warn(caller:Object, msg:String):void
		{
			if (Breeze.DEBUG)
			{
				var msg:String = (caller.toString().length > INDENT) ? ("" + caller + "\t !  WARNING: " + msg) : ("" + caller + "\t\t!!  WARNING: " + msg);
				trace(msg);
				setText(msg);
			}
		}
		
		/**
		 * Prints an error message to the debug buffer.
		 * @param	msg		Error message.
		 * @example Debug.error(this, "Error loading image.");
		 */
		public static function error(caller:Object, msg:String):void
		{
			if (Breeze.DEBUG)
			{
				var msg:String = (caller.toString().length > INDENT) ? ("" + caller + "\t!!  ERROR: " + msg) : ("" + caller + "\t\t!!  ERROR: " + msg);
				trace(msg);
				setText(msg);
			}
		}
		
		/**
		 * Temporary toolbar debug text
		 */
		public static function setText(str:String):void
		{
			BreezeBar.setText(/*"Debug: "+*/str);
		}
		public static function setFPSText(str:String):void
		{
			BreezeBar.setFPSText(str);
		}
		
	}
}