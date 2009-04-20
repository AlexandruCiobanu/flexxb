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
package com.googlecode.flexxb.api
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class FxAttribute extends FxMember
	{
		/**
		 * 
		 * @param name
		 * @param type
		 * @param accessType
		 * @param alias
		 * @return 
		 * 
		 */		
		public static function create(name : String, type : Class, accessType : AccessorType = null, alias : String = null) : FxAttribute{
			var field : FxField = new FxField(name, type, accessType);
			var attribute : FxAttribute = new FxAttribute(field, alias);
			return attribute;
		}
		/**
		 * 
		 * @param field
		 * @param alias
		 * 
		 */		
		public function FxAttribute(field : FxField, alias : String = null)
		{
			super(field, alias);
		}	
			
		protected override function getXmlAnnotationName() : String{
			return "XmlAttribute";
		}
	}
}