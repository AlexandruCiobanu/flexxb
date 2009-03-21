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
	import com.googlecode.flexxb.SerializerCore;
	import com.googlecode.flexxb.annotation.Annotation;
	import com.googlecode.flexxb.annotation.XmlMember;
	import com.googlecode.flexxb.error.ProcessingError;
	
	import flash.utils.getQualifiedClassName;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	internal class XmlMemberSerializer implements ISerializer
	{
		/**
		 * @see ISerializer#serialize
		 */ 
		public function serialize(object:Object, annotation:Annotation, parentXml:XML, serializer:SerializerCore):XML
		{
			var element : XmlMember = annotation as XmlMember;
			if(element.ignoreOn == XmlMember.IGNORE_ON_SERIALIZE){
				return null;
			}
			if(element.isDefaultValue()){
				parentXml.appendChild(serializer.converterStore.objectToString(object, element.fieldType));
				return null;
			}
			var location : XML = parentXml;
			
			if(element.isPath()){
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
		protected function serializeObject(object : Object, annotation : XmlMember, parentXml : XML, serializer : SerializerCore) : void{} 
		/**
		 * @see ISerializer#deserialize()
		 */		
		public function deserialize(xmlData:XML, annotation : Annotation, serializer : SerializerCore) : Object
		{
			var element : XmlMember = annotation as XmlMember;
			if(element.ignoreOn == XmlMember.IGNORE_ON_DESERIALIZE){
				return null;
			}
			if(element.isDefaultValue()){
				for each(var child : XML in xmlData.children()){
					if(child.nodeKind() == "text"){
						return serializer.converterStore.stringToObject(child.toXMLString(), element.fieldType);
					}
				}
			}
			
			var xmlElement : XML;
			
			if(element.isPath()){
				xmlElement = getPathElement(element, xmlData);
			}else{
				xmlElement = xmlData;
			}
			
			var xmlName : QName;
			if(element.useOwnerAlias()){
				xmlName = serializer.descriptorStore.getXmlName(element.fieldType);
			}else{
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
		protected function deserializeObject(xmlData : XML, xmlName : QName, annotation : XmlMember, serializer : SerializerCore) : Object{
			return null;
		}
		/**
		 * 
		 * @param element
		 * @param xmlData
		 * @return 
		 * 
		 */		
		private function getPathElement(element : XmlMember, xmlData : XML) : XML{
			var xmlElement : XML;
			var list : XMLList;
			var pathElement : QName;
			for(var i : int = 0; i < element.qualifiedPathElements.length ; i++){
				pathElement = element.qualifiedPathElements[i];
				if(!xmlElement){
					list = xmlData.child(pathElement);
				}else{
					list = xmlElement.child(pathElement);
				}
				if(list.length() > 0){
					xmlElement = list[0];
				}else{
					throw new ProcessingError(element.ownerClass.fieldType, element.fieldName, false, "Path element not found(" + pathElement + ")");
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
		private function setPathElement(element : XmlMember, xmlParent : XML) : XML{
			var cursor : XML = xmlParent;
			var count : int = 0;
			for each(var pathElement : QName in element.qualifiedPathElements){
				var path : XMLList = cursor.child(pathElement);
				if(path.length()>0){
					cursor = path[0];
				}else{
					var c : XML = <xml />;
					c.setName(pathElement);
					cursor.appendChild(c);
					cursor = c;
				}
				count ++;
			}
			return cursor;
		}
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		protected function isComplexType(value : Object) : Boolean
		{
		    var type:String = getQualifiedClassName(value);
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