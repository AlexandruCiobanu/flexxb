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
	import com.googlecode.flexxb.annotation.XmlArray;
	import com.googlecode.flexxb.annotation.XmlAttribute;
	import com.googlecode.flexxb.annotation.XmlClass;
	import com.googlecode.flexxb.annotation.XmlElement;
	import com.googlecode.flexxb.persistence.PersistableObject;
	import com.googlecode.flexxb.serializer.ISerializer;
	import com.googlecode.flexxb.serializer.XmlArraySerializer;
	import com.googlecode.flexxb.serializer.XmlAttributeSerializer;
	import com.googlecode.flexxb.serializer.XmlClassSerializer;
	import com.googlecode.flexxb.serializer.XmlElementSerializer;
	
	import flash.events.EventDispatcher;

	[Event(name="preserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	[Event(name="postserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	[Event(name="predeserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	[Event(name="postdeserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class SerializerCore extends EventDispatcher
	{
		/**
		 * 
		 */		
		private var _descriptorStore : DescriptorStore;
		/**
		 * 
		 */		
		private var _converterStore : ConverterStore;
		/**
		 * Constructor
		 * 
		 */		
		public function SerializerCore(descriptor : DescriptorStore, converter : ConverterStore)
		{
			if(!descriptor || !converter){
				throw new Error("Converter and descriptor stores must not be null");
			}
			_descriptorStore = descriptor;
			_converterStore = converter;
			_descriptorStore.registerAnnotation(XmlAttribute.ANNOTATION_NAME, XmlAttribute, XmlAttributeSerializer);
			_descriptorStore.registerAnnotation(XmlElement.ANNOTATION_NAME,   XmlElement,   XmlElementSerializer);
			_descriptorStore.registerAnnotation(XmlArray.ANNOTATION_NAME, 	 XmlArray, 	   XmlArraySerializer);
			_descriptorStore.registerAnnotation(XmlClass.ANNOTATION_NAME, 	 XmlClass, 	   XmlClassSerializer);
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get descriptorStore() : IDescriptorStore{
			return _descriptorStore;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get converterStore() : IConverterStore{
			return _converterStore;
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
			
			if(_descriptorStore.isCustomSerializable(object)){
				xmlData = IXmlSerializable(object).toXml();
			}else{
				var classDescriptor : XmlClass = _descriptorStore.getDescriptor(object);
				xmlData = _descriptorStore.getSerializer(classDescriptor).serialize(object, classDescriptor, null, this);
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
			var serializer : ISerializer = _descriptorStore.getSerializer(annotation);
			var target : Object = object[annotation.fieldName];
			if(target != null){
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
		public final function deserialize(xmlData : XML, objectClass : Class = null, getFromCache : Boolean = false) : Object{
			if(xmlData){
				if(!objectClass){
					objectClass = getIncomingType(xmlData);
				}
				if(objectClass){
					var result : Object;
					var id : String = getId(objectClass, xmlData);
									
					//get object from cache
					if(id && ModelObjectCache.instance.isCached(id, objectClass)){
						if(getFromCache){
							return ModelObjectCache.instance.getObject(id, objectClass);
						}
						result = ModelObjectCache.instance.getObject(id, objectClass);
					}else{
						result = new objectClass();
						if(id){
							ModelObjectCache.instance.putObject(id, result);
						}
					}
					
					//dispatch preDeserializeEvent
					dispatchEvent(XmlEvent.createPreDeserializeEvent(result, xmlData));
					
					if(result is PersistableObject){
						PersistableObject(result).stopListening();
					}
					//update object fields
					if(result is IXmlSerializable){	
						IXmlSerializable(result).fromXml(xmlData);
					}else{
						var classDescriptor : XmlClass = _descriptorStore.getDescriptor(result);
						for each(var annotation : Annotation in classDescriptor.members){	
							var serializer : ISerializer = _descriptorStore.getSerializer(annotation);
							result[annotation.fieldName] = serializer.deserialize(xmlData, annotation, this);
						}
					}
					if(result is PersistableObject){
						PersistableObject(result).commit();
						PersistableObject(result).startListening();
					}
					
					//dispatch postDeserializeEvent
					dispatchEvent(XmlEvent.createPostDeserializeEvent(result, xmlData));
					
					return result;
				}
			}
			return null;
		}
		/**
		 * Get the type class corresponding to the namespace defined in the incoming xml
		 * @param incomingXML
		 * @return class
		 * 
		 */		
		public final function getIncomingType(incomingXML : XML) : Class{
			if(!incomingXML || incomingXML.namespaceDeclarations().length == 0){
				return null;
			}
			var _namespace : String = (incomingXML.namespaceDeclarations()[0] as Namespace).uri;
			return _descriptorStore.getClassByNamespace(_namespace);
		}
		/**
		 * 
		 * @param result
		 * @param xmlData
		 * @return 
		 * 
		 */		
		private function getId(objectClass : Class, xmlData : XML) : String{
			var id : String;
			if(_descriptorStore.isCustomSerializable(objectClass)){
				id = _descriptorStore.getCustomSerializableReference(objectClass).getIdValue(xmlData);
			}else{
				var classDescriptor : XmlClass = _descriptorStore.getDescriptor(objectClass);
				var idSerializer : ISerializer = _descriptorStore.getSerializer(classDescriptor.idField);
				if(idSerializer){
					id = String(idSerializer.deserialize(xmlData, classDescriptor.idField, this));
				}
			}
			return id;
		}
	}
}