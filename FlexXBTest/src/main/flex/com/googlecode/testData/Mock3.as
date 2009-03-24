package com.googlecode.testData
{
	[XmlClass(alias="MOck2Replacement", idField="id")]
	public class Mock3 extends Mock2
	{
		[XmlAttribute]
		public var attribute : Boolean;
		[XmlElement(alias="objectVersion")]
		public var version : Number;
		
		public function Mock3()
		{
			super();
		}
	}
}