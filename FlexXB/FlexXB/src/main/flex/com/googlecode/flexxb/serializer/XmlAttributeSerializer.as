/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
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

		/**
		 * @see XmlMemberSerializer#serializeObject()
		 */
		protected override function serializeObject(object : Object, attribute : XmlMember, parentXml : XML, serializer : SerializerCore) : void {
			if(serializer.configuration.enableLogging){
				log.info("Serializing field {0} as attribute", attribute.fieldName);
			}
			var value : String = serializer.converterStore.objectToString(object, attribute.fieldType);
			parentXml.@[attribute.xmlName] = value;
		}

		/**
		 * @see XmlMemberSerializer#deserializeObject()
		 */
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