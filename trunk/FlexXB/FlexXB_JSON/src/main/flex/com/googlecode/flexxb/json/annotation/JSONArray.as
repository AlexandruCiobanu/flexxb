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
	import com.googlecode.flexxb.error.DescriptorParsingError;
	import com.googlecode.flexxb.util.isVector;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * 
	 * @author aciobanu
	 * 
	 */	
	public class JSONArray extends JSONMember
	{
		public static const NAME : String = "JSONArray";
		
		private var _memberType : Class;
		
		private var _memberName : String;
		
		public function JSONArray(descriptor : MetaDescriptor){
			super(descriptor);
		}
		
		public function get memberType() : Class {
			return _memberType;
		}
		
		public function get memberName() : String {
			return _memberName;
		}
		
		protected override function parse(metadata : MetaDescriptor) : void {
			super.parse(metadata);
			_memberType = determineElementType(metadata);
			_memberName = metadata.getString(JSONConstants.MEMBER_NAME);
		}
		
		public override function get annotationName() : String {
			return NAME;
		}
		
		private function determineElementType(metadata : MetaDescriptor) : Class{
			var type : Class;
			//handle the vector type. We need to check for it first as it will override settings in the member type 
			var classType : String = getQualifiedClassName(metadata.fieldType);
			if(isVector(classType)){
				if(classType.lastIndexOf("<") > -1){
					classType = classType.substring(classType.lastIndexOf("<") + 1, classType.length - 1);
				}
			}else{
				classType = metadata.getString(JSONConstants.TYPE);
			}
			if (classType) {
				try {
					type = getDefinitionByName(classType) as Class;
				} catch (e : Error) {
					throw new DescriptorParsingError(classAnnotation.type, memberName, "Member type <<" + classType + ">> can't be found as specified in the metadata. Make sure you spelled it correctly"); 
				}
			}
			return type;
		}
	}
}