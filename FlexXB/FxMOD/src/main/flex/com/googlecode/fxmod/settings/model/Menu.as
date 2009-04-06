package com.googlecode.fxmod.settings.model
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	[XmlClass(alias="Menu")]
	public class Menu
	{
		/**
		 * 
		 */			
		[XmlArray(alias="*", memberName="MenuItem", type="com.googlecode.fxmod.settings.model.MenuItem")]
		public var items : Array;
	}
}