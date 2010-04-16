package com.googlecode.flexxb.util.log
{
	import com.googlecode.flexxb.util.log.ILogger;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.StringUtil;

	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	internal final class Logger implements ILogger
	{
		private static const INFO : String = "INFO";
		private static const ERROR : String = "ERROR";
		private static const WARN : String = "WARN";
		
		private var type : String = "";
		/**
		 * 
		 * 
		 */		
		public function Logger(type : Class){
			if(type){
				this.type = getQualifiedClassName(type);
				this.type = this.type.substring(this.type.indexOf("::") + 2);
			}
		}
		/**
		 * 
		 * @param content the text content to be logged (can also be a template)
		 * @param args parameters that can be substituted into the content text
		 * 
		 */		
		public function info(content : String, ...args) : void{
			log(INFO, content, args);
		}
		
		/**
		 * 
		 * @param content the text content to be logged (can also be a template)
		 * @param args parameters that can be substituted into the content text
		 * 
		 */		
		public function warn(content : String, ...args) : void{
			log(WARN, content, args);
		}
		
		/**
		 * 
		 * @param content the text content to be logged (can also be a template)
		 * @param args parameters that can be substituted into the content text
		 * 
		 */		
		public function error(content : String, ...args) : void{
			log(ERROR, content, args);
		}
		
		private function log(logType : String, content : String, arguments : Array) : void{
			if(arguments && arguments.length > 0){
				content = StringUtil.substitute(content, arguments); 
			}
			trace(type + " " + logType + " - " + content);
		}		
	}
}