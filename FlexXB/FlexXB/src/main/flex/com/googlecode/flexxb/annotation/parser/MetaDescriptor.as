package com.googlecode.flexxb.annotation.parser
{	
	import com.googlecode.flexxb.annotation.contract.Constants;
	
	/**
	 * @private
	 * @author Alexutz
	 * 
	 */	
	public final class MetaDescriptor
	{
		public var metadataName : String;
		
		public var attributes : Object;
		
		public function MetaDescriptor(){
			attributes = new Object();
		}
		
		public function get version() : String{
			return attributes[Constants.VERSION];
		}
	}
}