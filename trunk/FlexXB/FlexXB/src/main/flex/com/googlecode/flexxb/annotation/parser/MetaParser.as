/**
 *   FlexXB
 *   Copyright (C) 2008-2010 Alex Ciobanu
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
package com.googlecode.flexxb.annotation.parser
{
	import com.googlecode.flexxb.annotation.contract.AccessorType;
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	import com.googlecode.flexxb.annotation.xml.XmlClass;
	
	import flash.utils.getDefinitionByName;

	/**
	 * @private
	 * @author Alexutz
	 * 
	 */	
	public final class MetaParser
	{
		/**
		 * Constructor 
		 * 
		 */		
		public function MetaParser(){ }
		
		/**
		 * 
		 * @param xmlDescriptor
		 * @return array of IClassAnnotation implementor instances, one for each version dicovered in the descriptor
		 * @see com.googlecode.flexxb.annotation.IClassAnnotation
		 * 
		 */		
		public function parseDescriptor(xmlDescriptor : XML) : Array{
			var classList : Array = [];
			if(xmlDescriptor.factory.length() > 0){
				xmlDescriptor = xmlDescriptor.factory[0];
			}
			var classReference : IClassAnnotation;
			var field : XML;
			var metaDescriptors : MetaDescriptor;
			for each (field in xmlDescriptor..variable) {
				
			}
			for each (field in xmlDescriptor..accessor) {
				
			}
			
			
			return classList;
		}
		
		private function getClass(classList : Array, version : String) : IClassAnnotation{
			for each(var clasz : IClassAnnotation in classList){
				if(clasz.version == version){
					return clasz;
				}
			}
			return null;
		}
		
		private function parseMetadata(xml : XML) : MetaDescriptor{
			var descriptor : MetaDescriptor = new MetaDescriptor();
			descriptor.metadataName = xml.@name;
			for each(var argument : XML in xml.arg){
				descriptor.attributes[argument.@key] = argument.@value;
			}
			return descriptor;
		}
		
		private function getFieldNameAndType(xml : XML) : void{
			var name : QName = new QName(xml.@uri, xml.@name);
			var accessType : AccessorType = AccessorType.fromString(xml.@accessor);
			var type : Class = getDefinitionByName(xml.@type) as Class;
		}
		
		private function getClassNameAndType(xml : XML) : void{
			var classType : String = xml.@type;
			if (!classType) {
				classType = xml.@name;
			}
			var name : QName = new QName(null, classType.substring(classType.lastIndexOf(":") + 1));
			var type : Class = getDefinitionByName(classType) as Class;
		}
	}
}