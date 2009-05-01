package com.googlecode.flexxb.api
{
	import com.googlecode.flexxb.FlexXBEngine;
	import com.googlecode.flexxb.annotation.XmlArray;
	import com.googlecode.flexxb.annotation.XmlAttribute;
	import com.googlecode.flexxb.annotation.XmlClass;
	import com.googlecode.flexxb.annotation.XmlElement;
	import com.googlecode.flexxb.annotation.XmlMember;
	import com.googlecode.testData.Address;
	import com.googlecode.testData.Person;
	import com.googlecode.testData.PhoneNumber;
	
	import flexunit.framework.TestCase;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class FxApiComponentTest extends TestCase
	{
		public function FxApiComponentTest(methodName:String=null)
		{
			//TODO: implement function
			super(methodName);
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function testFxAttribute() : void{
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
		public function testFxElement() : void{
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
		public function testFxArray() : void{
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
		public function testFxClass() : void{
			var cls : FxClass = buildDescriptor();
			FlexXBEngine.instance.api.processTypeDescriptor(null);
			var xmlCls : XmlClass = new XmlClass(cls.toXml());
			assertEquals("wrong type", cls.type, xmlCls.fieldType);
			assertEquals("wrong alias", cls.alias, xmlCls.alias);
			assertEquals("wrong prefix", cls.prefix, xmlCls.nameSpace.prefix);
			assertEquals("wrong uri", cls.uri, xmlCls.nameSpace.uri);
			assertEquals("wrong member count", 4, xmlCls.members.length);
		}
		
		private function buildDescriptor() : FxClass{
			var cls : FxClass = new FxClass(Person, "APerson");
			cls.prefix = "test";
			cls.uri="http://www.axway.com/xmlns/passport/v1";
			cls.addAttribute("firstName", String, null, "FirstName");
			cls.addAttribute("lastName", String, null, "LastName");
			cls.addElement("birthDate", Date, null, "BirthDate");
			cls.addElement("age", Number, null, "Age").ignoreOn = Stage.SERIALIZE;
			return cls;
		}
		
		public function testSerializationWithApiDescriptor() : void{
			var cls : FxClass = buildDescriptor();
			FlexXBEngine.instance.api.processTypeDescriptor(cls);
			var person : Person = new Person();
			person.firstName = "John";
			person.lastName = "Doe";
			person.birthDate = new Date();
			person.age = 34;
			var xml  :XML = FlexXBEngine.instance.serialize(person);
			var copy : Person = FlexXBEngine.instance.deserialize(xml, Person) as Person;
			assertEquals("Wrong firstName", person.firstName, copy.firstName);
			assertEquals("Wrong lastName", person.lastName, copy.lastName);
			assertEquals("Wrong birthDate", person.birthDate.toString(), copy.birthDate.toString());
			assertEquals("Wrong age", 0, copy.age);
		}
		
		/*public function testFileDescriptorProcessing() : void{
			new PhoneNumber();new Address();
			var xml : XML = getXmlDescriptor();
			FlexXBEngine.instance.api.processDescriptorsFromXml(xml);
		}*/
		
		private function doArrayAssertion(apiMember : FxArray, xmlArray : XmlArray) : void{
			doElementAssertion(apiMember, xmlArray);
			assertEquals("Wrong memberName", apiMember.memberName, xmlArray.memberName);
			assertEquals("Wrong memberType", apiMember.memberType, xmlArray.type);
		}	
		
		private function doElementAssertion(apiMember : FxElement, xmlElement : XmlElement) : void{
			doMemberAssertion(apiMember, xmlElement);
			assertEquals("Wrong getFromCache", apiMember.getFromCache, xmlElement.getFromCache);
			assertEquals("Wrong serializePartialElement", apiMember.serializePartialElement, xmlElement.serializePartialElement);
		}	
		
		private function doMemberAssertion(apiMember : FxMember, xmlMember : XmlMember) : void{
			assertEquals("Wrong field name", apiMember.fieldName, xmlMember.fieldName);
			assertEquals("Wrong field type", apiMember.fieldType, xmlMember.fieldType);
			assertEquals("Field access type is wrong for writeOnly", apiMember.fieldAccessType == AccessorType.WRITE_ONLY, xmlMember.writeOnly);
			assertEquals("Field access type is wrong for readOnly", apiMember.fieldAccessType == AccessorType.READ_ONLY, xmlMember.readOnly);
			assertEquals("Wrong ignoreOn", apiMember.ignoreOn, xmlMember.ignoreOn);
			assertEquals("Wrong alias", apiMember.alias, xmlMember.alias);
		}	
		
		private function getXmlDescriptor() : XML{
			var xml : XML = 
				<FlexXBAPI version="1">
				  <Descriptors>
				    <Class type="com.googlecode.testData.PhoneNumber" alias="TelephoneNumber" prefix="number" uri="http://www.aciobanu.com/schema/v1/phone" ordered="true">
				      <Attribute order="1">
				        <Field name="countryCode" type="String"/>
				      </Attribute>
				      <Attribute order="2">
				        <Field name="areaCode" type="String" access="readwrite"/>
				      </Attribute>
				      <Attribute alias="phoneNumber" order="3">
				        <Field name="number" type="String"/>
				      </Attribute>
				      <Attribute order="4">
				        <Field name="interior" type="String"/>
				      </Attribute>
				    </Class>
				    <Class type="com.googlecode.testData.Person" alias="Person" prefix="person" uri="http://www.aciobanu.com/schema/v1/person">
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
				    </Class>
				    <Class type="com.googlecode.testData.Address" alias="PersonAddress" prefix="add" uri="http://www.aciobanu.com/schema/v1/address" ordered="false">
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
				      <Array alias="numbers" memberName="" type="com.googlecode.testData.PhoneNumber" getFromCache="false" serializePartialElement="false" order="3">
				        <Field name="telephoneNumbers" type="Array" access="readwrite"/>
				      </Array>
				    </Class>
				  </Descriptors>
				</FlexXBAPI>;
			return xml;
		}
	}
}