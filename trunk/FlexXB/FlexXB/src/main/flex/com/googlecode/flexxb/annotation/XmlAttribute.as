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

	/**
	 * <p>Usage: <code>[XmlAttribute(alias="attribute", ignoreOn="serialize|deserialize")]</code></p>
	 * @author aCiobanu
	 *
	 */
	public final class XmlAttribute extends XmlMember {
		/**
		 * Annotation's name
		 */
		public static const ANNOTATION_NAME : String = "XmlAttribute";

		/**
		 * Constructor
		 * @param descriptor xml descriptor from which to parse the data
		 * @param classDescriptor owner XmlClass object
		 *
		 */
		public function XmlAttribute(descriptor : XML, classDescriptor : XmlClass = null) {
			super(descriptor, classDescriptor);
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