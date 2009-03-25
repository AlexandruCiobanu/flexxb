package com.googlecode.fxmod.model
{
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	public class Scope
	{
		/**
		 * 
		 */		
		public static const INSTANCE : Scope = new Scope("Instance");
		/**
		 * 
		 */		
		public static const CLASSIFIER : Scope = new Scope("Classifier"); 
		
		private static var initialised : Boolean;
		
		{
			initialised = true;
		}
		
		private var name : String;
		
		public function Scope(name : String)
		{
			if(initialised){
				throw new Error("You should only use Scope.INSTANCE or Scope.CLASSIFIER");
			}
			this.name = name;
		}
	}
}