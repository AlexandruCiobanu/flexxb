package com.googlecode.fxmod.model
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	public class Method extends Member
	{
		protected var _parameters : ArrayCollection;
		
		protected var _returnType : IType;
		
		public function Method(clasz : Class)
		{
			super(clasz);
		}
		
		public function get returnType() : IType{
			return _returnType;
		}
		
		public function set returnType(value : IType) : void{
			_returnType = value;
		}
		
		public function addParameter(parameter : Parameter) : void{
			
		}		
	}
}