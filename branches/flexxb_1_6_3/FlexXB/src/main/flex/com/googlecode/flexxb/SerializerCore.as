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
package com.googlecode.flexxb {
	import com.googlecode.flexxb.annotation.Annotation;
	import com.googlecode.flexxb.annotation.AnnotationFactory;
	import com.googlecode.flexxb.annotation.XmlArray;
	import com.googlecode.flexxb.annotation.XmlAttribute;
	import com.googlecode.flexxb.annotation.XmlClass;
	import com.googlecode.flexxb.annotation.XmlElement;
	import com.googlecode.flexxb.annotation.XmlMember;
	import com.googlecode.flexxb.api.Stage;
	import com.googlecode.flexxb.persistence.PersistableObject;
	import com.googlecode.flexxb.serializer.ISerializer;
	import com.googlecode.flexxb.serializer.XmlArraySerializer;
	import com.googlecode.flexxb.serializer.XmlAttributeSerializer;
	import com.googlecode.flexxb.serializer.XmlClassSerializer;
	import com.googlecode.flexxb.serializer.XmlElementSerializer;
	import com.googlecode.flexxb.util.Instanciator;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;
	
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
	public final class SerializerCore extends EventDispatcher {
		
		private static var log : ILogger = LogFactory.getLog(SerializerCore);
		
		{
			AnnotationFactory.instance.registerAnnotation(XmlAttribute.ANNOTATION_NAME, XmlAttribute, XmlAttributeSerializer);
			AnnotationFactory.instance.registerAnnotation(XmlElement.ANNOTATION_NAME, XmlElement, XmlElementSerializer);
			AnnotationFactory.instance.registerAnnotation(XmlArray.ANNOTATION_NAME, XmlArray, XmlArraySerializer);
			AnnotationFactory.instance.registerAnnotation(XmlClass.ANNOTATION_NAME, XmlClass, XmlClassSerializer);
		}
		/**
		 *
		 */
		private var _descriptorStore : DescriptorStore;
		/**
		 *
		 */
		private var _converterStore : ConverterStore;
		/**
		 *
		 */
		private var _configuration : Configuration;

		/**
		 * Constructor
		 *
		 */
		public function SerializerCore(descriptor : DescriptorStore, converter : ConverterStore, configuration : Configuration) {
			if (!descriptor || !converter) {
				throw new Error("Converter and descriptor stores must not be null");
			}
			_descriptorStore = descriptor;
			_converterStore = converter;
			//We always have a reference to a configuration object
			_configuration = configuration ? configuration : new Configuration();
			addEventListener(XmlEvent.PRE_DESERIALIZE, preDeserializeHandler, false, 150, true);
			addEventListener(XmlEvent.POST_DESERIALIZE, postDeserializeHandler, false, 150, true);
		}
		
		public function get configuration() : Configuration{
			return _configuration;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get descriptorStore() : IDescriptorStore {
			return _descriptorStore;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get converterStore() : IConverterStore {
			return _converterStore;
		}

		/**
		 * Convert an object to a xml representation.
		 * @param object object to be converted.
		 * @return xml representation of the given object
		 *
		 */
		public final function serialize(object : Object, partial : Boolean = false) : XML {
			if(configuration.enableLogging){
				log.info("Started object serialization. Partial flag is {0}", partial);
			}
			if (object == null) {
				if(configuration.enableLogging){
					log.info("Object is null. Ended serialization");
				}
				return null;
			}
			var xmlData : XML;

			//dispatch preSerializeEvent
			dispatchEvent(XmlEvent.createPreSerializeEvent(object, xmlData));

			if (_descriptorStore.isCustomSerializable(object)) {
				xmlData = IXmlSerializable(object).toXml();
			} else {
				var classDescriptor : XmlClass = _descriptorStore.getDescriptor(object);
				xmlData = AnnotationFactory.instance.getSerializer(classDescriptor).serialize(object, classDescriptor, null, this);
				var serializer : ISerializer;
				var annotation : XmlMember;
				if (partial && classDescriptor.idField) {
					doSerialize(object, classDescriptor.idField, xmlData);
				} else if (configuration.onlySerializeChangedValueFields && object is PersistableObject) {
					for each (annotation in classDescriptor.members) {
						if (annotation.writeOnly  || annotation.ignoreOn == Stage.SERIALIZE || !PersistableObject(object).isChanged(annotation.fieldName.localName)) {
							continue;
						}
						doSerialize(object, annotation, xmlData);
					}
				} else {
					for each (annotation in classDescriptor.members) {
						if (annotation.writeOnly || annotation.ignoreOn == Stage.SERIALIZE) {
							continue;
						}
						doSerialize(object, annotation, xmlData);
					}
				}
			}

			//dispatch postSerializeEvent
			dispatchEvent(XmlEvent.createPostSerializeEvent(object, xmlData));
			
			if(configuration.enableLogging){
				log.info("Ended object serialization");
			}
			
			return xmlData;
		}

		/**
		 *
		 * @param object
		 * @param annotation
		 * @param xmlData
		 *
		 */
		private function doSerialize(object : Object, annotation : Annotation, xmlData : XML) : void {
			var serializer : ISerializer = AnnotationFactory.instance.getSerializer(annotation);
			var target : Object = object[annotation.fieldName];
			if (target != null) {
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
		public final function deserialize(xmlData : XML, objectClass : Class = null, getFromCache : Boolean = false) : Object {
			if(configuration.enableLogging){
				log.info("Started xml deserialization to type {0}. GetFromCache flag is {1}", objectClass, getFromCache);
			}
			if (xmlData) {
				if (!objectClass) {
					objectClass = getIncomingType(xmlData);
				}
				if (objectClass) {
					var result : Object;
					var id : String = getId(objectClass, xmlData);
					var foundInCache : Boolean;

					//get object from cache
					if (id && ModelObjectCache.instance.isCached(id, objectClass)) {
						if (getFromCache) {
							return ModelObjectCache.instance.getObject(id, objectClass);
						}
						result = ModelObjectCache.instance.getObject(id, objectClass);
						if (result) {
							foundInCache = true;
						}
					}

					var classDescriptor : XmlClass;
					if (!_descriptorStore.isCustomSerializable(objectClass)) {
						classDescriptor = _descriptorStore.getDescriptor(objectClass);
					}

					if (!foundInCache) {
						//if object is auto processed, get constructor arguments declarations
						var _arguments : Array;
						if (!_descriptorStore.isCustomSerializable(objectClass) && !classDescriptor.constructor.isDefault()) {
							_arguments = [];
							var stageCache : Stage;
							for each (var member : XmlMember in classDescriptor.constructor.parameterFields) {
								//On deserialization, when using constructor arguments, we need to process them even though the ignoreOn 
								//flag is set to deserialize stage.
								var data : Object = AnnotationFactory.instance.getSerializer(member).deserialize(xmlData, member, this);
								_arguments.push(data);
							}
						}
						//create object instance
						result = Instanciator.getInstance(objectClass, _arguments);
						//put new object in cache
						if (id) {
							ModelObjectCache.instance.putObject(id, result);
						}
					}

					//dispatch preDeserializeEvent
					dispatchEvent(XmlEvent.createPreDeserializeEvent(result, xmlData));

					//update object fields
					if (_descriptorStore.isCustomSerializable(objectClass)) {
						IXmlSerializable(result).fromXml(xmlData);
					} else {
						//iterate through anotations
						for each (var annotation : XmlMember in classDescriptor.members) {
							if (annotation.readOnly || classDescriptor.constructor.hasParameterField(annotation)) {
								continue;
							}
							if(annotation.ignoreOn == Stage.DESERIALIZE){
								// Let's keep the old behavior for now. If the ignoreOn flag is set on deserialize, 
								// the field's value is set to null.
								// TODO: check if this can be removed
								result[annotation.fieldName] = null;
							}else{
								var serializer : ISerializer = AnnotationFactory.instance.getSerializer(annotation);
								result[annotation.fieldName] = serializer.deserialize(xmlData, annotation, this);
							}
						}
					}

					//dispatch postDeserializeEvent
					dispatchEvent(XmlEvent.createPostDeserializeEvent(result, xmlData));
					
					if(configuration.enableLogging){
						log.info("Ended xml deserialization");
					}
					
					return result;
				}
			}
			if(configuration.enableLogging){
				log.info("Ended xml deserialization");
			}
			return null;
		}

		/**
		 * Get the type class corresponding to the namespace defined in the incoming xml
		 * @param incomingXML
		 * @return class
		 *
		 */
		public final function getIncomingType(incomingXML : XML) : Class {
			if (incomingXML) {
				if (configuration.getResponseTypeByTagName) {
					var tagName : QName = incomingXML.name() as QName;
					if (tagName) {
						var clasz : Class = _descriptorStore.getClassByTagName(tagName.localName);
						if (clasz) {
							return clasz;
						}
					}
				}
				if (configuration.getResponseTypeByNamespace) {
					if (incomingXML.namespaceDeclarations().length > 0) {
						var _namespace : String = (incomingXML.namespaceDeclarations()[0] as Namespace).uri;
						return _descriptorStore.getClassByNamespace(_namespace);
					}
				}

			}
			return null;
		}

		/**
		 *
		 * @param result
		 * @param xmlData
		 * @return
		 *
		 */
		private function getId(objectClass : Class, xmlData : XML) : String {
			var id : String;
			if (_descriptorStore.isCustomSerializable(objectClass)) {
				id = _descriptorStore.getCustomSerializableReference(objectClass).getIdValue(xmlData);
			} else {
				var classDescriptor : XmlClass = _descriptorStore.getDescriptor(objectClass);
				var idSerializer : ISerializer = AnnotationFactory.instance.getSerializer(classDescriptor.idField);
				if (idSerializer) {
					id = String(idSerializer.deserialize(xmlData, classDescriptor.idField, this));
				}
			}
			return id;
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function preDeserializeHandler(event : XmlEvent) : void {
			if (event.object is PersistableObject) {
				PersistableObject(event.object).stopListening();
			}
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function postDeserializeHandler(event : XmlEvent) : void {
			var result : Object = event.object;
			if (result is PersistableObject) {
				PersistableObject(result).commit();
				PersistableObject(result).startListening();
			}
		}
	}
}