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
	import com.googlecode.flexxb.annotation.XmlClass;
	import com.googlecode.flexxb.serializer.ISerializer;
	
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
		
		private var annotationMap : Dictionary = new Dictionary();
		
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
		/**
		 * Register a new annotation and its serializer. If it founds a registration with the 
		 * same name and <code>overrideExisting </code> is set to <code>false</code>, it will disregard the current attempt and keep the old value.
		 * @param name the name of the annotation to be registered
		 * @param annotationClazz annotation class type
		 * @param serializerInstance instance of the serializer that will handle this annotation
		 * @param overrideExisting
		 * 
		 */		
		public function registerAnnotation(name : String, annotationClazz : Class, serializer : Class, overrideExisting : Boolean = false) : void{
			if(overrideExisting || !annotationMap[name]){
				annotationMap[name] = {annotation: annotationClazz, serializer: new serializer() as ISerializer};
			}
		}
		/**
		 * Get serializer associated with the annotation
		 * @param annotation target annotation
		 * @return the serializer object or null if the annotation name is not registered
		 * 
		 */		
		public function getSerializer(annotation : Annotation) : ISerializer{
			if(annotation && annotationMap[annotation.annotationName]){
				return annotationMap[annotation.annotationName].serializer as ISerializer;
			}
			return null;
		}
				
		private function getAnnotationClass(annotationName : String) : Class{
			if(annotationMap[annotationName]){
				return annotationMap[annotationName].annotation as Class;
			}
			return null;
		}
		
		private function xmlDescribeType(object : Object, xmlDescriptor : XML) : XmlClass{
			var descriptor : XML = xmlDescriptor;
			if(object is Class){
				descriptor = descriptor.factory[0];
			}
			//get class annotation				
			var classDescriptor : XmlClass = new XmlClass(descriptor);
			//get namespace
			var field : XML;
			for each(field in descriptor..variable){
				classDescriptor.addMember(getAnnotation(field, classDescriptor));
			}
			for each(field in descriptor..accessor.(@access == "readwrite")){
				classDescriptor.addMember(getAnnotation(field, classDescriptor));
			}
			//if the class descriptor defines a namespace, register it in the namespace map
			if(classDescriptor.nameSpace){
				if(!classNamespaceMap){
					classNamespaceMap = new Dictionary();
				}
				classNamespaceMap[classDescriptor.nameSpace.uri] = classDescriptor.fieldType;
			}
			return classDescriptor;
		}
		
		private function getAnnotation(field : XML, classDescriptor : XmlClass) : Annotation{
			var annotations : XMLList = field.metadata;
			for each(var member : XML in annotations){
				var annotationClass : Class = getAnnotationClass(member.@name);
				if(annotationClass){
					return new annotationClass(field, classDescriptor) as Annotation;
				}
			}
			return null;
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
				xmlClass = xmlDescribeType(object, descriptor);
			}
			var result : Object = {descriptor : xmlClass, customSerializable : customSerializable, reference : referenceObject};
			descriptorCache[className] = result;
			return result;
		}
	}
}