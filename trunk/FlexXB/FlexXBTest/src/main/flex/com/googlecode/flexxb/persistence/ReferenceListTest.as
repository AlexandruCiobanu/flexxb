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
package com.googlecode.flexxb.persistence {
	import flexunit.framework.TestCase;
	import com.googlecode.flexxb.persistence.PersistableList;

	import mx.events.CollectionEvent;

	public class ReferenceListTest extends TestCase {
		public function ReferenceListTest(methodName : String = null) {
			//TODO: implement function
			super(methodName);
		}

		public function testList() : void {
			var list : PersistableList = new PersistableList(["1", "2", "3"]);
			assertFalse("Modified wrongfully fired", list.modified);
			list.removeItemAt(0);
			list.addItem("4");
			list.addItem("5");
			assertTrue("Modified not set", list.modified);
			list.rollback();
			assertEquals("Wrong length", 3, list.length);
			assertEquals("Wronf first element", "1", list.getItemAt(0));
			assertEquals("Wronf second element", "2", list.getItemAt(1));
			assertEquals("Wronf third element", "3", list.getItemAt(2));
		}

		public function testEditMode() : void {
			var list : PersistableList = new PersistableList(["1", "2", "3"]);
			assertFalse("Modified wrongfully fired", list.modified);
			var changeDiscovered : Boolean;
			list.addEventListener(CollectionEvent.COLLECTION_CHANGE, function(event : CollectionEvent) : void {
					changeDiscovered = true;
				});
			list.setEditMode(true);
			list.removeItemAt(0);
			list.addItem("4");
			list.addItem("5");
			assertTrue("Modified not set", list.modified);
			assertFalse("Change was wrongfully detected when editMode was set to true", changeDiscovered);
			list.setEditMode(false);
			list.addItem("5");
			assertTrue("Change was not detected when editMode was setto false", changeDiscovered);
		}

		public function testListenMode() : void {
			var list : PersistableList = new PersistableList(["1", "2", "3"]);
			assertFalse("Modified wrongfully fired", list.modified);
			list.stopListening();
			list.addItem("4");
			list.addItem("5");
			assertFalse("Modified is wrong", list.modified);
			list.rollback();
			assertEquals("Member count invalid", 5, list.length);
		}
	}
}