package com.googlecode.flexxb.util
{
	/**
	 * Function that wraps the provided value in an xml with a CDATA tag 
	 * @param value value to which the cdata tag will be added
	 * @return XML representing the value
	 *  
	 */	
	public function cdata(value : *) : XML{
		return XML("<![CDATA[" + value + "]]>");
	}
}