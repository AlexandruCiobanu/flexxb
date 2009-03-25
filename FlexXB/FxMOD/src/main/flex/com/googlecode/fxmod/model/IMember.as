package com.googlecode.fxmod.model
{
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	public interface IMember extends IUMLObject
	{
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get classReference() : Class;
		/**
		 * 
		 * @param value
		 * 
		 */		
		function set classReference(value : Class) : void;
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get scope() : Scope;
		/**
		 * 
		 * @param value
		 * 
		 */		
		function set scope(value : Scope) : void;
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get visibility() : Visibility;
		/**
		 * 
		 * @param value
		 * 
		 */		
		function set visibility(value : Visibility) : void;
	}
}