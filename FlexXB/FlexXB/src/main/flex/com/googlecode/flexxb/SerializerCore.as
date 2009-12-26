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
			if (object == null) {
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
					if (incomingXML.namespaceDeclarations().length == 0) {
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