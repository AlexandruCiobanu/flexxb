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
	import com.googlecode.flexxb.SerializerCore;
	import com.googlecode.flexxb.annotation.XmlArray;
	import com.googlecode.flexxb.annotation.XmlMember;

	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;

	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;

	/**
	 * Insures serialization/deserialization for object field decorated with the XmlArray annotation.
	 * @author Alexutz
	 *
	 */
	public final class XmlArraySerializer extends XmlElementSerializer {
		/**
		 *Constructor
		 *
		 */
		public function XmlArraySerializer() {
			super();
		}

		/**
		 * @see XmlMemberSerializer#serializeObject()
		 */
		protected override function serializeObject(object : Object, annotation : XmlMember, parentXml : XML, serializer : SerializerCore) : void {
			var result : XML = <xml />;
			var xmlArray : XmlArray = annotation as XmlArray;
			var child : XML;
			for each (var member : Object in object) {
				if (isComplexType(member)) {
					child = serializer.serialize(member, xmlArray.serializePartialElement);
					if (xmlArray.memberName) {
						child.setName(xmlArray.memberName);
					}
				} else {
					var stringValue : String = serializer.converterStore.objectToString(member, xmlArray.type);
					var xmlValue : XML;
					try {
						xmlValue = XML(stringValue);
					} catch (error : Error) {
						stringValue = XML(new XMLNode(XMLNodeType.TEXT_NODE, stringValue)).toXMLString();
						xmlValue = XML(stringValue);
					}

					if (xmlArray.memberName) {
						child = <xml />;
						child.setName(xmlArray.memberName);
						child.appendChild(xmlValue);
					} else {
						child = xmlValue;
					}
				}
				result.appendChild(child);
			}

			if (xmlArray.useOwnerAlias()) {
				for each (var subChild : XML in result.children()) {
					parentXml.appendChild(subChild);
				}
			} else {
				result.setName(xmlArray.xmlName);
				parentXml.appendChild(result);
			}
		}

		/**
		 * @see XmlMemberSerializer#deserializeObject()
		 */
		protected override function deserializeObject(xmlData : XML, xmlName : QName, element : XmlMember, serializer : SerializerCore) : Object {
			var result : Object = new element.fieldType();

			var array : XmlArray = element as XmlArray;

			var xmlArray : XMLList;

			if (array.useOwnerAlias()) {
				if (array.memberName) {
					xmlName = array.memberName;
				} else if (array.type) {
					xmlName = serializer.descriptorStore.getXmlName(array.type);
				}
				xmlArray = xmlData.child(xmlName);
			} else {
				xmlName = array.xmlName;
				xmlArray = xmlData.child(xmlName);
				if (xmlArray.length() > 0) {
					xmlArray = xmlArray.children();
				}
			}
			if (xmlArray && xmlArray.length() > 0) {
				var list : Array = [];
				for each (var xmlChild : XML in xmlArray) {
					var member : Object = getValue(xmlChild, array.type, array.getFromCache, serializer);
					if (member) {
						list.push(member);
					}
				}
				addMembersToResult(list, result);
			}
			return result;
		}

		private function addMembersToResult(members : Array, result : Object) : void {
			if (result is Array) {
				(result as Array).push.apply(null, members);
			} else if (result is ArrayCollection) {
				ArrayCollection(result).source = members;
				ArrayCollection(result).refresh();
			} else if (result is ListCollectionView) {
				for each (var member : Object in members) {
					ListCollectionView(result).addItem(member);
				}
			}
		}
	}
}