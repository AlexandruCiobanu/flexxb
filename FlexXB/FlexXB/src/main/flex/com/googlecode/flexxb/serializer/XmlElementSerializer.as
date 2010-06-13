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
	import com.googlecode.flexxb.Configuration;
	import com.googlecode.flexxb.SerializerCore;
	import com.googlecode.flexxb.annotation.XmlElement;
	import com.googlecode.flexxb.annotation.XmlMember;
	import com.googlecode.flexxb.util.cdata;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;
	
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;

	/**
	 * Insures serialization/deserialization for object field decorated with the XmlElement annotation
	 * @author Alexutz
	 *
	 */
	public class XmlElementSerializer extends XmlMemberSerializer {
		
		private static var log : ILogger = LogFactory.getLog(XmlElementSerializer);
		/**
		 * Constructor
		 *
		 */
		public function XmlElementSerializer() {
		}

		/**
		 * @see XmlMemberSerializer#serializeObject()
		 */
		protected override function serializeObject(object : Object, annotation : XmlMember, parentXml : XML, serializer : SerializerCore) : void {
			if(serializer.configuration.enableLogging){
				log.info("Serializing field {0} as element", annotation.fieldName);
			}
			var child : XML = <xml />;
			if (isComplexType(object)) {
				child = serializer.serialize(object, XmlElement(annotation).serializePartialElement);
			}else if(annotation.fieldType == XML){
				child.appendChild(new XML(object));
			}else{
				var stringValue : String = serializer.converterStore.objectToString(object, annotation.fieldType);
				try {
					child.appendChild(stringValue);
				} catch (error : Error) {
					child.appendChild(escapeValue(stringValue, serializer.configuration));
				}
			}

			if (annotation.useOwnerAlias()) {
				var name : QName = serializer.descriptorStore.getXmlName(object);
				if (name) {
					child.setName(name);
				}
			} else if (annotation.xmlName) {
				child.setName(annotation.xmlName);
			}
			parentXml.appendChild(child);
		}
		
		protected final function escapeValue(value : *, configuration : Configuration) : XML{
			if(configuration.escapeSpecialChars){
				return XML(new XMLNode(XMLNodeType.TEXT_NODE, value));
			}else{
				return cdata(value);
			}
		}

		/**
		 * @see XmlMemberSerializer#deserializeObject()
		 */
		protected override function deserializeObject(xmlData : XML, xmlName : QName, element : XmlMember, serializer : SerializerCore) : Object {
			if(serializer.configuration.enableLogging){
				log.info("Deserializing element <<{0}>> to field {1}", xmlName, element.fieldName);
			}
			var list : XMLList = xmlData.child(xmlName);
			var xml : XML;
			if (list.length() == 0) {
				if(element.defaultSetValue){
					xml = XML(element.defaultSetValue);
				}else{
					return null;
				}
			}else{
				xml = list[0];
			}
			var type : Class = element.fieldType;
			if (XmlElement(element).getRuntimeType) {
				type = serializer.getIncomingType(list[0]);
				if (!type) {
					type = element.fieldType;
				}
			}
			return getValue(xml, type, XmlElement(element).getFromCache, serializer);
		}
		
		protected final function getValue(xml : XML, type : Class, getFromCache : Boolean, serializer : SerializerCore) : Object{
			if (isComplexType(type)) {
				return serializer.deserialize(xml, type, getFromCache);
			}
			//FIX: if the type is XML then we have a bit of processing to do
			//xml data is stored as child of an xml element whch can be namespaced
			//we remove the wrapper, along with its namespace(s) and keep the
			//content.
			if(type == XML){
				var value : String = xml.toXMLString();
				value = value.substring(value.indexOf(">") + 1, value.lastIndexOf("<"));
				xml = XML(value);
			}
			return serializer.converterStore.stringToObject(xml.toString(), type);
		}
	}
}