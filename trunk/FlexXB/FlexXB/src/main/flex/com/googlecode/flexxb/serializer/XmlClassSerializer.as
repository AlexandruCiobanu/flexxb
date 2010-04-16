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
		/**
		 * @see ISerializer#serialize()
		 */
		public function serialize(object : Object, annotation : Annotation, parentXml : XML, serializer : SerializerCore) : XML {
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

		/**
		 * @see ISerializer#deserialize()
		 */
		public function deserialize(xmlData : XML, annotation : Annotation, serializer : SerializerCore) : Object {
			var xmlClass : XmlClass = annotation as XmlClass;
			return null;
		}
	}
}