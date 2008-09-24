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
	import flash.utils.getQualifiedClassName;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class XmlElementSerializer implements ISerializer
	{
		public function XmlElementSerializer()
		{
			//TODO: implement function
		}
		/**
		 * @see com.aciobanu.serializer.xml.ISerializer#serialize()
		 */
		public function serialize(object:Object, annotation : Annotation, parentXml : XML) : XML
		{
			var element : XmlElement = annotation as XmlElement;
			if(element.ignoreOn == XmlMember.IGNORE_ON_SERIALIZE){
				return null;
			}
			/*if(element.serializePartialElement){
				return null;
			}*/
			var child : XML = <xml />;
			if(isComplexType(object)){
				child = XMLSerializer.instance.serialize(object);
			}else{
				child.appendChild(object);
			}
			child.setName(element.xmlName);
			parentXml.appendChild(child);
			return child;
		}
		/**
		 * @see com.aciobanu.serializer.xml.ISerializer#deserialize()
		 */
		public function deserialize(xmlData:XML, annotation : Annotation) : Object
		{
			var element : XmlElement = annotation as XmlElement;
			if(element.ignoreOn == XmlMember.IGNORE_ON_DESERIALIZE){
				return null;
			}
			var xmlElement : XMLList = xmlData.child(element.xmlName);
			if(xmlElement.length() == 0) 
				return null;
			if(isComplexType(annotation.fieldType)){
				return XMLSerializer.instance.deserialize(xmlElement[0], element.fieldType);
			}
			return XMLSerializer.instance.stringToObject(xmlElement[0].text()[0], element.fieldType);
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
		        {
		            return false;
		        }
		    }		
		    return true;
		}
	}
}