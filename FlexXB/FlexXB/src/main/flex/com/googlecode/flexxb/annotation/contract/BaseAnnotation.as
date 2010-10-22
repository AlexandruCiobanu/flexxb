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
package com.googlecode.flexxb.annotation.contract {

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public class BaseAnnotation implements IAnnotation {
		
		protected var _version : String;
		/**
		 * @private
		 */
		public function BaseAnnotation() { }
		
		public function get annotationName() : String {
			return "";
		}
		
		public function get version() : String{
			return _version;
		}
		
		protected function setVersion(value : String) : void{
			_version = value ? value : Constants.DEFAULT;
		}

		/**
		 * @private
		 * Analyze field/class descriptor to extract base informations like field's name and type
		 * @param field field descriptor
		 *
		 */
		protected function parse(descriptor : XML) : void {
		}
	}
}