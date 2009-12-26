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
package com.googlecode.flexxb.api {
	import com.googlecode.flexxb.FlexXBEngine;
	import com.googlecode.flexxb.annotation.XmlArray;
	import com.googlecode.flexxb.annotation.XmlAttribute;
	import com.googlecode.flexxb.annotation.XmlClass;
	import com.googlecode.flexxb.annotation.XmlElement;
	import com.googlecode.flexxb.annotation.XmlMember;
	import com.googlecode.testData.Address;
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Person;
	import com.googlecode.testData.PhoneNumber;
	
	import flash.utils.Dictionary;
	
	import flexunit.framework.TestCase;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public class FxApiComponentTest extends TestCase {
		public function FxApiComponentTest(methodName : String = null) {
			super(methodName);
			new PhoneNumber();
			new Person();
			new Address();
			FlexXBEngine.instance.api.processTypeDescriptor(null);
		}

		/**
		 *
		 * @return
		 *
		 */
		public function testFxAttribute() : void {
			var api : FxAttribute = FxAttribute.create("testAtt", String, null, 'aliasAttTest');
			var descriptor : XML = api.toXml();
			var att : XmlAttribute = new XmlAttribute(descriptor);
			doMemberAssertion(api, att);
		}

		/**
		 *
		 * @return
		 *
		 */
		public function testFxElement() : void {
			var api : FxElement = FxElement.create("testAtt", String, null, 'aliasAttTest');
			var descriptor : XML = api.toXml();
			var att : XmlElement = new XmlElement(descriptor);
			doElementAssertion(api, att);
		}

		/**
		 *
		 * @return
		 *
		 */
		public function testFxArray() : void {
			var api : FxArray = FxArray.create("testAtt", String, null, 'aliasAttTest');
			var descriptor : XML = api.toXml();
			var att : XmlArray = new XmlArray(descriptor);
			doArrayAssertion(api, att);
		}

		/**
		 *
		 * @return
		 *
		 */
		public function testFxClass() : void {
			var cls : FxClass = buildDescriptor();
			var xmlCls : XmlClass = new XmlClass(cls.toXml());
			assertEquals("wrong type", cls.type, xmlCls.fieldType);
			assertEquals("wrong alias", cls.alias, xmlCls.alias);
			assertEquals("wrong prefix", cls.prefix, xmlCls.nameSpace.prefix);
			assertEquals("wrong uri", cls.uri, xmlCls.nameSpace.uri);
			assertEquals("wrong member count", 4, xmlCls.members.length);
			assertEquals("wrong constructor argument count", 2, xmlCls.constructor.parameterFields.length);
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
			assertEquals("Wrong firstName", person.firstName, copy.firstName);
			assertEquals("Wrong lastName", person.lastName, copy.lastName);
			assertEquals("Wrong birthDate", person.birthDate.toString(), copy.birthDate.toString());
			assertEquals("Wrong age", 0, copy.age);
		}

		public function testFileDescriptorProcessing() : void {
			var xml : XML = getXmlDescriptor();
			var wrapper : FxApiWrapper = FlexXBEngine.instance.deserialize(xml, FxApiWrapper);
			assertEquals("Wrong number of classes parsed", 3, wrapper.descriptors.length);
			assertEquals("Wrong version", 1, wrapper.version);
			assertEquals("Wrong member count for first class", 4, FxClass(wrapper.descriptors[0]).flexxb_api_internal::members.length);
			assertEquals("Wrong constructor argument count for second class", 2, FxClass(wrapper.descriptors[1]).flexxb_api_internal::constructorArguments.length);
		}

		private function doArrayAssertion(apiMember : FxArray, xmlArray : XmlArray) : void {
			doElementAssertion(apiMember, xmlArray);
			assertEquals("Wrong memberName", apiMember.memberName, xmlArray.memberName);
			assertEquals("Wrong memberType", apiMember.memberType, xmlArray.type);
		}

		private function doElementAssertion(apiMember : FxElement, xmlElement : XmlElement) : void {
			doMemberAssertion(apiMember, xmlElement);
			assertEquals("Wrong getFromCache", apiMember.getFromCache, xmlElement.getFromCache);
			assertEquals("Wrong serializePartialElement", apiMember.serializePartialElement, xmlElement.serializePartialElement);
		}

		private function doMemberAssertion(apiMember : FxMember, xmlMember : XmlMember) : void {
			assertEquals("Wrong field name", apiMember.fieldName, xmlMember.fieldName);
			assertEquals("Wrong field type", apiMember.fieldType, xmlMember.fieldType);
			assertEquals("Field access type is wrong for writeOnly", apiMember.fieldAccessType == AccessorType.WRITE_ONLY, xmlMember.writeOnly);
			assertEquals("Field access type is wrong for readOnly", apiMember.fieldAccessType == AccessorType.READ_ONLY, xmlMember.readOnly);
			assertEquals("Wrong ignoreOn", apiMember.ignoreOn, xmlMember.ignoreOn);
			assertEquals("Wrong alias", apiMember.alias, xmlMember.alias);
		}
		
		public function testMultipleNamespace() : void{
			var cls : FxClass = new FxClass(Mock);
			var member : FxMember = cls.addAttribute("version", Number, null, "Version");
			member.setNamespace(new Namespace("me", "www.me.com"));
			member = cls.addElement("tester", String);
			member.setNamespace(new Namespace("us", "www.us.com"));
			member = cls.addAttribute("uue", String);
			member = cls.addAttribute("uueedr", String);
			member.setNamespace(new Namespace("me", "www.me.com"));
			assertEquals("Wrong number of registered namespaces upon programatic build", 2, count(cls.flexxb_api_internal::namespaces));
			var xml : XML = getXmlDescriptor();
			var wrapper : FxApiWrapper = FlexXBEngine.instance.deserialize(xml, FxApiWrapper);
			assertEquals("Wrong number of registered namespaces upon deserialization", 2, count(FxClass(wrapper.descriptors[0]).flexxb_api_internal::namespaces));
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
									<Field name="street" type="String"/>
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
									<Field name="telephoneNumbers" type="Array" access="readwrite"/>
								</Array>
							</Members>
						</Class>
					</Descriptors>
				</FlexXBAPI>;
			return xml;
		}
	}
}