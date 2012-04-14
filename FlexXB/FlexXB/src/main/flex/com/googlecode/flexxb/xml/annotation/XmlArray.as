/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2011 Alex Ciobanu
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
package com.googlecode.flexxb.xml.annotation {
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
	import com.googlecode.flexxb.error.DescriptorParsingError;
	import com.googlecode.flexxb.util.isVector;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.StringUtil;

	/**
	 * <p>Usage: <code>[XmlArray(alias="element", memberName="NameOfArrayElement", getFromCache="true|false", 
	 * type="my.full.type" ignoreOn="serialize|deserialize", serializePartialElement="true|false", 
	 * order="order_index", namespace="Namespace_Prefix", idref="true|false", 
	 * setXsiType="true|false", version="versionName")]</code></p>
	 * @author aCiobanu
	 *
	 */
	public final class XmlArray extends XmlElement {
		/**
		 *
		 */
		public static const ANNOTATION_NAME : String = "XmlArray";
		/**
		 * @private
		 */
		private var _memberType : Class;
		/**
		 * @private
		 */
		private var _memberName : QName;
		/**
		 * @private
		 */
		private var _memberNamespaceRef: String;
		/**
		 * @private
		 */
		private var _memberNamespace: Namespace;
		/**
		 * Constructor
		 * @param descriptor
		 * @param xmlClass
		 *
		 */
		public function XmlArray(descriptor : MetaDescriptor) {
			super(descriptor);
		}

		/**
		 * Get the type of the list elements if it has been set
		 * @return
		 *
		 */
		public function get memberType() : Class {
			return _memberType;
		}

		/**
		 * Get the qualified name of list elements if it has been set
		 * @return
		 *
		 */
		public function get memberName() : QName {
			return _memberName;
		}
		/**
		 * Get the optional namespace for member
		 * @return
		 *
		 */
		public function get memberNamespaceRef() : String
		{
			return _memberNamespaceRef;
		}
		/**
		 * Get the optional namespace for member
		 * @return
		 *
		 */
		public function set memberNamespace(value:Namespace):void
		{
			_memberNamespace = value;
			if(_memberName)
			{
				_memberName = new QName(value, _memberName.localName);
			}
		}
		public function get memberNamespace():Namespace
		{
			return _memberNamespace;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function hasMemberNamespaceRef() : Boolean{
			return _memberNamespaceRef && StringUtil.trim(_memberNamespaceRef).length > 0;
		}
		
		protected override function parse(metadata : MetaDescriptor) : void {
			super.parse(metadata);
			_memberType = determineElementType(metadata);
			_memberNamespaceRef = metadata.attributes[XmlConstants.MEMBER_NAMESPACE];
			var arrayMemberName : String = metadata.attributes[XmlConstants.MEMBER_NAME];
			if (arrayMemberName) {
				var ns:Namespace = memberNamespace?memberNamespace:nameSpace;
				_memberName = new QName(ns, arrayMemberName);
			}
		}
		
		public override function get annotationName() : String {
			return ANNOTATION_NAME;
		}
		
		private function determineElementType(metadata : MetaDescriptor) : Class{
			var type : Class;
			//handle the vector type. We need to check for it first as it will override settings in the member type 
			var classType : String = getQualifiedClassName(metadata.fieldType);
			if(isVector(classType)){
				if(classType.lastIndexOf("<") > -1){
					classType = classType.substring(classType.lastIndexOf("<") + 1, classType.length - 1);
				}
			}else{
				classType = metadata.attributes[XmlConstants.TYPE];
			}
			if (classType) {
				try {
					type = getDefinitionByName(classType) as Class;
				} catch (e : Error) {
					throw new DescriptorParsingError(ownerClass.type, memberName.localName, "Member type <<" + classType + ">> can't be found as specified in the metadata. Make sure you spelled it correctly"); 
				}
			}
			return type;
		}
	}
}