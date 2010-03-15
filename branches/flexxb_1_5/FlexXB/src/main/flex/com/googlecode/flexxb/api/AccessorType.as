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
package com.googlecode.flexxb.api {

	/**
	 * Enumeration defining field acces types. A class field can be accessed
	 * in readonly, writeonly or readwrite modes.
	 * @author Alexutz
	 *
	 */
	public class AccessorType {
		/**
		 * read only
		 */
		public static const READ_ONLY : AccessorType = new AccessorType("readonly");
		/**
		 * write only
		 */
		public static const WRITE_ONLY : AccessorType = new AccessorType("writeonly");
		/**
		 * read write
		 */
		public static const READ_WRITE : AccessorType = new AccessorType("readwrite");

		/**
		 * Obtain an AccessorType instance from a string value. If the value is
		 * invalid the READ_WRITE instance will be returned by default.
		 * @param value
		 * @return
		 *
		 */
		public static function fromString(value : String) : AccessorType {
			switch (value) {
				case "readonly":
					return READ_ONLY;
				case "writeonly":
					return WRITE_ONLY;
				case "readwrite":
					return READ_WRITE;
			}
			return READ_WRITE;
		}

		private static var initialized : Boolean = false;

		{
			initialized = true;
		}

		private var name : String;

		/**
		 * @private
		 *
		 */
		public function AccessorType(name : String) {
			if (initialized) {
				throw new Error("Use static fields instead.");
			}
			this.name = name;
		}

		/**
		 * Check if the type is read only
		 * @return true id type is read only, false otherwise
		 *
		 */
		public function isReadOnly() : Boolean {
			return READ_ONLY == this;
		}

		/**
		 * Check if the type is write only
		 * @return true id type is write only, false otherwise
		 *
		 */
		public function isWriteOnly() : Boolean {
			return WRITE_ONLY == this;
		}

		/**
		 * Check if the type is read-write
		 * @return true id type is read-write, false otherwise
		 *
		 */
		public function isReadWrite() : Boolean {
			return READ_WRITE == this;
		}

		/**
		 * Get a string representation of the current instance
		 * @return
		 *
		 */
		public function toString() : String {
			return name;
		}
	}
}