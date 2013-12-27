/**
 * Class: Entity
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.world.entities 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.world.TransformNode;
	import com.octadecimal.breeze.world.World;
	
	/**
	 * Entity description.
	 */
	public class Entity extends Module implements IDrawable
	{ 
		/**
		 * Transform node
		 */
		public var transform:TransformNode = new TransformNode();
		
		/**
		 * World reference
		 */
		protected var world:World;
		
		/**
		 * Constructor
		 */
		public function Entity()
		{
			world = Breeze.modules.find("World") as World;
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#initialize()
		 */
		override public function initialize():void 
		{
			
			super.initialize();
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#load()
		 */
		override public function load(callback:Function):void 
		{
			super.load(callback);
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#onLoaded()
		 */
		override public function onLoaded():void 
		{
			super.onLoaded();
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#unload()
		 */
		override public function unload():void 
		{
			super.unload();
		}
		
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#build()
		 */
		override public function build():void 
		{
			super.build();
		}
		
		/**
		 * @see com.octadecimal.breeze.engine.IUpdateable#update()
		 */
		public function update(change:uint):void 
		{
			
		}
		
		/**
		 * @see com.octadecimal.breeze.engine.IDrawable#draw()
		 */
		public function draw(change:uint):void 
		{
			
		}
		
	}
}