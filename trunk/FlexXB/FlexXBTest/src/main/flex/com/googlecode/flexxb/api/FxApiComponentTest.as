package com.googlecode.flexxb.api
{
	import com.googlecode.flexxb.annotation.XmlArray;
	import com.googlecode.flexxb.annotation.XmlAttribute;
	import com.googlecode.flexxb.annotation.XmlClass;
	import com.googlecode.flexxb.annotation.XmlElement;
	import com.googlecode.flexxb.annotation.XmlMember;
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Mock3;
	
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
			var cls : FXClass = new FXClass(Mock, "MyClass");
			cls.prefix = "test";
			cls.uri="http://www.axway.com/xmlns/passport/v1";
			cls.addAttribute("aField", String, null, "stuff");
			cls.addAttribute("date", Date, null).ignoreOn = Stage.SERIALIZE;
			cls.addElement("version", Number, null, "objVersion");
			cls.addElement("link", Mock3, null, "mock3").serializePartialElement = true;
			cls.addElement("reference", Object).serializePartialElement = true;
			cls.addArray("result", Array, null, "data").memberType = Mock;
			cls.addElement("xmlData", XML);
			cls.addElement("readOnly", String, AccessorType.READ_ONLY);
			cls.addElement("writeOnly", String, AccessorType.WRITE_ONLY);
			var xmlCls : XmlClass = new XmlClass(cls.toXml());
		}
		
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
	}
}