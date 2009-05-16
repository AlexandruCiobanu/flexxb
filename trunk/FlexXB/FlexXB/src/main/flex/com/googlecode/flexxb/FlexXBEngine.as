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
package com.googlecode.flexxb
{
	import com.googlecode.flexxb.annotation.AnnotationFactory;
	import com.googlecode.flexxb.api.IFlexXBApi;
	import com.googlecode.flexxb.converter.IConverter;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	/**
	* Triggers prior to the serialization of an object into XML
	*/	
	[Event(name="preserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	/**
	* Triggers after the serialization of an AS3 object into XML 
	*/	
	[Event(name="postserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	/**
	* Triggers prior to the deserialization of a XML into an AS3 object
	*/	
	[Event(name="predeserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	/**
	* Triggers after the deserialization of a XML into an AS3 object
	*/	
	[Event(name="postdeserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	/**
	 * Entry point for AS3-XML (de)serialization. Allows new annotation registration.
	 * The main access point consist of two methods: <code>serialize()</code> and <code>deserialize</code>, each corresponding to the specific stage in the conversion process.  
	 * By default it registeres the built-in annotations at startup. 
	 * <p>Built-in anotation usage:
	 *  <ul>
	 *  <li>XmlClass: <code>[XmlClass(alias="MyClass", useNamespaceFrom="elementFieldName", idField="idFieldName", prefix="my", uri="http://www.your.site.com/schema/", defaultValueField="fieldName")]</code></li>
	 *  <li>XmlAttribute: <code>[XmlAttribute(name="attribute", ignoreOn="serialize|deserialize")]</code></li>
	 *  <li>XmlElement: <code>[XmlElement(alias="element", getFromCache="true|false", ignoreOn="serialize|deserialize", serializePartialElement="true|false")]</code></li>
	 *  <li>XmlArray: <code>[XmlArray(alias="element", memberName="NameOfArrayElement", getFromCache="true|false", type="my.full.type" ignoreOn="serialize|deserialize", serializePartialElement="true|false")]</code></li>
	 *  </ul></p>
	 * <p>Make sure you add the following switches to your compiler settings:
	 * <code>-keep-as3-metadata XmlClass -keep-as3-metadata XmlAttribute -keep-as3-metadata XmlElement -keep-as3-metadata XmlArray</code></p>
	 * @author aCiobanu
	 * 
	 */
	public class FlexXBEngine implements IEventDispatcher
	{
		private static var _instance : FlexXBEngine;
		/**
		 * Singleton accessor
		 * @return instance of FlexXBEngine
		 * 
		 */		
		public static function get instance() : FlexXBEngine{
			if(!_instance){
				_instance = new FlexXBEngine();
			}
			return _instance;
		} 
		
		private var descriptorStore : DescriptorStore;
		
		private var converterStore : ConverterStore;
		
		private var core : SerializerCore;
		
		private var _api : IFlexXBApi;
		/**
		 * Constructor
		 * 
		 */		
		public function FlexXBEngine()
		{
			if(_instance){
				throw new Error("Use FlexXBEngine.instance instead!");
			}
			descriptorStore = new DescriptorStore();
			converterStore = new ConverterStore();
			core = new SerializerCore(descriptorStore, converterStore);
			_api = new FlexXBApi(descriptorStore);
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public final function get api() : IFlexXBApi{
			return _api;
		}
		/**
		 * Convert an object to a xml representation.
		 * @param object object to be converted.
		 * @return xml representation of the given object
		 * 
		 */		
		public final function serialize(object : Object, partial : Boolean = false) : XML{
			return core.serialize(object, partial);
		}
		/**
		 * Convert an xml to an AS3 object counterpart
		 * @param xmlData xml to be deserialized
		 * @param objectClass object class
		 * @param getFromCache get the object from the model object cache if it exists, without applying the xml  
		 * @return object of type objectClass 
		 * 
		 */		
		public final function deserialize(xmlData : XML, objectClass : Class = null, getFromCache : Boolean = false) : Object{
			return core.deserialize(xmlData, objectClass, getFromCache);
		}
		/**
		 * Do an early processing of types involved in the communication process if one 
		 * wants to bypass the lazy processing method implemented by the serializer.   
		 * @param args types to be processed
		 * 
		 */		
		public final function processTypes(...args) : void{
			if(args && args.length > 0){
				for each(var item : Object in args){
					if(item is Class){
						descriptorStore.getDescriptor(item);
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
		public function registerSimpleTypeConverter(converter : IConverter, overrideExisting : Boolean = false) : Boolean{
			return converterStore.registerSimpleTypeConverter(converter, overrideExisting);
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
			AnnotationFactory.instance.registerAnnotation(name, annotationClazz, serializer, overrideExisting);
		}
		/**
		 * 
		 * @see flash.events.IEventDispatcher#addEventListener()
		 * 
		 */		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			core.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		/**
		 * 
		 * @see flash.events.IEventDispatcher#removeEventListener()
		 * 
		 */	
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			core.removeEventListener(type, listener, useCapture);
		}
		/**
		 * 
		 * @see flash.events.IEventDispatcher#dispatchEvent()
		 * 
		 */	
		public function dispatchEvent(event:Event):Boolean
		{
			return false;
		}
		/**
		 * 
		 * @see flash.events.IEventDispatcher#hasEventListener()
		 * 
		 */	
		public function hasEventListener(type:String):Boolean
		{
			return false;
		}
		/**
		 * 
		 * @see flash.events.IEventDispatcher#willTrigger()
		 * 
		 */	
		public function willTrigger(type:String):Boolean
		{
			return false;
		}
	}
}