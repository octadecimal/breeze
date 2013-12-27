/**
 * Class: Actor
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.world.entities 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.content.types.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.graphics.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.resources.*;
	import com.octadecimal.breeze.util.*;
	import com.octadecimal.breeze.util.lists.List;
	import com.octadecimal.breeze.world.*;
	
	/**
	 * Actor description.
	 */
	public class Actor extends Entity implements IDrawable
	{
		/**
		 * Static type lookup list.
		 */
		public static var types:List = new List();
		
		/**
		 * Type (file)
		 */
		public function get type():String	{ return _type; }
		private var _type:String;
		
		/**
		 * Poses
		 */
		public function get poses():List	{ return _poses; }
		private var _poses:List = new List();
		private var _numPosesTotal:uint=0;
		
		/**
		 * XML
		 */
		public function get xml():XMLFile	{ return _xml; }
		private var _xml:XMLFile;
		
		
		/**
		 * Constructor
		 */
		public function Actor(type:String)
		{
			_type = type;
		}
		
		public static function registerType(type:String, file:String)
		{
			var item:String = types.find(type);
			if (item == null) {
				types.add(type, file);
				if(Breeze.DEBUG) { Debug.print("[static Actor]", "Type registered: "+type+"->"+file); }
			}
			else if(Breeze.DEBUG) { Debug.print("[static Actor]", "Type already registered: "+type+"->"+file); }
		}
		
		public function showPose(name:String, onClipComplete:Function=null):void
		{
			// Hide all
			hideAllClips();
			
			// Show new
			var sprite:Sprite4D = _poses.find(name) as Sprite4D;
			sprite.visible = true;
			sprite.onComplete = onClipComplete;
		}
		
		protected function hideAllClips():void
		{
			for each(var pose:Sprite4D in _poses.items) {
				pose.visible = false;
			}
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#load()
		 */
		override public function load(callback:Function):void 
		{
			// Load XML
			_xml = requireResource(new ResourceParams(XMLFile.type, Actor.types.find(type)), onXMLLoaded) as XMLFile;
			
			super.load(callback);
		}
		
		private function onXMLLoaded(resource:XMLFile):void
		{
			// Save XML reference
			_xml = resource;
			
			// Graphics
			var graphics:Graphics = Breeze.modules.find("Graphics") as Graphics;
			
			// Create sprites from XML
			for each(var pose:XML in _xml.data.poses.children())
			{
				var sprite:Sprite4D = requireAsset(graphics.createSprite4D(pose, false, onPoseLoaded), true/*, new Array(_xml)*/) as Sprite4D;
				_poses.add(String(pose.name()).split("_")[1], sprite);
				
			}
		}
		
		private var _posesLoaded:uint = 0;
		private function onPoseLoaded():void
		{
			_posesLoaded++;
			//if (_posesLoaded == _xml.poses.children().length())
			{
				// Initially hide all clips
				//hideAllClips();
				
				// Dispatch onLoaded
				//onLoaded();
			}
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#onLoaded()
		 */
		override public function onLoaded():void 
		{
			
			// Add to actors list
			world.registerActor(this);
			
			// No super
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
		override public function update(change:uint):void 
		{
			// Project to camera
			world.camera.project(transform);
			
			// Update poses
			for each(var pose:Sprite4D in _poses.items)
			{
				// Constrain pose to transform node
				pose.display.x = transform.screenX;
				pose.display.y = transform.screenY;
				pose.angle = transform.angle;
				
				// Hide initially
				//pose.visible = false;
				
				pose.update(change);
			}
		}
		
		/**
		 * @see com.octadecimal.breeze.engine.IDrawable#draw()
		 */
		override public function draw(change:uint):void 
		{
			
			// Draw poses - TEMP HACK: don't draw if screen position is at 0,0 for now
			if(transform.screenX != 0 && transform.screenY != 0)
				for each(var pose:Sprite4D in _poses.items)
					pose.draw(change);
				
		}
		
	}
}