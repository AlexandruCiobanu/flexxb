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
 package com.googlecode.serializer.flexxb
{
	/**
	 * <p>Usage: <code>[XmlArray(alias="element", getFromCache="true|false", type="my.full.type" ignoreOn="serialize|deserialize", serializePartialElement="true|false")]</code></p>
	 * @author aCiobanu
	 * 
	 */	
	public final class XmlArray extends XmlElement
	{
		/**
		 * 
		 */		
		public static const ANNOTATION_NAME : String = "XmlArray";
		/**
		 * 
		 */		
		public static const ARGUMENT_TYPE : String = "type";
		/**
		 * 
		 */ 
		protected var _type : String = "*";
		/**
		 * Constructor
		 * 
		 */		
		public function XmlArray(descriptor : XML){
			super(descriptor);
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get type() : String{
			return _type;
		}
		/**
		 * 
		 * @see Annotation#parseMetadata()
		 * 
		 */	
		protected override function parseMetadata(metadata : XML) : void{
			super.parseMetadata(metadata);
			_type =  metadata.arg.(@key == ARGUMENT_TYPE).@value;
			if(_type == ""){
				_type = "*";
			}
		}
		/**
		 * 
		 * @see Annotation#annotationName
		 * 
		 */
		public override function get annotationName():String{
			return ANNOTATION_NAME;
		}		
	}
}