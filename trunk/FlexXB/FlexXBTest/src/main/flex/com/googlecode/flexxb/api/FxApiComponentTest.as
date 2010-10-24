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
package com.googlecode.flexxb.api {
	import com.googlecode.flexxb.FlexXBEngine;
	import com.googlecode.flexxb.annotation.contract.AccessorType;
	import com.googlecode.flexxb.annotation.contract.Stage;
	import com.googlecode.flexxb.annotation.parser.MetaParser;
	import com.googlecode.flexxb.annotation.xml.XmlArray;
	import com.googlecode.flexxb.annotation.xml.XmlAttribute;
	import com.googlecode.flexxb.annotation.xml.XmlClass;
	import com.googlecode.flexxb.annotation.xml.XmlElement;
	import com.googlecode.flexxb.annotation.xml.XmlMember;
	import com.googlecode.flexxb.converter.W3CDateConverter;
	import com.googlecode.testData.APITestObject;
	import com.googlecode.testData.Address;
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Person;
	import com.googlecode.testData.PhoneNumber;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.Assert;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public class FxApiComponentTest {
		
		public function FxApiComponentTest() {
			new PhoneNumber();
			new Person();
			new Address();
			FlexXBEngine.instance.api.processTypeDescriptor(null);
		}

		[Test]
		public function testFxAttribute() : void {
			var api : FxAttribute = FxAttribute.create("testAtt", String, null, 'aliasAttTest');
			var descriptor : XML = api.toXml();
			var att : XmlAttribute = new XmlAttribute(new MetaParser().parseField(descriptor)[0], null);
			doMemberAssertion(api, att);
		}

		[Test]
		public function testFxElement() : void {
			var api : FxElement = FxElement.create("testAtt", String, null, 'aliasAttTest');
			var descriptor : XML = api.toXml();
			var att : XmlElement = new XmlElement(new MetaParser().parseField(descriptor)[0], null);
			doElementAssertion(api, att);
		}

		[Test]
		public function testFxArray() : void {
			var api : FxArray = FxArray.create("testAtt", String, null, 'aliasAttTest');
			var descriptor : XML = api.toXml();
			var att : XmlArray = new XmlArray(new MetaParser().parseField(descriptor)[0], null);
			doArrayAssertion(api, att);
		}

		[Test]
		public function testFxClass() : void {
			var parser : MetaParser = new MetaParser();
			var cls : FxClass = buildDescriptor();
			var xmlCls : XmlClass = parser.parseDescriptor(cls.toXml())[0];
			Assert.assertEquals("wrong type", cls.type, xmlCls.type);
			Assert.assertEquals("wrong alias", cls.alias, xmlCls.alias);
			Assert.assertEquals("wrong prefix", cls.prefix, xmlCls.nameSpace.prefix);
			Assert.assertEquals("wrong uri", cls.uri, xmlCls.nameSpace.uri);
			Assert.assertEquals("wrong member count", 4, xmlCls.members.length);
			Assert.assertEquals("wrong constructor argument count", 2, xmlCls.constructor.parameterFields.length);
		}

		private function buildDescriptor() : FxClass {
			var cls : FxClass = new FxClass(Person, "APerson");
			cls.prefix = "test";
			cls.uri = "http://www.axway.com/xmlns/passport/v1";
			cls.addAttribute("firstName", String, null, "FirstName");
			cls.addAttribute("lastName", String, null, "LastName");
			cls.addElement("birthDate", Date, null, "BirthDate");
			cls.addElement("age", Number, null, "Age").ignoreOn = Stage.SERIALIZE;
			cls.addArgument("firstName");
			cls.addArgument("lastName");
			return cls;
		}
		
		[Test]
		public function testSerializationWithApiDescriptor() : void {
			var cls : FxClass = buildDescriptor();
			FlexXBEngine.instance.api.processTypeDescriptor(cls);
			var person : Person = new Person();
			person.firstName = "John";
			person.lastName = "Doe";
			person.birthDate = new Date();
			person.age = 34;
			var xml : XML = FlexXBEngine.instance.serialize(person);
			var copy : Person = FlexXBEngine.instance.deserialize(xml, Person);
			Assert.assertEquals("Wrong firstName", person.firstName, copy.firstName);
			Assert.assertEquals("Wrong lastName", person.lastName, copy.lastName);
			Assert.assertEquals("Wrong birthDate", person.birthDate.toString(), copy.birthDate.toString());
			Assert.assertEquals("Wrong age", 0, copy.age);
		}
		
		[Test]
		public function testFileDescriptorProcessing() : void {
			var xml : XML = getXmlDescriptor();
			var wrapper : FxApiWrapper = FlexXBEngine.instance.deserialize(xml, FxApiWrapper);
			Assert.assertEquals("Wrong number of classes parsed", 3, wrapper.descriptors.length);
			Assert.assertEquals("Wrong version", 1, wrapper.version);
			Assert.assertEquals("Wrong member count for first class", 4, FxClass(wrapper.descriptors[0]).flexxb_api_internal::members.length);
			Assert.assertEquals("Wrong constructor argument count for second class", 2, FxClass(wrapper.descriptors[1]).flexxb_api_internal::constructorArguments.length);
		}

		private function doArrayAssertion(apiMember : FxArray, xmlArray : XmlArray) : void {
			doElementAssertion(apiMember, xmlArray);
			Assert.assertEquals("Wrong memberName", apiMember.memberName, xmlArray.memberName);
			Assert.assertEquals("Wrong memberType", apiMember.memberType, xmlArray.type);
		}

		private function doElementAssertion(apiMember : FxElement, xmlElement : XmlElement) : void {
			doMemberAssertion(apiMember, xmlElement);
			Assert.assertEquals("Wrong getFromCache", apiMember.getFromCache, xmlElement.getFromCache);
			Assert.assertEquals("Wrong serializePartialElement", apiMember.serializePartialElement, xmlElement.serializePartialElement);
		}

		private function doMemberAssertion(apiMember : FxMember, xmlMember : XmlMember) : void {
			Assert.assertEquals("Wrong field name", apiMember.fieldName, xmlMember.name);
			Assert.assertEquals("Wrong field type", apiMember.fieldType, xmlMember.type);
			Assert.assertEquals("Field access type is wrong for writeOnly", apiMember.fieldAccessType == AccessorType.WRITE_ONLY, xmlMember.writeOnly);
			Assert.assertEquals("Field access type is wrong for readOnly", apiMember.fieldAccessType == AccessorType.READ_ONLY, xmlMember.readOnly);
			Assert.assertEquals("Wrong ignoreOn", apiMember.ignoreOn, xmlMember.ignoreOn);
			Assert.assertEquals("Wrong alias", apiMember.alias, xmlMember.alias);
		}
		
		[Test]
		public function testMultipleNamespace() : void{
			var cls : FxClass = new FxClass(Mock);
			var member : FxMember = cls.addAttribute("version", Number, null, "Version");
			member.setNamespace(new Namespace("me", "www.me.com"));
			member = cls.addElement("tester", String);
			member.setNamespace(new Namespace("us", "www.us.com"));
			member = cls.addAttribute("uue", String);
			member = cls.addAttribute("uueedr", String);
			member.setNamespace(new Namespace("me", "www.me.com"));
			Assert.assertEquals("Wrong number of registered namespaces upon programatic build", 2, count(cls.flexxb_api_internal::namespaces));
			var xml : XML = getXmlDescriptor();
			var wrapper : FxApiWrapper = FlexXBEngine.instance.deserialize(xml, FxApiWrapper);
			Assert.assertEquals("Wrong number of registered namespaces upon deserialization", 2, count(FxClass(wrapper.descriptors[0]).flexxb_api_internal::namespaces));
		}
		
		[Test]
		public function testFullAPIProcessing() : void{
			FlexXBEngine.instance.registerSimpleTypeConverter(new W3CDateConverter());
			var cls : FxClass = new FxClass(APITestObject, "ATO");
			cls.prefix = "apitest";
			cls.uri = "http://www.apitest.com/api/test";
			cls.addAttribute("id", Number);
			cls.addArgument("id", false);
			var member : FxMember = cls.addAttribute("name", String, AccessorType.READ_WRITE, "meta/objName");
			member.setNamespace(new Namespace("pref1", "http://www.p.r.com"));
			cls.addElement("version", Number, null, "meta/objVersion");
			member = cls.addElement("currentDate", Date, null, "todayIs");
			member.setNamespace(new Namespace("pref1", "http://www.p.r.com"));
			member = cls.addElement("xmlData", XML, null, "data");
			member.setNamespace(new Namespace("pref2", "http://www.p3.r2.com"));
			cls.addAttribute("xmlAtts", XML, null, "attributes");
			var array : FxArray = cls.addArray("results", ArrayCollection, null, "Results");
			array.memberName = "resultItem";
			array.memberType = String;
			FlexXBEngine.instance.api.processTypeDescriptor(cls);
			var target : APITestObject = new APITestObject(1234);
			target.currentDate = new Date();
			target.name = "MyName";
			target.results = new ArrayCollection(["me", "you", "us"]);
			target.version = 3;
			target.xmlAtts = <atts><att index="0"/><att index="1"/><att index="2"/></atts>;
			target.xmlData = <data id="34"><result value="one"/></data>;
			var xml : XML = FlexXBEngine.instance.serialize(target);
			var copy : APITestObject = FlexXBEngine.instance.deserialize(xml, APITestObject);
			
			Assert.assertEquals("Id is wrong", target.id, copy.id);
			Assert.assertEquals("Name is wrong", target.name, copy.name);
			Assert.assertEquals("Version is wrong", target.version, copy.version);
			Assert.assertEquals("XmlAtts is wrong", target.xmlAtts.toXMLString(), copy.xmlAtts.toXMLString());
			Assert.assertEquals("XmlData is wrong", target.xmlData.toXMLString(), copy.xmlData.toXMLString());
			Assert.assertEquals("Results count is wrong", target.results.length, copy.results.length);
			for(var i : int = 0; i < target.results.length; i++){
				Assert.assertEquals("Results memeber indexed " + i + " is wrong", target.results[i], copy.results[i]);
			}
			Assert.assertEquals("Current date is wrong", target.currentDate.time, copy.currentDate.time);
		}
		
		private function count(map : Dictionary) : int{
			var size : int = 0;
			for(var key : * in map){
				size++;	
			}
			return size;
		}

		private function getXmlDescriptor() : XML {
			var xml : XML = <FlexXBAPI version="1">
					<Descriptors>
						<Class type="com.googlecode.testData.PhoneNumber" alias="TelephoneNumber" prefix="number" uri="http://www.aciobanu.com/schema/v1/phone" ordered="true">
							<Members>
								<Attribute order="1">
									<Field name="countryCode" type="String"/>
									<Namespace prefix="test" uri="http://www.test.org" />
								</Attribute>
								<Attribute order="2">
									<Field name="areaCode" type="String" access="readwrite"/>
								</Attribute>
								<Attribute alias="phoneNumber" order="3">
									<Field name="number" type="String"/>
									<Namespace prefix="test" uri="http://www.test.org" />
								</Attribute>
								<Attribute order="4">
									<Field name="interior" type="String"/>
									<Namespace prefix="ns2" uri="http://www.test.org/ns/2" />
								</Attribute>
							</Members>
						</Class>
						<Class type="com.googlecode.testData.Person" alias="Person" prefix="person" uri="http://www.aciobanu.com/schema/v1/person">
							<ConstructorArguments>
								<Argument reference="firstName" optional="true"/>
								<Argument reference="lastName" />
							</ConstructorArguments>
							<Members>
								<Element alias="BirthDate">
									<Field name="birthDate" type="Date"/>
								</Element>
								<Element alias="Age" ignoreOn="serialize">
									<Field name="birthDate" type="Date"/>
								</Element>
								<Attribute>
									<Field name="firstName" type="String"/>
								</Attribute>
								<Attribute>
									<Field name="lastName" type="String"/>
								</Attribute>
							</Members>
						</Class>
						<Class type="com.googlecode.testData.Address" alias="PersonAddress" prefix="add" uri="http://www.aciobanu.com/schema/v1/address" ordered="false">
							<Members>
								<Element getFromCache="true">
									<Field name="person" type="com.googlecode.testData.Person"/>
								</Element>
								<Element>
									<Field name="emailAddress" type="String"/>
								</Element>
								<Attribute>
									<Field name="street" type="String" accessType="readwrite"/>
								</Attribute>
								<Attribute>
									<Field name="number" type="String"/>
								</Attribute>
								<Attribute>
									<Field name="city" type="String"/>
								</Attribute>
								<Attribute>
									<Field name="country" type="String"/>
								</Attribute>
								<Array alias="numbers" memberName="" memberType="com.googlecode.testData.PhoneNumber" getFromCache="false" serializePartialElement="false" order="3">
									<Field name="telephoneNumbers" type="Array" accessType="readwrite"/>
								</Array>
							</Members>
						</Class>
					</Descriptors>
				</FlexXBAPI>;
			return xml;
		}
	}
}