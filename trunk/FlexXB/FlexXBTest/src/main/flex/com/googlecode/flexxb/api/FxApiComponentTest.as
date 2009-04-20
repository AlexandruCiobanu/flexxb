package com.googlecode.flexxb.api
{
	import com.googlecode.flexxb.annotation.XmlArray;
	import com.googlecode.flexxb.annotation.XmlAttribute;
	import com.googlecode.flexxb.annotation.XmlElement;
	import com.googlecode.flexxb.annotation.XmlMember;
	
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
			doMemberAssertion(api, att);
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
			doMemberAssertion(api, att);
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function testFxClass() : void{
			
		}	
		
		private function doMemberAssertion(apiMember : FxMember, xmlMember : XmlMember) : void{
			assertEquals("Wrong field name", apiMember.fieldName, xmlMember.fieldName);
			assertEquals("Wrong field type", apiMember.fieldType, xmlMember.fieldType);
			assertEquals("Wrong alias", apiMember.alias, xmlMember.alias);
		}	
	}
}