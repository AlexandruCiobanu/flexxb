package com.googlecode.fxmod.model
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */
	[Bindable]	
	public class Package extends UMLObject
	{
		protected var _members : ArrayCollection;
		/**
		 * Constructor 
		 * 
		 */		
		public function Package()
		{
			super();
		}
		
		public function addMember(member) : void{
			
		}
		
	}
}