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
	public class Configuration {
		/**
		 * Determine the type of the object the response will be deserialised into
		 * by the namespace defined in the received xml.
		 */
		public var getResponseTypeByNamespace : Boolean = true;
		/**
		 * Determine the type of the object the response will be deserialised into
		 * by the root element name of the received xml.
		 */
		public var getResponseTypeByTagName : Boolean = true;
		/**
		 * Serializing persistable objects can be done by including only the fields
		 * whose values have been changed.
		 */
		public var onlySerializeChangedValueFields : Boolean = false;
		/**
		 * Set this flag to true if you want special chars to be escaped in the xml. 
		 * If set to false, text containing special characters will be enveloped in a CDATA tag.
		 * This option applies to xml elements. For xml attributes special chars are automatically 
		 * escaped.
		 */		
		public var escapeSpecialChars : Boolean = false;
		/**
		 * Use this flag to control whether to permit logging or not. This is mostly intended for
		 * debugging the (de)serialization process.<br/>
		 * <b>Logging can slow down the process up to 20 times. Use with caution!</b>
		 */		
		public var enableLogging : Boolean = false;
		/**
		 * Constructor
		 *
		 */
		public function Configuration() {}
	}
}