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
	import com.googlecode.flexxb.annotation.xml.XmlArray;
	import com.googlecode.flexxb.annotation.xml.XmlMember;
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
		
		private static const LOG : ILogger = LogFactory.getLog(XmlArraySerializer);
		/**
		 *Constructor
		 *
		 */
		public function XmlArraySerializer() {
			super();
		}
		
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
		
		protected override function deserializeObject(xmlData : XML, xmlName : QName, element : XmlMember, serializer : SerializerCore) : Object {
			if(serializer.configuration.enableLogging){
				LOG.info("Deserializing array element <<{0}>> to field {1} with items of type <<{2}>>", xmlName, element.name, XmlArray(element).type);
			}
			var result : Object = new element.type();

			var array : XmlArray = element as XmlArray;

			var xmlArray : XMLList;
			//get the xml list representing the array
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
			//extract the items from xml, build the result array and return it
			if (xmlArray && xmlArray.length() > 0) {
				var list : Array = [];
				if(!array.memberName && xmlArray.length() == 1 && xmlArray[0].nodeKind() == "text"){
					// we need to handle differently the case in which we have items of simple type 
					// and have no item name defined
					var values : Array = xmlArray[0].toString().split("\n");
					for each(var value : String in values){
						list.push(getValue(XML(value), array.type, array.getFromCache, serializer))
					}
				}else{
					for each (var xmlChild : XML in xmlArray) {
						var member : Object = getValue(xmlChild, array.type, array.getFromCache, serializer);
						if (member != null) {
							list.push(member);
						}
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