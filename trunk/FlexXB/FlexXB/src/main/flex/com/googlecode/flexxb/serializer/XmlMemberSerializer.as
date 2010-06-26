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
	import com.googlecode.flexxb.annotation.Annotation;
	import com.googlecode.flexxb.annotation.XmlMember;
	import com.googlecode.flexxb.api.Stage;
	import com.googlecode.flexxb.error.ProcessingError;

	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	internal class XmlMemberSerializer implements ISerializer {
		
		public function serialize(object : Object, annotation : Annotation, parentXml : XML, serializer : SerializerCore) : XML {
			var element : XmlMember = annotation as XmlMember;
			
			if (element.isDefaultValue()) {
				parentXml.appendChild(serializer.converterStore.objectToString(object, element.fieldType));
				return null;
			}
			var location : XML = parentXml;

			if (element.isPath()) {
				location = setPathElement(element, parentXml);
			}

			serializeObject(object, element, location, serializer);

			return location;
		}

		/**
		 *
		 * @param object
		 * @param annotation
		 * @param serializer
		 * @return
		 *
		 */
		protected function serializeObject(object : Object, annotation : XmlMember, parentXml : XML, serializer : SerializerCore) : void {
		}
		
		public function deserialize(xmlData : XML, annotation : Annotation, serializer : SerializerCore) : Object {
			var element : XmlMember = annotation as XmlMember;
			
			if (element.isDefaultValue()) {
				for each (var child : XML in xmlData.children()) {
					if (child.nodeKind() == "text") {
						return serializer.converterStore.stringToObject(child.toXMLString(), element.fieldType);
					}
				}
			}

			var xmlElement : XML;

			if (element.isPath()) {
				xmlElement = getPathElement(element, xmlData);
			} else {
				xmlElement = xmlData;
			}

			if (xmlElement == null) {
				return null;
			}

			var xmlName : QName;
			if (element.useOwnerAlias()) {
				xmlName = serializer.descriptorStore.getXmlName(element.fieldType);
			} else {
				xmlName = element.xmlName;
			}

			return deserializeObject(xmlElement, xmlName, element, serializer);
		}

		/**
		 *
		 * @param xmlData
		 * @param annotation
		 * @param serializer
		 * @return
		 *
		 */
		protected function deserializeObject(xmlData : XML, xmlName : QName, annotation : XmlMember, serializer : SerializerCore) : Object {
			return null;
		}

		/**
		 *
		 * @param element
		 * @param xmlData
		 * @return
		 *
		 */
		private function getPathElement(element : XmlMember, xmlData : XML) : XML {
			var xmlElement : XML;
			var list : XMLList;
			var pathElement : QName;
			for (var i : int = 0; i < element.qualifiedPathElements.length; i++) {
				pathElement = element.qualifiedPathElements[i];
				if (!xmlElement) {
					list = xmlData.child(pathElement);
				} else {
					list = xmlElement.child(pathElement);
				}
				if (list.length() > 0) {
					xmlElement = list[0];
				} else {
					xmlElement = null;
					break;
				}
			}
			return xmlElement;
		}

		/**
		 *
		 * @param element
		 * @param xmlParent
		 * @param serializedChild
		 * @return
		 *
		 */
		private function setPathElement(element : XmlMember, xmlParent : XML) : XML {
			var cursor : XML = xmlParent;
			var count : int = 0;
			for each (var pathElement : QName in element.qualifiedPathElements) {
				var path : XMLList = cursor.child(pathElement);
				if (path.length() > 0) {
					cursor = path[0];
				} else {
					var c : XML = <xml />;
					c.setName(pathElement);
					cursor.appendChild(c);
					cursor = c;
				}
				count++;
			}
			return cursor;
		}

		/**
		 *
		 * @param value
		 * @return
		 *
		 */
		protected function isComplexType(value : Object) : Boolean {
			var type : String = getQualifiedClassName(value);
			switch (type) {
				case "Number":
				case "int":
				case "uint":
				case "String":
				case "Boolean":
				case "Date":
				case "XML":  {
					return false;
				}
			}
			return true;
		}
	}
}