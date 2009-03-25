package com.googlecode.fxmod.model
{
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	[Bindable]
	public class Parameter extends UMLObject
	{
		private var _type : IType; 
		
		private var _defaultValue : Object;
		
		public function Parameter()
		{
			super();
		}
		
		public function get type() : IType{
			return _type;
		}
		
		public function set type(value : IType) : void{
			_type = value;
		}		
	}
}