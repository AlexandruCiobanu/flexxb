package com.googlecode.testData
{
	import mx.collections.ArrayCollection;

	public class APITestObject
	{
		public var id : Number;
		
		public var name : String;
		
		public var version : Number;
		
		public var xmlData : XML;
		
		public var xmlAtts : XML;
		
		public var currentDate : Date;
		
		public var results : ArrayCollection;
		
		public function APITestObject(id : Number){
			this.id = id;
		}
	}
}