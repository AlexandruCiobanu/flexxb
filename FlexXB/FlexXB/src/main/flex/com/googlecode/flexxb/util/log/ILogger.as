package com.googlecode.flexxb.util.log
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public interface ILogger
	{
		/**
		 * 
		 * @param content the text content to be logged (can also be a template)
		 * @param args parameters that can be substituted into the content text
		 * 
		 */		
		function info(content : String, ...args) : void;
		
		/**
		 * 
		 * @param content the text content to be logged (can also be a template)
		 * @param args parameters that can be substituted into the content text
		 * 
		 */		
		function warn(content : String, ...args) : void;
		
		/**
		 * 
		 * @param content the text content to be logged (can also be a template)
		 * @param args parameters that can be substituted into the content text
		 * 
		 */		
		function error(content : String, ...args) : void;
	}
}