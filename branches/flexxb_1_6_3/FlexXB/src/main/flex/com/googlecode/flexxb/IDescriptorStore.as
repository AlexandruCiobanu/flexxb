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