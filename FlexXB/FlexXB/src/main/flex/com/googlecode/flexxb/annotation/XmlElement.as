/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
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
package com.googlecode.flexxb.annotation {

	/**
	 * Usage: <code>[XmlElement(alias="element", getFromCache="true|false", ignoreOn="serialize|deserialize", serializePartialElement="true|false", order="order_index", getRuntimeType="true|false", namespace="Namespace_Prefix", default="DEFAULT_VALUE")]</code>
	 * @author aCiobanu
	 *
	 */
	public class XmlElement extends XmlMember {
		/**
		 * Annotation's name
		 */
		public static const ANNOTATION_NAME : String = "XmlElement";
		/**
		 * SerializePartialElement attribute name
		 */
		public static const ARGUMENT_SERIALIZE_PARTIAL_ELEMENT : String = "serializePartialElement";
		/**
		 * GetFromCache attribute name
		 */
		public static const ARGUMENT_GET_FROM_CACHE : String = "getFromCache";

		public static const ARGUMENT_GET_RUNTIME_TYPE : String = "getRuntimeType";
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
		public function XmlElement(descriptor : XML, xmlClass : XmlClass = null) {
			super(descriptor, xmlClass);
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

		/**
		 *
		 * @see Annotation#parseMetadata()
		 *
		 */
		protected override function parseMetadata(metadata : XML) : void {
			super.parseMetadata(metadata);
			_serializePartialElement = metadata.arg.(@key == ARGUMENT_SERIALIZE_PARTIAL_ELEMENT).@value == "true";
			_getFromCache = metadata.arg.(@key == ARGUMENT_GET_FROM_CACHE).@value == "true";
			_getRuntimeType = metadata.arg.(@key == ARGUMENT_GET_RUNTIME_TYPE).@value == "true";
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