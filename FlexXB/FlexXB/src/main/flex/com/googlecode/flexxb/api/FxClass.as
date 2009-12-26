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
package com.googlecode.flexxb.api {
	import com.googlecode.flexxb.annotation.Annotation;
	import com.googlecode.flexxb.annotation.XmlClass;
	import com.googlecode.flexxb.error.ApiError;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	use namespace flexxb_api_internal;

	[XmlClass(alias="Class")]
	[ConstructorArg(reference="type")]
	[ConstructorArg(reference="alias")]
	/**
	 * API wrapper for a class type. Allows programatically defining all the
	 * elements that would normally be specified via annotations.
	 * @author Alexutz
	 *
	 */
	public class FxClass {
		/**
		 *
		 */
		[XmlAttribute]
		/**
		 * 
		 * @default 
		 */
		public var alias : String;
		/**
		 *
		 */
		[XmlAttribute]
		/**
		 * 
		 * @default 
		 */
		public var prefix : String;
		/**
		 *
		 */
		[XmlAttribute]
		/**
		 * 
		 * @default 
		 */
		public var uri : String;
		/**
		 *
		 */
		[XmlAttribute]
		/**
		 * 
		 * @default 
		 */
		public var ordered : Boolean;
		/**
		 *
		 */
		[XmlAttribute]
		/**
		 * 
		 * @default 
		 */
		public var useNamespaceFrom : String;
		/**
		 *
		 */
		[XmlAttribute]
		/**
		 * 
		 * @default 
		 */
		public var idField : String;
		/**
		 *
		 */
		[XmlAttribute]
		/**
		 * 
		 * @default 
		 */
		public var defaultValueField : String;
		/**
		 *
		 */
		private var _members : Array = [];
		/**
		 *
		 */
		[XmlArray(alias="ConstructorArguments", memberType="com.googlecode.flexxb.api.FxConstructorArgument")]
		flexxb_api_internal var constructorArguments : Array;
		/**
		 * 
		 */		
		flexxb_api_internal var namespaces : Dictionary;
		/**
		 *
		 */
		private var _type : Class;

		/**
		 *Constructor
		 *
		 */
		public function FxClass(type : Class, alias : String = null) {
			this.type = type;
			this.alias = alias;
		}
		
		[XmlArray(alias="Members")]
		/**
		 * 
		 * @return 
		 * 
		 */		
		flexxb_api_internal function get members() : Array{
			return _members;
		}
		/**
		 * 
		 * @param value
		 * 
		 */		
		flexxb_api_internal function set members(value : Array) : void{
			_members = value;
			for each(var member : FxMember in value){
				member.owner = this;
				addNamespace(member.nameSpace);
			}
		}

		/**
		 *
		 * @return
		 *
		 */
		[XmlAttribute]
		/**
		 * 
		 * @return 
		 */
		public function get type() : Class {
			return _type;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set type(value : Class) : void {
			if (value == null) {
				throw new ApiError("Class type is null!");
			}
			_type = value;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set defaultNamespace(value : Namespace) : void {
			if (value) {
				uri = value.uri;
				prefix = value.prefix;
			}
		}
		/**
		 * 
		 * @param ns
		 * @return 
		 * 
		 */		
		internal function addNamespace(ns : FxNamespace) : FxNamespace{
			if(ns){
				if(namespaces){
					var existing : FxNamespace = namespaces[ns.prefix];
					if(existing){
						if(existing.uri != ns.uri){
							throw new Error("A namespace already exists with the same prefix but a different uri!\n Existing namespace: " + existing + "\nNamespace to add: " + ns);
						}
						return existing;
					}
				}else{
					namespaces = new Dictionary();
				}
				namespaces[ns.prefix] = ns;
			}
			return ns;
		}
		/**
		 * 
		 * @param ns
		 * 
		 */		
		internal function removeNamespace(ns : FxNamespace) : void{
			if(ns && namespaces){
				for each(var member : FxMember in members){
					if(member.nameSpace && member.nameSpace.prefix == ns.prefix){
						return;
					}
				}
				delete namespaces[ns.prefix];
			}
		}

		/**
		 *
		 * @param fieldName
		 * @param optional
		 *
		 */
		public function addArgument(fieldName : String, optional : Boolean = false) : void {
			if (!constructorArguments) {
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
		public function addAttribute(fieldName : String, fieldType : Class, access : AccessorType = null, alias : String = null) : FxAttribute {
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
		public function addElement(fieldName : String, fieldType : Class, access : AccessorType = null, alias : String = null) : FxElement {
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
		public function addArray(fieldName : String, fieldType : Class, access : AccessorType = null, alias : String = null) : FxArray {
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
		private function hasMember(name : String) : Boolean {
			for each (var member : FxMember in members) {
				if (member.fieldName == name) {
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
		public function addMember(member : FxMember) : void {
			if (hasMember(member.fieldName)) {
				throw new Error("Field <" + member.fieldName + "> has already been defined for class type " + type);
			}
			member.owner = this;
			addNamespace(member.nameSpace);
			members.push(member);
		}

		/**
		 * 
		 * @return 
		 */
		public function toXml() : XML {
			var xml : XML = <type />;
			xml.@name = getQualifiedClassName(type);
			if (constructorArguments) {
				for (var i : int = constructorArguments.length - 1; i >= 0; i--) {
					xml.appendChild((constructorArguments[i] as FxConstructorArgument).toXml());
				}
			}
			xml.appendChild(buildMetadata());
			for each (var ns : FxNamespace in namespaces) {
				xml.appendChild(ns.toXml());
			}
			for each (var member : FxMember in members) {
				xml.appendChild(member.toXml());
			}

			return xml;
		}

		private function buildMetadata() : XML {
			var xml : XML = <metadata />;
			xml.@name = XmlClass.ANNOTATION_NAME;

			var items : Dictionary = new Dictionary();
			items[Annotation.ARGUMENT_ALIAS] = alias;
			items[XmlClass.ARGUMENT_NAMESPACE_PREFIX] = prefix;
			items[XmlClass.ARGUMENT_NAMESPACE_URI] = uri;
			items[XmlClass.ARGUMENT_ORDERED] = ordered;
			items[XmlClass.ARGUMENT_USE_CHILD_NAMESPACE] = useNamespaceFrom;
			items[XmlClass.ARGUMENT_ID] = idField;
			items[XmlClass.ARGUMENT_VALUE] = defaultValueField;

			for (var key : *in items) {
				if (items[key] != null) {
					xml.appendChild(<arg key={key} value={items[key]} />)
				}
			}
			return xml;
		}

		/**
		 * 
		 * @return 
		 */
		public function toString() : String {
			return "Class[type: " + type + ", alias:" + alias + "]";
		}
	}
}