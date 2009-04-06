package com.googlecode.fxmod.settings.model
{
	import mx.utils.StringUtil;
	
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	[XmlClass]
	public class MenuItem
	{
		/**
		 * 
		 */		
		[XmlAttribute]
		public var label : String;
		/**
		 * 
		 */		
		[XmlAttribute]
		public var separator : Boolean;
		/**
		 * 
		 */		
		[XmlAttribute]
		public var shortCutKey : String;
		/**
		 * 
		 */		
		[XmlAttribute]
		public var mnemonicIndex : Number;
		/**
		 * 
		 */
		[XmlAttribute(alias="select")]
		public var selectHandler : String;
		/**
		 * 
		 */		
		[XmlAttribute]
		public var dataProvider : String;
		/**
		 * 
		 */		
		[XmlAttribute]
		public var dataField : String;
		/**
		 * 
		 */		
		[XmlAttribute]
		public var labelField : String;
		/**
		 * 
		 */				
		[XmlArray(alias="*", memberName="MenuItem", type="com.googlecode.fxmod.settings.model.MenuItem")]
		public var subItems : Array;
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function hasSubItems() : Boolean{
			return (subItems && subItems.length > 0) || StringUtil.trim(dataProvider)!= "";
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function hasDataProvider() : Boolean{
			return StringUtil.trim(dataProvider)!= "";
		}
	}
}