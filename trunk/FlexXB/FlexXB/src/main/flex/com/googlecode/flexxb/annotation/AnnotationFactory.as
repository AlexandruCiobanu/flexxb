/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
 *   Copyright (C) 2008-2009 Alex Ciobanu
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
package com.googlecode.flexxb.annotation
{
	import com.googlecode.flexxb.serializer.ISerializer;
	
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public final class AnnotationFactory
	{
		private static var _instance : AnnotationFactory;
		/**
		 * Singleton accessor
		 * @return instance of AnnotationFactory
		 * 
		 */		
		public static function get instance() : AnnotationFactory{
			if(!_instance){
				_instance = new AnnotationFactory();
			}
			return _instance;
		} 
		
		private var annotationMap : Dictionary = new Dictionary();
		
		/**
		 * Constructor 
		 * 
		 */		
		public function AnnotationFactory()
		{
			if(_instance){
				throw new Error("Use AnnotationFactory.instance instead!");
			}
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
		/**
		 * 
		 * @param annotationName
		 * @return 
		 * 
		 */		
		public function getAnnotationClass(annotationName : String) : Class{
			if(annotationMap[annotationName]){
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
		public function getAnnotation(field : XML, classDescriptor : XmlClass) : Annotation{
			if(field && classDescriptor){
				var annotations : XMLList = field.metadata;
				for each(var member : XML in annotations){
					var annotationClass : Class = getAnnotationClass(member.@name);
					if(annotationClass){
						return new annotationClass(field, classDescriptor) as Annotation;
					}
				}
			}
			return null;
		}
	}
}