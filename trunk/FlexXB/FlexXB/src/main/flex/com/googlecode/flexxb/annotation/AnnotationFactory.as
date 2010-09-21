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
	import com.googlecode.flexxb.serializer.ISerializer;
	import com.googlecode.flexxb.serializer.XmlArraySerializer;
	import com.googlecode.flexxb.serializer.XmlAttributeSerializer;
	import com.googlecode.flexxb.serializer.XmlClassSerializer;
	import com.googlecode.flexxb.serializer.XmlElementSerializer;
	
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
			registerAnnotation(XmlAttribute.ANNOTATION_NAME, XmlAttribute, XmlAttributeSerializer);
			registerAnnotation(XmlElement.ANNOTATION_NAME, XmlElement, XmlElementSerializer);
			registerAnnotation(XmlArray.ANNOTATION_NAME, XmlArray, XmlArraySerializer);
			registerAnnotation(XmlClass.ANNOTATION_NAME, XmlClass, XmlClassSerializer);
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
		public function registerAnnotation(name : String, annotationClazz : Class, serializer : Class, overrideExisting : Boolean = false) : void {
			if (overrideExisting || !annotationMap[name]) {
				annotationMap[name] = {annotation: annotationClazz, serializer: new serializer() as ISerializer};
			}
		}

		/**
		 * Get serializer associated with the annotation
		 * @param annotation target annotation
		 * @return the serializer object or null if the annotation name is not registered
		 *
		 */
		public function getSerializer(annotation : Annotation) : ISerializer {
			if (annotation && annotationMap[annotation.annotationName]) {
				return annotationMap[annotation.annotationName].serializer as ISerializer;
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
				return annotationMap[annotationName].annotation as Class;
			}
			return null;
		}

		/**
		 * Get the annotation representing the xml field descriptor
		 * @param field
		 * @param classDescriptor
		 * @return
		 *
		 */
		public function getAnnotation(field : XML, classDescriptor : XmlClass) : Annotation {
			if (field && classDescriptor) {
				var annotations : XMLList = field.metadata;
				for each (var member : XML in annotations) {
					var annotationClass : Class = getAnnotationClass(member.@name);
					if (annotationClass) {
						return new annotationClass(field, classDescriptor) as Annotation;
					}
				}
			}
			return null;
		}
	}
}