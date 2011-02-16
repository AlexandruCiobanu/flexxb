/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2011 Alex Ciobanu
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
	import com.googlecode.flexxb.core.FxBEngine;
	import com.googlecode.flexxb.core.IFlexXB;
	import com.googlecode.testData.ConstructorRefObj;
	import com.googlecode.testData.CustomSerializabeObject;
	import com.googlecode.testData.List;
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Mock2;
	import com.googlecode.testData.Mock3;
	import com.googlecode.testData.Node;
	import com.googlecode.testData.VectoredElement;
	import com.googlecode.testData.XmlPathObject;
	import com.googlecode.testData.XmlTypedObj;
	import com.googlecode.testData.idref.Data;
	import com.googlecode.testData.idref.Node;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.Assert;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.equalTo;
	
	public class XmlSerializerTest {
		
		protected function getObject() : Mock {
			var target : Mock = new Mock();
			target.link = new Mock3();
			target.aField = "test1";
			target.type = Mock2;
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
			assertEquals("Wrong type specified", source.type, copy.type);
		}
		
		[Test]
		public function testSerializeWithNS() : void {
			var target : Mock = getObject();
			var xml : XML = FxBEngine.instance.getXmlSerializer().serialize(target) as XML;
			var copy : Mock = FxBEngine.instance.getXmlSerializer().deserialize(xml, Mock);
			compare(target, copy);
			var nss : Array = xml.inScopeNamespaces();
			var str : String = xml.toXMLString().split(nss[0].prefix + ":").join("").split("xmlns:" + nss[0].prefix + "=\"" + nss[0].uri + "\"").join("");
			xml = XML(str);
			copy = FxBEngine.instance.getXmlSerializer().deserialize(xml, Mock);
			compare(target, copy);
		}
		
		[Test]
		public function testXmlTypedFields() : void{
			var target : XmlTypedObj = new XmlTypedObj();
			target.firstXml = <test id="1" xmlns="http://com.example/model"/>;
			target.secondXml = <person id="3"><name>Doe</name></person>;
			var engine : IFlexXB = new FxBEngine().getXmlSerializer();
			engine.processTypes(XmlTypedObj);
			var xml : XML = engine.serialize(target) as XML;
			var copy : XmlTypedObj = engine.deserialize(xml, XmlTypedObj);
			Assert.assertEquals("firstXml stinks", target.firstXml.toXMLString(), copy.firstXml.toXMLString());
			Assert.assertEquals("secondXml stinks", target.secondXml.toXMLString(), copy.secondXml.toXMLString());
		}
		
		[Test]
		public function testCustomConstructor() : void {
			var target : ConstructorRefObj = new ConstructorRefObj("test", 1, true);
			var xml : XML = FxBEngine.instance.getXmlSerializer().serialize(target) as XML;
			var copy : ConstructorRefObj = FxBEngine.instance.getXmlSerializer().deserialize(xml, ConstructorRefObj);
			Assert.assertEquals("Ref1 is different", target.ref1, copy.ref1);
			Assert.assertEquals("Ref2 is different", target.ref2, copy.ref2);
			Assert.assertEquals("Ref3 is different", target.ref3, copy.ref3);
		}
		
		[Test]
		public function testSerializeWithoutNS() : void {
			var target : Mock3 = new Mock3();
			target.attribute = true;
			target.id = 5;
			target.version = 33;
			var xml : XML = FxBEngine.instance.getXmlSerializer().serialize(target) as XML;
			var copy : Mock3 = FxBEngine.instance.getXmlSerializer().deserialize(xml, Mock3);
			Assert.assertEquals("Attribute is wrong", target.attribute, copy.attribute);
			Assert.assertEquals("id is wrong", target.id, copy.id);
			Assert.assertEquals("version is wrong", target.version, copy.version);
		}
		
		[Test]
		public function testSimpleTypedArrays() : void {
			var tst : List = new List();
			tst.nums.push(1, 2, 3, 4);
			var xml : XML = FxBEngine.instance.getXmlSerializer().serialize(tst) as XML;
			var copy : List = FxBEngine.instance.getXmlSerializer().deserialize(xml, List);
			Assert.assertEquals("Length does not match", tst.nums.length, copy.nums.length);
			var i : int = 0;
			while (i < tst.nums.length) {
				Assert.assertEquals("Element " + i + " does not match", tst.nums[i], copy.nums[i++]);
			}
		}
		
		[Test]
		public function verifySimpleTypedNoWrapperArrays() : void{
			var list : List = new List();
			list.items = ["one", "two", "three"];
			var xml : XML = FxBEngine.instance.getXmlSerializer().serialize(list) as XML;
			var copy : List = FxBEngine.instance.getXmlSerializer().deserialize(xml, List);
			Assert.assertEquals("Item count is incorrect", 3, copy.items.length);
			xml = <List>
					  <items>
					    one
					    two
					    three
					  </items>
					  <nbrs>
					    1
					    2
					    3
					  </nbrs>		
				  </List>;
			copy = FxBEngine.instance.getXmlSerializer().deserialize(xml, List);
			Assert.assertEquals("Item count is incorrect", 3, copy.items.length);
			Assert.assertEquals("Numbers count is incorrect", 3, copy.numbers.length);
			
		}
		
		[Test]
		public function testVirtualPath() : void {
			var target : XmlPathObject = new XmlPathObject();
			target.defaultTest = "My custom default";
			target.identity = 345;
			target.reference = "SOmeRef";
			var xml : XML = FxBEngine.instance.getXmlSerializer().serialize(target) as XML;
			var copy : XmlPathObject = FxBEngine.instance.getXmlSerializer().deserialize(xml, XmlPathObject);
			Assert.assertEquals("Identity is wrong", target.identity, copy.identity);
			Assert.assertEquals("Reference is wrong", target.reference, copy.reference);
			Assert.assertEquals("DefaultTest is wrong", target.defaultTest, copy.defaultTest);
		}
		
		[Test]
		public function testClassTypeByNamespace() : void {
			var target : Mock2 = new Mock2();
			target.id = 512;
			var xml : XML = FxBEngine.instance.getXmlSerializer().serialize(target) as XML;
			var copy : Object = FxBEngine.instance.getXmlSerializer().deserialize(xml);
			Assert.assertTrue("copy is null or not mock2", copy is Mock2);
		}
		
		[Test]
		public function testCustomSerialization() : void {
			var target : CustomSerializabeObject = new CustomSerializabeObject();
			target.test = "acesta este un test";
			var xml : XML = FxBEngine.instance.getXmlSerializer().serialize(target) as XML;
			Assert.assertNotNull("Empty xml!", xml);
			var result : CustomSerializabeObject = FxBEngine.instance.getXmlSerializer().deserialize(xml, CustomSerializabeObject);
			Assert.assertEquals("Wrong test field values", target.test, result.test);

		}
		
		[Test]
		public function testVectorTypeFields() : void{
			var item : VectoredElement = new VectoredElement();
			item.id = "test";
			item.list = new Vector.<String>();
			item.list.push("one", "two", "ten");
			var xml : XML = FxBEngine.instance.getXmlSerializer().serialize(item) as XML;
			var clone : VectoredElement = FxBEngine.instance.getXmlSerializer().deserialize(xml, VectoredElement);
			assertThat(clone.id, equalTo(item.id));
			assertNotNull(clone.list);
			assertThat(clone.list.length, equalTo(item.list.length));
			for(var i : int = 0; i < item.list.length; i++){
				assertThat(clone.list[i], equalTo(item.list[i]));
			}
		}
		
		[Test]
		public function idRefTest() : void{
			var xml : XML = <data><node id="1" name="bar" /><referenceAtt id="1" /><referenceElement>1</referenceElement><referenceArray><node>1</node></referenceArray></data>;
			var initial : Data = new Data();
			initial.node = new com.googlecode.testData.idref.Node();
			initial.node.id = "1";
			initial.referenceAtt = initial.node;
			initial.referenceElement = initial.node;
			initial.referenceArray = new ArrayCollection([initial.node]);
			var xmlInitial : XML = FxBEngine.instance.getXmlSerializer().serialize(initial) as XML;
			assertEquals("Node id missing", "1", String(xmlInitial.node.@id));
			assertEquals("Reference att id missing", "1", String(xmlInitial.referenceAtt.@id));
			assertEquals("Reference element id missing", "1", String(xmlInitial.referenceElement));
			assertEquals("Reference Array missing", "1", String(xmlInitial.referenceArray[0].node));
			var data : Data = FxBEngine.instance.getXmlSerializer().deserialize(xml, Data)
			assertEquals("Node differs from attribute value", data.node,  data.referenceAtt);
			assertEquals("Node differs from element value", data.node,  data.referenceElement);
			assertEquals("Node differs from array's first item value", data.node,  data.referenceArray.getItemAt(0));
		}
	}
}