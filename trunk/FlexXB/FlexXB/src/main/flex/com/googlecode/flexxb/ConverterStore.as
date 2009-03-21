package com.googlecode.flexxb
{
	import com.googlecode.flexxb.converter.IConverter;
	
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	internal class ConverterStore implements IConverterStore
	{
		private var converterMap : Dictionary;
		/**
		 * 
		 * 
		 */		
		public function ConverterStore()
		{
			
		}		
		/**
		 * 
		 * @param converter
		 * @return 
		 * 
		 */		
		public function registerSimpleTypeConverter(converter : IConverter, overrideExisting : Boolean = false) : Boolean{
			if(converter == null || converter.type == null){
				return false;
			}
			if(!overrideExisting && converterMap && converterMap[converter.type]){
				return false;
			}			
			if(converterMap == null){
				converterMap = new Dictionary();
			}
			converterMap[converter.type] = converter;
			return true;
		}
		/**
		 * 
		 * @param type
		 * @return 
		 * 
		 */		
		public function hasConverter(type : Class) : Boolean{
			return converterMap && type && converterMap[type] is IConverter;
		}
		/**
		 * 
		 * @param clasz
		 * @return 
		 * 
		 */		
		public function getConverter(clasz : Class) : IConverter{
			return converterMap[clasz] as IConverter;
		}
		/**
		 * 
		 * @see IConverterStore#stringToObject()
		 * 
		 */		
		public final function stringToObject(value : String, clasz : Class) : Object{
			if(hasConverter(clasz)){
				return getConverter(clasz).fromString(value);
			}
			if(!value) return null;
			if(clasz==Boolean){
				return (value && value.toLowerCase() == "true");
			}
			if(clasz == Date){
				if(value == ""){
					return null;
				}
				var date : Date = new Date();
				date.setTime(Date.parse(value));
				return date;
			}
			return clasz(value);
		}
		/**
		 * 
		 * @see IConverterStore#objectToString()
		 */	
		public final function objectToString(object : Object, clasz : Class) : String{
			if(hasConverter(clasz)){
				return getConverter(clasz).toString(object);
			}
			if(object is String){
				return object as String;
			}
			try{
				return object.toString();
			}catch(e:Error){}
			return "";
		}

	}
}