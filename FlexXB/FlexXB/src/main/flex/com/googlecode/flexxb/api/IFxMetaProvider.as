package com.googlecode.flexxb.api
{
	import flash.utils.Dictionary;

	/**
	 * 
	 * @author User
	 * 
	 */	
	public interface IFxMetaProvider
	{
		/**
		 * 
		 * @return 
		 * 
		 */		
		function getMetadataName() : String;
		/**
		 * 
		 * @return 
		 * 
		 */		
		function getMappingValues() : Dictionary;
	}
}