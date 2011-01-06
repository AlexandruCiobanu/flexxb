/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2011 Alex Ciobanu
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
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;

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
		public function BaseAnnotation(descriptor : MetaDescriptor) {
			if(descriptor){
				parse(descriptor);
			}
		}
		
		public function get annotationName() : String {
			return "";
		}
		
		public final function get version() : String{
			return _version;
		}
		
		protected final function setVersion(value : String) : void{
			_version = value ? value : Constants.DEFAULT;
		}

		/**
		 * @private
		 * Analyze field/class descriptor to extract base informations like field's name and type
		 * @param descriptor
		 *
		 */
		protected function parse(descriptor : MetaDescriptor) : void {
			setVersion(descriptor.version);
		}
	}
}