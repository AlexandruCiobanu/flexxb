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
	import com.googlecode.flexxb.error.DescriptorParsingError;
	
	/**
	 * Defines a member of an XmlClass, that is, a field of the class definition. 
	 * The XmlMember is base for XmlAttribute and XmlElement since field values can 
	 * be rendered as XML in the form of attributes or elements.
	 * <p>A member's alias can define "virtual paths". Virtual paths allow definition 
	 * of complex xml structures for a field without complicating the model design. Thus,
	 * structures can be present in the xml just by adding vistual paths in the alias 
	 * definition of a member.
	 * <p>Example: Lets assume the xml representation looks like:
	 * <p><code><pre>
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
	 * <p>This would normally translate itself in about 4 model classes. Using virtual paths, one can describe it in just one model class:
	 * <p><code><pre>
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
	 * <pre></code> 
	 * @author aCiobanu
	 * 
	 */	
	public class XmlMember extends Annotation
	{
		/**
		 * Do not serialize this member 
		 */		
		public static const IGNORE_ON_SERIALIZE : String = "serialize";
		/**
		 * Do not deserialize this member
		 */		
		public static const IGNORE_ON_DESERIALIZE : String = "deserialize";
		/**
		 * 
		 */		
		public static const ARGUMENT_IGNORE_ON : String = "ignoreOn";
		/**
		 * 
		 */		
		public static const ARGUMENT_ORDER : String = "order";
		/**
		 * Path separator used for defining virtual paths in the alias
		 */		
		public static const ALIAS_PATH_SEPARATOR : String = "/";
		/**
		 * @private
		 */ 
		protected var _ignoreOn: String = "";
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
		private var pathElements : Array;
		/**
		 *@private 
		 */		
		private var _accessorType : int;
		/**
		 * Constructor 
		 * @param descriptor xml descriptor of the class' field
		 * @param _class owner XmlClass entity
		 * 
		 */		 
		public function XmlMember(descriptor : XML, _class : XmlClass){
			super(descriptor);
			this._class = _class;
		}
		/**
		 * Check if this member is marked as default in the (de)serialization process
		 * @return true if the member is default, false otherwise
		 * 
		 */		
		public function isDefaultValue() : Boolean{
			return _class && _class.valueField == this;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get readOnly() : Boolean{
			return AccessorType.isReadOnly(_accessorType);
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get writeOnly() : Boolean{
			return AccessorType.isWriteOnly(_accessorType);
		}
		/**
		 * Chenck if the alias defines virtual paths
		 * @return true if virtual paths are defined, false otherwise
		 * 
		 */		
		public function isPath() : Boolean{
			return pathElements && pathElements.length > 0;
		}
		/**
		 * Get the list of virtual path consituents
		 * @return Array containing pathe elements
		 * 
		 */		
		public function get qualifiedPathElements() : Array{
			return pathElements;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get order() : Number{
			return _order;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get ignoreOn() : String{
			return _ignoreOn;
		}
		/**
		 * Get the owner XmlClass entity
		 * @return 
		 * 
		 */		
		public function get ownerClass() : XmlClass{
			return _class;
		}
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set ignoreOn(value : String) : void{
			if(readOnly){
				_ignoreOn = IGNORE_ON_DESERIALIZE;
				return;
			}
			if(writeOnly){
				_ignoreOn = IGNORE_ON_SERIALIZE;
				return;
			}
			if(value == "" || value == IGNORE_ON_SERIALIZE || value == IGNORE_ON_DESERIALIZE){
				_ignoreOn = value;
			}
		}
		
		protected override function parse(field : XML):void{
			_accessorType = AccessorType.getAccessorType(field);
			super.parse(field);
		}
		/**
		 * 
		 * @see Annotation#parseMetadata()
		 * 
		 */	
		protected override function parseMetadata(metadata : XML) : void{
			setAlias(metadata.arg.(@key == ARGUMENT_ALIAS).@value);
			ignoreOn = metadata.arg.(@key == ARGUMENT_IGNORE_ON).@value;
			setOrder(metadata.arg.(@key == ARGUMENT_ORDER).@value)
		}		
		
		protected function setOrder(value : String) : void{
			if(value){
				var nr : Number;
				try{
					nr = Number(value);
				}catch(error : Error){
					throw new DescriptorParsingError(ownerClass.fieldType, fieldName, "The order attribute of the annotation is invalid as number");
				}
				_order = nr;
			}
		}
		/**
		 * 
		 * @see Annotation#setAlias()
		 * 
		 */		
		protected override function setAlias(value:String):void{
			if(value && value.indexOf(ALIAS_PATH_SEPARATOR) > 0){
				var elems : Array = value.split(ALIAS_PATH_SEPARATOR);
				pathElements = [];
				var localName : String;
				for (var i : int = 0; i < elems.length ; i++){
					localName = elems[i] as String;
					if(localName && localName.length > 0){
						if(i == elems.length - 1){
							super.setAlias(localName);
							break;
						}
						pathElements.push(new QName(nameSpace, localName));
					}
				}
			}else{
				super.setAlias(value);
			}
		} 
	}
}