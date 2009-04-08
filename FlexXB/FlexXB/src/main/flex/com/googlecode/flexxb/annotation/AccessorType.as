package com.googlecode.flexxb.annotation
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class AccessorType
	{
		/**
		 * read only
		 */		
		public static const READ_ONLY : int = 0;
		/**
		 * write only
		 */		
		public static const WRITE_ONLY : int = 1;
		/**
		 * read write
		 */		
		public static const READ_WRITE : int = 2;
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function isReadOnly(value : int) : Boolean{
			return READ_ONLY == value;
		}
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function isWriteOnly(value : int) : Boolean{
			return WRITE_ONLY == value;
		}
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function isReadWrite(value : int) : Boolean{
			return READ_WRITE == value;
		}
		/**
		 * 
		 * @param field
		 * @return 
		 * 
		 */		
		public static function getAccessorType(field : XML) : int{
			if(field){
				var accessType : String = field.@access;
				switch(accessType){
					case "readonly": 
						return READ_ONLY;
					case "writeonly":
						return WRITE_ONLY;
					case "readwrite":
						return READ_WRITE;
				}
			}
			return READ_WRITE;
		}
		
		public function AccessorType(){
			throw new Error("Do not instanciate this class. Use static accessors instead");
		}
	}
}