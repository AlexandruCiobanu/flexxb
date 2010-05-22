/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */
package com.googlecode.flexxb.annotation {
	import com.googlecode.flexxb.error.DescriptorParsingError;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;

	/**
	 *
	 * <p>Usage: <code>[XmlClass(alias="MyClass", useNamespaceFrom="elementFieldName", idField="idFieldName", prefix="my", uri="http://www.your.site.com/schema/", defaultValueField="fieldName", ordered="true|false")]</code></p>
	 * @author aCiobanu
	 *
	 */
	public final class XmlClass extends Annotation {
		/**
		 * Annotation's name
		 */
		public static const ANNOTATION_NAME : String = "XmlClass";
		/**
		 * Namespace prefix
		 */
		public static const ARGUMENT_NAMESPACE_PREFIX : String = "prefix";
		/**
		 * 
		 */		
		public static const ARGUMENT_NAMESPACE : String = "Namespace";
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
		 * @private
		 */		
		private var _namespaces : Dictionary;

		/**
		 *Constructor
		 *
		 */
		public function XmlClass(descriptor : XML) {
			_constructor = new Constructor(this);
			super(descriptor);
		}

		/**
		 *
		 * @param annotation
		 *
		 */
		public function addMember(annotation : XmlMember) : void {
			if (annotation && !isFieldRegistered(annotation)) {
				if(annotation.hasNamespaceRef()){
					annotation.nameSpace = getRegisteredNamespace(annotation.namespaceRef);
				}else{
					annotation.nameSpace = nameSpace;
				}
				members.addItem(annotation);
				if (annotation.fieldName.localName == id) {
					_idField = annotation;
				}
				if (annotation.alias == defaultValue) {
					_defaultValueField = annotation;
				}
			}
		}

		/**
		 *
		 *
		 */
		public function memberAddFinished() : void {
			//Flex SDK 4 hotfix: we need to put the default field first, if it exists,
			// otherwise the default text will be added as a child of a previous element 
			var member : XmlMember;
			for (var i : int = 0; i < members.length; i++){
				member = members[i] as XmlMember;
				if(member.isDefaultValue()){
					members.addItemAt(members.removeItemAt(i), 0);
					break;
				}
			}
			if (ordered) {
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
		public function getMember(memberFieldName : String) : Annotation {
			if (memberFieldName && memberFieldName.length > 0) {
				for each (var member : Annotation in members) {
					if (member.fieldName.localName == memberFieldName) {
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
		public function get constructor() : Constructor {
			return _constructor;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get idField() : Annotation {
			return _idField;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get valueField() : Annotation {
			return _defaultValueField;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get ordered() : Boolean {
			return _ordered;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function hasDefaultValueField() : Boolean {
			return _defaultValueField != null;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get childNameSpaceFieldName() : String {
			return _useChildNamespace;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function useOwnNamespace() : Boolean {
			return _useChildNamespace == null || _useChildNamespace.length == 0;
		}

		/**
		 *
		 * @see Annotation#annotationName
		 *
		 */
		public override function get annotationName() : String {
			return ANNOTATION_NAME;
		}

		/**
		 *
		 * @see Annotation#parse()
		 *
		 */
		protected override function parse(descriptor : XML) : void {
			//super.parse(descriptor);
			var type : String = descriptor.@type;
			if (!type) {
				type = descriptor.@name;
			}
			_fieldName = new QName(null, type.substring(type.lastIndexOf(":") + 1));
			_fieldType = getDefinitionByName(type) as Class;
			if (!alias || alias.length == 0 || alias == type) {
				setAlias(_fieldName.localName);
			}
			var metadata : XMLList = descriptor.metadata.(@name == annotationName);
			if (metadata.length() > 0) {
				parseMetadata(metadata[0]);
			}
			if (descriptor.factory.length() > 0) {
				descriptor = descriptor.factory[0];
			}
			processNamespaces(descriptor);
			processMembers(descriptor);
			constructor.parse(descriptor);
		}

		/**
		 * @private
		 *
		 */
		protected function processMembers(descriptor : XML) : void {
			var field : XML;
			for each (field in descriptor..variable) {
				addMember(AnnotationFactory.instance.getAnnotation(field, this) as XmlMember);
			}
			for each (field in descriptor..accessor) {
				addMember(AnnotationFactory.instance.getAnnotation(field, this) as XmlMember);
			}
		}

		/**
		 *
		 * @see Annotation#parseMetadata()
		 *
		 */
		protected override function parseMetadata(metadata : XML) : void {
			nameSpace = getNamespace(metadata);
			setAlias(metadata.arg.(@key == ARGUMENT_ALIAS).@value);
			setIdField(metadata.arg.(@key == ARGUMENT_ID).@value);
			_useChildNamespace = metadata.arg.(@key == ARGUMENT_USE_CHILD_NAMESPACE).@value;
			setValueField(metadata.arg.(@key == ARGUMENT_VALUE).@value);
			setOrdered(metadata.arg.(@key == ARGUMENT_ORDERED).@value);
		}

		private function setIdField(field : String) : void {
			if (field && field.length > 0) {
				id = field;
			}
		}

		private function setValueField(field : String) : void {
			if (field && field.length > 0) {
				defaultValue = field;
			}
		}

		private function setOrdered(value : String) : void {
			if (value && value.length > 0) {
				_ordered = value == "true";
			}
		}
		
		private function processNamespaces(descriptor : XML) : void{
			var nss : XMLList = descriptor.metadata.(@name=="Namespace");
			if(nss.length() > 0){
				_namespaces = new Dictionary();
				var ns : Namespace;
				for each(var nsXml : XML in nss){
					ns = getNamespace(nsXml);
					_namespaces[ns.prefix] = ns;
				}
			}
		}
		
		private function getRegisteredNamespace(ref : String) : Namespace{
			if(!_namespaces || !_namespaces[ref]){
				throw new DescriptorParsingError(fieldType, "", "Namespace reference <<" + ref + ">> could not be found. Make sure you typed the prefix correctly and the namespace is registered as annotation of the containing class.");
			}
			return _namespaces[ref] as Namespace;
		}

		private function getNamespace(metadata : XML) : Namespace {
			var prefix : String = metadata.arg.(@key == ARGUMENT_NAMESPACE_PREFIX).@value;
			var uri : String = metadata.arg.(@key == ARGUMENT_NAMESPACE_URI).@value;
			if (uri == null || uri.length == 0) {
				return null;
			}
			if (prefix.length > 0) {
				return new Namespace(prefix, uri);
			}
			return new Namespace(uri);
		}

		private function isFieldRegistered(annotation : Annotation) : Boolean {
			for each (var member : Annotation in members) {
				if (member.fieldName == annotation.fieldName) {
					return true;
				}
			}
			return false;
		}
	}
}