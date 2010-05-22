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
	import com.googlecode.flexxb.annotation.XmlArray;
	import com.googlecode.flexxb.annotation.XmlMember;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;

	/**
	 * Insures serialization/deserialization for object field decorated with the XmlArray annotation.
	 * @author Alexutz
	 *
	 */
	public final class XmlArraySerializer extends XmlElementSerializer {
		
		private static var log : ILogger = LogFactory.getLog(XmlArraySerializer);
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
			if(serializer.configuration.enableLogging){
				log.info("Serializing field {0} as array element", annotation.fieldName);
			}
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
						xmlValue = escapeValue(stringValue, serializer.configuration);
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
			if(serializer.configuration.enableLogging){
				log.info("Deserializing array element <<{0}>> to field {1} with items of type <<{2}>>", xmlName, element.fieldName, XmlArray(element).type);
			}
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
					if (member != null) {
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