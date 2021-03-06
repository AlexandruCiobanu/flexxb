/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2012 Alex Ciobanu
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

	/**
	 * Usage: <code>[XmlElement(alias="element", getFromCache="true|false", 
	 * ignoreOn="serialize|deserialize", serializePartialElement="true|false", 
	 * order="order_index", getRuntimeType="true|false", namespace="Namespace_Prefix", 
	 * default="DEFAULT_VALUE", idref="true|false", setXsiType="true|false", 
	 * version="versionName")]</code>
	 * @author aCiobanu
	 *
	 */
	public class XmlElement extends XmlMember {
		/**
		 * Annotation's name
		 */
		public static const ANNOTATION_NAME : String = "XmlElement";
		/**
		 * @private
		 */
		protected var _serializePartialElement : Boolean;
		/**
		 * @private
		 */
		protected var _getFromCache : Boolean;
		/**
		 *@private
		 */
		protected var _getRuntimeType : Boolean;
		/**
		 * @private 
		 */		
		protected var _setXsiType : Boolean;
		/**
		 * @private 
		 */		
		protected var _nillable : Boolean;
		
		/**
		 * @private 
		 */		
		protected var _wrapCdata : Boolean;
		
		/**
		 * Constructor
		 * @param descriptor
		 * @param xmlClass
		 *
		 */
		public function XmlElement(descriptor : MetaDescriptor) {
			super(descriptor);
		}

		/**
		 * Get serializePartialElement flag
		 * @return
		 *
		 */
		public function get serializePartialElement() : Boolean {
			return _serializePartialElement;
		}
		/**
		 *
		 * @return
		 *
		 */
		public function get getRuntimeType() : Boolean {
			return _getRuntimeType;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get setXsiType() : Boolean{
			return _setXsiType;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get nillable() : Boolean{
			return _nillable;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get wrapCDATA() : Boolean{
			return _wrapCdata;
		}
		
		
		/**
		 * Returns required if nillable is true
		 * @return 
		 * 
		 */	
		override public function get isRequired() : Boolean{
			return super.isRequired || nillable;
		}

		/**
		 * Get getFromCache flag
		 * @return
		 *
		 */
		public function get getFromCache() : Boolean {
			return _getFromCache;
		}
		
		protected override function parse(metadata : MetaDescriptor) : void {
			super.parse(metadata);
			_serializePartialElement = metadata.getBoolean(XmlConstants.SERIALIZE_PARTIAL_ELEMENT);
			_getFromCache = metadata.getBoolean(XmlConstants.GET_FROM_CACHE);
			_getRuntimeType = metadata.getBoolean(XmlConstants.GET_RUNTIME_TYPE);
			_setXsiType = metadata.getBoolean(XmlConstants.SET_XSI_TYPE);
			_nillable = metadata.getBoolean(XmlConstants.NILLABLE);
			_wrapCdata = metadata.getBoolean(XmlConstants.WRAP_CDATA);
		}
		
		public override function get annotationName() : String {
			return ANNOTATION_NAME;
		}
	}
}