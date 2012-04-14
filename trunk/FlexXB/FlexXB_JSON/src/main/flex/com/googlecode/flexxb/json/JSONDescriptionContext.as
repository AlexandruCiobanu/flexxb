/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 * 	 FlexXB_JSON -  FlexXB extension for JSON serialization support
 *   Copyright (C) 2008-2012 Alex Ciobanu
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
package com.googlecode.flexxb.json
{
	import com.googlecode.flexxb.converter.ClassTypeConverter;
	import com.googlecode.flexxb.converter.XmlConverter;
	import com.googlecode.flexxb.core.DescriptionContext;
	import com.googlecode.flexxb.json.annotation.JSONArray;
	import com.googlecode.flexxb.json.annotation.JSONClass;
	import com.googlecode.flexxb.json.annotation.JSONField;
	import com.googlecode.flexxb.json.annotation.JSONObject;
	import com.googlecode.flexxb.json.serializer.JSONArraySerializer;
	import com.googlecode.flexxb.json.serializer.JSONClassSerializer;
	import com.googlecode.flexxb.json.serializer.JSONFieldSerializer;
	import com.googlecode.flexxb.json.serializer.JSONObjectSerializer;

	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public final class JSONDescriptionContext extends DescriptionContext
	{
		
		public function JSONDescriptionContext(){
			super();
			_configuration = new JSONConfiguration();
		}
		
		protected override function performInitialization() : void{
			registerSimpleTypeConverter(new ClassTypeConverter());
			registerSimpleTypeConverter(new XmlConverter());
			registerAnnotation(JSONClass.NAME, JSONClass, JSONClassSerializer);
			registerAnnotation(JSONField.NAME, JSONField, JSONFieldSerializer);
			registerAnnotation(JSONObject.NAME, JSONObject, JSONObjectSerializer);
			registerAnnotation(JSONArray.NAME, JSONArray, JSONArraySerializer);
		}
		
		public override function handleDescriptors(descriptors : Array) : void {
			
		}
	}
}