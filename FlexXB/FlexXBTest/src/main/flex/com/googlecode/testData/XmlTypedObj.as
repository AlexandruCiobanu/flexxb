package com.googlecode.testData
{
	public class XmlTypedObj
	{
		[XmlElement]
		public var firstXml : XML;
		[XmlAttribute]
		public var secondXml : XML;
		[XmlElement]
		public var field : int = 6;
	}
}