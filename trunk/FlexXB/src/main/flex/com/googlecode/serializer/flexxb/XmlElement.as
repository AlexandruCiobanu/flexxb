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
	 * Usage: <code>[XmlElement(alias="element", getFromCache="true|false", ignoreOn="serialize|deserialize", serializePartialElement="true|false")]</code>
	 * @author aCiobanu
	 * 
	 */
	public class XmlElement extends XmlMember
	{
		/**
		 * 
		 */		
		public static const ANNOTATION_NAME : String = "XmlElement";
		/**
		 * 
		 */		
		public static const ARGUMENT_SERIALIZE_PARTIAL_ELEMENT : String = "serializePartialElement";
		/**
		 * 
		 */
		protected var _serializePartialElement : Boolean;
		/**
		 * 
		 */		
		protected var _getFromCache : Boolean;
		
		public function XmlElement(descriptor : XML){
			super(descriptor);
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get serializePartialElement() : Boolean{
			return _serializePartialElement;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get getFromCache() : Boolean{
			return _getFromCache;
		}
		/**
		 * 
		 * @see Annotation#parseMetadata()
		 * 
		 */	
		protected override function parseMetadata(metadata : XML):void{
			super.parseMetadata(metadata);
			_serializePartialElement = metadata.arg.(@key == ARGUMENT_SERIALIZE_PARTIAL_ELEMENT).@value == "true";
			_getFromCache =  metadata.arg.(@key == ARGUMENT_IGNORE_ON).@value == "true";
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