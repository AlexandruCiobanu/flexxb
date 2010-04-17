/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
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