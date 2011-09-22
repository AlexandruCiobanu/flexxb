/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
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
package com.googlecode.flexxb.xml.serializer {
	import com.googlecode.flexxb.annotation.contract.IAnnotation;
	import com.googlecode.flexxb.core.DescriptionContext;
	import com.googlecode.flexxb.core.SerializationCore;
	import com.googlecode.flexxb.serializer.BaseSerializer;
	import com.googlecode.flexxb.xml.XmlDescriptionContext;
	import com.googlecode.flexxb.xml.annotation.XmlMember;
	import com.googlecode.flexxb.xml.util.XmlUtils;
	
	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	internal class XmlMemberSerializer extends BaseSerializer {
		
		public function XmlMemberSerializer(context : DescriptionContext) {
			super(context);
		}
		
		public override function serialize(object : Object, annotation : IAnnotation, serializedData : Object, serializer : SerializationCore) : Object {
			var element : XmlMember = annotation as XmlMember;
			var parentXml : XML = serializedData as XML;
			
			
			var location : XML = parentXml;

			if (element.isPath()) {
				location = XmlUtils.setPathElement(element, parentXml);
			}
			
			if (element.isDefaultValue()) {
				location.appendChild(serializer.converterStore.objectToString(object, element.type));
				return null;
			}
			
			if(element.hasNamespaceRef() && element.nameSpace != element.ownerClass.nameSpace && XmlUtils.mustAddNamespace(element.nameSpace, parentXml)){
				parentXml.addNamespace(element.nameSpace);
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
		protected function serializeObject(object : Object, annotation : XmlMember, parentXml : XML, serializer : SerializationCore) : void {
		}
		
		public override function deserialize(serializedData : Object, annotation : IAnnotation, serializer : SerializationCore) : Object {
			var element : XmlMember = annotation as XmlMember;
			var xmlData : XML = serializedData as XML;
			
			var xmlElement : XML;

			if (element.isPath()) {
				xmlElement = XmlUtils.getPathElement(element, xmlData);
			} else {
				xmlElement = xmlData;
			}

			if (xmlElement == null) {
				signalMissingField();
				return null;
			}
			
			if (element.isDefaultValue()) {
				for each (var child : XML in xmlElement.children()) {
					if (child.nodeKind() == "text") {
						return serializer.converterStore.stringToObject(child.toXMLString(), element.type);
					}
				}
			}

			var xmlName : QName;
			if (element.useOwnerAlias()) {
				xmlName = XmlDescriptionContext(context).getXmlName(element.type);
			} else {
				xmlName = element.xmlName;
			}

			var value : Object = deserializeObject(xmlElement, xmlName, element, serializer);
			return value;
		}

		/**
		 *
		 * @param xmlData
		 * @param annotation
		 * @param serializer
		 * @return
		 *
		 */
		protected function deserializeObject(xmlData : XML, xmlName : QName, annotation : XmlMember, serializer : SerializationCore) : Object {
			return null;
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
				case "XML":
				case "Class":
					return false;break;
				default:
					return !context.hasSimpleTypeConverter(value);
			}
		}
	}
}