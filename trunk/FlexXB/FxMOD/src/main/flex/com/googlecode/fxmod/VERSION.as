package com.googlecode.fxmod
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public final class VERSION
	{
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function get Version() : String{
			return "0.1";
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function get Name() : String{
			return "FxMOD";
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function get Link() : String{
			return "http://code.google.com/p/flexxb";
		}
		/**
		 * 
		 * 
		 */		
		public function VERSION()
		{
			throw new Error("Do not instanciate this class");
		}
	}
}