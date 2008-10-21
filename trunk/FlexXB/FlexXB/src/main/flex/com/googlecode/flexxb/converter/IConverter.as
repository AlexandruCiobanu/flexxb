package com.googlecode.flexxb.converter
{
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	public interface IConverter
	{
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get type() : Class;
		/**
		 * 
		 * @param object
		 * @return 
		 * 
		 */		
		function toString(object : Object) : String;
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		function fromString(value : String) : Object;
	}
}