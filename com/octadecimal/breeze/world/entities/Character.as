/**
 * Class: Character
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.world.entities 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.graphics.Sprite4D;
	import com.octadecimal.breeze.input.Controls;
	import com.octadecimal.breeze.input.Mouse;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.util.Debug;
	import com.octadecimal.breeze.util.VisualVector;
	import com.octadecimal.breeze.world.TransformNode;
	
	/**
	 * Character description.
	 */
	public class Character extends Actor implements IDrawable
	{
		/**
		 * State constants
		 */
		private static const IDLE:String = "idle";
		private static const RUN:String = "run";
		private static const ATTACK:String = "attack";
		private static const SPAWN:String = "spawn";
		private static const DEAD:String = "death";
		
		public static var debugDraw:Boolean = false;
		
		/**
		 * State
		 */
		private var _state:String;
		private var _stateLast:String;
		
		/**
		 * Waypoints
		 */
		public function get wayspoints():Vector.<TransformNode>	{ return _wayspoints; }
		private var _wayspoints:Vector.<TransformNode> = new Vector.<TransformNode>();
		
		/**
		 * Target
		 */
		public function get target():Character			{ return _target; }
		public function set target(a:Character):void	{ _target = a; }
		private var _target:Character;
		
		/**
		 * Alive
		 */
		public function get alive():Boolean	{ return _alive; }
		private var _alive:Boolean;
		
		/**
		 * Attacking
		 */
		public function get attacking():Boolean	{ return _attacking; }
		private var _attacking:Boolean = false;
		
		/**
		 * Running
		 */
		public function get running():Boolean	{ return _running; }
		private var _running:Boolean = false;
		
		/**
		 * If currently patroling
		 */
		public function get patrolling():Boolean		{ return _patrolling; }
		public function set patrolling(a:Boolean):void	{ _patrolling = a; }
		private var _patrolling:Boolean;
		
		/**
		 * Visual debug vector
		 */
		private var _visualVector:VisualVector;
		
		/**
		 * Temp move speed, replaced by DynamicsNode later
		 */
		public var moveSpeed:Number = Math.random() * 0.75 + 0.5;
		public var angularVelocity:Number = 0;
		public var angularAcceleration:Number = 0.5;
		public var velocityX:Number = 0;
		public var velocityY:Number = 0;
		public var acceleration:Number = 0.1;
		
		
		/**
		 * Constructor
		 */
		public function Character(type:String)
		{
			super(type);
		}
		
		override public function onLoaded():void 
		{
			_visualVector = new VisualVector(transform);
			
			// Bind attack
			var controls:Controls = Breeze.modules.find("Controls") as Controls;
			controls.bind("debug", onDebugDown, onDebugUp);
			
			super.onLoaded();
		}
		
		private static function onDebugUp():void
		{
			debugDraw  = false;
		}
		
		private static function onDebugDown():void
		{
			debugDraw = true;
		}
		
		
		protected function spawn():void
		{
			if (_state != SPAWN)
			{
				transform.angle = uint(4 * Math.random()) * 90 + 44;
				showPose("spawn", onSpawned);
				var pose:Sprite4D = poses.find("spawn") as Sprite4D;
				pose.time = 0;
				pose.playSpeed = Math.random() * 0.35 + 0.25;
				pose.loop = false;
				pose.display.anchorY = -8;
			}
			_state = SPAWN;
			_alive = true;
			_running = false;
		}
		
		protected function onSpawned():void
		{
			//idle();
		}
		
		protected function idle():void
		{
			if (_state != IDLE)
			{
				showPose("idle");
				var pose:Sprite4D = poses.find("idle") as Sprite4D;
				pose.playSpeed = Math.random() * .25 + .05;
			}
			
			_state = IDLE;
			_attacking = false;
			_running = false;
		}
		
		protected function run():void
		{
			if (_state != RUN) showPose("run");
			poses.find("run").playSpeed = .25;
			
			_state = RUN;
			_attacking = false;
			_running = true;
		}
		
		protected function attack():void
		{
			if (_state != ATTACK)
			{
				showPose("attack");
				var pose:Sprite4D = poses.find("attack") as Sprite4D;
				pose.time = 0;
				pose.playSpeed = Math.random() * .5 + .5;
			}
			
			_state = ATTACK;
			_attacking = true;
			_running = false;
		}
		
		public function die():void 
		{
			if (_state != DEAD)
			{
				showPose("death", onSpawned);
				var pose:Sprite4D = poses.find("death") as Sprite4D;
				pose.playSpeed = Math.random() * 0.5 + .25;
				pose.time = 0;
				pose.loop = false;
				//pose.display.anchorY = -8;
			}
			
			_state = DEAD;
			_alive = false;
			_attacking = false;
			_running = false;
		}
			
		
		
		override public function update(change:uint):void 
		{
			// Save last state
			_stateLast = _state;
			
			// Spawn
			if (_state == null) spawn();
			
			// Character is alive and not attacking
			if (_attacking)
			{
				if (target)
				{
					if (Math.abs(transform.magnitude(target.transform)) > 30)
						idle();
				}
			}
			
			// Waypoints
			if (_alive && !_attacking)
			{
				// Waypoints
				if (_wayspoints.length > 0) 
					updateWaypoints();
			
				// Update angle
				transform.angle += angularVelocity;
				transform.x += velocityX;
				transform.y += velocityY;
			}
			
			if (_state == RUN)
				poses.find("run").playSpeed = moveSpeed * .3;
			
			
			angularVelocity *= 0.90;
			velocityX *= .85;
			velocityY *= .85;
			
				
			// Detect state change
			if (_state != _stateLast)
				onStateChange();
			
			super.update(change);
		}
		
		private function updateWaypoints():void
		{
			var t:TransformNode = _wayspoints[0];
			
			// Test if waypoint reached
			if (transform.magnitude(t) > 15)
			{
				// Orient towards
				orientTowards(t);
				
				// Position towards
				positionTowards(t);
				
				// Run
				run();
				
			}
			// Waypoint reached
			else onWaypointReached();
		}
		
		protected function onWaypointReached():void
		{
			// Remove waypoint
			_wayspoints.shift();
			
			if (_alive)
			{
				// Attack if at target
				if (_target != null && _attacking) 
					attack();
				
				// Idle
				else if (_wayspoints.length == 0)
					idle();
			}
		}
		
		
		
		private function positionTowards(target:TransformNode):void
		{
			var rad:Number = transform.angle * (Math.PI / 180);
			velocityX += Math.cos(rad) * acceleration;
			velocityY += Math.sin(rad) * acceleration;
		}
		
		/**
		 * Orients transform angle towards the passed target.
		 * @param	target
		 * @return	Angle between.
		 */
		private function orientTowards(target:TransformNode):Number
		{
			// Derive angle difference
			var angleBetween:Number = transform.angleBetween(target);
			var radians:Number = transform.angle * (Math.PI / 180);
			var difference:Number = radians - angleBetween;
			
			// Wrap
			if (difference < 0) difference += Math.PI * 2;
			else if (difference >= Math.PI * 2) difference -= Math.PI * 2;
			
			// Kinda hacky, must be a better solution
			var threshold:Number = 0.05;
			if (difference > threshold && difference < Math.PI * 2 - threshold)
			{
				// Orient towards
				if (angleBetween < Math.PI)
				{
						if (difference < Math.PI) angularVelocity -= angularAcceleration;
						else angularVelocity += angularAcceleration;
						//debugDraw = false;
				}
				else
				{
						if (difference > Math.PI) angularVelocity -= angularAcceleration;
						else angularVelocity += angularAcceleration;
				}
			}
			
			// Wrap transform angle
			if (transform.angle < 0) transform.angle += 360;
			else if (transform.angle >= 360) transform.angle -= 360;
			
			return angleBetween;
		}
		
		private function onStateChange():void
		{
			//trace("State: " + _state);
			//showPose(_state);
		}
		
		override public function draw(change:uint):void 
		{
			if(debugDraw && _alive) {
				if (_wayspoints.length > 0) _visualVector.draw(_wayspoints[0]);
			}
			else
				_visualVector.clear();
			
			super.draw(change);
		}
	}
}