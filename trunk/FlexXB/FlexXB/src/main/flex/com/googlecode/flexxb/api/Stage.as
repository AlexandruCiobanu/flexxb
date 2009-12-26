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
package com.googlecode.flexxb.api {

	/**
	 * This enumeration defines the preocessing directions supported by the
	 * FlexXBEngine: serialize and deserialize
	 * @author Alexutz
	 *
	 */
	public final class Stage {
		/**
		 * Serialization stage
		 */
		public static const SERIALIZE : Stage = new Stage("serialize");
		/**
		 * Deserialization stage
		 */
		public static const DESERIALIZE : Stage = new Stage("deserialize");

		/**
		 * Obtain a Stage instance from a string value.
		 * @param value string representation
		 * @return Stage instance if the value is valid, <code>null</code> otherwise
		 *
		 */
		public static function fromString(value : String) : Stage {
			if (value == DESERIALIZE.name) {
				return DESERIALIZE;
			}
			if (value == SERIALIZE.name) {
				return SERIALIZE;
			}
			return null;
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
		public function Stage(name : String) {
			if (initialized) {
				throw new Error("Use static fields instead.");
			}
			this.name = name;
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