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
package com.googlecode.flexxb.annotation {
	import flash.utils.getDefinitionByName;

	/**
	 * <p>Usage: <code>[XmlArray(alias="element", memberName="NameOfArrayElement", getFromCache="true|false", type="my.full.type" ignoreOn="serialize|deserialize", serializePartialElement="true|false")]</code></p>
	 * @author aCiobanu
	 *
	 */
	public final class XmlArray extends XmlElement {
		/**
		 *
		 */
		public static const ANNOTATION_NAME : String = "XmlArray";
		/**
		 *
		 */
		public static const ARGUMENT_TYPE : String = "type";
		/**
		 *
		 */
		public static const ARGUMENT_MEMBER_NAME : String = "memberName";
		/**
		 * @private
		 */
		protected var _type : Class;
		/**
		 * @private
		 */
		protected var _memberName : QName;

		/**
		 * Constructor
		 * @param descriptor
		 * @param xmlClass
		 *
		 */
		public function XmlArray(descriptor : XML, xmlClass : XmlClass = null) {
			super(descriptor, xmlClass);
		}

		/**
		 * Get the type of the list elements if it has been set
		 * @return
		 *
		 */
		public function get type() : Class {
			return _type;
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