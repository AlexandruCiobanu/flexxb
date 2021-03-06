/**
 *   FlexXB
 *   Copyright (C) 2008-2012 Alex Ciobanu
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
package com.googlecode.flexxb.annotation.parser
{	
	import com.googlecode.flexxb.annotation.AnnotationFactory;
	import com.googlecode.flexxb.annotation.contract.AccessorType;
	import com.googlecode.flexxb.annotation.contract.Constants;
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	
	/**
	 * @private
	 * @author Alexutz
	 * 
	 */	
	public class MetaDescriptor
	{
		public var metadataName : String;
		
		private var _fieldName : QName;
		
		public var fieldType : Class;
		
		public var fieldAccess : AccessorType;
		
		public var attributes : Object;
		
		private var _owner : IClassAnnotation;
		
		private var _factory : AnnotationFactory;
		/**
		 * 
		 * 
		 */		
		public function MetaDescriptor(factory : AnnotationFactory){
			attributes = new Object();
			_factory = factory;
		}
		
		public final function get factory() : AnnotationFactory{
			return _factory;
		}

		public function get owner() : IClassAnnotation{
			return _owner;
		}

		public function set owner(value : IClassAnnotation) : void{
			_owner = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fieldName():QName
		{
			return _fieldName;
		}
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set fieldName(value:QName):void
		{
			//if(value == null){
			//	throw new Error("QName is null. Fuck!");
			//}
			_fieldName = value;
		}
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get version() : String{
			return attributes[Constants.VERSION] ? attributes[Constants.VERSION] : Constants.DEFAULT;
		}
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getBoolean(name : String) : Boolean{
			return attributes[name] == "true";
		} 
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getInt(name : String) : Number{
			return Number(attributes[name]);
		}
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getString(name : String) : String{
			return attributes[name] as String;
		}
	}
}