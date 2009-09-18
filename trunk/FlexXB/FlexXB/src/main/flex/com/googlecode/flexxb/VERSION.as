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
package com.googlecode.flexxb {

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public final class VERSION {
		/**
		 *
		 * @return
		 *
		 */
		public static function get Version() : String {
			return "1.3.0";
		}

		/**
		 *
		 * @return
		 *
		 */
		public static function get Name() : String {
			return "FlexXB";
		}

		/**
		 *
		 * @return
		 *
		 */
		public static function get Link() : String {
			return "http://code.google.com/p/flexxb";
		}

		public function VERSION() {
			throw new Error("Do not instanciate this class");
		}

	}
}