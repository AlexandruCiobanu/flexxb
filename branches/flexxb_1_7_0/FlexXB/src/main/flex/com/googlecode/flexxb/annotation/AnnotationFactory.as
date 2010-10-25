/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */
package com.googlecode.flexxb.annotation {
	import com.googlecode.flexxb.annotation.contract.IAnnotation;
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
	import com.googlecode.flexxb.serializer.ISerializer;
	
	import flash.utils.Dictionary;

	/**
	 * This Factory will return an annotation instance based on the type required. Since each
	 * annotation has a specific serializer, it will also provide the serializer instance to be
	 * used when processing a field. Since they are stateless, serializers do not need to be
	 * instanciated more than once.
	 *
	 * @author Alexutz
	 *
	 */
	public final class AnnotationFactory {
		private static var _instance : AnnotationFactory;

		/**
		 * Singleton accessor
		 * @return instance of AnnotationFactory
		 *
		 */
		public static function get instance() : AnnotationFactory {
			if (!_instance) {
				_instance = new AnnotationFactory();
			}
			return _instance;
		}

		private var annotationMap : Dictionary = new Dictionary();

		/**
		 * Constructor
		 *
		 */
		public function AnnotationFactory() {
			if (_instance) {
				throw new Error("Use AnnotationFactory.instance instead!");
			}
		}
		
		/**
		 * Check if there is an annotation with the given name registered in the factory.
		 * @param metaName annotation name
		 * @return true if an annotation with this name is registered, false otherwise
		 * 
		 */		
		public function isRegistered(metaName : String) : Boolean{
			return metaName && annotationMap[metaName];
		}
		
		/**
		 * 
		 * @param metaName
		 * @return 
		 * 
		 */		
		public function isClassAnnotation(metaName : String) : Boolean{
			if(annotationMap[metaName]){
				return MetaStore(annotationMap[metaName]).isClass;
			}
			return false;
		}
		
		/**
		 * 
		 * @param metaName
		 * @return 
		 * 
		 */		
		public function isMemberAnnotation(metaName : String) : Boolean{
			if(annotationMap[metaName]){
				return MetaStore(annotationMap[metaName]).isMember;
			}
			return false;
		}
		
		/**
		 * 
		 * @param metaName
		 * @return 
		 * 
		 */		
		public function isGlobalAnnotation(metaName : String) : Boolean{
			if(annotationMap[metaName]){
				return MetaStore(annotationMap[metaName]).isGlobal;
			}
			return false;
		}

		/**
		 * Register a new annotation and its serializer. If it finds a registration with the
		 * same name and <code>overrideExisting </code> is set to <code>false</code>, it will disregard the current attempt and keep the old value.
		 * @param name the name of the annotation to be registered
		 * @param annotationClazz annotation class type
		 * @param serializerInstance instance of the serializer that will handle this annotation
		 * @param overrideExisting
		 *
		 */
		public function registerAnnotation(name : String, annotationClazz : Class, serializer : Class, overrideExisting : Boolean = false) : void {
			if (overrideExisting || !annotationMap[name]) {
				annotationMap[name] = new MetaStore(annotationClazz, serializer);
			}
		}

		/**
		 * Get serializer associated with the annotation
		 * @param annotation target annotation
		 * @return the serializer object or null if the annotation name is not registered
		 *
		 */
		public function getSerializer(annotation : IAnnotation) : ISerializer {
			if (annotation && annotationMap[annotation.annotationName]) {
				return  MetaStore(annotationMap[annotation.annotationName]).serializer as ISerializer;
			}
			return null;
		}

		/**
		 * Get the annotation class based on the annotation name
		 * @param annotationName the name of the annotation
		 * @return the Class object definition
		 *
		 */
		public function getAnnotationClass(annotationName : String) : Class {
			if (annotationMap[annotationName]) {
				return MetaStore(annotationMap[annotationName]).annotation as Class;
			}
			return null;
		}

		/**
		 * Get the annotation representing the xml field descriptor
		 * @param field
		 * @param descriptor
		 * @return
		 *
		 */
		public function getAnnotation(descriptor : MetaDescriptor, owner : IClassAnnotation) : IAnnotation {
			if (descriptor) {
				var annotationClass : Class = getAnnotationClass(descriptor.metadataName);
				if (annotationClass) {
					if(isClassAnnotation(descriptor.metadataName)){
						return new annotationClass(descriptor) as IAnnotation;
					}else{
						return new annotationClass(descriptor, owner) as IAnnotation;
					}
				}
			}
			return null;
		}
	}
}
import com.googlecode.flexxb.serializer.ISerializer;
import mx.utils.DescribeTypeCache;

final class MetaStore{
	
	public var annotation : Class;
	
	public var serializer : ISerializer;
	
	private var _isClass : Boolean;
	
	private var _isGlobal : Boolean;
	
	private var _isMember : Boolean;
	
	public function MetaStore(annotation : Class, serializerClass : Class){
		this.annotation = annotation;
		if(serializerClass){
			this.serializer = new serializerClass() as ISerializer;
		}
		var xml : XML = DescribeTypeCache.describeType(annotation).typeDescription;
		if(xml.factory.length() > 0){
			xml = xml.factory[0];
		}
		for each(var interf : XML in xml.implementsInterface){
			if(interf.@type == "com.googlecode.flexxb.annotation.contract::IClassAnnotation"){
				_isClass = true;
				break;
			}
			if(interf.@type == "com.googlecode.flexxb.annotation.contract::IMemberAnnotation"){
				_isMember = true;
				break;
			}
			if(interf.@type == "com.googlecode.flexxb.annotation.contract::IGlobalAnnotation"){
				_isGlobal = true;
				break;
			}
		}
	}
	
	public function get isClass() : Boolean{
		return _isClass;
	}
	
	public function get isGlobal() : Boolean{
		return _isGlobal;
	}
	
	public function get isMember() : Boolean{
		return _isMember;
	}
}