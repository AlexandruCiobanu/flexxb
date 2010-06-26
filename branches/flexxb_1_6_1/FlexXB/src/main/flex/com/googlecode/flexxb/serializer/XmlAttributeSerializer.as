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
package com.googlecode.flexxb.serializer {
	import com.googlecode.flexxb.SerializerCore;
	import com.googlecode.flexxb.annotation.XmlMember;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;

	/**
	 * Insures serialization/deserialization for object field decorated with the XmlAttribute annotation
	 * @author Alexutz
	 *
	 */
	public final class XmlAttributeSerializer extends XmlMemberSerializer {
		
		private static var log : ILogger = LogFactory.getLog(XmlAttributeSerializer);
		/**
		 * Constructor
		 *
		 */
		public function XmlAttributeSerializer() {
		}
		
		protected override function serializeObject(object : Object, attribute : XmlMember, parentXml : XML, serializer : SerializerCore) : void {
			if(serializer.configuration.enableLogging){
				log.info("Serializing field {0} as attribute", attribute.fieldName);
			}
			var value : String = serializer.converterStore.objectToString(object, attribute.fieldType);
			parentXml.@[attribute.xmlName] = value;
		}
		
		protected override function deserializeObject(xmlData : XML, xmlName : QName, attribute : XmlMember, serializer : SerializerCore) : Object {
			if(serializer.configuration.enableLogging){
				log.info("Deserializing attribute <<{0}>> to field {1}", xmlName, attribute.fieldName);
			}
			var valueXML : XMLList = xmlData.attribute(xmlName);
			var value : String = "";
			if(valueXML.length() > 0){
				value = valueXML[0];
			}else{
				value = attribute.defaultSetValue;
			}
			var result : Object = serializer.converterStore.stringToObject(value, attribute.fieldType);
			return result;
		}
	}
}