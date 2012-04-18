package com.googlecode.testData.cdata
{
	[XmlClass(defaultValueField='value')]
	public class ChildModel
	{
		[XmlAttribute]
		public var what:String;
		
		[XmlElement]
		public var value:String;
	}
}