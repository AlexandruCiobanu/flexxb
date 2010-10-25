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
package com.googlecode.flexxb.persistence {
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;

	use namespace flexxb_persistence_internal;

	/**
	 *
	 * @author aCiobanu
	 *
	 */
	public class ChangeTracker {
		/**
		 * Get a <code>ChangeTracker</code> instance from a property change event
		 * @param changeEvent
		 * @return <code>ChangeTracker</code> instance
		 * @private
		 */
		flexxb_persistence_internal static function fromPropertyChangeEvent(changeEvent : PropertyChangeEvent, index : Number) : ChangeTracker {
			if (!changeEvent) {
				throw new Error("Property change event can't be null");
			}
			return new ChangeTracker(changeEvent.property as String, changeEvent.oldValue, ChangeTrackerKind.UPDATE, index);
		}

		/**
		 * Get a <code>ChangeTracker</code> instance from a collection change event
		 * @param changeEvent
		 * @return <code>ChangeTracker</code> instance
		 * @private
		 */
		flexxb_persistence_internal static function fromCollectionChangeEvent(changeEvent : CollectionEvent, index : Number) : ChangeTracker {
			if (!changeEvent) {
				throw new Error("Collection change event can't be null");
			}
			var tracker : ChangeTracker = new ChangeTracker("", changeEvent.items, changeEvent.kind, index);
			tracker._additional = changeEvent.location;
			return tracker;
		}

		private var _field : String;
		private var _persistedValue : Object;
		private var _kind : String;
		private var _additional : Object;
		private var _index : Number;

		/**
		 * Constructor
		 * @param property
		 * @param value
		 * @param type
		 * @param additionalInfo
		 *
		 */
		public function ChangeTracker(property : String, value : Object, type : String, index : int = 0, additionalInfo : Object = null) {
			_field = property;
			_persistedValue = value;
			_kind = type;
			_additional = additionalInfo;
			_index = index;
		}

		/**
		 * Get the name of the field whose value has been changed
		 * @return field's name
		 *
		 */
		public function get fieldName() : String {
			return _field;
		}

		/**
		 * Get the initial value of the target field, that is, the persisted value,
		 * prior any changes since the last commit or rollback.
		 * @return field's persisted value
		 *
		 */
		public function get persistedValue() : Object {
			return _persistedValue;
		}

		/**
		 * Get the change type.
		 * @see com.googlecode.flexxb.persistence.ChangeTrackerKind
		 * @return change kind
		 *
		 */
		public function get kind() : String {
			return _kind;
		}
		
		/**
		 * Get the index of the current operation being tracked
		 * @return 
		 * 
		 */		
		public function get index() : Number{
			return _index;
		}

		/**
		 * Get additional information. Usualy, this additional information is
		 * in the form of a number for collection events representing the object's index.
		 * @return object representing the additional info
		 *
		 */
		public function get additional() : Object {
			return _additional;
		}

		/**
		 * Determine if the object was added in the list
		 * @return
		 *
		 */
		public function isAdded() : Boolean {
			return kind == ChangeTrackerKind.ADD;
		}

		/**
		 * Determine if the objects was removed from the list 
		 * @return
		 *
		 */
		public function isRemoved() : Boolean {
			return kind == ChangeTrackerKind.REMOVE;
		}

		/**
		 * Determine if the object was moved within the list
		 * @return
		 *
		 */
		public function isMoved() : Boolean {
			return kind == ChangeTrackerKind.MOVE;
		}

		/**
		 * Clone the current tracker
		 * @return
		 *
		 */
		public function clone() : ChangeTracker {
			var copy : ChangeTracker = new ChangeTracker(fieldName, persistedValue, kind, index, additional);
			return copy;
		}
	}
}