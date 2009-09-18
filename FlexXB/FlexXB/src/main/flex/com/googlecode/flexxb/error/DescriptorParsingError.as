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
package com.googlecode.flexxb.error {
	import mx.utils.StringUtil;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public class DescriptorParsingError extends Error {
		/**
		 *
		 */
		public static const DESCRIPTOR_PARSING_ERROR_ID : int = 0;

		private var _type : Class;

		private var _fieldName : String;

		/**
		 *
		 * @param type
		 * @param field
		 * @param message
		 *
		 */
		public function DescriptorParsingError(type : Class, field : String, message : String = "") {
			super(message, DESCRIPTOR_PARSING_ERROR_ID);
			_type = type;
			_fieldName = field;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get type() : Class {
			return _type;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get field() : String {
			return _fieldName;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function toString() : String {
			var error : String = "Error encountered while processing the descriptor ";
			if (type) {
				error += "for type " + type;
			}
			if (field) {
				error += " (field " + field + ")";
			}
			if (message) {
				error += ":\n" + message;
			}
			return error;
		}
	}
}