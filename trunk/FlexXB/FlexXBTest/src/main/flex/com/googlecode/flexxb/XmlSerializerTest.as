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
	import com.googlecode.testData.ConstructorRefObj;
	import com.googlecode.testData.CustomSerializabeObject;
	import com.googlecode.testData.List;
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Mock2;
	import com.googlecode.testData.Mock3;
	import com.googlecode.testData.XmlPathObject;
	import com.googlecode.testData.XmlTypedObj;
	
	import flexunit.framework.TestCase;

	public class XmlSerializerTest extends TestCase {
		public function XmlSerializerTest(methodName : String = null) {
			super(methodName);
		}

		protected function getObject() : Mock {
			var target : Mock = new Mock();
			target.link = new Mock3();
			target.aField = "test1";
			target.date = new Date();
			target.version = 6;
			target.result = [];
			var mk : Mock = new Mock();
			mk.date = new Date();
			mk.aField = "mocktestfield";
			target.result.push(mk);
			return target;
		}

		protected function compare(source : Mock, copy : Mock) : void {
			assertEquals("Wrong version", source.version, copy.version);
			assertEquals("Wrong aField", source.aField, copy.aField);
			assertEquals("Wrong link id", source.link.id, copy.link.id);
			assertNull("Date not null", copy.date);
			assertEquals("Wrong result list", source.result.length, copy.result.length);
			assertFalse("Wrong excluded field", copy.someExcludedField);			
		}

		public function testSerializeWithNS() : void {
			var target : Mock = getObject();
			var xml : XML = FlexXBEngine.instance.serialize(target);
			var copy : Mock = FlexXBEngine.instance.deserialize(xml, Mock);
			compare(target, copy);
			var nss : Array = xml.inScopeNamespaces();
			var str : String = xml.toXMLString().split(nss[0].prefix + ":").join("").split("xmlns:" + nss[0].prefix + "=\"" + nss[0].uri + "\"").join("");
			xml = XML(str);
			copy = FlexXBEngine.instance.deserialize(xml, Mock);
			compare(target, copy);
		}
		
		public function testXmlTypedFields() : void{
			var target : XmlTypedObj = new XmlTypedObj();
			target.firstXml = <test id="1"><element>retw</element></test>;
			target.secondXml = <person id="3"><name>Doe</name></person>;
			var engine : FlexXBEngine = new FlexXBEngine();
			engine.processTypes(XmlTypedObj);
			var xml : XML = engine.serialize(target);
			var copy : XmlTypedObj = engine.deserialize(xml, XmlTypedObj);
			assertEquals("firstXml stinks", target.firstXml.toXMLString(), copy.firstXml.toXMLString());
			assertEquals("secondXml stinks", target.secondXml.toXMLString(), copy.secondXml.toXMLString());
		}

		public function testCustomConstructor() : void {
			var target : ConstructorRefObj = new ConstructorRefObj("test", 1, true);
			var xml : XML = FlexXBEngine.instance.serialize(target);
			var copy : ConstructorRefObj = FlexXBEngine.instance.deserialize(xml, ConstructorRefObj);
			assertEquals("Ref1 is different", target.ref1, copy.ref1);
			assertEquals("Ref2 is different", target.ref2, copy.ref2);
			assertEquals("Ref3 is different", target.ref3, copy.ref3);
		}

		public function testSerializeWithoutNS() : void {
			var target : Mock3 = new Mock3();
			target.attribute = true;
			target.id = 5;
			target.version = 33;
			var xml : XML = FlexXBEngine.instance.serialize(target);
			var copy : Mock3 = FlexXBEngine.instance.deserialize(xml, Mock3);
			assertEquals("Attribute is wrong", target.attribute, copy.attribute);
			assertEquals("id is wrong", target.id, copy.id);
			assertEquals("version is wrong", target.version, copy.version);
		}

		public function testSimpleTypedArrays() : void {
			var tst : List = new List();
			tst.nums.push(1, 2, 3, 4);
			var xml : XML = FlexXBEngine.instance.serialize(tst);
			var copy : List = FlexXBEngine.instance.deserialize(xml, List);
			assertEquals("Length does not match", tst.nums.length, copy.nums.length);
			var i : int = 0;
			while (i < tst.nums.length) {
				assertEquals("Element " + i + " does not match", tst.nums[i], copy.nums[i++]);
			}
		}

		public function testVirtualPath() : void {
			var target : XmlPathObject = new XmlPathObject();
			target.defaultTest = "My custom default";
			target.identity = 345;
			target.reference = "SOmeRef";
			var xml : XML = FlexXBEngine.instance.serialize(target);
			var copy : XmlPathObject = FlexXBEngine.instance.deserialize(xml, XmlPathObject);
			assertEquals("Identity is wrong", target.identity, copy.identity);
			assertEquals("Reference is wrong", target.reference, copy.reference);
			assertEquals("DefaultTest is wrong", target.defaultTest, copy.defaultTest);
		}

		public function testClassTypeByNamespace() : void {
			var target : Mock2 = new Mock2();
			target.id = 512;
			var xml : XML = FlexXBEngine.instance.serialize(target);
			var copy : Object = FlexXBEngine.instance.deserialize(xml);
			assertTrue("copy is null or not mock2", copy is Mock2);
		}

		public function testCustomSerialization() : void {
			var target : CustomSerializabeObject = new CustomSerializabeObject();
			target.test = "acesta este un test";
			var xml : XML = FlexXBEngine.instance.serialize(target);
			assertNotNull("Empty xml!", xml);
			var result : CustomSerializabeObject = FlexXBEngine.instance.deserialize(xml, CustomSerializabeObject);
			assertEquals("Wrong test field values", target.test, result.test);

		}
	}
}