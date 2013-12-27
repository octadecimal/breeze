/**
 * Class: Snake
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.testland 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.world.entities.NPC;
	
	/**
	 * Snake description.
	 */
	public class Snake extends NPC implements IDrawable
	{ 
		
		/**
		 * Constructor
		 */
		public function Snake(type:String)
		{
			super(type);
		}
		
		override protected function onAggress():void 
		{
			
			
			super.onAggress();
		}
		
		override public function load(callback:Function):void 
		{
			super.load(callback);
		}
		
		
		/**
		 * @copy com.octadecimal.breeze.engine.IUpdateable#update()
		 * @see com.octadecimal.breeze.engine.IUpdateable#update()
		 */
		override public function update(change:uint):void 
		{
			super.update(change);
		}
		
	}
}