package com.googlecode.fxmod.model
{
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	public class Visibility
	{
		/**
		 * 
		 */		
		public static const PUBLIC : Visibility = new Visibility("Public", "+");
		/**
		 * 
		 */		
		public static const PROTECTED : Visibility = new Visibility("Protected", "#");
		/**
		 * 
		 */		
		public static const PRIVATE : Visibility = new Visibility("Private", "-");
		/**
		 * 
		 */		
		public static const PACKAGE : Visibility = new Visibility("Package", "~"); 
		
		private static var initialised : Boolean;
		
		{
			initialised = true;
		}
		
		private var _name : String;		
		
		private var _symbol : String;
		/**
		 * 
		 * @param name
		 * @param symbol
		 * 
		 */		
		public function Visibility(name : String, symbol : String)
		{
			if(initialised){
				throw new Error("You should only use Scope.INSTANCE or Scope.CLASSIFIER");
			}
			this._name = name;
			this._symbol = symbol;
		}
	}
}