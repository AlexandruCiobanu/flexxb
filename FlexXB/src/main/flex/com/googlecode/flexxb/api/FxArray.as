/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */
package com.googlecode.flexxb.api {
	import com.googlecode.flexxb.annotation.XmlArray;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	[XmlClass(alias="Array")]
	[ConstructorArg(reference="field")]
	[ConstructorArg(reference="alias")]
	public class FxArray extends FxElement {
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
		public static function create(name : String, type : Class, accessType : AccessorType = null, alias : String = null) : FxArray {
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
		public function FxArray(field : FxField, alias : String = null) {
			super(field, alias);
		}

		protected override function getXmlAnnotationName() : String {
			return XmlArray.ANNOTATION_NAME;
		}

		protected override function getContent() : Dictionary {
			var items : Dictionary = super.getContent();
			items[XmlArray.ARGUMENT_MEMBER_NAME] = memberName;
			if(memberType is Class){
				items[XmlArray.ARGUMENT_TYPE] =  getQualifiedClassName(memberType);
			}
			return items;
		}
		
		/**
		 * Get string representation of the current instance
		 * @return string representing the current instance
		 */
		public override function toString() : String {
			return "Array[field: " + fieldName + ", type:" + fieldType + "]";
		}
	}
}