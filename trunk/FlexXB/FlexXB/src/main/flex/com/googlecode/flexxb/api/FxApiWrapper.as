package com.googlecode.flexxb.api
{
	
	[XmlClass(alias="FlexXBAPI")]
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class FxApiWrapper
	{
		[XmlArray(alias="Descriptors", type="com.googlecode.flexxb.api.FxClass")]
		public var descriptors : Array;
		[XmlAttribute]
		public var version : Number;

	}
}