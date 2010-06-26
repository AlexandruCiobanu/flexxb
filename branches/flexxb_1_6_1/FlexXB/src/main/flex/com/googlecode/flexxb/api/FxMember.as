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
	import com.googlecode.flexxb.annotation.XmlMember;
	import com.googlecode.flexxb.error.ApiError;
	
	import flash.errors.MemoryError;
	import flash.utils.Dictionary;

	use namespace flexxb_api_internal;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	internal class FxMember {
				
		[XmlAttribute]
		/**
		 * 
		 * @default 
		 */
		public var alias : String;
		
		[XmlAttribute]
		/**
		 * 
		 * @default 
		 */
		public var ignoreOn : Stage = null;
		
		[XmlAttribute]
		/**
		 * 
		 * @default 
		 */
		public var order : Number;
		
		/**
		 *
		 */
		protected var _field : FxField;
		/**
		 * @private
		 */		
		protected var _nameSpace : FxNamespace;
		/**
		 * @private
		 */		
		internal var owner : FxClass;

		/**
		 *
		 * @param field
		 * @param alias
		 *
		 */
		public function FxMember(field : FxField, alias : String = null) {
			this.field = field;
			this.alias = alias;
		}

		[XmlElement(alias="*")]
		/**
		 * 
		 * @return 
		 */
		public function get field() : FxField {
			return _field;
		}
		
		[XmlElement(alias="*")]
		/**
		 * 
		 * @return 
		 */
		public final function get nameSpace() : FxNamespace{
			return _nameSpace;
		}
		
		/**
		 * 
		 * @param value
		 */
		public final function set nameSpace(value : FxNamespace) : void{
			_nameSpace = value;
			if(owner){
				if(value){
					_nameSpace = owner.addNamespace(value);
				}else{
					owner.removeNamespace(value);
				}
			}
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set field(value : FxField) : void {
			if (!value) {
				throw new ApiError("Field cannot be null");
			}
			_field = value;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get fieldName() : String {
			return field.name;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get fieldType() : Class {
			return field.type;
		}

		/**
		 * 
		 * @return 
		 */
		public function get fieldAccessType() : AccessorType {
			return field.accessType;
		}
		
		/**
		 * 
		 * @param ns
		 */
		public function setNamespace(ns : Namespace) : void{
			nameSpace = FxNamespace.create(ns);
		}

		/**
		 *
		 * @see com.googlecode.flexxb.IXmlSerializable#toXml()
		 *
		 */
		public function toXml() : XML {
			var xml : XML = field.toXml();
			var metadata : XML = <metadata />;
			xml.appendChild(metadata);

			metadata.@name = getXmlAnnotationName();

			var items : Dictionary = getContent();
			
			if(items && _nameSpace){
				items[XmlMember.ARGUMENT_NAMESPACE_REF] = _nameSpace.prefix;
			}

			for (var key : *in items) {
				if (items[key] != null) {
					metadata.appendChild(<arg key={key} value={items[key]} />)
				}
			}
			return xml;
		}

		/**
		 *
		 * @return
		 *
		 */
		protected function getXmlAnnotationName() : String {
			return null;
		}

		/**
		 *
		 * @return
		 *
		 */
		protected function getContent() : Dictionary {
			var items : Dictionary = new Dictionary();
			items[Annotation.ARGUMENT_ALIAS] = alias;
			items[XmlMember.ARGUMENT_IGNORE_ON] = ignoreOn;
			if (!isNaN(order))
				items[XmlMember.ARGUMENT_ORDER] = order;
			return items;
		}
	}
}