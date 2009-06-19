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
	import com.googlecode.flexxb.annotation.XmlElement;
	
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author Alexutz
	 * 
	 */
	[XmlClass(alias="Element")]
	[ConstructorArg(reference="field")]
	[ConstructorArg(reference="alias")]	
	public class FxElement extends FxMember
	{
		public static const INCOMING_XML_NAME : String = "Element";
		/**
		 * 
		 * @param name
		 * @param type
		 * @param accessType
		 * @param alias
		 * @return 
		 * 
		 */		
		public static function create(name : String, type : Class, accessType : AccessorType = null, alias : String = null) : FxElement{
			var field : FxField = new FxField(name, type, accessType);
			var element : FxElement = new FxElement(field, alias);
			return element;
		}
		/**
		 * 
		 */
		[XmlAttribute]		
		public var getFromCache : Boolean;
		
		[XmlAttribute]
		/**
		 * 
		 */
		public var serializePartialElement : Boolean;
		/**
		 * 
		 * @param field
		 * @param alias
		 * 
		 */		
		public function FxElement(field : FxField, alias : String = null)
		{
			super(field, alias);
		}	
		
		protected override function getXmlAnnotationName() : String{
			return XmlElement.ANNOTATION_NAME;
		}
		
		protected override function getContent() : Dictionary{
			var items : Dictionary = super.getContent();
			items[XmlElement.ARGUMENT_GET_FROM_CACHE] = getFromCache;
			items[XmlElement.ARGUMENT_SERIALIZE_PARTIAL_ELEMENT] = serializePartialElement;
			return items;
		}
		
		public function toString() : String{
			return "Element[field: " + fieldName + ", type:" + fieldType + "]";
		}
	}
}