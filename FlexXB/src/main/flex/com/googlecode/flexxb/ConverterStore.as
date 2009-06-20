/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
 *   Copyright (C) 2008-2009 Alex Ciobanu
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 * 
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */ 
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