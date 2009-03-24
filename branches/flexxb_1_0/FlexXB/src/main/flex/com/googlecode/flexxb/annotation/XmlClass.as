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
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 
	 * <p>Usage: <code>[XmlClass(alias="MyClass", useNamespaceFrom="elementFieldName", idField="idFieldName", prefix="my", uri="http://www.your.site.com/schema/", defaultValueField="fieldName")]</code></p>
	 * @author aCiobanu
	 * 
	 */	
	public final class XmlClass extends Annotation
	{
		/**
		 * Annotation's name
		 */		
		public static const ANNOTATION_NAME : String = "XmlClass";
		/**
		 * Namespace prefix
		 */		
		public static const ARGUMENT_NAMESPACE_PREFIX : String = "prefix";
		/**
		 * Namespace uri
		 */ 
		public static const ARGUMENT_NAMESPACE_URI : String = "uri";
		/**
		 * 
		 */		
		public static const ARGUMENT_USE_CHILD_NAMESPACE : String = "useNamespaceFrom";
		/**
		 * 
		 */		
		public static const ARGUMENT_ID : String = "idField";
		/**
		 * 
		 */		
		public static const ARGUMENT_VALUE : String = "defaultValueField";
		/**
		 * 
		 */		
		public var members : ArrayCollection = new ArrayCollection();
		/**
		 * 
		 */		
		private var id : String; 
		/**
		 * 
		 */		
		protected var _idField : Annotation;
		/**
		 * 
		 */		
		private var defaultValue : String;
		/**
		 * 
		 */		
		protected var _defaultValueField : Annotation;
		/**
		 * 
		 */		
		private var _useChildNamespace : String;
		/**
		 *Constructor 
		 * 
		 */		
		public function XmlClass(descriptor : XML){
			super(descriptor);
		}
		/**
		 * 
		 * @param annotation
		 * 
		 */		
		public function addMember(annotation : Annotation) : void{
			if(annotation && !isFieldRegistered(annotation)){
				annotation.nameSpace = nameSpace;
				members.addItem(annotation);
				if(annotation.fieldName == id){
					_idField = annotation;
				}
				if(annotation.alias == defaultValue){
					_defaultValueField = annotation;
				}
			}
		}
		/**
		 * 
		 * @param memberFieldName
		 * @return 
		 * 
		 */		
		public function getMember(memberFieldName : String) : Annotation{
			if(fieldName && fieldName.length > 0){
				for each(var member : Annotation in members){
					if(member.fieldName == memberFieldName){
						return member;
					}
				}
			}
			return null;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get idField() : Annotation{
			return _idField;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get valueField() : Annotation{
			return _defaultValueField;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function hasDefaultValueField() : Boolean{
			return _defaultValueField != null;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get childNameSpaceFieldName() : String{
			return _useChildNamespace;
		}
		
		public function useOwnNamespace() : Boolean{
			return _useChildNamespace == null || _useChildNamespace.length == 0;
		}
		/**
		 * 
		 * @see Annotation#annotationName
		 * 
		 */		
		public override function get annotationName():String{
			return ANNOTATION_NAME;
		} 
		/**
		 * 
		 * @see Annotation#parse()
		 * 
		 */		
		protected override function parse(field:XML):void{
			super.parse(field);
			if(field.name() == "type"){
				_fieldName = _fieldName.substring(_fieldName.lastIndexOf(":") + 1);
				_fieldType = getDefinitionByName(field.@name) as Class;
			}else if(field.name() == "factory"){
				var type : String = field.@type;
				_fieldName = type.substring(type.lastIndexOf(":") + 1);
			}
			if(!alias || alias.length == 0){
				setAlias(_fieldName);
			}
		}
		/**
		 * 
		 * @see Annotation#parseMetadata()
		 * 
		 */		
		protected override function parseMetadata(metadata : XML) : void{
			nameSpace = getNamespace(metadata);
			setAlias(metadata.arg.(@key == ARGUMENT_ALIAS).@value);
			setIdField(metadata.arg.(@key == ARGUMENT_ID).@value);
			_useChildNamespace = metadata.arg.(@key == ARGUMENT_USE_CHILD_NAMESPACE).@value;
			setValueField(metadata.arg.(@key == ARGUMENT_VALUE).@value);
		}
		
		private function setIdField(field : String) : void{
			if(field && field.length > 0) {
				id = field;
			}
		}
		
		private function setValueField(field : String) : void{
			if(field && field.length > 0) {
				defaultValue = field;
			}
		}
		/**
		 * 
		 * @param metadata
		 * @return 
		 * 
		 */		
		private function getNamespace(metadata : XML) : Namespace{
			var prefix : String = metadata.arg.(@key == ARGUMENT_NAMESPACE_PREFIX).@value;
			var uri : String = metadata.arg.(@key == ARGUMENT_NAMESPACE_URI).@value;
			if(uri == null || uri.length==0){
				return null;
			}
			if(prefix.length>0){
				return new Namespace(prefix, uri);
			}
			return new Namespace(uri);			
		}
		/**
		 * 
		 * @param annotation
		 * @return 
		 * 
		 */		
		private function isFieldRegistered(annotation : Annotation) : Boolean{
			for each(var member : Annotation in members){
				if(member.fieldName == annotation.fieldName){
					return true;
				}
			}
			return false;
		}
	}
}