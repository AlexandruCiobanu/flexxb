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
	import com.googlecode.flexxb.annotation.XmlClass;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public final class XmlClassSerializer implements ISerializer {
		
		private static var log : ILogger = LogFactory.getLog(XmlClassSerializer);
		
		public function serialize(object : Object, annotation : Annotation, parentXml : XML, serializer : SerializerCore) : XML {
			if(serializer.configuration.enableLogging){
				log.info("Serializing object of type {0}", annotation.fieldName);
			}
			var xmlClass : XmlClass = annotation as XmlClass;
			var xml : XML = <xml />
			xml.setNamespace(xmlClass.nameSpace);
			xml.setName(new QName(xmlClass.nameSpace, xmlClass.alias));
			if (xmlClass.useOwnNamespace()) {
				xml.addNamespace(xmlClass.nameSpace);
			} else {
				var member : Annotation = xmlClass.getMember(xmlClass.childNameSpaceFieldName);
				if (member) {
					var ns : Namespace = serializer.descriptorStore.getNamespace(object[member.fieldName]);
					if (ns) {
						xml.addNamespace(ns);
					}
				}
			}
			return xml;
		}
		
		public function deserialize(xmlData : XML, annotation : Annotation, serializer : SerializerCore) : Object {
			var xmlClass : XmlClass = annotation as XmlClass;
			return null;
		}
	}
}