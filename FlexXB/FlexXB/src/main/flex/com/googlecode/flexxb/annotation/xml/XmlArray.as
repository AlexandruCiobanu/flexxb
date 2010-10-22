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
package com.googlecode.flexxb.annotation.xml {
	import flash.utils.getDefinitionByName;

	/**
	 * <p>Usage: <code>[XmlArray(alias="element", memberName="NameOfArrayElement", getFromCache="true|false", 
	 * type="my.full.type" ignoreOn="serialize|deserialize", serializePartialElement="true|false", 
	 * order="order_index", namespace="Namespace_Prefix")]</code></p>
	 * @author aCiobanu
	 *
	 */
	public final class XmlArray extends XmlElement {
		/**
		 *
		 */
		public static const ANNOTATION_NAME : String = "XmlArray";
		/**
		 * @private
		 */
		private var _memberType : Class;
		/**
		 * @private
		 */
		private var _memberName : QName;

		/**
		 * Constructor
		 * @param descriptor
		 * @param xmlClass
		 *
		 */
		public function XmlArray() {
			super();
		}

		/**
		 * Get the type of the list elements if it has been set
		 * @return
		 *
		 */
		public function get memberType() : Class {
			return _memberType;
		}

		/**
		 * Get the qualified name of list elements if it has been set
		 * @return
		 *
		 */
		public function get memberName() : QName {
			return _memberName;
		}

		/**
		 *
		 * @see Annotation#parseMetadata()
		 *
		 */
		protected override function parseMetadata(metadata : XML) : void {
			super.parseMetadata(metadata);
			var classType : String = metadata.arg.(@key == ARGUMENT_TYPE).@value;
			if (classType) {
				try {
					_type = getDefinitionByName(classType) as Class;
				} catch (e : Error) {
					trace(e);
				}
			}
			var arrayMemberName : String = metadata.arg.(@key == ARGUMENT_MEMBER_NAME).@value;
			if (arrayMemberName) {
				_memberName = new QName(nameSpace, arrayMemberName);
			}
		}

		/**
		 *
		 * @see Annotation#annotationName
		 *
		 */
		public override function get annotationName() : String {
			return ANNOTATION_NAME;
		}
	}
}