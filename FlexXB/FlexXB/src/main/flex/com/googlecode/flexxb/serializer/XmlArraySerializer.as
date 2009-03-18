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
	import com.googlecode.flexxb.annotation.XmlArray;
	import com.googlecode.flexxb.annotation.XmlMember;
	
	import mx.collections.ListCollectionView;
	
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public final class XmlArraySerializer extends XmlElementSerializer
	{
		/**
		 *Constructor 
		 * 
		 */		
		public function XmlArraySerializer()
		{
			super();
		}
		/**
		 * @see XmlMemberSerializer#serializeObject()
		 */
		protected override function serializeObject(object : Object, annotation : XmlMember, parentXml : XML, serializer : XMLSerializer) : void{
			var result : XML = <xml />;
			
			for each(var member : Object in object){
				if(isComplexType(member)){
					result.appendChild(serializer.serialize(member, XmlArray(annotation).serializePartialElement));
				}else{
					result.appendChild(serializer.objectToString(member, XmlArray(annotation).type));
				}
			}
			
			var name : QName = result.name() as QName;
			if(name && name.localName != "xml"){
				parentXml.appendChild(result);
			}else{
				for each(var subChild : XML in result.children()){
					parentXml.appendChild(subChild);
				}
			}
			
		}
		/**
		 * @see com.aciobanu.serializer.xml.ISerializer#deserialize()
		 */
		public override function deserialize(xmlData:XML, annotation : Annotation, serializer : XMLSerializer):Object
		{
			var array : XmlArray = annotation as XmlArray;
			if(array.ignoreOn == XmlMember.IGNORE_ON_DESERIALIZE){
				return null;
			}
			
			var result : Object = new annotation.fieldType();
			
			var xmlName : QName;
			var xmlArray : XMLList;
			
			if(array.useOwnerAlias()){
				if(array.memberName){
					xmlName = array.memberName;
				}else if(array.type){
					xmlName = serializer.getXmlName(array.type);
				}
				xmlArray = xmlData.child(xmlName);
			}else{
				xmlName = array.xmlName;
				xmlArray = xmlData.child(xmlName);
				if(xmlArray.length() > 0){
					xmlArray = xmlArray.children();
				}
			}
			if(xmlArray && xmlArray.length() > 0) {
				for each(var xmlChild : XML in xmlArray){
					var member : Object = serializer.deserialize(xmlChild, array.type, array.getFromCache);
					if(member){
						addMemberToResult(member, result);
					}
				}
			}
			return result;
		}		
		
		private function addMemberToResult(member : Object, result : Object) : void{
			if(result is Array){
				(result as Array).push(member);
			}else if(result is ListCollectionView){
				ListCollectionView(result).addItem(member);
			}
		}
	}
}