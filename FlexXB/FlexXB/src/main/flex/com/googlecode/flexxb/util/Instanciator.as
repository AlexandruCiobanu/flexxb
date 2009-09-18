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
package com.googlecode.flexxb.util {
	import flash.utils.getDefinitionByName;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public final class Instanciator {
		/**
		 *
		 * @param className
		 * @return
		 *
		 */
		public static function getInstanceByName(className : String) : Object {
			var clasz : Class = getDefinitionByName(className) as Class;
			if (clasz) {
				return getInstance(clasz);
			}
			return null;
		}

		/**
		 * Dynamically create an instance with runtime known parameters.
		 * Restricted to max 10(ten) instance parameters.
		 * TODO: Find a better way to do this!!!!!
		 * @param clasz
		 * @param args
		 * @return
		 *
		 */
		public static function getInstance(clasz : Class, args : Array = null) : Object {
			if (!args || args.length == 0) {
				return new clasz();
			}
			if (args.length == 1) {
				return new clasz(args[0]);
			}
			if (args.length == 2) {
				return new clasz(args[0], args[1]);
			}
			if (args.length == 3) {
				return new clasz(args[0], args[1], args[2]);
			}
			if (args.length == 4) {
				return new clasz(args[0], args[1], args[2], args[3]);
			}
			if (args.length == 5) {
				return new clasz(args[0], args[1], args[2], args[3], args[4]);
			}
			if (args.length == 6) {
				return new clasz(args[0], args[1], args[2], args[3], args[4], args[5]);
			}
			if (args.length == 7) {
				return new clasz(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
			}
			if (args.length == 8) {
				return new clasz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
			}
			if (args.length == 9) {
				return new clasz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
			}
			if (args.length == 10) {
				return new clasz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
			}
			return null;
		}

		public function Instanciator() {
			throw new Error("Access static memebers!");
		}

	}
}