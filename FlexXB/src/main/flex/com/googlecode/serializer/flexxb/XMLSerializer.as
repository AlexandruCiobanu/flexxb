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
	 * Entry point for AS3-XML (de)serialization. Allows new annotation registration. 
	 * By default it registeres the built-in annotations at startup. 
	 * <p>Built-in anotation usage:
	 *  <ul>
	 *  <li>XmlClass: <code>[XmlClass(name="MyClass", prefix="my", uri="http://www.your.site.com/schema/")]</code></li>
	 *  <li>XmlAttribute: <code>[XmlAttribute(name="attribute", ignoreOn="serialize|deserialize")]</code></li>
	 *  <li>XmlElement: <code>[XmlElement(name="element", ignoreOn="serialize|deserialize", serializePartialElement="true|false")]</code></li>
	 *  <li>XmlArray: <code>[Array(name="element", type="my.full.type" ignoreOn="serialize|deserialize", serializePartialElement="true|false")]</code></li>
	 *  </ul></p>
	 * <p>Make sure you add the following switches to your compiler settings:
	 * <code>-keep-as3-metadata XmlClass -keep-as3-metadata XmlAttribute -keep-as3-metadata XmlElement -keep-as3-metadata XmlArray</code></p>
	 * @author aCiobanu
	 * 
	 */		
	public final class XMLSerializer
	{	
		/**
		 * Singleton
		 */		
		public static const instance : XMLSerializer = new XMLSerializer();
		/**
		 * 
		 */		
		private var descriptorCache : Object;
		/**
		 * 
		 */		
		private var annotationMap : Object;
		/**
		 * Constructor
		 * 
		 */		
		public function XMLSerializer()
		{
			if(instance){
				throw new Error("Please do not instanciate this class. Use XMLSerializer.instance instead");
			}
			annotationMap = new Object();
			registerAnnotation(XmlAttribute.ANNOTATION_NAME, XmlAttribute, XmlAttributeSerializer);
			registerAnnotation(XmlElement.ANNOTATION_NAME,   XmlElement,   XmlElementSerializer);
			registerAnnotation(XmlArray.ANNOTATION_NAME, 	 XmlArray, 	   XmlArraySerializer);
			registerAnnotation(XmlClass.ANNOTATION_NAME, 	 XmlClass, 	   XmlClassSerializer);
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
		public final function registerAnnotation(name : String, annotationClazz : Class, serializer : Class, overrideExisting : Boolean = false) : void{
			if(overrideExisting || !annotationMap[name]){
				annotationMap[name] = {annotation: annotationClazz, serializer: new serializer() as ISerializer};
			}
		}
		/**
		 * Convert an object to a xml representation.
		 * @param object object to be converted.
		 * @return xml representation of the given object
		 * 
		 */		
		public final function serialize(object : Object) : XML{
			if(object == null){
				return null;
			}
			if(object is IXmlSerializable){
				return IXmlSerializable(object).toXml();
			}
			var annotations : Array = getAnnotations(object);
			var xmlData : XML = <xml />;
			for each(var annotation : Annotation in annotations){
				var serializer : ISerializer = getSerializer(annotation.annotationName);
				var target : Object = annotation is XmlClass ? object : object[annotation.fieldName];
				if(target){
					serializer.serialize(target, annotation, xmlData);
				}
			}
			return xmlData;
		}
		/**
		 * Convert an xml to an AS3 object counterpart
		 * @param xmlData xml to be deserialized
		 * @param objectClass object class
		 * @return object of type objectClass 
		 * 
		 */		
		public final function deserialize(xmlData : XML, objectClass : Class) : Object{
			if(xmlData && objectClass){
				var result : Object = new objectClass();
				if(result is IXmlSerializable){
					IXmlSerializable(result).fromXml(xmlData);
				}else{
					var annotations : Array = getAnnotations(result);
					for each(var annotation : Annotation in annotations){
						if(annotation is XmlClass){
							continue;
						}					
						var serializer : ISerializer = getSerializer(annotation.annotationName);
						result[annotation.fieldName] = serializer.deserialize(xmlData, annotation);
					}
				}
				return result;
			}
			return null;
		}
		/**
		 * 
		 * @param annotationName
		 * @return 
		 * 
		 */		
		private function getClass(annotationName : String) : Class{
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
		private function getSerializer(annotationName : String) : ISerializer{
			if(annotationMap[annotationName]){
				return annotationMap[annotationName].serializer as ISerializer;
			}
			return null;
		}		
		/**
		 * 
		 * @param object
		 * @return Array of Annotation objects
		 * 
		 */		
		private function getAnnotations(object : Object) : Array{
			var result : Array;
			var className : String = getQualifiedClassName(object);
			//attempt to get the annotations from the descriptor cache
			if(descriptorCache && descriptorCache[className]){
				result = descriptorCache[className];
			}else{
				result = [];
				var descriptor : XML = describeType(object);
				//get class annotation
				result.push(new XmlClass(descriptor));
				//get namespace
				var ns : Namespace = (result[0] as Annotation).nameSpace;
				var field : XML;
				var annotation : Annotation;
				for each(field in descriptor..variable){
					annotation = getAnnotation(field);
					if(annotation){
						//add the same namespace to all of the current class' fields 
						annotation.nameSpace = ns;
						result.push(annotation);
					}
				}
				for each(field in descriptor..accessor.(@access == "readwrite")){
					annotation = getAnnotation(field);
					if(annotation){
						//add the same namespace to all of the current class' fields 
						annotation.nameSpace = ns;
						result.push(annotation);
					}
				}
				//save the annotation list in cache				
				if(!descriptorCache){
					descriptorCache = new Object();
				}
				descriptorCache[className] = result;
			}
			return result;
		}
		/**
		 * 
		 * @param field
		 * @return 
		 * 
		 */		
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
		/**
		 * 
		 * @param value
		 * @param clasz
		 * @return 
		 * 
		 */		
		public final function stringToObject(value : String, clasz : Class) : Object{
			if(clasz==Boolean){
				return (value && value.toLowerCase() == "true");
			}
			if(clasz == Date){
				if(value == ""){
					return null;
				}
				var date : Date = new Date();
				date.setTime(Date.parse(value));
				return date;
			}
			return clasz(value);
		}
		/**
		 * 
		 * @param object
		 * @return 
		 * 
		 */		
		public final function objectToString(object : Object) : String{
			if(object is String){
				return object as String;
			}
			try{
				return object.toString();
			}catch(e:Error){}
			return "";
		}
	}
}