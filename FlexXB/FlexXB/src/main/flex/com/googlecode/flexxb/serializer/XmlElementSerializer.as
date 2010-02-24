/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2009 Alex Ciobanu
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
	import com.googlecode.flexxb.Configuration;
	import com.googlecode.flexxb.SerializerCore;
	import com.googlecode.flexxb.annotation.XmlElement;
	import com.googlecode.flexxb.annotation.XmlMember;
	import com.googlecode.flexxb.util.cdata;
	
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;

	/**
	 * Insures serialization/deserialization for object field decorated with the XmlElement annotation
	 * @author Alexutz
	 *
	 */
	public class XmlElementSerializer extends XmlMemberSerializer {
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
			var child : XML = <xml />;
			if (isComplexType(object)) {
				child = serializer.serialize(object, XmlElement(annotation).serializePartialElement);
			} else {
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
			var list : XMLList = xmlData.child(xmlName);
			if (list.length() == 0) {
				return null;
			}
			var type : Class = element.fieldType;
			if (XmlElement(element).getRuntimeType) {
				type = serializer.getIncomingType(list[0]);
				if (!type) {
					type = element.fieldType;
				}
			}
			return getValue(list[0], type, XmlElement(element).getFromCache, serializer);
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
				trace(value);
				xml = XML(value);
			}
			return serializer.converterStore.stringToObject(xml.toString(), type);
		}
	}
}