package com.octadecimal.topographer 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 */
	public class Test extends Sprite
	{
		
		var debug:TextField = new TextField();
		
		public function Test() 
		{
			addChild(debug);
			debug.defaultTextFormat = new TextFormat("Arial", 11, 0xFFFFFF, true);
			debug.selectable = false;
			debug.autoSize = TextFieldAutoSize.LEFT;
			debug.x = 40;
			debug.y = 140;
			
			addEventListener(Event.ENTER_FRAME, onMove);
		}
		
		private function onMove(e:Event):void 
		{
			var tileWidth:Number = 256;
			var tileHeight:Number = 128;
			var perspective:Number = tileWidth / tileHeight;
			
			var x:Number = mouseX;
			var y:Number = mouseY;
			
			var a:Boolean = x < y * perspective;
			var b:Boolean = x < tileWidth - y * perspective;
			
			
			graphics.clear();
			
			if (a && b) graphics.beginFill(0x00FF00);
			if (a && !b) graphics.beginFill(0x0000FF);
			if (!a && b) graphics.beginFill(0xFF0000);
			if (!a && !b) graphics.beginFill(0x000000);
			
			graphics.drawRect(0, 0, tileWidth, tileHeight);
			graphics.endFill();
			
			graphics.lineStyle(1, 0xFFFFFF);
			graphics.lineTo(tileWidth, tileHeight);
			graphics.moveTo(tileWidth, 0);
			graphics.lineTo(0, tileHeight);
			
			debug.text = int(x) + "," + int(y) + "\n" + a + "," + b;
		}
		
		private function draw():void
		{
		}
		
	}

}