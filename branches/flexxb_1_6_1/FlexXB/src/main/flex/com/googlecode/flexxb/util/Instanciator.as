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