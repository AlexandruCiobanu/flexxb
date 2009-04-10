package com.googlecode.flexxb.api
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class Stage
	{
		/**
		 * 
		 */		
		public static const SERIALIZE : Stage = new Stage("serialize");
		/**
		 * 
		 */		
		public static const DESERIALIZE : Stage = new Stage("deserialize");
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function fromString(value : String) : Stage{
			if(value == DESERIALIZE.name){
				return DESERIALIZE;
			}
			if(value == SERIALIZE.name){
				return SERIALIZE;
			}
			throw new Error("Unknown Stage element:" + value);
		}
		
		private static var initialized : Boolean = false;
		
		{
			initialized = true;
		}
		
		private var name : String;
		/**
		 * 
		 * @param name
		 * 
		 */		
		public function Stage(name : String)
		{
			if(initialized){
				throw new Error("Use static fields instead.");
			}
			this.name = name;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function toString() : String{
			return name;
		}
	}
}