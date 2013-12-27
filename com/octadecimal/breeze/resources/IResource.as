/**
 * Interface: IResource
 * ================================================================================================================================================
 * Breeze Engine - http://breeze.octadecimal.com
 * Copyright ©2009 Dylan Heyes. All rights reserved.
 */

package com.octadecimal.breeze.resources
{
	
	/**
	 * Implementation for an individual resource that is loaded and managed by the Content manager.
	 */
	public interface IResource extends ILoadable
	{
		/**
		 * Reference to ResourceParams object.
		 */
		function get params():ResourceParams;
	}
	
}