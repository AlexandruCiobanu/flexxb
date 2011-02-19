/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2011 Alex Ciobanu
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
	import com.googlecode.testData.Persist;
	
	import flexunit.framework.TestCase;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;

	public class PersistableObjectTest extends TestCase {
		public var bindedVar : String;

		public function PersistableObjectTest(methodName : String = null) {
			super(methodName);
		}

		public function testObject() : void {
			var target : Persist = new Persist();
			target.isOK = true;
			target.test1 = 5;
			target.test2 = "test"
			target.commit();
			validate(target, true, 5, "test");
			target.isOK = false;
			target.test1 = 35;
			target.test2 = "test 3"
			target.rollback();
			validate(target, true, 5, "test");
		}

		public function testEditMode() : void {
			var target : Persist = new Persist();
			bindedVar = "";
			var watcher : ChangeWatcher = BindingUtils.bindProperty(this, "bindedVar", target, "test2");
			target.setEditMode(false);
			target.test2 = "123";
			assertEquals("Binded Var not notified (editMode false):", target.test2, bindedVar);
			target.setEditMode(true);
			target.test2 = "456";
			assertEquals("Binded Var notified (editMode true):", "123", bindedVar);
			target.setEditMode(false);
			target.test2 += "789";
			assertEquals("Binded Var not notified (editMode false):", target.test2, bindedVar);
		}
		
		public function testExclude() : void{
			var target : Persist = new Persist();
			target.startListening();
			assertFalse("Target wrongfully determined as modified", target.modified);
			target.selected = true;
			assertFalse("Target wrongfully determined as modified", target.modified);
		}
		
		public function testWatchFeature() : void{
			var target : Persist = new Persist();
			assertFalse("Modified flag was not set to false", target.modified);
			target.unwatched.someField = "testValue";
			assertFalse("Modified flag was not set to false", target.modified);
			target.watchedRef.someField = "testValue";
			assertTrue("Modified flag was not set to true", target.modified);
		}

		private function validate(target : Persist, ... args) : void {
			assertEquals(target.isOK, args[0]);
			assertEquals(target.test1, args[1]);
			assertEquals(target.test2, args[2]);
		}
	}
}