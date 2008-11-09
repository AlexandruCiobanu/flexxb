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
	import com.googlecode.flexxb.annotation.Annotation;
	import com.googlecode.flexxb.annotation.XmlElement;
	import com.googlecode.flexxb.annotation.XmlMember;
	
	import flash.utils.getQualifiedClassName;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class XmlElementSerializer implements ISerializer
	{
		public function XmlElementSerializer(){}
		/**
		 * @see com.aciobanu.serializer.xml.ISerializer#serialize()
		 */
		public function serialize(object:Object, annotation : Annotation, parentXml : XML, serializer : XMLSerializer) : XML
		{
			var element : XmlElement = annotation as XmlElement;
			if(element.ignoreOn == XmlMember.IGNORE_ON_SERIALIZE){
				return null;
			}
			var child : XML = <xml />;
			if(isComplexType(object)){
				child = serializer.serialize(object, element.serializePartialElement);
			}else{
				child.appendChild(serializer.objectToString(object, annotation.fieldType));
			}
			if(element.useOwnerAlias()){
				var name : QName = serializer.getXmlName(object);
				if(name){
					child.setName(name);
				}
			}else{
				child.setName(element.xmlName);
			}
			parentXml.appendChild(child);
			return child;
		}
		/**
		 * @see com.aciobanu.serializer.xml.ISerializer#deserialize()
		 */
		public function deserialize(xmlData:XML, annotation : Annotation, serializer : XMLSerializer) : Object
		{
			var element : XmlElement = annotation as XmlElement;
			if(element.ignoreOn == XmlMember.IGNORE_ON_DESERIALIZE){
				return null;
			}
			var xmlName : QName = element.xmlName;
			if(element.useOwnerAlias()){
				xmlName = serializer.getXmlName(element.fieldType);
			}
			var xmlElement : XMLList = xmlData.child(xmlName);
			if(xmlElement.length() == 0) 
				return null;
			if(isComplexType(annotation.fieldType)){
				return serializer.deserialize(xmlElement[0], element.fieldType, element.getFromCache);
			}
			return serializer.stringToObject(XML(xmlElement[0]).children()[0].toString(), element.fieldType);
		}
		
		private function isComplexType(value : Object) : Boolean
		{
		    var type:String =  getQualifiedClassName(value);
		    switch (type)
		    {
		        case "Number":
		        case "int":
		        case "uint":
		        case "String":
		        case "Boolean":
		        case "Date":
		        case "XML":
		        {
		            return false;
		        }
		    }		
		    return true;
		}
	}
}