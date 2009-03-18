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
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	public class XmlMember extends Annotation
	{
		/**
		 * 
		 */		
		public static const IGNORE_ON_SERIALIZE : String = "serialize";
		/**
		 * 
		 */		
		public static const IGNORE_ON_DESERIALIZE : String = "deserialize";
		/**
		 * 
		 */		
		public static const ARGUMENT_IGNORE_ON : String = "ignoreOn";
		/**
		 * 
		 */		
		public static const ALIAS_PATH_SEPARATOR : String = "/";
		/**
		 * 
		 */ 
		protected var _ignoreOn: String = "";
		/**
		 * 
		 */		
		protected var _class : XmlClass;
		/**
		 * 
		 */		
		private var pathElements : Array;
		/**
		 * Constructor
		 * 
		 * 
		 */ 
		public function XmlMember(descriptor : XML, _class : XmlClass){
			super(descriptor);
			this._class = _class;
		}
		/**
		 * 
		 * @return 
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
		public function isPath() : Boolean{
			return pathElements && pathElements.length > 0;
		}
		/**
		 * 
		 * @return 
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
		public function get ignoreOn() : String{
			return _ignoreOn;
		}
		/**
		 * 
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
			if(value == "" || value == IGNORE_ON_SERIALIZE || value == IGNORE_ON_DESERIALIZE){
				_ignoreOn = value;
			}
		}
		/**
		 * 
		 * @see Annotation#parseMetadata()
		 * 
		 */	
		protected override function parseMetadata(metadata : XML) : void{
			setAlias(metadata.arg.(@key == ARGUMENT_ALIAS).@value);
			ignoreOn = metadata.arg.(@key == ARGUMENT_IGNORE_ON).@value;
		}		
		/**
		 * 
		 * @param value
		 * 
		 */		
		protected override function setAlias(value:String):void{
			if(value && value.indexOf(ALIAS_PATH_SEPARATOR) > 0){
				var elems : Array = alias.split(ALIAS_PATH_SEPARATOR);
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