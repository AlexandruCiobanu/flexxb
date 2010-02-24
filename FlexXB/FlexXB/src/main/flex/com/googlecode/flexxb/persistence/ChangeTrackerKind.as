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
package com.googlecode.flexxb.persistence {

	/**
	 *
	 * @author Alexutz
	 *
	 */
	internal class ChangeTrackerKind {
		/**
		 *
		 * @default
		 */
		public static const UPDATE : String = "update";
		/**
		 *
		 * @default
		 */
		public static const ADD : String = "add";
		/**
		 *
		 * @default
		 */
		public static const REMOVE : String = "remove";
		/**
		 *
		 * @default
		 */
		public static const DELETE : String = "delete";
		/**
		 *
		 * @default
		 */
		public static const MOVE : String = "move";
		/**
		 *
		 * @default
		 */
		public static const REPLACE : String = "replace";

		/**
		 *
		 * @param action
		 * @return
		 */
		public static function isActionTracked(action : String) : Boolean {
			return action == UPDATE || action == DELETE;
		}

		/**
		 *
		 * @param action
		 * @return
		 */
		public static function isCollectionActionTracked(action : String) : Boolean {
			return action == ADD || action == REMOVE || action == MOVE || action == REPLACE;
		}

		/**
		 * Constructor
		 * @private
		 */
		public function ChangeTrackerKind() {
			throw new Error("Don't instanciate this class.");
		}
	}
}