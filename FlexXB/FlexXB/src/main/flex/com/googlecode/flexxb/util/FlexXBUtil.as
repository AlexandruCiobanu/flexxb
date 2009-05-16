/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
 *   Copyright (C) 2008-2009 Alex Ciobanu
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
package com.googlecode.flexxb.util
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public final class FlexXBUtil
	{
		/**
		 * 
		 */		
		public static const CDATA_START : String = "<![CDATA[";
		/**
		 * 
		 */		
		public static const CDATA_END : String = "]]>";
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function getCDATAValue(value : String) : String{
			return CDATA_START + value + CDATA_END;
		}
		
		
		public function FlexXBUtil()
		{
			throw new Error("Do not instanciate FlexXBUtil class. Use static members instead");
		}
	}
}