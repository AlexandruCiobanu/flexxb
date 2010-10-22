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
	import flash.events.Event;
	/**
	 * 
	 * @author Alexutzutz
	 * 
	 */	
	public class XmlEvent extends Event {
		public static const PRE_SERIALIZE : String = "preserialize";
		public static const POST_SERIALIZE : String = "postserialize";
		public static const PRE_DESERIALIZE : String = "predeserialize";
		public static const POST_DESERIALIZE : String = "postdeserialize";
		/**
		 * 
		 * @param object
		 * @param parent
		 * @param xml
		 * @return 
		 * 
		 */		
		public static function createPreSerializeEvent(object : Object, parent : Object, xml : XML) : XmlEvent {
			return new XmlEvent(PRE_SERIALIZE, object, parent, xml);
		}
		/**
		 * 
		 * @param object
		 * @param parent
		 * @param xml
		 * @return 
		 * 
		 */		
		public static function createPostSerializeEvent(object : Object, parent : Object, xml : XML) : XmlEvent {
			return new XmlEvent(POST_SERIALIZE, object, parent, xml);
		}
		/**
		 * 
		 * @param object
		 * @param parent
		 * @param xml
		 * @return 
		 * 
		 */		
		public static function createPreDeserializeEvent(object : Object, parent : Object, xml : XML) : XmlEvent {
			return new XmlEvent(PRE_DESERIALIZE, object, parent, xml);
		}
		/**
		 * 
		 * @param object
		 * @param parent
		 * @param xml
		 * @return 
		 * 
		 */		
		public static function createPostDeserializeEvent(object : Object, parent : Object, xml : XML) : XmlEvent {
			return new XmlEvent(POST_DESERIALIZE, object, parent, xml);
		}

		private var _object : Object;
		private var _parent : Object;
		private var _xml : XML;
		/**
		 * 
		 * @param type
		 * @param object
		 * @param xml
		 * 
		 */		
		public function XmlEvent(type : String, object : Object, parent : Object, xml : XML) {
			super(type);
			_object = object;
			_parent = parent;
			_xml = xml;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get object() : Object {
			return _object;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get parent() : Object{
			return _parent;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get xml() : XML {
			return _xml;
		}
		
		public override function clone():Event{
			return new XmlEvent(type, _object, parent, xml);
		}
	}
}