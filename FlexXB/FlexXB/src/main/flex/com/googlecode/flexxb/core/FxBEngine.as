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
package com.googlecode.flexxb.core {
	import com.googlecode.flexxb.annotation.AnnotationFactory;
	import com.googlecode.flexxb.annotation.contract.Constants;
	import com.googlecode.flexxb.annotation.contract.ConstructorArgument;
	import com.googlecode.flexxb.api.IFlexXBApi;
	import com.googlecode.flexxb.converter.IConverter;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;
	import com.googlecode.flexxb.xml.XmlDescriptionContext;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
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
	public final class FxBEngine {
		private static var _instance : FxBEngine;
		
		private static const LOG : ILogger = LogFactory.getLog(FxBEngine);
		
		private var _api : IFlexXBApi;
		
		private var contextMap : Object;
		
		private var store : DescriptorStore;

		/**
		 * Not a singleton, but an easy access instance.
		 * @return instance of FlexXBEngine
		 *
		 */
		public static function get instance() : FxBEngine {
			if (!_instance) {
				_instance = new FxBEngine();
			}
			return _instance;
		}

		/**
		 * Constructor
		 *
		 */
		public function FxBEngine() {
			contextMap = new Object();
			store = new DescriptorStore();
			registerDescriptionContext("XML", new XmlDescriptionContext());
		}
		/**
		 * Get a reference to the api object
		 * @return instance of type <code>com.googlecode.flexxb.api.IFlexXBApi</code>
		 *
		 */		
		public function get api() : IFlexXBApi {
			if (!_api) {
				_api = new FlexXBApi(getXmlSerializer() as FlexXBCore, store);
			}
			return _api;
		}
		/**
		 * 
		 * @param name
		 * @param context
		 * 
		 */		
		public function registerDescriptionContext(name : String, context : DescriptionContext) : void{
			if(!name || !context){
				throw new Error();
			}
			if(contextMap[name]){
				throw new Error();
			}
			contextMap[name] = {context: context, core : null};
		}
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */	
		public function getSerializer(name : String) : IFlexXB{
			var item : Object = contextMap[name];
			if(item){
				DescriptionContext(item.context).initializeContext(this, store);
				if(!item.core){
					item.core = new FlexXBCore(item.context as DescriptionContext, store);
				}
				return item.core as IFlexXB;
			}
			return null;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function getXmlSerializer() : IFlexXB{
			return getSerializer("XML");
		}
	}
}