package com.googlecode.flexxb
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public interface IDescriptorStore
	{
		/**
		 * Get the namespace defined for an object type
		 * @param object target instance
		 * @return 
		 * 
		 */		
		function getNamespace(object : Object) : Namespace;
		/**
		 * Get the qualified name that defines the object type as specified in the XmlClass annotation assigned to it
		 * @param object
		 * @return 
		 * 
		 */		
		function getXmlName(object : Object) : QName;
		/**
		 * 
		 * @param ns
		 * @return 
		 * 
		 */		
		function getClassByNamespace(ns : String) : Class;						
	}
}