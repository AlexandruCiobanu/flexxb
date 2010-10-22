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
	import com.googlecode.flexxb.annotation.xml.XmlArray;
	import com.googlecode.flexxb.annotation.xml.XmlAttribute;
	import com.googlecode.flexxb.annotation.xml.XmlClass;
	import com.googlecode.flexxb.annotation.xml.XmlElement;
	import com.googlecode.flexxb.api.IFlexXBApi;
	import com.googlecode.flexxb.converter.ClassTypeConverter;
	import com.googlecode.flexxb.converter.IConverter;
	import com.googlecode.flexxb.converter.XmlConverter;
	import com.googlecode.flexxb.serializer.XmlArraySerializer;
	import com.googlecode.flexxb.serializer.XmlAttributeSerializer;
	import com.googlecode.flexxb.serializer.XmlClassSerializer;
	import com.googlecode.flexxb.serializer.XmlElementSerializer;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * Triggers prior to the serialization of an object into XML
	 */
	[Event(name="preserialize", type="com.googlecode.flexxb.XmlEvent")]
	/**
	 * Triggers after the serialization of an AS3 object into XML
	 */
	[Event(name="postserialize", type="com.googlecode.flexxb.XmlEvent")]
	/**
	 * Triggers prior to the deserialization of a XML into an AS3 object
	 */
	[Event(name="predeserialize", type="com.googlecode.flexxb.XmlEvent")]
	/**
	 * Triggers after the deserialization of a XML into an AS3 object
	 */
	[Event(name="postdeserialize", type="com.googlecode.flexxb.XmlEvent")]
	/**
	 * Entry point for AS3-XML (de)serialization. Allows new annotation registration.
	 * The main access point consist of two methods: <code>serialize()</code> and <code>deserialize</code>, each corresponding to the specific stage in the conversion process.
	 * By default it registeres the built-in annotations at startup.
	 * <p>Built-in anotation usage:
	 *  <ul>
	 *  <li>XmlClass: <code>[XmlClass(alias="MyClass", useNamespaceFrom="elementFieldName", idField="idFieldName", prefix="my", 
	 *                        uri="http://www.your.site.com/schema/", defaultValueField="fieldName")]</code></li>
	 *  <li>XmlAttribute: <code>[XmlAttribute(name="attribute", ignoreOn="serialize|deserialize")]</code></li>
	 *  <li>XmlElement: <code>[XmlElement(alias="element", getFromCache="true|false", ignoreOn="serialize|deserialize", 
	 *                     serializePartialElement="true|false")]</code></li>
	 *  <li>XmlArray: <code>[XmlArray(alias="element", memberName="NameOfArrayElement", getFromCache="true|false", type="my.full.type" ignoreOn="serialize|deserialize", 
	 *                   serializePartialElement="true|false")]</code></li>
	 *  </ul></p>
	 * <p>Make sure you add the following switches to your compiler settings:
	 * <code>-keep-as3-metadata XmlClass -keep-as3-metadata XmlAttribute -keep-as3-metadata XmlElement -keep-as3-metadata XmlArray</code></p>
	 * @author aCiobanu
	 *
	 */
	public final class FlexXBEngine implements IEventDispatcher {
		private static var _instance : FlexXBEngine;
		
		private static const LOG : ILogger = LogFactory.getLog(FlexXBEngine);

		/**
		 * Not a singleton, but an easy access instance.
		 * @return instance of FlexXBEngine
		 *
		 */
		public static function get instance() : FlexXBEngine {
			if (!_instance) {
				_instance = new FlexXBEngine();
			}
			return _instance;
		}
		
		private var mappingModel : MappingModel;
		
		private var core : SerializerCore;

		private var _api : IFlexXBApi;

		/**
		 * Constructor
		 *
		 */
		public function FlexXBEngine() {
			mappingModel = new MappingModel();
			core = new SerializerCore(mappingModel);
			registerSimpleTypeConverter(new ClassTypeConverter());
			registerSimpleTypeConverter(new XmlConverter());
			
			registerAnnotation(XmlAttribute.ANNOTATION_NAME, XmlAttribute, XmlAttributeSerializer);
			registerAnnotation(XmlElement.ANNOTATION_NAME, XmlElement, XmlElementSerializer);
			registerAnnotation(XmlArray.ANNOTATION_NAME, XmlArray, XmlArraySerializer);
			registerAnnotation(XmlClass.ANNOTATION_NAME, XmlClass, XmlClassSerializer);
		}

		/**
		 * Get a reference to the configuration object
		 * @return instance of type <code>com.googlecode.flexxb.Configuration</code>
		 *
		 */
		public function get configuration() : Configuration {
			return mappingModel.configuration;
		}

		/**
		 * Get a reference to the api object
		 * @return instance of type <code>com.googlecode.flexxb.api.IFlexXBApi</code>
		 *
		 */
		public final function get api() : IFlexXBApi {
			if (!_api) {
				_api = new FlexXBApi(this, mappingModel.descriptorStore);
			}
			return _api;
		}

		/**
		 * Convert an object to a xml representation.
		 * @param object object to be converted.
		 * @param partial serialize the object in partial mode (only the object tag with id field)
		 * @param version 
		 * @return xml representation of the given object
		 *
		 */
		public final function serialize(object : Object, partial : Boolean = false, version : String = "") : XML {
			mappingModel.collisionDetector.beginDocument();
			var xml : XML = core.serialize(object, partial, version);
			mappingModel.collisionDetector.endDocument();
			return xml;
		}

		/**
		 * Convert an xml to an AS3 object counterpart
		 * @param xmlData xml to be deserialized
		 * @param objectClass object class
		 * @param getFromCache get the object from the model object cache if it exists, without applying the xml
		 * @param version
		 * @return object of type objectClass
		 *
		 */
		public final function deserialize(xmlData : XML, objectClass : Class = null, getFromCache : Boolean = false, version : String = "") : * {
			mappingModel.idResolver.beginDocument();
			mappingModel.collisionDetector.beginDocument();
			var object : Object = core.deserialize(xmlData, objectClass, getFromCache, version);
			mappingModel.idResolver.endDocument();
			mappingModel.collisionDetector.endDocument();
			return object;
		}

		/**
		 * Do an early processing of types involved in the communication process if one
		 * wants to bypass the lazy processing method implemented by the serializer.
		 * @param args types to be processed
		 *
		 */
		public final function processTypes(... args) : void {
			if (args && args.length > 0) {
				for each (var item : Object in args) {
					if (item is Class) {
						if(configuration.enableLogging){
							LOG.info("Processing class {0}", item);
						}
						mappingModel.descriptorStore.getDescriptor(item);
					}else if(configuration.enableLogging){
						LOG.info("Excluded from processing because it is not a class: {0}", item);
					}
				}
			}
		}

		/**
		 * Register a converter that defines how string values
		 * are transformed to a simple type object and viceversa
		 * @param converter converter instance
		 * @param overrideExisting override an existing converter for the specified type
		 * @return
		 *
		 */
		public function registerSimpleTypeConverter(converter : IConverter, overrideExisting : Boolean = false) : Boolean {
			return mappingModel.converterStore.registerSimpleTypeConverter(converter, overrideExisting);
		}

		/**
		 * @see AnnotationFactory#registerAnnotation()
		 *
		 */
		public function registerAnnotation(name : String, annotationClazz : Class, serializer : Class, overrideExisting : Boolean = false) : void {
			AnnotationFactory.instance.registerAnnotation(name, annotationClazz, serializer, overrideExisting);
		}
		
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			core.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			core.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event : Event) : Boolean {
			return false;
		}
		
		public function hasEventListener(type : String) : Boolean {
			return false;
		}
		
		public function willTrigger(type : String) : Boolean {
			return false;
		}
	}
}