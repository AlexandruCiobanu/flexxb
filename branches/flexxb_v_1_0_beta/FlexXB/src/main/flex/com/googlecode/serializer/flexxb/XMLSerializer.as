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
	import com.googlecode.serializer.ModelObjectCache;
	import com.googlecode.serializer.flexxb.annotation.Annotation;
	import com.googlecode.serializer.flexxb.annotation.XmlArray;
	import com.googlecode.serializer.flexxb.annotation.XmlAttribute;
	import com.googlecode.serializer.flexxb.annotation.XmlClass;
	import com.googlecode.serializer.flexxb.annotation.XmlElement;
	import com.googlecode.serializer.flexxb.converter.IConverter;
	import com.googlecode.serializer.flexxb.serializer.ISerializer;
	import com.googlecode.serializer.flexxb.serializer.XmlArraySerializer;
	import com.googlecode.serializer.flexxb.serializer.XmlAttributeSerializer;
	import com.googlecode.serializer.flexxb.serializer.XmlClassSerializer;
	import com.googlecode.serializer.flexxb.serializer.XmlElementSerializer;
	
	import flash.events.EventDispatcher;
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
	[Event(name="preserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	[Event(name="postserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	[Event(name="predeserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	[Event(name="postdeserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	public final class XMLSerializer extends EventDispatcher
	{	
		/**
		 * Singleton
		 */		
		public static const instance : XMLSerializer = new XMLSerializer();
		/**
		 * 
		 */		
		private var descriptorCache : DescriptorCache = new DescriptorCache();
		/**
		 * 
		 */		
		private var converterMap : Object;
		/**
		 * Constructor
		 * 
		 */		
		public function XMLSerializer()
		{
			if(instance){
				throw new Error("Please do not instanciate this class. Use XMLSerializer.instance instead");
			}
			descriptorCache.registerAnnotation(XmlAttribute.ANNOTATION_NAME, XmlAttribute, XmlAttributeSerializer);
			descriptorCache.registerAnnotation(XmlElement.ANNOTATION_NAME,   XmlElement,   XmlElementSerializer);
			descriptorCache.registerAnnotation(XmlArray.ANNOTATION_NAME, 	 XmlArray, 	   XmlArraySerializer);
			descriptorCache.registerAnnotation(XmlClass.ANNOTATION_NAME, 	 XmlClass, 	   XmlClassSerializer);
		}
		/**
		 * 
		 * @param converter
		 * @return 
		 * 
		 */		
		public function registerSimpleTypeConverter(converter : IConverter, overrideExisting : Boolean = false) : Boolean{
			if(converter == null || converter.type == null){
				return false;
			}
			if(!overrideExisting && converterMap && converterMap[converter.type]){
				return false;
			}			
			if(converterMap == null){
				converterMap = new Object();
			}
			converterMap[converter.type] = converter;
			return true;
		}
		/**
		 * 
		 * @param type
		 * @return 
		 * 
		 */		
		public function hasConverter(type : Class) : Boolean{
			return converterMap && type && converterMap[type] is IConverter;
		}
		/**
		 * Convert an object to a xml representation.
		 * @param object object to be converted.
		 * @return xml representation of the given object
		 * 
		 */		
		public final function serialize(object : Object, partial : Boolean = false) : XML{
			if(object == null){
				return null;
			}
			var xmlData : XML;
			
			//dispatch preSerializeEvent
			dispatchEvent(XmlEvent.createPreSerializeEvent(object, xmlData));
			
			if(object is IXmlSerializable){
				xmlData = IXmlSerializable(object).toXml();
			}else{
				var classDescriptor : XmlClass = descriptorCache.getDescriptor(object);
				xmlData = descriptorCache.getSerializer(classDescriptor).serialize(object, classDescriptor, null, this);
				var serializer : ISerializer;
				if(partial && classDescriptor.idField){
					doSerialize(object, classDescriptor.idField, xmlData);  
				}else{
					for each(var annotation : Annotation in classDescriptor.members){
						doSerialize(object, annotation, xmlData);
					}
				}
			}
			
			//dispatch postSerializeEvent
			dispatchEvent(XmlEvent.createPostSerializeEvent(object, xmlData));
			
			return xmlData;
		}
		/**
		 * 
		 * @param object
		 * @param annotation
		 * @param xmlData
		 * 
		 */		
		private function doSerialize(object : Object, annotation : Annotation, xmlData : XML) : void{
			var serializer : ISerializer = descriptorCache.getSerializer(annotation);
			var target : Object = object[annotation.fieldName];
			if(target){
				serializer.serialize(target, annotation, xmlData, this);
			}
		}
		/**
		 * Convert an xml to an AS3 object counterpart
		 * @param xmlData xml to be deserialized
		 * @param objectClass object class
		 * @return object of type objectClass 
		 * 
		 */		
		public final function deserialize(xmlData : XML, objectClass : Class, getFromCache : Boolean = false) : Object{
			if(xmlData && objectClass){
				var result : Object = new objectClass();
				var id : String = getId(result, xmlData);
				
				//dispatch preSerializeEvent
				dispatchEvent(XmlEvent.createPreDeserializeEvent(result, xmlData));
				
				//get object from cache
				if(id && ModelObjectCache.instance.isCached(id, objectClass)){
					if(getFromCache){
						return ModelObjectCache.instance.getObject(id, objectClass);
					}
					result = ModelObjectCache.instance.getObject(id, objectClass);
				}else if(id){
					ModelObjectCache.instance.putObject(id, result);
				}
				//update obect fields
				if(result is IXmlSerializable){	
					IXmlSerializable(result).fromXml(xmlData);
				}else{
					var classDescriptor : XmlClass = descriptorCache.getDescriptor(result);
					for each(var annotation : Annotation in classDescriptor.members){				
						var serializer : ISerializer = descriptorCache.getSerializer(annotation);
						result[annotation.fieldName] = serializer.deserialize(xmlData, annotation, this);
					}
				}
				
				//dispatch preSerializeEvent
				dispatchEvent(XmlEvent.createPostDeserializeEvent(result, xmlData));
				
				return result;
			}
			return null;
		}
		/**
		 * 
		 * @param object
		 * @return 
		 * 
		 */		
		public final function getXmlName(object : Object) : QName{
			if(object != null){
				var classDescriptor : XmlClass = descriptorCache.getDescriptor(object);
				if(classDescriptor){
					return classDescriptor.xmlName;
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
			if(hasConverter(clasz)){
				return getConverter(clasz).fromString(value);
			}
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
		public final function objectToString(object : Object, clasz : Class) : String{
			if(hasConverter(clasz)){
				return getConverter(clasz).toString(object);
			}
			if(object is String){
				return object as String;
			}
			try{
				return object.toString();
			}catch(e:Error){}
			return "";
		}
		/**
		 * 
		 * @param result
		 * @param xmlData
		 * @return 
		 * 
		 */		
		private function getId(result : Object, xmlData : XML) : String{
			var id : String;
			if(result is IXmlSerializable){
				id = IXmlSerializable(result).getIdValue(xmlData);
			}else{
				var classDescriptor : XmlClass = descriptorCache.getDescriptor(result);
				var idSerializer : ISerializer = descriptorCache.getSerializer(classDescriptor.idField);
				if(idSerializer){
					id = String(idSerializer.deserialize(xmlData, classDescriptor.idField, this));
				}
			}
			return id;
		}
		/**
		 * 
		 * @param clasz
		 * @return 
		 * 
		 */		
		private function getConverter(clasz : Class) : IConverter{
			return converterMap[clasz] as IConverter;
		}
	}
}