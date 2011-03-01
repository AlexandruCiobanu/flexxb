/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 * 	 FlexXB_JSON -  FlexXB extension for JSON serialization support
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
package com.googlecode.flexxb.json.annotation
{
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
	/**
	 * 
	 * @author aciobanu
	 * 
	 */	
	public class JSONField extends JSONMember
	{
		public static const NAME : String = "JSONField";
		
		public function JSONField(descriptor:MetaDescriptor){
			super(descriptor);
		}
		
		public override function get annotationName() : String {
			return NAME;
		}
	}
}