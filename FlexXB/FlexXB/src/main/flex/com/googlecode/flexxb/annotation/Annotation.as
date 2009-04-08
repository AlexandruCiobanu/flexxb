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
 package com.googlecode.flexxb.annotation
{
	import flash.utils.getDefinitionByName;
	
	/**
	 * This is the base class for a field xml annotation.
	 * <p> It obtains basic informations about the field:
	 * <ul><li>Field name</li>
	 *     <li>Field type</li>
	 *     <li>Alias (the name under which the field will be used in the xml reprezentation)</li>
	 * </p>
	 * @author aCiobanu
	 * 
	 */	
	public class Annotation
	{
		/**
		 * 
		 */		
		public static const ARGUMENT_ALIAS : String = "alias"; 
		/**
		 * 
		 */		
		public static const ALIAS_ANY : String = "*";
		/**
		 * 
		 */		
		public var nameSpace : Namespace;
		/**
		 * 
		 */		
		protected var _fieldName : String;
		/**
		 * 
		 */		
		protected var _fieldType : Class;
		/**
		 * 
		 */		
		protected var _alias : String = "";
		/**
		 * 
		 */		
		private var _xmlName : QName;
		/**
		 * Constructor
		 * @param descriptor
		 * 
		 */				
		public function Annotation(descriptor : XML){
			if(!descriptor){
				throw new Error("The field's xml descriptor must not be empty.");
			}
			parse(descriptor);
		}
		/**
		 * 
		 * @return field name
		 * 
		 */		
		public function get fieldName():String{
			return _fieldName;
		}
		/**
		 * 
		 * @return field type
		 * 
		 */		
		public function get fieldType() : Class{
			return _fieldType;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get xmlName() : QName{
			if(!_xmlName){
				_xmlName = new QName(nameSpace, _alias == "" ? _fieldName : _alias);
			}
			return _xmlName;
		}
		/**
		 * 
		 * @return name
		 * 
		 */		
		public function get alias() : String{
			return _alias;
		}
		/**
		 * 
		 * @param value name to be set
		 * 
		 */		
		protected function setAlias(value : String) : void{
			if(value == null) return;
			_alias = value;
			if(_alias.length == 0){
				_alias = _fieldName;
			}
		}
		/**
		 * Get the annotation's name used in descriptor
		 * @return annotation name
		 * 
		 */				
		public function get annotationName() : String{
			return "";
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function hasNamespaceDeclaration() : Boolean{
			return nameSpace && nameSpace.uri && nameSpace.uri.length > 0;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function useOwnerAlias() : Boolean{
			return _alias == ALIAS_ANY;
		}
		/**
		 * @private
		 * Analyze field/class descriptor to extract base informations like field's name and type
		 * @param field field descriptor
		 * 
		 */				
		protected function parse(field : XML) : void
		{
			if(field.@name.length() > 0){
				_fieldName = field.@name;
			}
			if(field.@type.length() > 0){
				_fieldType = getDefinitionByName(field.@type) as Class;
			}
			var metadata : XMLList = field.metadata.(@name == annotationName);
			if(metadata.length()>0){
				parseMetadata(metadata[0]);
			}
			return;
		}
		/**
		 * @private
		 * Process the metadata attached to the field to extract annotation specific data
		 * @param field field descriptor
		 * 
		 */		
		protected function parseMetadata(field : XML) : void{}
	}
}