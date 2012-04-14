/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2012 Alex Ciobanu
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */
package com.googlecode.flexxb.persistence {
	import flexunit.framework.TestCase;
	import com.googlecode.flexxb.persistence.PersistableList;

	import mx.events.CollectionEvent;

	public class ReferenceListTest extends TestCase {
		public function ReferenceListTest(methodName : String = null) {
			super(methodName);
		}

		public function testList() : void {
			var list : PersistableList = new PersistableList(["1", "2", "3"], true);
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
			var list : PersistableList = new PersistableList(["1", "2", "3"], true);
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
			assertTrue("Change was not detected when editMode was set to false", changeDiscovered);
		}

		public function testListenMode() : void {
			var list : PersistableList = new PersistableList(["1", "2", "3"], true);
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