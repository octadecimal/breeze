/**
 * Flo Engine - http://flo.octadecimal.com
 * Copyright ©2009 Dylan Heyes
 * -----------------------------------------------------------------------------------
 * Class: Main 
 * Usage: [empty]
 */

package com.octadecimal.testland 
{
	import com.octadecimal.breeze.*;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class Main extends Sprite
	{
		public static const PLAY_INTRO:Boolean = false;
		
		private var _breeze:Game;
		
		public function Main() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//_breeze = new Game(this.stage);
			
			// Intro
			if (PLAY_INTRO)
			{
				intro.x = stage.stageWidth / 2 - 160 / 2;
				intro.y = stage.stageHeight / 2 - 60 / 2;
			}
			else
			{
				intro.stop();
				removeChild(intro);
				createBreeze();
			}
		}
		
		public function createBreeze():void
		{
			_breeze = new Game(this.stage);
		}
		
	}
	
}