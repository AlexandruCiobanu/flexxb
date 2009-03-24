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
package com.googlecode.flexxb.error
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class ProcessingError extends Error
	{
		/**
		 * 
		 */		
		public static const STAGE_SERIALIZE : int = 0;
		/**
		 * 
		 */		
		public static const STAGE_DESERIALIZE : int = 1;
		
		private var _stage : int;
		
		private var _type : Class;
		
		private var _field : String;
		/**
		 * 
		 * @param message
		 * @param id
		 * 
		 */		
		public function ProcessingError(type : Class, field : String, inSerializeStage : Boolean, message : String){
			super("", 0);
			_stage = inSerializeStage ? STAGE_SERIALIZE : STAGE_DESERIALIZE;
			_type = type;
			_field = field;
			buildErrorMessage(message);
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function isInSerializeStage() : Boolean{
			return _stage == STAGE_SERIALIZE;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function isInDeserializeStage() : Boolean{
			return _stage == STAGE_DESERIALIZE;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get type() : Class{
			return _type;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get field() : String{
			return _field;
		}
		
		private function buildErrorMessage(additional : String) : void{
			message = "Error occured on " + 
				isInSerializeStage() ? "serialize" : "deserialize" + " stage for type " +
				type + ", field " + field + ":\n" + additional;			
		}
	}
}