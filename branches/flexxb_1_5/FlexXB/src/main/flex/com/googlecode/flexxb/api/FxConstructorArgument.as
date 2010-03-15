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
	import com.googlecode.flexxb.error.ApiError;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	[XmlClass(alias="Argument")]
	[ConstructorArg(reference="reference")]
	public class FxConstructorArgument {
		protected var _reference : String;

		protected var _optional : Boolean;

		public function FxConstructorArgument(reference : String, optional : Boolean = false) {
			this.reference = reference;
			this.optional = optional;
		}

		/**
		 *
		 * @return
		 *
		 */
		[XmlAttribute]
		public function get reference() : String {
			return _reference;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set reference(value : String) : void {
			if (!value) {
				throw new ApiError("Reference cannot be null for this constructor argument.");
			}
			_reference = value;
		}

		/**
		 *
		 * @return
		 *
		 */
		[XmlAttribute]
		public function get optional() : Boolean {
			return _optional;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set optional(value : Boolean) : void {
			_optional = value;
		}

		public function toXml() : XML {
			return <metadata name="ConstructorArg">
					<arg key="reference" value={reference} />
					<arg key="optional" value={optional} />
				</metadata>
		}

		public function toString() : String {
			return "Argument[reference: " + reference + ", optional:" + optional + "]";
		}
	}
}