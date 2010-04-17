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