/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
 *   Copyright (C) 2008-2009 Alex Ciobanu
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
package com.googlecode.flexxb.api
{
	import com.googlecode.flexxb.IXmlSerializable;
	
	import flash.utils.Dictionary;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	internal class FxMember
	{
		/**
		 * 
		 */		
		protected var field : FxField;
		
		[XmlAttribute]
		/**
		 * 
		 */		
		public var alias : String;
		
		[XmlAttribute]
		/**
		 * 
		 */		
		public var ignoreOn : Stage = null;
		
		[XmlAttribute]
		/**
		 * 
		 */		
		public var order : Number;
		/**
		 * 
		 * @param field
		 * @param alias
		 * 
		 */			
		public function FxMember(field : FxField, alias : String = null)
		{
			this.field = field;
			this.alias = alias;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fieldName() : String{
			return field.name;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fieldType() : Class{
			return field.type;
		}
		
		public function get fieldAccessType() : AccessorType{
			return field.accessType;
		}
		/**
		 * 
		 * @see com.googlecode.flexxb.IXmlSerializable#toXml()
		 * 
		 */
		public function toXml():XML
		{
			var xml : XML = field.toXml();
			var metadata : XML = <metadata />;
			xml.appendChild(metadata);
			
			metadata.@name = getXmlAnnotationName();
			
			var items : Dictionary = getContent();
			
			for(var key : * in items){
				if(items[key]!= null){
					metadata.appendChild(<arg key={key} value={items[key]} />)
				}
			}
			return xml;
		}
		/**
		 * 
		 * @see com.googlecode.flexxb.IXmlSerializable#fromXml()
		 * 
		 */		
		public function fromXml(xmlData:XML):Object
		{
			this.alias = xmlData.@alias;
			this.ignoreOn = xmlData.@ignoreOn; 
			this.order = xmlData.@order;
			//if(xmlData.children().length() == 1){
			//	this.field = new FxField().fromXml(xmlData.children()[0]) as FxField;
			//}
			xmlToObject(xmlData);
			return this;
		}
		/**
		 * 
		 * @param xml
		 * 
		 */		
		protected function xmlToObject(xml : XML) : void{}
		/**
		 * 
		 * @return 
		 * 
		 */		
		protected function getXmlAnnotationName() : String{
			return null;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		protected function getContent() : Dictionary{
			var items : Dictionary = new Dictionary();
			items["alias"] = alias;
			items["ignoreOn"] = ignoreOn;
			if(!isNaN(order))
				items["order"] = order;
			return items;
		}
		
		public function get thisType():Class
		{
			return FxMember;
		}
		
		public function get id():String
		{
			return null;
		}
		
		public function getIdValue(xmldata:XML):String
		{
			return null;
		}
		
	}
}