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
package com.googlecode.flexxb.converter {

	/**
	 * Interface defining how strings can be converted to
	 * specific objects and viceversa.
	 * @author aCiobanu
	 *
	 */
	public interface IConverter {
		/**
		 *
		 * @return Object type
		 *
		 */
		function get type() : Class;
		/**
		 * Get the string representation of the specified object
		 * @param object Target object
		 * @return String representation of the specified object
		 *
		 */
		function toString(object : Object) : String;
		/**
		 * Get the object whose representation is the specified value
		 * @param value String parameter from which the object is created
		 * @return Object whose representation is the specified value
		 *
		 */
		function fromString(value : String) : Object;
	}
}