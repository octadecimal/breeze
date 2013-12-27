/**
 * Class: World
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.world 
{
	import com.octadecimal.breeze.*;
	import com.octadecimal.breeze.content.*;
	import com.octadecimal.breeze.content.types.*;
	import com.octadecimal.breeze.engine.*;
	import com.octadecimal.breeze.graphics.*;
	import com.octadecimal.breeze.gui.*;
	import com.octadecimal.breeze.modules.*;
	import com.octadecimal.breeze.resources.ResourceParams;
	import com.octadecimal.breeze.util.Debug;
	import com.octadecimal.breeze.world.entities.*;
	import com.octadecimal.testland.Snake;
	
	/**
	 * World description.
	 */
	public class World extends Module implements IDrawable
	{ 
		/**
		 * Map reference
		 */
		public function get map():Map	{ return _map; }
		private var _map:Map;
		
		/**
		 * Active camera reference
		 */
		public function get camera():Camera	{ return _camera; }
		private var _camera:Camera;
		
		/**
		 * Ground tileGrid reference
		 */
		public function get ground():TileGrid	{ return _ground; }
		private var _ground:TileGrid;
		
		/**
		 * Actors list
		 */
		public function get actors():Vector.<Actor>	{ return _actors; }
		private var _actors:Vector.<Actor> = new Vector.<Actor>();
		
		/**
		 * NPCs
		 */
		public function get npcs():Vector.<NPC>	{ return _npcs; }
		private var _npcs:Vector.<NPC> = new Vector.<NPC>();
		
		/**
		 * Test player
		 */
		public function get player():Player	{ return _player; }
		private var _player:Player;
		
		
		
		/**********************************************************************************************************************
		 *  Initialization
		 */
		
		/**
		 * Constructor
		 */
		public function World()
		{
			
		}
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#initialize()
		 */
		override public function initialize():void 
		{
			// Register actor types
			Actor.registerType("snake", "resources/characters/snake.xml");
			
			super.initialize();
		}
		
		
		
		/**********************************************************************************************************************
		 *  Loading
		 */
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#load()
		 */
		override public function load(callback:Function):void 
		{
			// Load camera
			_camera = requireAsset(new Camera()) as Camera;
			
			// Load map
			var mapName:String = "resources/maps/trio.xml";
			requireResource(new ResourceParams(XMLFile.type, mapName), onMapSettingsLoaded);
			
			// Player
			_player = requireAsset(new Player("snake")) as Player;
			
			// NPCs
			for (var i:uint = 0; i < 1; i++)
				npcs.push(requireAsset(new NPC("snake")) as NPC);
			
			super.load(callback);
		}
		
		private function onMapSettingsLoaded(resource:XMLFile):void
		{
			if(Breeze.DEBUG) { Debug.print(this, "Map settings loaded: "+resource.params.file); }
			
			// Create map
			_map = requireAsset(new Map(new MapSettings(resource.data))) as Map;
			
			// Load ground
			_ground = requireAsset(new TileGrid(_map, Breeze.stage.stageWidth, Breeze.stage.stageHeight)) as TileGrid;
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
		
		
		
		/**********************************************************************************************************************
		 *  Map
		 */
		
		public function loadMap(map:String):void
		{
			if(Breeze.DEBUG) { Debug.print(this, "Loading map: "+map); } 
			
			// Load map settings
			Breeze.content.loadResource(new ResourceParams(XMLFile.type, map), onMapSettingsLoaded);
		}
		
		
		/**********************************************************************************************************************
		 *  Actors
		 */
		
		 /**
		  * Loads an NPC.
		  */
		public function spawnNPC(type:String, x:Number=-1, y:Number=-1):NPC
		{
			if(Breeze.DEBUG) { Debug.print(this, "Spawning NPC: "+type); }
			
			// Instantiate, temp as Snake
			var npc:Snake = new Snake(type);
			
			// Load
			npc.load(onNPCLoaded);
			
			// Temporary build
			npc.build();
			
			// Register
			_npcs.push(npc);
			
			if (x <= -1)
			{
				//npc.transform.x = Math.random () * 512 * 19;
				//npc.transform.y = Math.random() * 512 * 9;
				npc.transform.x = camera.transform.x + (Math.random () * Breeze.stage.stageWidth) - (Breeze.stage.stageWidth * 0.5);
				npc.transform.y = camera.transform.y + (Math.random() * Breeze.stage.stageHeight) - (Breeze.stage.stageHeight * 0.5);
			}
			else
			{
				npc.transform.x = x;
				npc.transform.y = y;
			}
			
			if(Breeze.DEBUG) { Debug.print(this, "NPC Loaded: "+type+" ("+_npcs.length+" total)"); }
			
			return npc;
		}
		
		private var _npcsLoaded:uint = 0;
		private function onNPCLoaded():void
		{
			
		}
		
		
		private function onAllNPCsLoaded():void
		{
		}
		
		/**
		 * Registers an actor.
		 * @param	name	Unique name of actor.
		 * @param	actor	Actor reference.
		 */
		public function registerActor(actor:Actor, name:String=null):void
		{
			// Push
			_actors.push(actor);
			
			// Debug
			if(Breeze.DEBUG) { Debug.print(this, "Added actor: "+actor.type+"->"+name); }
		}
		
		
		
		/****************************************************************************************************
		 *  Build
		 */
		
		/**
		 * @see com.octadecimal.breeze.modules.Module#build()
		 */
		override public function build():void 
		{
			// Move camera
			//_camera.transform.x = 6470;
			_camera.transform.y = 1500;
			
			// Center player
			_player.transform.x = 6470;
			_player.transform.y = 735 ;
			
			// NPCs
			for each(var npc:NPC in _npcs)
			{
				// Hack to anchor the spawn anchor
				var spawnPose:Sprite4D = npc.poses.find("spawn") as Sprite4D;
				spawnPose.display.anchorY = 500;
			}
			
			// Attach camera to ground
			_ground.attachCamera(_camera);
			
			// Register with engine
			Breeze.engine.registerUpdateable(this);
			Breeze.engine.registerDrawable(this);
			
			super.build();
		}
		
		
		
		/****************************************************************************************************
		 *  Engine
		 */
		
		/**
		 * @see com.octadecimal.breeze.engine.IUpdateable
		 */
		public function update(change:uint):void 
		{
			if(_camera != null) _camera.update(change);
			if (_ground != null) _ground.update(change);
			
			// Depth sort actors
			depthSortActors();
			
			// Update actors
			Debug.profile.begin("update_Actors");
			for each(var actor:Actor in _actors)
				actor.update(change);
			Debug.profile.end("update_Actors");
				
			// Temporary random spawn
			//if (Math.random() < 0.0075) spawnNPC("snake");
		}
		
		/**
		 * @see com.octadecimal.breeze.engine.IDrawable
		 */
		public function draw(change:uint):void 
		{
			if (_ground != null) _ground.draw(change);
			
			// Draw actors
			Debug.profile.begin("draw_Actors");
			for each(var actor:Actor in _actors)
				actor.draw(change);
			Debug.profile.end("draw_Actors");
		}
		
		
		private function depthSortActors():void
		{
			_actors.sort(depthSort);
		}
		
		private function depthSort(a:Actor, b:Actor):int
		{
			if (a.transform.y < b.transform.y) return -1;
			else if (a.transform.y == b.transform.y) return 0;
			else return 1;
		}
	}
}