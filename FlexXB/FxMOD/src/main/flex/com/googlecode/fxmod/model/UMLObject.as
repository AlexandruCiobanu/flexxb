package com.googlecode.fxmod.model
{
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	[Bindable]
	public class UMLObject implements IUMLObject
	{
		protected var _name : String;		
		/**
		 * Constructor 
		 * 
		 */		
		public function UMLObject(){}
		/**
		 * 
		 * @see IUMLObject#name()
		 * 
		 */		
		public function get name() : String
		{
			return _name;

		}
		/**
		 * 
		 * @see IUMLObject#name()
		 * 
		 */		
		public function set name(value : String) : void
		{
			_name = value;
		}		
	}
}