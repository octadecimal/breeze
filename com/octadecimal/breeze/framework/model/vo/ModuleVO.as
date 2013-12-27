package com.octadecimal.breeze.framework.model.vo 
{
	import com.octadecimal.breeze.framework.interfaces.IModule;
	/**
	 * ...
	 */
	public class ModuleVO
	{
		public var key:String;
		public var instance:IModule;
		
		public function ModuleVO(key:String, instance:IModule) 
		{
			this.key = key;
			this.instance = instance;
		}
		
	}

}