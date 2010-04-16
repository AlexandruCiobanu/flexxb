package com.googlecode.flexxb.util.log
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public final class LogFactory
	{
		/**
		 * 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getLog(type : Class) : ILogger{
			if(!type){
				throw new Error("You must provide a type");
			}
			return new Logger(type);
		}
		
		public function LogFactory(){
			throw new Error("Use static accessors instead");
		}
	}
}