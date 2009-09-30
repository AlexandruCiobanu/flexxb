package com.googlecode.testData {
	import com.googlecode.flexxb.IXmlSerializable;

	public class CustomSerializabeObject implements IXmlSerializable {
		public var test : String;

		public function CustomSerializabeObject() {
		}

		public function get id() : String {
			return null;
		}

		public function toXml() : XML {
			return <testObject><testField>{test}</testField></testObject>;
		}

		public function get thisType() : Class {
			return CustomSerializabeObject;
		}

		public function fromXml(xmlData : XML) : Object {
			test = xmlData.testField;
			return this;
		}

		public function getIdValue(xmldata : XML) : String {
			return null;
		}
	}
}