package com.googlecode.serializer.flexxb
{
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Mock3;
	
	import flexunit.framework.TestCase;
	
	import mx.controls.Alert;
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
			Alert.show(xml);
		} 		
	}
}