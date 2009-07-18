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
package com.googlecode.flexxb.annotation
{
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
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
		public static const ARGUMENT_ORDERED : String = "ordered";
		/**
		 * Class members
		 */		
		public var members : ArrayCollection = new ArrayCollection();
		/**
		 * @private
		 */		
		private var id : String; 
		/**
		 * @private
		 */		
		protected var _idField : Annotation;
		/**
		 * @private
		 */		
		private var defaultValue : String;
		/**
		 * @private
		 */		
		protected var _defaultValueField : Annotation;
		/**
		 * @private
		 */		
		private var _useChildNamespace : String;
		/**
		 * @private
		 */		
		private var _ordered : Boolean;
		/**
		 * @private
		 */		
		private var _constructor : Constructor;
		/**
		 *Constructor 
		 * 
		 */		
		public function XmlClass(descriptor : XML){
			_constructor = new Constructor(this);
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
				if(annotation.fieldName.localName == id){
					_idField = annotation;
				}
				if(annotation.alias == defaultValue){
					_defaultValueField = annotation;
				}
			}
		}
		/**
		 * 
		 * 
		 */		
		public function memberAddFinished() : void{
			if(ordered){
				var sort : Sort = new Sort();
				var fields : Array = [];
				fields.push(new SortField("order", false, false, true));
				fields.push(new SortField("alias", true, false, false));
				sort.fields = fields;
				members.sort = sort;
				members.refresh();
			}
		}
		/**
		 * 
		 * @param memberFieldName
		 * @return 
		 * 
		 */		
		public function getMember(memberFieldName : String) : Annotation{
			if(memberFieldName && memberFieldName.length > 0){
				for each(var member : Annotation in members){
					if(member.fieldName.localName == memberFieldName){
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
		public function get constructor() : Constructor{
			return _constructor;
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
		public function get ordered() : Boolean{
			return _ordered;
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
		/**
		 * 
		 * @return 
		 * 
		 */		
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
		protected override function parse(descriptor : XML):void{
			super.parse(descriptor);
			var type : String = descriptor.@type;
			if(!type){
				type = descriptor.@name;
			}
			_fieldName = new QName(null, type.substring(type.lastIndexOf(":") + 1));
			_fieldType = getDefinitionByName(type) as Class;
			if(!alias || alias.length == 0 || alias == type){
				setAlias(_fieldName.localName);
			}
			if(descriptor.factory.length() > 0){
				descriptor = descriptor.factory[0];
			}
			processMembers(descriptor);
			constructor.parse(descriptor);
		}
		/**
		 * @private
		 * 
		 */		
		protected function processMembers(descriptor : XML) : void{
			var field : XML;
			for each(field in descriptor..variable){
				addMember(AnnotationFactory.instance.getAnnotation(field, this));
			}
			for each(field in descriptor..accessor){
				addMember(AnnotationFactory.instance.getAnnotation(field, this));
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
			setOrdered(metadata.arg.(@key == ARGUMENT_ORDERED).@value);
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
		
		private function setOrdered(value : String) : void{
			if(value && value.length > 0) {
				_ordered = value == "true";
			}
		}
			
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