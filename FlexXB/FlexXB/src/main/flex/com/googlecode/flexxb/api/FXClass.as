package com.googlecode.flexxb.api
{
	import com.googlecode.flexxb.IXmlSerializable;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class FXClass implements IXmlSerializable
	{
		/**
		 * 
		 */		
		public var type : Class;
		/**
		 * 
		 */		
		public var alias : String;
		/**
		 * 
		 */		
		public var prefix : String;
		/**
		 * 
		 */		
		public var uri : String;
		/**
		 * 
		 */		
		public var ordered : Boolean;
		/**
		 * 
		 */		
		private var _members : Array = [];
		/**
		 *Constructor 
		 * 
		 */		
		public function FXClass(type : Class, alias : String = null)
		{
			this.type = type;
			this.alias = alias;
		}
		
		public function addAttribute() : FxAttribute{
			return null;
		}
		
		public function addElement() : FxElement{
			return null;
		}
		
		public function addArray() : FxArray{
			return null;
		}
		
		public function toXml():XML
		{
			//TODO: implement function
			return null;
		}
		
		public function fromXml(xmlData:XML):Object
		{
			//TODO: implement function
			return null;
		}
		
		public function get thisType():Class
		{
			//TODO: implement function
			return FXClass;
		}
		
		public function get id():String
		{
			return null;
		}
		
		public function getIdValue(xmldata:XML):String
		{
			return null;
		}		
	}
}