package com.octadecimal.breeze.modules.world.model
{
	/**
	 * ...
	 * @author Dylan Heyes
	 */
	public class IsometricPosition
	{
		/**
		 * Accurate float of 70.1701412 degrees (for best isometric angle and antialiasing)
		 */
		private static const PROJECTION:Number = Math.cos(-Math.PI/6)*Math.SQRT2;
		
		/**
		 * World X position.
		 */
		public var x:Number;
		
		/**
		 * World Y position.
		 */
		public var y:Number;
		
		/**
		 * World Z position.
		 */
		public var z:Number;
		
		
		/**
		 * Constructor
		 */
		public function IsometricPosition(x:Number=0, y:Number=0, z:Number=0) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		/**
		 * Projects isometric coordinates to screen coordinates.
		 */
		/*public static function toScreen(iso:IsometricPosition, tileSize:Number):ScreenPosition
		{
			//return new ScreenPosition(iso.x - iso.z, iso.y * PROJECTION + (iso.x + iso.z) * 0.5);
			
			//var x:Number = (iso.x * tileSize + iso.z & 1) * (tileSize / 2);
			//var y:Number = iso.z * (tileSize / 4);
			var x:Number = iso.x * tileSize   + (iso.z & 1) * (tileSize * 0.5);
			var y:Number = iso.y * PROJECTION + iso.z       * (tileSize * 0.25);
			
			return new ScreenPosition(x, y);
		}*/
		
		/**
		 * Projects screen coordinates to isometric.
		 */
		/*public static function toIsometric(x:Number, y:Number, tileSize:Number):IsometricPosition
		{
			//return new IsometricPosition(y + x * .5, 0, y - x * .5);
			
			var ix:int = (x / tileSize) - (y & 1) * (tileSize * 2);
			var iz:int = (y / tileSize)*2;
			
			//trace(ix);
			
			//trace(Math.round(ix), Math.round(iz));
			return new IsometricPosition(ix, 0, iz);
		}*/
		
		public function clone():IsometricPosition
		{
			return new IsometricPosition(x, y, z);
		}
	}

}