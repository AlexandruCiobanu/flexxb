/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
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
	import flash.events.Event;

	public class XmlEvent extends Event {
		public static const PRE_SERIALIZE : String = "preserialize";
		public static const POST_SERIALIZE : String = "postserialize";
		public static const PRE_DESERIALIZE : String = "predeserialize";
		public static const POST_DESERIALIZE : String = "postdeserialize";

		public static function createPreSerializeEvent(object : Object, xml : XML) : XmlEvent {
			return new XmlEvent(PRE_SERIALIZE, object, xml);
		}

		public static function createPostSerializeEvent(object : Object, xml : XML) : XmlEvent {
			return new XmlEvent(POST_SERIALIZE, object, xml);
		}

		public static function createPreDeserializeEvent(object : Object, xml : XML) : XmlEvent {
			return new XmlEvent(PRE_DESERIALIZE, object, xml);
		}

		public static function createPostDeserializeEvent(object : Object, xml : XML) : XmlEvent {
			return new XmlEvent(POST_DESERIALIZE, object, xml);
		}

		private var _object : Object;
		private var _xml : XML;

		public function XmlEvent(type : String, object : Object, xml : XML, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			_object = object;
			_xml = xml;
		}

		public function get object() : Object {
			return _object;
		}

		public function get xml() : XML {
			return _xml;
		}
	}
}