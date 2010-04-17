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