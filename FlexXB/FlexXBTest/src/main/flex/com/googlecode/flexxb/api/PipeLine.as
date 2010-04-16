package com.googlecode.flexxb.api
{
	public class PipeLine
	{
		[XmlAttribute]
		public var name : String;
		[XmlArray]
		[ArrayElementType("com.googlecode.flexxb.api.FetchPanel")]
		public var panels : Array;
		
		public function PipeLine()
		{
		}
	}
}