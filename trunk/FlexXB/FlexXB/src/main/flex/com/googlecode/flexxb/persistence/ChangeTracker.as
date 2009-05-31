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
package com.googlecode.flexxb.persistence
{
	import mx.events.PropertyChangeEvent;
	
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	internal class ChangeTracker
	{
		public static function fromPropertyChangeEvent(changeEvent : PropertyChangeEvent) : ChangeTracker{
			if(!changeEvent){
				throw new Error("Property change event can't be null");
			}
			return new ChangeTracker(changeEvent.property as String, changeEvent.oldValue, ChangeTrackerKind.UPDATE);
		}
		
		private var _field : String;
		private var _persistedValue : Object;
		private var _kind : String;
		private var _additional : Object;
		/**
		 * 
		 * @param changeEvent
		 * 
		 */		
		public function ChangeTracker(property : String, value : Object, type : String, additionalInfo : Object = null)
		{
			_field = property;
			_persistedValue = value;
			_kind = type;
			_additional = additionalInfo;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fieldName() : String{
			return _field;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get persistedValue() : Object{
			return _persistedValue;
		}
		
		public function get kind() : String{
			return _kind;
		}
		
		public function get additional() : Object{
			return _additional;
		}
	}
}