/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
 *   Copyright (C) 2008 Alex Ciobanu
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
 package com.googlecode.serializer.flexxb
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public final class XmlAttributeSerializer implements ISerializer
	{
		/**
		 * Constructor 
		 * 
		 */		
		public function XmlAttributeSerializer(){}
		/**
		 * @see com.aciobanu.serializer.xml.ISerializer#serialize()
		 */		
		public function serialize(object:Object, annotation : Annotation, parentXml : XML):XML
		{
			var attribute : XmlAttribute = annotation as XmlAttribute;
			if(attribute.ignoreOn == XmlMember.IGNORE_ON_SERIALIZE){
				return null;
			}
			var value : String = XMLSerializer.instance.objectToString(object);
			if(value && value.length > 0){
				parentXml.@[attribute.xmlName] = value;
			} 
			return parentXml;
		}
		/**
		 * @see com.aciobanu.serializer.xml.ISerializer#deserialize()
		 */	
		public function deserialize(xmlData:XML, annotation : Annotation):Object
		{
			var attribute : XmlAttribute = annotation as XmlAttribute;
			if(attribute.ignoreOn == XmlMember.IGNORE_ON_DESERIALIZE){
				return null;
			}
			var result : Object = XMLSerializer.instance.stringToObject(xmlData.@[annotation.xmlName], annotation.fieldType);
			return result;
		}
	}
}