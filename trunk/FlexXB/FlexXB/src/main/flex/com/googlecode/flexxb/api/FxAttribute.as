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

	[XmlClass(alias="Attribute")]
	[ConstructorArg(reference="field")]
	[ConstructorArg(reference="alias")]
	/**
	 *
	 * @author Alexutz
	 *
	 */
	public class FxAttribute extends FxMember {
		public static const INCOMING_XML_NAME : String = "Attribute";

		/**
		 *
		 * @param name
		 * @param type
		 * @param accessType
		 * @param alias
		 * @return
		 *
		 */
		public static function create(name : String, type : Class, accessType : AccessorType = null, alias : String = null) : FxAttribute {
			var field : FxField = new FxField(name, type, accessType);
			var attribute : FxAttribute = new FxAttribute(field, alias);
			return attribute;
		}

		/**
		 *
		 * @param field
		 * @param alias
		 *
		 */
		public function FxAttribute(field : FxField, alias : String = null) {
			super(field, alias);
		}

		protected override function getXmlAnnotationName() : String {
			return "XmlAttribute";
		}
		
		/**
		 * Get string representation of the current instance
		 * @return string representing the current instance
		 */
		public function toString() : String {
			return "Attribute[field: " + fieldName + ", type:" + fieldType + "]";
		}
	}
}