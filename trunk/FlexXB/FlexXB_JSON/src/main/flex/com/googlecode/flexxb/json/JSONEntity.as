package com.googlecode.flexxb.json
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	/**
	 * 
	 * @author User
	 * 
	 */	
	public class JSONEntity
	{
		private var config : JSONConfiguration;
		
		private var _target : Object;
		/**
		 * 
		 * 
		 */		
		public function JSONEntity(conf : JSONConfiguration){
			config = conf;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get target() : Object{
			return _target;
		}
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set target(value : Object) : void{
			_target = value;
		}
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public function fromString(value : String) : Object{
			_target = new JSONDecoder(value, strict);
			return _target;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function toString() : String{
			return new JSONEncoder(target).getString();
		}
		
		private function get strict() : Boolean{
			return config ? config.strict : false;
		}
	}
}