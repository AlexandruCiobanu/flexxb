package com.googlecode.fxmod.model
{
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	public class Constructor extends Method
	{
		
		public function Constructor(clasz : Class)
		{
			super(clasz);
			_returnType = clasz;
		}
		
		public override function set returnType(value : IType) : void{}
	}
}