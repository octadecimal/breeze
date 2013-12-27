/**
 * Class: NPC
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.world.entities 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.lists.List;
	import com.octadecimal.breeze.world.TransformNode;
	import flash.utils.getTimer;
	
	/**
	 * NPC description.
	 */
	public class NPC extends Character implements IDrawable
	{ 
		/**
		 * Hate list
		 */
		public function get hateList():Vector.<Player>	{ return _hateList; }
		private var _hateList:Vector.<Player> = new Vector.<Player>();
		
		/**
		 * Aggressive
		 */
		public function get aggressive():Boolean		{ return _aggressive; }
		public function set aggressive(a:Boolean):void	{ _aggressive = a; }
		private var _aggressive:Boolean = false;
		
		// Inital spawn location
		private var _spawnX:int, _spawnY:int;
		
		// Patrol finish time, used to have an idle delay time between waypoints
		private var _nextPatrolTime:int;
		
		// Set to true if to re-patrol after timeout
		private var _watchPatrol:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function NPC(type:String)
		{
			super(type);
		}
		
		public function aggress(target:Character):void
		{
			if (!_aggressive) return;
			
			// If not already in hate list
			var found:Boolean = false;
			for each(var t:Player in _hateList)
				if (target == t) found = true;
			
			if (!found)
			{
				// Add to hate list
				_hateList.push(target);
				
				// Set as target
				this.target = target;
				
				// Make waypoint
				wayspoints.push(target.transform);
			}
			
			// onAgress
			onAggress();
		}
		
		protected function onAggress():void
		{
			
		}
		
		override protected function onSpawned():void 
		{
			// Make aggressive
			_aggressive = true;
			
			// Save spawn position
			_spawnX = transform.x;
			_spawnY = transform.y;
			
			// Delay patrol
			_watchPatrol = true;
			_nextPatrolTime = getTimer() + (100 * Math.random()) + 100;
			
			super.onSpawned();
		}
		
		private function patrol():void
		{
			_watchPatrol = false;
			patrolling = true;
			
			// Generate random position
			wayspoints.push(new TransformNode(_spawnX + (Math.random() * 512 - 256), _spawnY + (Math.random() * 512 - 256)));
		}
		
		override protected function onWaypointReached():void 
		{
			// Generate next patrol time
			_nextPatrolTime = getTimer() + (8000 * Math.random());
			_watchPatrol = true;
			
			super.onWaypointReached();
		}
		
		override public function update(change:uint):void 
		{
			if (alive)
			{
				angularAcceleration = 2;
				
				// If items in hate list
				if (_hateList.length > 0)
				{
					moveSpeed = 1.75;
					acceleration = .225;
					
					// Loop through each character in hate list
					for each(var character:Player in _hateList)
					{
						// Update waypoint
						wayspoints[0] = character.transform;
						
						// Check if in attack range
						if (Math.abs(transform.magnitude(character.transform)) < 50)
							attack();
					}
				}
				else
				{
					// Patrol
					if (_watchPatrol == true && _nextPatrolTime <= getTimer())
						patrol();
				}
			}
			super.update(change);
		}
	}
}