package com.googlecode.serializer.flexxb.converter
{
	import com.googlecode.serializer.flexxb.XMLSerializer;
	
	
	internal class XMLConverter implements IConverter
	{
		{
			XMLSerializer.instance.registerSimpleTypeConverter(new XMLConverter());
		}
		
		public function XMLConverter()
		{
			//TODO: implement function
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