package com.googlecode.flexxb
{
	import com.googlecode.flexxb.converter.IConverter;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	/**
	* 
	*/	
	[Event(name="preserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	/**
	* 
	*/	
	[Event(name="postserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	/**
	* 
	*/	
	[Event(name="predeserialize", type="com.googlecode.serializer.flexxb.XmlEvent")]
	/**
	* 
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
		 * 
		 * @return 
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
		/**
		 * 
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
		}
		/**
		 * 
		 * @param object
		 * @param partial
		 * @return 
		 * 
		 */		
		public final function serialize(object : Object, partial : Boolean = false) : XML{
			return core.serialize(object, partial);
		}
		/**
		 * 
		 * @param xmlData
		 * @param objectClass
		 * @param getFromCache
		 * @return 
		 * 
		 */		
		public final function deserialize(xmlData : XML, objectClass : Class = null, getFromCache : Boolean = false) : Object{
			return core.deserialize(xmlData, objectClass, getFromCache);
		}	
		/**
		 * 
		 * @param converter
		 * @param overrideExisting
		 * @return 
		 * 
		 */		
		public function registerSimpleTypeConverter(converter : IConverter, overrideExisting : Boolean = false) : Boolean{
			return converterStore.registerSimpleTypeConverter(converter, overrideExisting);
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