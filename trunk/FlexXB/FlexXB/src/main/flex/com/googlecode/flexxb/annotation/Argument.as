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
package com.googlecode.flexxb.annotation {

	/**
	 * Defines a constructor argument. This annotaton is used when a class has a
	 * non default constructor. In order to maintain the business restrictions, FlexXB
	 * will determine the values of the arguments based on the received xml and call
	 * the constructor with those values.
	 * <p/>An argument has a reference; the reference is the name of the class field
	 * whose value it represents. A non default constructor will most often configure
	 * some of the object's fields when called. Since the only available data is the
	 * incoming xml, arguments must specify the field the the constructor will modify
	 * with the received value.
	 * <p/><b>The class field referenced in the argument must have an annotation defined
	 *  for it</b>
	 * @author Alexutz
	 *
	 */
	public class Argument extends BaseAnnotation {
		/**
		 * The annotation's name
		 */
		public static const ANNOTATION_NAME : String = "ConstructorArg";
		/**
		 * Reference attribute name
		 */
		public static const ARGUMENT_REF : String = "reference";
		/**
		 * Optional attribute name
		 */
		public static const ARGUMENT_OPTIONAL : String = "optional";
		/**
		 *
		 */
		private var _referenceField : String;
		/**
		 *
		 */
		private var _optional : Boolean;

		/**
		 * Constructor
		 *
		 */
		public function Argument(descriptor : XML) {
			super(descriptor);
		}

		/**
		 * Get optional flag
		 * @return
		 *
		 */
		public function get optional() : Boolean {
			return _optional;
		}

		/**the reference field name
		 * @return
		 *
		 */
		public function get referenceField() : String {
			return _referenceField;
		}

		/**
		 *
		 * @see com.googlecode.flexxb.annotation.BaseAnnotation#parse()
		 *
		 */
		protected override function parse(descriptor : XML) : void {
			_referenceField = descriptor.arg.(@key == ARGUMENT_REF).@value;
			_optional = descriptor.arg.(@key == ARGUMENT_OPTIONAL).@value == "true";
		}

		/**
		 *
		 * @see com.googlecode.flexxb.annotation.BaseAnnotation#annotationName()
		 *
		 */
		public override function get annotationName() : String {
			return ANNOTATION_NAME;
		}
	}
}