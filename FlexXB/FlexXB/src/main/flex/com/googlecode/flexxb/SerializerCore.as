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
	import com.googlecode.flexxb.annotation.AnnotationFactory;
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	import com.googlecode.flexxb.annotation.contract.IFieldAnnotation;
	import com.googlecode.flexxb.annotation.contract.IMemberAnnotation;
	import com.googlecode.flexxb.annotation.contract.Stage;
	import com.googlecode.flexxb.interfaces.ICycleRecoverable;
	import com.googlecode.flexxb.interfaces.IXmlSerializable;
	import com.googlecode.flexxb.persistence.IPersistable;
	import com.googlecode.flexxb.persistence.PersistableObject;
	import com.googlecode.flexxb.serializer.ISerializer;
	import com.googlecode.flexxb.util.Instanciator;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;
	
	import flash.events.EventDispatcher;
	
	/**
	 * @private
	 * @author Alexutz
	 *
	 */
	public final class SerializerCore extends EventDispatcher {
		
		private static const LOG : ILogger = LogFactory.getLog(SerializerCore);
		
		private var mappingModel : MappingModel;

		/**
		 * Constructor
		 *
		 */
		public function SerializerCore(mappingModel : MappingModel){
			if (!MappingModel) {
				throw new Error("Mapping model must not be null");
			}
			this.mappingModel = mappingModel;
			addEventListener(XmlEvent.PRE_DESERIALIZE, onPreDeserialize, false, 150, true);
			addEventListener(XmlEvent.POST_DESERIALIZE, onPostDeserialize, false, 150, true);
		}
		
		public function get configuration() : Configuration{
			return mappingModel.configuration;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get descriptorStore() : IDescriptorStore {
			return mappingModel.descriptorStore;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get converterStore() : IConverterStore {
			return mappingModel.converterStore;
		}
		
		public function get idResolver() : IdResolver{
			return mappingModel.idResolver;
		}
		
		public function get currentObject() : Object{
			return mappingModel.collisionDetector.getCurrent();
		}

		/**
		 * Convert an object to a xml representation.
		 * @param object object to be converted.
		 * @param version
		 * @return xml representation of the given object
		 *
		 */
		public final function serialize(object : Object, partial : Boolean = false, version : String = "") : XML {
			if(configuration.enableLogging){
				LOG.info("Started object serialization. Partial flag is {0}", partial);
			}
			if (object == null) {
				if(configuration.enableLogging){
					LOG.info("Object is null. Ended serialization");
				}
				return null;
			}
			var xmlData : XML;
			
			object = pushObject(object, partial);
			
			mappingModel.processNotifier.notifyPreSerialize(this, xmlData);

			if (mappingModel.descriptorStore.isCustomSerializable(object)) {
				xmlData = IXmlSerializable(object).toXml();
			} else {
				var classDescriptor : IClassAnnotation = mappingModel.descriptorStore.getDescriptor(object, version);
				xmlData = AnnotationFactory.instance.getSerializer(classDescriptor).serialize(object, classDescriptor, null, this);
				var serializer : ISerializer;
				var annotation : IMemberAnnotation;
				if (partial && classDescriptor.idField) {
					doSerialize(object, classDescriptor.idField, xmlData);
				} else if (configuration.onlySerializeChangedValueFields && object is PersistableObject) {
					for each (annotation in classDescriptor.members) {
						if (annotation.writeOnly  || annotation.ignoreOn == Stage.SERIALIZE || !PersistableObject(object).isChanged(annotation.name.localName)) {
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

			mappingModel.processNotifier.notifyPostSerialize(this, xmlData);
			
			mappingModel.collisionDetector.pop();
			
			if(configuration.enableLogging){
				LOG.info("Ended object serialization");
			}
			
			return xmlData;
		}
		
		public function getObjectId(object : Object) : String{
			var classDescriptor : IClassAnnotation = mappingModel.descriptorStore.getDescriptor(object);
			if(classDescriptor.idField){
				return object[classDescriptor.idField.name];
			}
			return "";
		} 
		
		private function pushObject(obj : Object, partial : Boolean) : Object{
			var collisionDetected : Boolean = !mappingModel.collisionDetector.push(obj);
			if(collisionDetected){
				if(partial){
					mappingModel.collisionDetector.pushNoCheck(obj);
				}else if(obj is ICycleRecoverable){
					obj = ICycleRecoverable(obj).onCycleDetected(mappingModel.collisionDetector.getCurrent());
					obj = pushObject(obj, partial);
				}else{
					throw new Error("Cycle detected!");
				}
			}
			return obj;
		}

		/**
		 *
		 * @param object
		 * @param annotation
		 * @param xmlData
		 *
		 */
		private function doSerialize(object : Object, annotation : IFieldAnnotation, xmlData : XML) : void {
			if(configuration.enableLogging){
				LOG.info("Serializing field {0} as {1}", annotation.name, annotation.annotationName);
			}
			var serializer : ISerializer = AnnotationFactory.instance.getSerializer(annotation);
			var target : Object = object[annotation.name];
			if (target != null) {
				serializer.serialize(target, annotation, xmlData, this);
			}
		}

		/**
		 * Convert an xml to an AS3 object counterpart
		 * @param xmlData xml to be deserialized
		 * @param objectClass object class
		 * @param getFromCache
		 * @param version
		 * @return object of type objectClass
		 *
		 */
		public final function deserialize(xmlData : XML, objectClass : Class = null, getFromCache : Boolean = false, version : String = "") : Object {
			if(configuration.enableLogging){
				LOG.info("Started xml deserialization to type {0}. GetFromCache flag is {1}", objectClass, getFromCache);
			}
			if (xmlData) {
				if (!objectClass) {
					objectClass = getIncomingType(xmlData);
				}
				if (objectClass) {
					var result : Object;
					var itemId : String = getId(objectClass, xmlData);
					var foundInCache : Boolean;

					//get object from cache
					if (configuration.allowCaching && itemId && configuration.cacheProvider.isInCache(itemId, objectClass)) {
						if (getFromCache) {
							return configuration.cacheProvider.getFromCache(itemId, objectClass);
						}
						result = configuration.cacheProvider.getFromCache(itemId, objectClass);
						foundInCache = result != null;
					}

					var classDescriptor : IClassAnnotation;
					if (!mappingModel.descriptorStore.isCustomSerializable(objectClass)) {
						classDescriptor = mappingModel.descriptorStore.getDescriptor(objectClass, version);
					}

					if (!foundInCache) {
						//if object is auto processed, get constructor arguments declarations
						var _arguments : Array;
						if (!mappingModel.descriptorStore.isCustomSerializable(objectClass) && !classDescriptor.constructor.isDefault()) {
							_arguments = [];
							var stageCache : Stage;
							for each (var member : IMemberAnnotation in classDescriptor.constructor.parameterFields) {
								//On deserialization, when using constructor arguments, we need to process them even though the ignoreOn 
								//flag is set to deserialize stage.
								var data : Object = AnnotationFactory.instance.getSerializer(member).deserialize(xmlData, member, this);
								_arguments.push(data);
							}
						}
						//create object instance
						if(configuration.allowCaching){
							result = configuration.cacheProvider.getNewInstance(objectClass, itemId, _arguments);
						}else{
							result = Instanciator.getInstance(objectClass, _arguments);
						}
					}
					
					if(itemId){
						mappingModel.idResolver.bind(itemId, result);
					}
					
					mappingModel.collisionDetector.pushNoCheck(result);
					
					//dispatch preDeserializeEvent
					mappingModel.processNotifier.notifyPreDeserialize(this, result, xmlData);
					
					//update object fields
					if (mappingModel.descriptorStore.isCustomSerializable(objectClass)) {
						IXmlSerializable(result).fromXml(xmlData);
					} else {
						//iterate through anotations
						for each (var annotation : IMemberAnnotation in classDescriptor.members) {
							if (annotation.readOnly || classDescriptor.constructor.hasParameterField(annotation)) {
								continue;
							}
							if(annotation.ignoreOn == Stage.DESERIALIZE){
								// Let's keep the old behavior for now. If the ignoreOn flag is set on deserialize, 
								// the field's value is set to null.
								// TODO: check if this can be removed
								result[annotation.name] = null;
							}else{
								var serializer : ISerializer = AnnotationFactory.instance.getSerializer(annotation);
								result[annotation.name] = serializer.deserialize(xmlData, annotation, this);
							}
						}
					}
					//dispatch postDeserializeEvent
					mappingModel.processNotifier.notifyPostDeserialize(this, result, xmlData);
					
					mappingModel.collisionDetector.pop();
					
					if(configuration.enableLogging){
						LOG.info("Ended xml deserialization");
					}
					
					return result;
				}
			}
			if(configuration.enableLogging){
				LOG.info("Ended xml deserialization");
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
						var clasz : Class = mappingModel.descriptorStore.getClassByTagName(tagName.localName);
						if (clasz) {
							return clasz;
						}
					}
				}
				if (configuration.getResponseTypeByNamespace) {
					if (incomingXML.namespaceDeclarations().length > 0) {
						var _namespace : String = (incomingXML.namespaceDeclarations()[0] as Namespace).uri;
						return mappingModel.descriptorStore.getClassByNamespace(_namespace);
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
			var itemId : String;
			if (mappingModel.descriptorStore.isCustomSerializable(objectClass)) {
				itemId = mappingModel.descriptorStore.getCustomSerializableReference(objectClass).getIdValue(xmlData);
			} else {
				var classDescriptor : IClassAnnotation = mappingModel.descriptorStore.getDescriptor(objectClass);
				var idSerializer : ISerializer = AnnotationFactory.instance.getSerializer(classDescriptor.idField);
				if (idSerializer) {
					itemId = String(idSerializer.deserialize(xmlData, classDescriptor.idField, this));
				}
			}
			return itemId;
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onPreDeserialize(event : XmlEvent) : void {
			if (event.object is IPersistable) {
				IPersistable(event.object).stopListening();
			}
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onPostDeserialize(event : XmlEvent) : void {
			var result : Object = event.object;
			if (result is IPersistable) {
				IPersistable(result).commit();
				IPersistable(result).startListening();
			}
		}
	}
}