/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
 *   Copyright (C) 2008 Alex Ciobanu
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
package com.googlecode.flexxb.api
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class Stage
	{
		/**
		 * 
		 */		
		public static const SERIALIZE : Stage = new Stage("serialize");
		/**
		 * 
		 */		
		public static const DESERIALIZE : Stage = new Stage("deserialize");
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function fromString(value : String) : Stage{
			if(value == DESERIALIZE.name){
				return DESERIALIZE;
			}
			if(value == SERIALIZE.name){
				return SERIALIZE;
			}
			throw new Error("Unknown Stage element:" + value);
		}
		
		private static var initialized : Boolean = false;
		
		{
			initialized = true;
		}
		
		private var name : String;
		/**
		 * 
		 * @param name
		 * 
		 */		
		public function Stage(name : String)
		{
			if(initialized){
				throw new Error("Use static fields instead.");
			}
			this.name = name;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function toString() : String{
			return name;
		}
	}
}