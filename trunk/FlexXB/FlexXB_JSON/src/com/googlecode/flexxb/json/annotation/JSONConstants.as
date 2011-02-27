/**
 *   FlexXB
 *   Copyright (C) 2008-2011 Alex Ciobanu
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
package com.googlecode.flexxb.json.annotation
{
	public class JSONConstants
	{
		/**
		 * 
		 */		
		public static const ALIAS : String = "alias";
		/**
		 * 
		 */		
		public static const ALIAS_ANY : String = "*";
		
		public function JSONConstants(){
			throw new Error("Do not instantiate this class. Use static variables instead");
		}
	}
}