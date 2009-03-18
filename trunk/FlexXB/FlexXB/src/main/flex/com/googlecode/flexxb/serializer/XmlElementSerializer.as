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
	import com.googlecode.flexxb.annotation.XmlElement;
	import com.googlecode.flexxb.annotation.XmlMember;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class XmlElementSerializer extends XmlMemberSerializer
	{
		public function XmlElementSerializer(){}
		/**
		 * @see XmlMemberSerializer#serializeObject()
		 */		
		protected override function serializeObject(object : Object, annotation : XmlMember, parentXml : XML, serializer : XMLSerializer) : void{
			var child : XML = <xml />;
			if(isComplexType(object)){
				child = serializer.serialize(object, XmlElement(annotation).serializePartialElement);
			}else{
				child.appendChild(serializer.objectToString(object, annotation.fieldType));
			}
			
			if(annotation.useOwnerAlias()){
				var name : QName = serializer.getXmlName(object);
				if(name){
					child.setName(name);
				}
			}else if(annotation.xmlName){
				child.setName(annotation.xmlName);
			}
			parentXml.appendChild(child);
		}
		/**
		 * @see XmlMemberSerializer#deserializeObject()
		 */		
		protected override function deserializeObject(xmlData : XML, xmlName : QName, element : XmlMember, serializer : XMLSerializer) : Object{
			var list : XMLList = xmlData.child(xmlName);
			if(list.length() == 0){
				return null;
			}
			if(isComplexType(element.fieldType)){
				return serializer.deserialize(list[0], element.fieldType, XmlElement(element).getFromCache);
			}
			return serializer.stringToObject(list[0].toString(), element.fieldType);
		}		
	}
}