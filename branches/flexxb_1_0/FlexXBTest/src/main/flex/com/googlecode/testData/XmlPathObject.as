package com.googlecode.testData
{	
	[XmlClass(alias="myPathTester", defaultValueField="defaultTest")]
	public class XmlPathObject
	{
		[XmlElement(alias="subObject/id")]
		public var identity : Number = 2;
		[XmlElement(alias="subObject/subSubObj/ref")]
		public var reference : String = "ReferenceTo"; 
		[XmlArray(alias="subObject/list")]
		public var list : Array;
		[XmlAttribute(alias="anotherSub/attTest")]
		public var test : Date = new Date();
		[XmlElement()]
		public var defaultTest : String = "This is Default!!!"
		
		public function XmlPathObject()
		{
		}
	}
}