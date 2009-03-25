package com.googlecode.fxmod.model
{
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */
	[Bindable]	
	public class Property extends Member
	{
		private var _type : IType;
		
		public function Property(clasz : Class)
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