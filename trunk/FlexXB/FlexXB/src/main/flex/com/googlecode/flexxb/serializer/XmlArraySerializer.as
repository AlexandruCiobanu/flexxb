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
	
	import flash.utils.getDefinitionByName;
	
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
			//TODO: implement function
		}
		/**
		 * @see com.aciobanu.serializer.xml.ISerializer#serialize()
		 */
		public override function serialize(object:Object, annotation : Annotation, parentXml : XML, serializer : XMLSerializer) : XML
		{
			var array : XmlArray = annotation as XmlArray;
			if(array.ignoreOn == XmlMember.IGNORE_ON_SERIALIZE){
				return null;
			}
			var result : XML = <xml />;
			result.setName(annotation.xmlName);
			for each(var member : Object in object){
				result.appendChild(serializer.serialize(member));
			}
			parentXml.appendChild(result);
			return result;
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
			var xmlArray : XMLList = xmlData.child(array.xmlName);
			if(xmlArray.length() > 0) {
				var memberType : Class = getDefinitionByName(array.type) as Class;
				for each(var xmlChild : XML in xmlArray.children()){
					var member : Object = serializer.deserialize(xmlChild, memberType, array.getFromCache);
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