package com.googlecode.flexxb
{
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
			var xml : XML = FlexXBEngine.instance.serialize(target);
			var mk3 : XML = xml.children()[1];
			assertTrue(mk3.length()>0);
			assertEquals(mk3.@id, "325");
			assertEquals(mk3.@attribute.toString(), "");
			assertEquals(mk3.objectVersion.toString(), "");			
		} 		
	}
}