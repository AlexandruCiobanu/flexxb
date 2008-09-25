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
	import flash.utils.getDefinitionByName;
	
	/**
	 * 
	 * <p>Usage: <code>[XmlClass(alias="MyClass", prefix="my", uri="http://www.your.site.com/schema/")]</code></p>
	 * @author aCiobanu
	 * 
	 */	
	public final class XmlClass extends Annotation
	{
		/**
		 * Annotation's name
		 */		
		public static const ANNOTATION_NAME : String = "XmlClass";
		/**
		 * Namespace prefix
		 */		
		public static const ARGUMENT_NAMESPACE_PREFIX : String = "prefix";
		/**
		 * Namespace uri
		 */ 
		public static const ARGUMENT_NAMESPACE_URI : String = "uri";
		/**
		 *Constructor 
		 * 
		 */		
		public function XmlClass(descriptor : XML){
			super(descriptor);
		}
		/**
		 * 
		 * @see Annotation#parse()
		 * 
		 */		
		protected override function parse(field:XML):void{
			super.parse(field);
			_fieldName = _fieldName.substring(_fieldName.lastIndexOf(":") + 1);
			_fieldType = getDefinitionByName(field.@name) as Class;
		}
		/**
		 * 
		 * @see Annotation#parseMetadata()
		 * 
		 */		
		protected override function parseMetadata(metadata : XML) : void{
			nameSpace = getNamespace(metadata);
			setAlias(metadata.arg.(@key == ARGUMENT_ALIAS).@value);
		}
		
		private function getNamespace(metadata : XML) : Namespace{
			var prefix : String = metadata.arg.(@key == ARGUMENT_NAMESPACE_PREFIX).@value;
			var uri : String = metadata.arg.(@key == ARGUMENT_NAMESPACE_URI).@value;
			if(uri == null || uri.length==0){
				return null;
			}
			if(prefix.length>0){
				return new Namespace(prefix, uri);
			}
			return new Namespace(uri);			
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