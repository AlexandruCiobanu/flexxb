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
	import com.googlecode.flexxb.api.AccessorType;
	import com.googlecode.flexxb.api.Stage;
	import com.googlecode.flexxb.error.DescriptorParsingError;
	
	import mx.utils.StringUtil;

	/**
	 * Defines a member of an XmlClass, that is, a field of the class definition.
	 * The XmlMember is base for XmlAttribute and XmlElement since field values can
	 * be rendered as XML in the form of attributes or elements.
	 * <p/>A member's alias can define "virtual paths". Virtual paths allow definition
	 * of complex xml structures for a field without complicating the model design. Thus,
	 * structures can be present in the xml just by adding vistual paths in the alias
	 * definition of a member.
	 * <p/>Example: Lets assume the xml representation looks like:
	 * <p/><code><pre>
	 * &lt;myPathTester&gt;
	 *	  &lt;anotherSub attTest="Thu Mar 19 15:49:32 GMT+0200 2009"/&gt;
	 *	  This is Default!!!
	 *	  &lt;subObject&gt;
	 *	    &lt;id&gt;
	 *	      2
	 *	    &lt;/id&gt;
	 *	    &lt;subSubObj&gt;
	 *	      &lt;ref&gt;
	 *	        ReferenceTo
	 *	      &lt;/ref&gt;
	 *	    &lt;/subSubObj&gt;
	 *	  &lt;/subObject&gt;
	 *	&lt;/myPathTester&gt;
	 * </pre></code>
	 * <p/>This would normally translate itself in about 4 model classes. Using virtual paths, one can describe it in just one model class:
	 * <p/><code><pre>
	 * [XmlClass(alias="myPathTester", defaultValueField="defaultTest")]
	 *	public class XmlPathObject
	 *	{
	 *		[XmlElement(alias="subObject/id")]
	 *		public var identity : Number = 2;
	 *		[XmlElement(alias="subObject/subSubObj/ref")]
	 *		public var reference : String = "ReferenceTo";
	 *		[XmlArray(alias="subObject/list")]
	 *		public var list : Array;
	 *		[XmlAttribute(alias="anotherSub/attTest")]
	 *		public var test : Date = new Date();
	 *		[XmlElement()]
	 *		public var defaultTest : String = "This is Default!!!"
	 *
	 *		public function XmlPathObject()
	 *		{
	 *		}
	 *	}
	 * </pre></code>
	 * @author aCiobanu
	 *
	 */
	public class XmlMember extends Annotation {
		/**
		 * IgnoreOn attribute name
		 */
		public static const ARGUMENT_IGNORE_ON : String = "ignoreOn";
		/**
		 * Order attribute name
		 */
		public static const ARGUMENT_ORDER : String = "order";
		/**
		 * Path separator used for defining virtual paths in the alias
		 */
		public static const ALIAS_PATH_SEPARATOR : String = "/";
		/**
		 * 
		 */		
		public static const ARGUMENT_NAMESPACE_REF : String = "namespace";
		/**
		 * 
		 */		
		public static const ARGUMENT_DEFAULT : String = "default";
		/**
		 * @private
		 */
		protected var _ignoreOn : Stage;
		/**
		 * @private
		 */
		protected var _order : Number;
		/**
		 * @private
		 */
		protected var _class : XmlClass;
		/**
		 * @private 
		 */		
		protected var _nsRef : String;
		/**
		 * @private
		 */
		private var pathElements : Array;
		/**
		 * @private
		 */
		private var _accessorType : AccessorType;
		/**
		 * @private 
		 */		
		private var _default : String;
		/**
		 * Constructor
		 * @param descriptor xml descriptor of the class field
		 * @param _class owner XmlClass entity
		 *
		 */
		public function XmlMember(descriptor : XML, _class : XmlClass) {
			super(descriptor);
			this._class = _class;
		}
		
		public override function set nameSpace(value : Namespace) : void{
			super.nameSpace = value;
			if(isPath()){
				var path : QName;
				for(var i : int = 0; i < pathElements.length; i++){
					path = pathElements[i] as QName;
					pathElements[i] = new QName(value, path.localName);
				}
			}
		}
		/**
		 * Check if this member is marked as default in the (de)serialization process
		 * @return true if the member is default, false otherwise
		 *
		 */
		public function isDefaultValue() : Boolean {
			return _class && _class.valueField == this;
		}

		/**
		 * Get the readOnly flag
		 * @return
		 *
		 */
		public function get readOnly() : Boolean {
			return _accessorType.isReadOnly();
		}

		/**
		 * Get the writeOnly flag
		 * @return
		 *
		 */
		public function get writeOnly() : Boolean {
			return _accessorType.isWriteOnly();
		}
		
		/**
		 * Get the namespace reference value
		 * @return
		 *
		 */
		public function get namespaceRef() : String {
			return _nsRef;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get defaultSetValue() : String{
			return _default;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function hasNamespaceRef() : Boolean{
			return _nsRef && StringUtil.trim(_nsRef).length > 0;
		}

		/**
		 * Check if the alias defines virtual paths
		 * @return true if virtual paths are defined, false otherwise
		 *
		 */
		public function isPath() : Boolean {
			return pathElements && pathElements.length > 0;
		}

		/**
		 * Get the list of virtual path consituents
		 * @return Array containing pathe elements
		 *
		 */
		public function get qualifiedPathElements() : Array {
			return pathElements;
		}

		/**
		 * Get the order flag
		 * @return
		 *
		 */
		public function get order() : Number {
			return _order;
		}

		/**
		 * Get the ignoreOn flag
		 * @return
		 *
		 */
		public function get ignoreOn() : Stage {
			return _ignoreOn;
		}

		/**
		 * Get the owner XmlClass entity
		 * @return
		 *
		 */
		public function get ownerClass() : XmlClass {
			return _class;
		}

		/**
		 * Set the ignoreOn flag. Restrictions apply when setting this flag in
		 * compliance with the class field's accessType.
		 * You cannot set the flag to <code>serialize</code> if the access type is <code>writeOnly</code>.
		 * You cannot set the flag to <code>deserialize</code> if the access type is <code>readOnly</code>.
		 * @param value Stage
		 *
		 */
		public function set ignoreOn(value : Stage) : void {
			if (readOnly) {
				_ignoreOn = Stage.DESERIALIZE;
				return;
			}
			if (writeOnly) {
				_ignoreOn = Stage.SERIALIZE;
				return;
			}
			if (value) {
				_ignoreOn = value;
			}
		}

		/**
		 *
		 * @private
		 *
		 */
		protected override function parse(field : XML) : void {
			_accessorType = AccessorType.fromString(field.@access);
			super.parse(field);
		}

		/**
		 *
		 * @see Annotation#parseMetadata()
		 *
		 */
		protected override function parseMetadata(metadata : XML) : void {
			_nsRef = metadata.arg.(@key == ARGUMENT_NAMESPACE_REF).@value;
			setAlias(metadata.arg.(@key == ARGUMENT_ALIAS).@value);
			ignoreOn = Stage.fromString(metadata.arg.(@key == ARGUMENT_IGNORE_ON).@value);
			setOrder(metadata.arg.(@key == ARGUMENT_ORDER).@value);
			_default = metadata.arg.(@key == ARGUMENT_DEFAULT).@value;
		}
		/**
		 *
		 * @private
		 *
		 */
		protected function setOrder(value : String) : void {
			if (value) {
				var nr : Number;
				try {
					nr = Number(value);
				} catch (error : Error) {
					throw new DescriptorParsingError(ownerClass.fieldType, fieldName.localName, "The order attribute of the annotation is invalid as number");
				}
				_order = nr;
			}
		}

		/**
		 *
		 * @see Annotation#setAlias()
		 *
		 */
		protected override function setAlias(value : String) : void {
			if (value && value.indexOf(ALIAS_PATH_SEPARATOR) > 0) {
				var elems : Array = value.split(ALIAS_PATH_SEPARATOR);
				pathElements = [];
				var localName : String;
				for (var i : int = 0; i < elems.length; i++) {
					localName = elems[i] as String;
					if (localName && localName.length > 0) {
						if (i == elems.length - 1) {
							super.setAlias(localName);
							break;
						}
						pathElements.push(new QName(nameSpace, localName));
					}
				}
			} else {
				super.setAlias(value);
			}
		}
	}
}