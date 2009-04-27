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
package com.googlecode.flexxb
{
	import com.googlecode.flexxb.annotation.Annotation;
	import com.googlecode.flexxb.annotation.AnnotationFactory;
	import com.googlecode.flexxb.annotation.XmlClass;
	
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	internal final class DescriptorStore implements IDescriptorStore
	{		
		private var descriptorCache : Dictionary = new Dictionary();
		
		private var classNamespaceMap : Dictionary;
		/**
		 * Get the class descriptor associated with the object type
		 * @param object
		 * @return XmlClass descriptor
		 * 
		 */		 	
		public function getDescriptor(object : Object) : XmlClass{
			var className : String = getQualifiedClassName(object);
			return getDefinition(object, className).descriptor as XmlClass; 
		}
		/**
		 * Determine whether the object is custom serializable or not
		 * @param object
		 * @return true if the object is custom serialisable, false otherwise
		 * 
		 */		
		public function isCustomSerializable(object : Object) : Boolean{
			var className : String = getQualifiedClassName(object);
			return getDefinition(object, className).reference != null;
		}
		/**
		 * Get the reference instance defined for a custom serializable type
		 * @param clasz
		 * @return object type instance 
		 * 
		 */		
		public function getCustomSerializableReference(clasz : Class) : IXmlSerializable{
			var className : String = getQualifiedClassName(clasz);
			return getDefinition(clasz, className).reference as IXmlSerializable;
		}
		/**
		 * @see IDescriptorStore#getXmlName()
		 * 
		 */		
		public final function getXmlName(object : Object) : QName{
			if(object != null){
				var classDescriptor : XmlClass = getDescriptor(object);
				if(classDescriptor){
					return classDescriptor.xmlName;
				}
			}
			return null;
		}
		/**
		 * 
		 * @see IDescriptorStore#getClassByNamespace() 
		 * 
		 */		
		public function getClassByNamespace(ns : String) : Class{
			if(classNamespaceMap){
				return classNamespaceMap[ns] as Class;
			}
			return null;
		}
		/**
		 * @see IDescriptorStore#getNamespace()
		 * 
		 */		
		public function getNamespace(object : Object) : Namespace{
			if(object){
				var desc : XmlClass = getDescriptor(object);
				if(desc){
					return desc.nameSpace;
				}
			}
			return null;
		}
		
		private function xmlDescribeType(xmlDescriptor : XML) : XmlClass{
			var descriptor : XML = xmlDescriptor;
			if(descriptor.factory.length() > 0){
				descriptor = descriptor.factory[0];
			}
			//get class annotation				
			var classDescriptor : XmlClass = new XmlClass(descriptor);
			//signal the class descriptor that no more members are to be added
			classDescriptor.memberAddFinished();
			//if the class descriptor defines a namespace, register it in the namespace map
			if(classDescriptor.nameSpace){
				if(!classNamespaceMap){
					classNamespaceMap = new Dictionary();
				}
				classNamespaceMap[classDescriptor.nameSpace.uri] = classDescriptor.fieldType;
			}
			return classDescriptor;
		}
		
		private function getDefinition(object : Object, className : String) : Object{
			if(descriptorCache && descriptorCache[className] != null){
				return descriptorCache[className];
			}
			return put(object, className);
		}
		
		private function put(object : Object, className : String) : Object{
			var descriptor : XML = describeType(object);
			var interfaces : XMLList = descriptor.name() == "type" ? descriptor.implementsInterface : descriptor.factory.implementsInterface
			var customSerializable : Boolean;
			for each(var interf : XML in interfaces){
				if(interf.@type.indexOf("IXmlSerializable") >= 0){
					customSerializable = true;
					break;
				}
			}
			var xmlClass : XmlClass;
			var referenceObject : Object;
			if(customSerializable){
				var cls : Class = Class(object is Class ? object : getDefinitionByName(className));
				referenceObject = new cls();
			}else{
				xmlClass = xmlDescribeType(descriptor);
			}
			var result : Object = {descriptor : xmlClass, customSerializable : customSerializable, reference : referenceObject};
			descriptorCache[className] = result;
			return result;
		}
	}
}