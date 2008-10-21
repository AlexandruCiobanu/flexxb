package com.googlecode.flexxb.converter
{
	import com.googlecode.flexxb.XMLSerializer;
	
	
	internal class XmlConverter implements IConverter
	{
		{
			XMLSerializer.instance.registerSimpleTypeConverter(new XmlConverter());
		}
		
		public function get type():Class
		{
			return XML;
		}
		
		public function toString(object:Object):String
		{
			return (object as XML).toString();
		}
		
		public function fromString(value:String):Object
		{
			var result : XML = XML(value);			
			return result;
		}		
	}
}