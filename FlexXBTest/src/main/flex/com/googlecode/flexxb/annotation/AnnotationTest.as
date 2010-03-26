/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008 - 2010 Alex Ciobanu
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
package com.googlecode.flexxb.annotation {
	import com.googlecode.flexxb.annotation.Annotation;
	import com.googlecode.testData.Mock;

	import flash.utils.describeType;

	import flexunit.framework.TestCase;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public class AnnotationTest extends TestCase {

		public function AnnotationTest(methodName : String = null) {
			super(methodName);
		}

		protected function getTestObject() : Object {
			return new Mock();
		}

		/**
		 * Method that handles annotation validation. It tests the annotation against a
		 * value list received as a list of parameters. The list is as follows:
		 *  <ul>
		 * 		<li>- Field Name</li>
		 *  	<li>- Field Type</li>
		 *  	<li>- Name (as given in the objects' annotation)</li>
		 *  	<li>- Custom parameters handles in overrides of the customValidate method</li>
		 * </ul>
		 * @param annotation annotation to be validated
		 * @param args values List
		 *
		 */
		protected final function validate(annotation : Annotation, ... args) : void {
			assertNotNull("Null annotation", annotation);
			assertNotNull("Validation arguments are missing", args);
			assertEquals("Field Name is incorrect", args[0], annotation.fieldName.localName);
			assertEquals("Field Type is incorrect", args[1], annotation.fieldType);
			assertEquals("Alias is incorrect", args[2], annotation.alias);
			customValidate.apply(this, [annotation].concat(args));
		}

		/**
		 *
		 * @param annotation
		 * @param args
		 *
		 */
		protected function customValidate(annotation : Annotation, ... args) : void {
		}

		/**
		 *
		 * @param descriptor
		 *
		 */
		protected function runTest(descriptor : XML) : void {
		}

		/**
		 *
		 * @param fieldName
		 * @param descriptor
		 * @return
		 *
		 */
		protected final function getFieldDescriptor(fieldName : String, descriptor : XML) : XML {
			var result : XML = descriptor.variable.(@name == fieldName)[0];
			if (result == null) {
				result = descriptor.accessor.(@name == fieldName)[0];
			}
			return result;
		}

		/**
		 *
		 *
		 */
		public function testAnnotation() : void {
			var descriptor : XML = describeType(getTestObject());
			runTest(descriptor);
		}
	}
}