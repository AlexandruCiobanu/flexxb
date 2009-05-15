/**
 *   FxMOD - FLEX Model Object Designer 
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
package com.googlecode.fxmod.settings.model
{
	import mx.utils.StringUtil;
	
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	[XmlClass]
	public class MenuItem
	{
		/**
		 * 
		 */		
		[XmlAttribute]
		public var label : String;
		/**
		 * 
		 */		
		[XmlAttribute]
		public var separator : Boolean;
		/**
		 * 
		 */		
		[XmlAttribute]
		public var shortCutKey : String;
		/**
		 * 
		 */		
		[XmlAttribute]
		public var mnemonicIndex : Number;
		/**
		 * 
		 */
		[XmlAttribute(alias="select")]
		public var selectHandler : String;
		/**
		 * 
		 */		
		[XmlAttribute]
		public var dataProvider : String;
		/**
		 * 
		 */		
		[XmlAttribute]
		public var dataField : String;
		/**
		 * 
		 */		
		[XmlAttribute]
		public var labelField : String;
		/**
		 * 
		 */				
		[XmlArray(alias="*", memberName="MenuItem", type="com.googlecode.fxmod.settings.model.MenuItem")]
		public var subItems : Array;
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function hasSubItems() : Boolean{
			return (subItems && subItems.length > 0) || StringUtil.trim(dataProvider)!= "";
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function hasDataProvider() : Boolean{
			return StringUtil.trim(dataProvider)!= "";
		}
	}
}