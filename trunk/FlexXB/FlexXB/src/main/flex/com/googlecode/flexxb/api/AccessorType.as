package com.googlecode.flexxb.api
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
		public static const READ_ONLY : AccessorType = new AccessorType("readonly");
		/**
		 * write only
		 */		
		public static const WRITE_ONLY : AccessorType = new AccessorType("writeonly");
		/**
		 * read write
		 */		
		public static const READ_WRITE : AccessorType = new AccessorType("readwrite");
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function fromString(value : String) : AccessorType{
			switch(value){
				case "readonly": 
					return READ_ONLY;
				case "writeonly":
					return WRITE_ONLY;
				case "readwrite":
					return READ_WRITE;
			}
			return READ_WRITE;
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
		public function AccessorType(name : String){
			if(initialized){
				throw new Error("Use static fields instead.");
			}
			this.name = name;
		}
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public function isReadOnly() : Boolean{
			return READ_ONLY == this;
		}
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public function isWriteOnly() : Boolean{
			return WRITE_ONLY == this;
		}
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public function isReadWrite() : Boolean{
			return READ_WRITE == this;
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