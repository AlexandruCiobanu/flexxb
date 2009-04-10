package com.googlecode.flexxb.api
{
	import com.googlecode.flexxb.IXmlSerializable;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	internal class FxMember implements IXmlSerializable
	{
		/**
		 * 
		 */		
		public var alias : String;
		/**
		 * 
		 */		
		public var ignoreOn : Stage = null;
		/**
		 * 
		 * 
		 */		
		public function FxMember()
		{
			//TODO: implement function
		}

		public function get id():String
		{
			//TODO: implement function
			return null;
		}
		
		public function toXml():XML
		{
			//TODO: implement function
			return null;
		}
		
		public function get thisType():Class
		{
			//TODO: implement function
			return null;
		}
		
		public function fromXml(xmlData:XML):Object
		{
			//TODO: implement function
			return null;
		}
		
		public function getIdValue(xmldata:XML):String
		{
			//TODO: implement function
			return null;
		}
		
	}
}