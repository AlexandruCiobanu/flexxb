package com.googlecode.flexxb
{
	import com.googlecode.flexxb.XMLSerializer;
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Mock3;
	
	import flexunit.framework.TestCase;
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	public class PartialSerializationTest extends TestCase
	{
		public function PartialSerializationTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public function testPartialSerialization() : void{
			var target : Mock = new Mock();
			target.aField = "test";
			target.link = new Mock3();
			target.link.id = 325;
			target.link.version = 2;
			var xml : XML = XMLSerializer.instance.serialize(target);
			assertTrue(xml.MOck2Replacement.length()>0);
			assertEquals(xml.MOck2Replacement.@id, "325");
			assertEquals(xml.MOck2Replacement.@attribute.toString(), "");
			assertEquals(xml.MOck2Replacement.objectVersion.toString(), "");			
		} 		
	}
}