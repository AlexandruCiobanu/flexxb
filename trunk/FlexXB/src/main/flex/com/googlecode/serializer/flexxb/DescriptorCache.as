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
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	internal final class DescriptorCache
	{		
		private var descriptorCache : Object;
		
		private var annotationMap : Object = new Object();
		/**
		 * 
		 * @param object
		 * @return 
		 * 
		 */		
		public function getDescriptor(object : Object) : XmlClass{
			var className : String = getQualifiedClassName(object);
			if(hasDescriptor(className)){
				return descriptorCache[className] as XmlClass;
			}
			var descriptor : XmlClass = xmlDescribeType(object);
			putDescriptor(className, descriptor)
			return descriptor; 
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
		 * 
		 * @param namespaceUri
		 * @return 
		 * 
		 */		
		public function getObjectType(namespaceUri : String) : Class{
			for each(var dsc : XmlClass in descriptorCache){
				if(dsc.nameSpace.uri == namespaceUri){
					return dsc.fieldType;
				}
			}
			return null;
		}
		/**
		 * 
		 * @param annotationName
		 * @return 
		 * 
		 */		
		public function getClass(annotationName : String) : Class{
			if(annotationMap[annotationName]){
				return annotationMap[annotationName].annotation as Class;
			}
			return null;
		}
		/**
		 * 
		 * @param annotationName
		 * @return 
		 * 
		 */		
		public function getSerializer(annotation : Annotation) : ISerializer{
			if(annotation && annotationMap[annotation.annotationName]){
				return annotationMap[annotation.annotationName].serializer as ISerializer;
			}
			return null;
		}
		
		private function xmlDescribeType(object : Object) : XmlClass{
			var descriptor : XML = describeType(object);
			//get class annotation				
			var classDescriptor : XmlClass = new XmlClass(descriptor);
			//get namespace
			var field : XML;
			for each(field in descriptor..variable){
				classDescriptor.addMember(getAnnotation(field));
			}
			for each(field in descriptor..accessor.(@access == "readwrite")){
				classDescriptor.addMember(getAnnotation(field));
			}
			return classDescriptor;
		}
		
		private function getAnnotation(field : XML) : Annotation{
			var annotations : XMLList = field.metadata;
			for each(var member : XML in annotations){
				var annotationClass : Class = getClass(member.@name);
				if(annotationClass){
					return new annotationClass(field) as Annotation;
				}
			}
			return null;
		}
		
		private function hasDescriptor(className : String) : Boolean{
			return  descriptorCache && descriptorCache[className] is XmlClass;
		}
				
		private function putDescriptor(className : String, descriptor : XmlClass) : Boolean{
			if(!descriptorCache){
				descriptorCache = new Object();
			}else{
				if(descriptorCache[className] is XmlClass){
					return false
				}
			}
			descriptorCache[className] = descriptor;
			return true;
		}
	}
}