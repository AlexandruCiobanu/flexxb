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
	public final class XmlClassSerializer implements ISerializer
	{
		/**
		 *Constructor 
		 * 
		 */		
		public function XmlClassSerializer()
		{
			//TODO: implement function
		}
		/**
		 * @see com.aciobanu.serializer.xml.ISerializer#serialize()
		 */
		public function serialize(object:Object, annotation : Annotation, parentXml : XML, serializer : XMLSerializer) : XML
		{
			var xmlClass : XmlClass = annotation as XmlClass;
			var xml : XML = <xml />
			xml.setName(new QName(xmlClass.nameSpace, xmlClass.alias));
			xml.addNamespace(xmlClass.nameSpace);
			return xml;
		}
		/**
		 * @see com.aciobanu.serializer.xml.ISerializer#deserialize()
		 */
		public function deserialize(xmlData:XML, annotation : Annotation, serializer : XMLSerializer):Object
		{
			var xmlClass : XmlClass = annotation as XmlClass;
			return null;
		}		
	}
}