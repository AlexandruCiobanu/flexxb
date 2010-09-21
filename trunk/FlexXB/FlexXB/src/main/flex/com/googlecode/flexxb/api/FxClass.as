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
		 * Class alias
		 * @default 
		 */
		public var alias : String;
		/**
		 *
		 */
		[XmlAttribute]
		/**
		 * Namespace prefix
		 * @default 
		 */
		public var prefix : String;
		/**
		 *
		 */
		[XmlAttribute]
		/**
		 * Namespace uri
		 * @default 
		 */
		public var uri : String;
		/**
		 *
		 */
		[XmlAttribute]
		/**
		 * Flag signaling whether the class members are ordered or not in the xml processing stages
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
		 * Name of the field which will be considered as an identifier for the class instance
		 * @default 
		 */
		public var idField : String;
		/**
		 *
		 */
		[XmlAttribute]
		/**
		 * Name of the field which is considered to be the default value
		 * @default 
		 */
		public var defaultValueField : String;
		/**
		 *
		 */
		private var _members : Array = [];
		/**
		 * Constructor argument list
		 */
		[XmlArray(alias="ConstructorArguments", memberType="com.googlecode.flexxb.api.FxConstructorArgument")]
		flexxb_api_internal var constructorArguments : Array;
		/**
		 * Class namespace list
		 */		
		flexxb_api_internal var namespaces : Dictionary;
		/**
		 *
		 */
		private var _type : Class;

		/**
		 * Constructor
		 * @param	type class type
		 * @param	alias class alias
		 */
		public function FxClass(type : Class, alias : String = null) {
			this.type = type;
			this.alias = alias;
		}
		
		[XmlArray(alias="Members")]
		/**
		 * Get the class members
		 * @return Array of FxMember items 
		 * 
		 */		
		flexxb_api_internal function get members() : Array{
			return _members;
		}
		/**
		 * Set the class members
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

		[XmlAttribute]
		/**
		 * Get the type
		 * @return 
		 */
		public function get type() : Class {
			return _type;
		}

		/**
		 * Set the type
		 * @param value type
		 *
		 */
		public function set type(value : Class) : void {
			if (value == null) {
				throw new ApiError("Class type is null!");
			}
			_type = value;
		}

		/**
		 * Set the default namespace for this class
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
		 * Add a namespace to the class namespace list
		 * @param ns target namespace
		 * @return reference to the target namespace
		 * @throws error if the namespace is already registered in the class' namespace list
		 * @see FxNamesapce
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
		 * Remove a namespace from the class namespace list
		 * @param ns target namespace
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
		 * Add a constructor argument. Arguments are used in order to correctly instantiate objects upon deserialization
		 * taking into account default and parameterized constructor. 
		 * @param fieldName field name
		 * @param optional Flag signaling whether the argument is optional or not (eg. default valued parameters)
		 *
		 */
		public function addArgument(fieldName : String, optional : Boolean = false) : void {
			if (!constructorArguments) {
				constructorArguments = [];
			}
			constructorArguments.push(new FxConstructorArgument(fieldName, optional));
		}

		/**
		 * Add a field mapped to an xml attribute
		 * @param fieldName name of the target field
		 * @param fieldType type of the target field
		 * @param access field access type
		 * @param alias field alias in the xml mapping
		 * @return FxAttribute instance
		 * @see FxAttribute
		 * @see AccessorType
		 *
		 */
		public function addAttribute(fieldName : String, fieldType : Class, access : AccessorType = null, alias : String = null) : FxAttribute {
			var attribute : FxAttribute = FxAttribute.create(fieldName, fieldType, access, alias);
			addMember(attribute);
			return attribute;
		}

		/**
		 * Add a field mapped to an xml element
		 * @param fieldName name of the target field
		 * @param fieldType type of the target field
		 * @param access field access type
		 * @param alias field alias in the xml mapping
		 * @return FxElement instance
		 * @see FxElement
		 * @see AccessorType
		 *
		 */
		public function addElement(fieldName : String, fieldType : Class, access : AccessorType = null, alias : String = null) : FxElement {
			var element : FxElement = FxElement.create(fieldName, fieldType, access, alias);
			addMember(element);
			return element;
		}

		/**
		 * Add an array field mapped to an xml element
		 * @param fieldName name of the target field
		 * @param fieldType type of the target field (Array, ArrayCollection, ListCollectionView etc.)
		 * @param access field access type
		 * @param alias field alias in the xml mapping
		 * @return FxArray instance
		 * @see FxArray
		 * @see AccessorType
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
		 * Add a class member 
		 * @param member class member (subclass of FxMember)
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

			for (var key : * in items) {
				if (items[key] != null) {
					xml.appendChild(<arg key={key} value={items[key]} />)
				}
			}
			return xml;
		}

		/**
		 * Get string representation of the current instance
		 * @return string representing the current instance
		 */
		public function toString() : String {
			return "Class[type: " + type + ", alias:" + alias + "]";
		}
	}
}