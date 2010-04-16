package com.googlecode.testData
{
	public class DefaultValueTestObj
	{
		[XmlElement()]
		public var date : Date;
		
		[XmlAttribute(default="MyValue")]
		public var string : String;
		
		[XmlElement(default="1")]
		public var min : Number;
		
		[XmlElement(default="5")]
		public var max : int;
	}
}