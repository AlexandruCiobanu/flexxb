package com.googlecode.flexxb
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public interface IConverterStore
	{	
		/**
		 * Convert string value to object
		 * @param value value to be converted to object
		 * @param clasz type of the object to which the value is converted
		 * @return instance of type passed as argument
		 * 
		 */			
		function stringToObject(value : String, clasz : Class) : Object;
		/**
		 * Convert object value to string
		 * @param object instance to be converted to string
		 * @return string value
		 * 
		 */		
		function objectToString(object : Object, clasz : Class) : String;	}
}