package com.googlecode.flexxb.annotation
{
	import com.googlecode.flexxb.FlexXBEngine;
	import com.googlecode.testData.DefaultValueTestObj;
	
	import flexunit.framework.TestCase;
	
	import org.flexunit.asserts.assertEquals;
	
	public class DefaultValueTest extends TestCase
	{
		public function DefaultValueTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
		}
		
		public function testDefaultValue() : void{
			var v : DefaultValueTestObj ;
			var xml : XML =
				<DefaultValueTestObj>
					<min>3</min>
				</DefaultValueTestObj>;
			v = FlexXBEngine.instance.deserialize(xml, DefaultValueTestObj);
			assertEquals("String field wrong", "MyValue", v.string);
			assertEquals("min field wrong", 3, v.min);
			assertEquals("max field wrong", 5, v.max);
		}	
	}
}