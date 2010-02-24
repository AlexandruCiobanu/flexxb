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
package com.googlecode.flexxb {

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public interface IDescriptorStore {
		/**
		 * Get the namespace defined for an object type
		 * @param object target instance
		 * @return
		 *
		 */
		function getNamespace(object : Object) : Namespace;
		/**
		 * Get the qualified name that defines the object type as specified in the XmlClass annotation assigned to it
		 * @param object
		 * @return
		 *
		 */
		function getXmlName(object : Object) : QName;
		/**
		 *
		 * @param ns
		 * @return
		 *
		 */
		function getClassByNamespace(ns : String) : Class;
	}
}