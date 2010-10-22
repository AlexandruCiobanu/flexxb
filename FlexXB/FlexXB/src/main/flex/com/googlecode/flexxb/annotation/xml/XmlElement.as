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

	/**
	 * Usage: <code>[XmlElement(alias="element", getFromCache="true|false", 
	 * ignoreOn="serialize|deserialize", serializePartialElement="true|false", 
	 * order="order_index", getRuntimeType="true|false", namespace="Namespace_Prefix", 
	 * default="DEFAULT_VALUE")]</code>
	 * @author aCiobanu
	 *
	 */
	public class XmlElement extends XmlMember {
		/**
		 * Annotation's name
		 */
		public static const ANNOTATION_NAME : String = "XmlElement";
		/**
		 * @private
		 */
		protected var _serializePartialElement : Boolean;
		/**
		 * @private
		 */
		protected var _getFromCache : Boolean;
		/**
		 *@private
		 */
		protected var _getRuntimeType : Boolean;

		/**
		 * Constructor
		 * @param descriptor
		 * @param xmlClass
		 *
		 */
		public function XmlElement() {
			super();
		}

		/**
		 * Get serializePartialElement flag
		 * @return
		 *
		 */
		public function get serializePartialElement() : Boolean {
			return _serializePartialElement;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get getRuntimeType() : Boolean {
			return _getRuntimeType;
		}

		/**
		 * Get getFromCache flag
		 * @return
		 *
		 */
		public function get getFromCache() : Boolean {
			return _getFromCache;
		}
		
		protected override function parseMetadata(metadata : XML) : void {
			super.parseMetadata(metadata);
			_serializePartialElement = metadata.arg.(@key == ARGUMENT_SERIALIZE_PARTIAL_ELEMENT).@value == "true";
			_getFromCache = metadata.arg.(@key == ARGUMENT_GET_FROM_CACHE).@value == "true";
			_getRuntimeType = metadata.arg.(@key == ARGUMENT_GET_RUNTIME_TYPE).@value == "true";
		}
		
		public override function get annotationName() : String {
			return ANNOTATION_NAME;
		}
	}
}