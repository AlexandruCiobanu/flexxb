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
package com.googlecode.flexxb.api
{
	import com.googlecode.flexxb.IXmlSerializable;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class FxClass implements IXmlSerializable
	{
		/**
		 * 
		 */		
		public var alias : String;
		/**
		 * 
		 */		
		public var prefix : String;
		/**
		 * 
		 */		
		public var uri : String;
		/**
		 * 
		 */		
		public var ordered : Boolean;
		/**
		 * 
		 */		
		private var _type : Class;
		/**
		 * 
		 */		
		private var members : Array = [];
		/**
		 *Constructor 
		 * 
		 */		
		public function FxClass(type : Class, alias : String = null)
		{
			this.type = type;
			this.alias = alias;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get type () : Class{
			return _type;
		} 
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set type(value : Class) : void{
			if(value == null){
				throw new Error("Class type is null!");
			}
			_type = value;
		}
		/**
		 * 
		 * @param fieldName
		 * @param fieldType
		 * @param access
		 * @param alias
		 * @return 
		 * 
		 */		
		public function addAttribute(fieldName : String, fieldType : Class, access : AccessorType = null, alias : String = null) : FxAttribute{
			var attribute : FxAttribute = FxAttribute.create(fieldName, fieldType, access, alias);
			addMember(attribute);			
			return attribute;
		}
		/**
		 * 
		 * @param fieldName
		 * @param fieldType
		 * @param access
		 * @param alias
		 * @return 
		 * 
		 */		
		public function addElement(fieldName : String, fieldType : Class, access : AccessorType = null, alias : String = null) : FxElement{
			var element : FxElement = FxElement.create(fieldName, fieldType, access, alias);
			addMember(element);			
			return element;
		}
		/**
		 * 
		 * @param fieldName
		 * @param fieldType
		 * @param access
		 * @param alias
		 * @return 
		 * 
		 */		
		public function addArray(fieldName : String, fieldType : Class, access : AccessorType = null, alias : String = null) : FxArray{
			var array : FxArray = FxArray.create(fieldName, fieldType, access, alias);
			addMember(array);			
			return array;
		}
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */		
		private function hasMember(name : String) : Boolean{
			for each(var member : FxMember in members){
				if(member.fieldName == name){
					return true;
				}
			}
			return false;
		}
		/**
		 * 
		 * @param member
		 * 
		 */		
		private function addMember(member : FxMember) : void{
			if(hasMember(member.fieldName)){
				throw new Error("Field <" + member.fieldName + "> has already been defined for class type " + type);
			}
			members.push(member);
		}
		
		public function toXml():XML
		{
			var xml : XML = <type />;
			xml.@name = getQualifiedClassName(type);
			xml.appendChild(buildMetadata());			
			for each(var member : FxMember in members){
				xml.appendChild(member.toXml());
			}
			
			return xml;
		}
		
		private function buildMetadata() : XML{
			var xml : XML = <metadata />;
			xml.@name = "XmlClass";
			
			var items : Dictionary = new Dictionary();
			items["alias"] = alias;
			items["prefix"] = prefix;
			items["uri"] = uri;
			items["ordered"] = ordered;
			
			for(var key : * in items){
				if(items[key]!= null){
					xml.appendChild(<arg key={key} value={items[key]} />)
				}
			}
			return xml;
		}
		
		public function fromXml(xmlData:XML):Object
		{
			this.type = getDefinitionByName(xmlData.@type) as Class;
			this.alias = xmlData.@alias;
			this.prefix = xmlData.@prefix;
			this.uri = xmlData.@uri;
			this.ordered = xmlData.@ordered == true;
			return this;
		}
		
		public function get thisType():Class
		{
			return FxClass;
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