/**
 * Class: Player
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.world.entities 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.gui.GUI;
	import com.octadecimal.breeze.input.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.Debug;
	import com.octadecimal.breeze.world.TransformNode;
	
	/**
	 * Player description.
	 */
	public class Player extends Character implements IDrawable
	{ 
		
		/**
		 * Constructor
		 */
		public function Player(type:String)
		{
			super(type);
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#onLoaded()
		 */
		override public function onLoaded():void 
		{
			// Bind attack
			var controls:Controls = Breeze.modules.find("Controls") as Controls;
			controls.bind("attack", onAttackDown, onAttackUp);
			
			// Center
			
			super.onLoaded();
		}
		
		override protected function onSpawned():void 
		{
			idle();
			
			super.onSpawned();
		}
		
		private function onAttackDown():void
		{
			attack();
		}
		
		private function onAttackUp():void
		{
			idle();
		}
		
		/**
		 * @see com.octadecimal.breeze.engine.IUpdateable#update()
		 */
		override public function update(change:uint):void 
		{
			// Check for aggro
			Debug.profile.begin("npcCheck_"+this);
			for each(var npc:NPC in world.npcs)
			{
				var distance:Number = Math.abs(transform.magnitude(npc.transform));
				
				// If within aggro range AND not already target
				if (distance < 128)
					if(npc.target != this)
					npc.aggress(this);		
				
				// If within attack range
				if (attacking && distance < 50)
					npc.die();
			}
			Debug.profile.end("npcCheck_"+this);
			moveSpeed = 5;
			acceleration = .50;
			angularAcceleration = 2;
			
			// Test waypoint -- Definitely redo all this
			var mouse:Mouse = Breeze.modules.find("Mouse") as Mouse;
			var gui:GUI = Breeze.modules.find("GUI") as GUI;
			if (gui != null)
			{
				if (!gui.receivedInput)
				{
					if (mouse != null)
					{
						if (mouse.isDown) wayspoints[0] = (new TransformNode(mouse.transform.x, mouse.transform.y));
					}
				}
			}
			else if (mouse != null)
			{
				if (mouse.isDown) wayspoints[0] = (new TransformNode(mouse.transform.x, mouse.transform.y));
			}
			//if (mouse.isClicked) wayspoints.push(new TransformNode(mouse.transform.x, mouse.transform.y));
			
			super.update(change);
		}
		
		/**
		 * @see com.octadecimal.breeze.engine.IDrawable#draw()
		 */
		override public function draw(change:uint):void 
		{
			super.draw(change);
		}
		
	}
}