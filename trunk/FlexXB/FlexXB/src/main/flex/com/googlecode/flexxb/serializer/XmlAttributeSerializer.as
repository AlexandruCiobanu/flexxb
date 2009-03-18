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
 package com.googlecode.flexxb.serializer
{
	import com.googlecode.flexxb.XMLSerializer;
	import com.googlecode.flexxb.annotation.XmlMember;
		
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public final class XmlAttributeSerializer extends XmlMemberSerializer
	{
		/**
		 * Constructor 
		 * 
		 */		
		public function XmlAttributeSerializer(){}
		/**
		 * @see XmlMemberSerializer#serializeObject()
		 */		
		protected override function serializeObject(object : Object, attribute : XmlMember, parentXml : XML, serializer : XMLSerializer) : void{
			var value : String = serializer.objectToString(object, attribute.fieldType);
			parentXml.@[attribute.xmlName] = value;			
		}
		/**
		 * @see XmlMemberSerializer#deserializeObject()
		 */		
		protected override function deserializeObject(xmlData : XML, xmlName : QName, attribute : XmlMember, serializer : XMLSerializer) : Object{
			var value : String = xmlData.attribute(xmlName);
			var result : Object = serializer.stringToObject(value, attribute.fieldType);
			return result;
		}
	}
}