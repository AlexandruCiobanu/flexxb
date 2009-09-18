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
package com.googlecode.flexxb.persistence {

	/**
	 * Interface defining an object that can be persisted. A persistable object
	 * is capable of tracking changes done to it and reverting to initial values
	 * if required.
	 * <code>IPersistable</code> exposes three methods:
	 * <ul>
	 * 	<li><code>modified</code> - check if object has been changed since its last save</li>
	 * 	<li><code>commit</code> - make changes done from the last save persistent</li>
	 * 	<li><code>rollback</code> - revert to the initial state of the object</li>
	 * </ul>
	 * @author aCiobanu
	 *
	 */
	public interface IPersistable {
		/**
		 * Get the object's status: has it been modified since the previous commit?
		 * @return  true/false
		 *
		 */
		function get modified() : Boolean;
		/**
		 *
		 * @return
		 *
		 */
		function get editMode() : Boolean;
		/**
		 *
		 * @param mode
		 *
		 */
		function setEditMode(mode : Boolean) : void;
		/**
		 * Commit the changes made to the object since the previous commit
		 *
		 */
		function commit() : void;
		/**
		 * Revert all the changes made to the object since the previous commit
		 *
		 */
		function rollback() : void;
		/**
		 * Stop listening for changes occuring to the object.
		 * It is usually called before deserialization occurs.
		 *
		 */
		function stopListening() : void;
		/**
		 * Start listening for changes occuring to the object.
		 * Usually called after deserialization completes.
		 *
		 */
		function startListening() : void;
	}
}