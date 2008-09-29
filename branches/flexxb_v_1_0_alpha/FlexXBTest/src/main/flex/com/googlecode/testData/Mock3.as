package com.googlecode.testData
{
	[XmlClass(alias="MOck2Replacement", prefix="m2r", uri="http://www.axway.com/v1/shit")]
	public class Mock3 extends Mock2
	{
		[XmlAtribute]
		public var shit : Boolean;
		
		public function Mock3()
		{
			super();
		}
		
	}
}