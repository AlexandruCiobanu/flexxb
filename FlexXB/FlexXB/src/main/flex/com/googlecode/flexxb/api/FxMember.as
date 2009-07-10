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
package com.googlecode.flexxb.api
{
	import com.googlecode.flexxb.annotation.Annotation;
	import com.googlecode.flexxb.annotation.XmlMember;
	import com.googlecode.flexxb.error.ApiError;
	
	import flash.utils.Dictionary;
	
	import com.googlecode.flexxb.api.flexxb_api_internal;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	internal class FxMember
	{
		/**
		 * 
		 */		
		protected var _field : FxField;
		/**
		 * 
		 */	
		[XmlAttribute]	
		public var alias : String;
		/**
		 * 
		 */
		[XmlAttribute]		
		public var ignoreOn : Stage = null;
		/**
		 * 
		 */	
		[XmlAttribute]	
		public var order : Number;
		/**
		 * 
		 * @param field
		 * @param alias
		 * 
		 */			
		public function FxMember(field : FxField, alias : String = null)
		{
			this.field = field;
			this.alias = alias;
		}
		/**
		 * 
		 * @return 
		 * 
		 */
		[XmlElement(alias="*")]		
		public function get field() : FxField{
			return _field;
		}
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set field(value : FxField) : void{
			if(!value){
				throw new ApiError("Field cannot be null");
			}
			_field = value;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fieldName() : String{
			return field.name;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fieldType() : Class{
			return field.type;
		}
		
		public function get fieldAccessType() : AccessorType{
			return field.accessType;
		}
		/**
		 * 
		 * @see com.googlecode.flexxb.IXmlSerializable#toXml()
		 * 
		 */
		public function toXml():XML
		{
			var xml : XML = field.toXml();
			var metadata : XML = <metadata />;
			xml.appendChild(metadata);
			
			metadata.@name = getXmlAnnotationName();
			
			var items : Dictionary = getContent();
			
			for(var key : * in items){
				if(items[key]!= null){
					metadata.appendChild(<arg key={key} value={items[key]} />)
				}
			}
			return xml;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		protected function getXmlAnnotationName() : String{
			return null;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		protected function getContent() : Dictionary{
			var items : Dictionary = new Dictionary();
			items[Annotation.ARGUMENT_ALIAS] = alias;
			items[XmlMember.ARGUMENT_IGNORE_ON] = ignoreOn;
			if(!isNaN(order))
				items[XmlMember.ARGUMENT_ORDER] = order;
			return items;
		}
	}
}