package com.googlecode.serializer.flexxb
{
	import flash.events.Event;

	public class XmlEvent extends Event
	{
		public static const PRE_SERIALIZE : String = "preserialize";
		public static const POST_SERIALIZE : String = "postserialize";
		public static const PRE_DESERIALIZE : String = "predeserialize";
		public static const POST_DESERIALIZE : String = "postdeserialize";
		
		public static function createPreSerializeEvent(object : Object, xml : XML) : XmlEvent{
			return new XmlEvent(PRE_SERIALIZE, object, xml);
		}
		
		public static function createPostSerializeEvent(object : Object, xml : XML) : XmlEvent{
			return new XmlEvent(POST_SERIALIZE, object, xml);
		}
		
		public static function createPreDeserializeEvent(object : Object, xml : XML) : XmlEvent{
			return new XmlEvent(PRE_DESERIALIZE, object, xml);
		}
		
		public static function createPostDeserializeEvent(object : Object, xml : XML) : XmlEvent{
			return new XmlEvent(POST_DESERIALIZE, object, xml);
		}
		
		private var _object : Object;
		private var _xml : XML;
		
		public function XmlEvent(type:String, object : Object, xml : XML, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			_object = object;
			_xml = xml;
		}
		
		public function get object() : Object{
			return _object;
		}
		
		public function get xml() : XML{
			return _xml;
		}
	}
}