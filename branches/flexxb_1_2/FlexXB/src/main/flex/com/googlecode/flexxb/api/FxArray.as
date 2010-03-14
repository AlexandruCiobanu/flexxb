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
	import com.googlecode.flexxb.annotation.XmlArray;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	[XmlClass(alias="Array")]
	[ConstructorArg(reference="field")]
	[ConstructorArg(reference="alias")]
	public class FxArray extends FxElement
	{
		public static const INCOMING_XML_NAME : String = "Array";
		/**
		 * 
		 * @param name
		 * @param type
		 * @param accessType
		 * @param alias
		 * @return 
		 * 
		 */		
		public static function create(name : String, type : Class, accessType : AccessorType = null, alias : String = null) : FxArray{
			var field : FxField = new FxField(name, type, accessType);
			var array : FxArray = new FxArray(field, alias);
			return array;
		}
		/**
		 * 
		 */
		[XmlAttribute]		
		public var memberName : String;
		/**
		 * 
		 */
		[XmlAttribute]		
		public var memberType : Class;
		/**
		 * 
		 * @param field
		 * @param alias
		 * 
		 */		
		public function FxArray(field : FxField, alias : String = null)
		{
			super(field, alias);
		}		
		
		protected override function getXmlAnnotationName() : String{
			return XmlArray.ANNOTATION_NAME;
		}
		
		protected override function getContent() : Dictionary{
			var items : Dictionary = super.getContent();
			items[XmlArray.ARGUMENT_MEMBER_NAME] = memberName;
			items[XmlArray.ARGUMENT_TYPE] = memberType;
			return items;
		}
		
		public override function toString() : String{
			return "Array[field: " + fieldName + ", type:" + fieldType + "]";
		}
	}
}