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
 package com.googlecode.flexxb.converter
{
	import com.googlecode.flexxb.FlexXBEngine;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * Converter for Class objects
	 * @author Alexutz
	 * 
	 */	
	internal class ClassTypeConverter implements IConverter
	{
		{
			FlexXBEngine.instance.registerSimpleTypeConverter(new ClassTypeConverter());
		}
		
		public function get type():Class
		{
			return Class;
		}
		
		public function toString(object:Object):String
		{
			return getQualifiedClassName(object);
		}
		
		public function fromString(value:String):Object
		{
			var result : Object = getDefinitionByName(value);			
			return result;
		}		
	}
}