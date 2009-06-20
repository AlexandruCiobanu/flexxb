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
	import com.googlecode.flexxb.annotation.Annotation;
	import com.googlecode.flexxb.annotation.XmlClass;
	import com.googlecode.flexxb.error.ApiError;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	[XmlClass(alias="Class")]
	[ConstructorArg(reference="type")]
	[ConstructorArg(reference="alias")]
	/**
	 * API wrapper for a class type. Allows programatically defining all the 
	 * elements that would normally be specified via annotations.
	 * @author Alexutz
	 * 
	 */	
	public class FxClass
	{
		/**
		 * 
		 */	
		[XmlAttribute]	
		public var alias : String;
		/**
		 * 
		 */		
		public var prefix : String;
		/**
		 * 
		 */	
		[XmlAttribute]	
		public var uri : String;
		/**
		 * 
		 */	
		[XmlAttribute]	
		public var ordered : Boolean;
		/**
		 * 
		 */		
		private var _type : Class;
		/**
		 * 
		 */		
		[XmlArray(alias="Members")]
		public var members : Array = [];
		/**
		 * 
		 */		
		[XmlArray(alias="ConstructorArguments", memberType="com.googlecode.flexxb.api.FxConstructorArgument")]
		public var constructorArguments : Array;
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
		[XmlAttribute]
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
				throw new ApiError("Class type is null!");
			}
			_type = value;
		}
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set nameSpace(value : Namespace) : void{
			if(value){
				uri = value.uri;
				prefix = value.prefix;
			}
		}
		/**
		 * 
		 * @param fieldName
		 * @param optional
		 * 
		 */		
		public function addArgument(fieldName : String, optional : Boolean = false) : void{
			if(!constructorArguments){
				constructorArguments = [];
			}
			constructorArguments.push(new FxConstructorArgument(fieldName, optional));
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
		
		public function toXml() : XML
		{
			var xml : XML = <type />;
			xml.@name = getQualifiedClassName(type);
			if(constructorArguments){
				for(var i : int = constructorArguments.length - 1; i >= 0; i--){
					xml.appendChild((constructorArguments[i] as FxConstructorArgument).toXml());
				}
			}
			xml.appendChild(buildMetadata());			
			for each(var member : FxMember in members){
				xml.appendChild(member.toXml());
			}
			
			return xml;
		}
		
		private function buildMetadata() : XML{
			var xml : XML = <metadata />;
			xml.@name = XmlClass.ANNOTATION_NAME;
			
			var items : Dictionary = new Dictionary();
			items[Annotation.ARGUMENT_ALIAS] = alias;
			items[XmlClass.ARGUMENT_NAMESPACE_PREFIX] = prefix;
			items[XmlClass.ARGUMENT_NAMESPACE_URI] = uri;
			items[XmlClass.ARGUMENT_ORDERED] = ordered;
			
			for(var key : * in items){
				if(items[key]!= null){
					xml.appendChild(<arg key={key} value={items[key]} />)
				}
			}
			return xml;
		}
		
		public function toString() : String{
			return "Class[type: " + type + ", alias:" + alias + "]";
		}
	}
}