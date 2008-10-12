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
		protected var _ignoreOn: String = "";
		/**
		 * Constructor
		 * 
		 * 
		 */ 
		public function XmlMember(descriptor : XML){
			super(descriptor);
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
	}
}