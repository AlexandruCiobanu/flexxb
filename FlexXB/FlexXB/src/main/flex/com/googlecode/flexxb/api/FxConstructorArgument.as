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
package com.googlecode.flexxb.api {
	import com.googlecode.flexxb.error.ApiError;

	/**
	 * A constructor argument is a way to say to the FlexXB engine that objects of a certain type
	 * need a special way to be instantiated in the deserialization stage. A constructor argument 
	 * is linked to a class field. Usually, when having parameterized arguments, in the constructor
	 * these values are mapped to specific fields within the object.
	 * @author Alexutz
	 *
	 */
	[XmlClass(alias="Argument")]
	[ConstructorArg(reference="reference")]
	public class FxConstructorArgument {
		protected var _reference : String;

		protected var _optional : Boolean;
		/**
		 * Constructor
		 * @param	reference name of the class field this argument references
		 * @param	optional Flag signaling whether this argument is optional or not in the constructor call
		 */
		public function FxConstructorArgument(reference : String, optional : Boolean = false) {
			this.reference = reference;
			this.optional = optional;
		}

		/**
		 * Get class member reference
		 * @return String value
		 *
		 */
		[XmlAttribute]
		public function get reference() : String {
			return _reference;
		}

		/**
		 * Set class member reference
		 * @param value String value
		 *
		 */
		public function set reference(value : String) : void {
			if (!value) {
				throw new ApiError("Reference cannot be null for this constructor argument.");
			}
			_reference = value;
		}

		/**
		 * Get the optional flag
		 * @return Boolean value
		 *
		 */
		[XmlAttribute]
		public function get optional() : Boolean {
			return _optional;
		}

		/**
		 * Set optional flag
		 * @param value Boolean value
		 *
		 */
		public function set optional(value : Boolean) : void {
			_optional = value;
		}
		/**
		 * Get the xml representation of the current instance
		 * @return XML instance
		 */
		public function toXml() : XML {
			return <metadata name="ConstructorArg">
					<arg key="reference" value={reference} />
					<arg key="optional" value={optional} />
				</metadata>
		}
		/**
		 * Get the string representation of the current instance
		 * @return String instance
		 */
		public function toString() : String {
			return "Argument[reference: " + reference + ", optional:" + optional + "]";
		}
	}
}