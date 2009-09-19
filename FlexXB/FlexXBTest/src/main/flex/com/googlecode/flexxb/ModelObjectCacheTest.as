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
package com.googlecode.flexxb {
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Mock3;

	import flexunit.framework.TestCase;

	public class ModelObjectCacheTest extends TestCase {
		public function ModelObjectCacheTest(methodName : String = null) {
			super(methodName);
		}

		public function testEmptyCache() : void {
			ModelObjectCache.instance.putObject("id", new Mock());
			assertTrue("Cache does not coontain the object", ModelObjectCache.instance.isCached("id", Mock));
			ModelObjectCache.instance.clearCache(Mock);
			assertNull(ModelObjectCache.instance.getObject("id", Mock));
		}

		public function testCache() : void {
			var obj : Mock3 = new Mock3();
			obj.id = 352;
			obj.attribute = true;
			var xml : XML = FlexXBEngine.instance.serialize(obj);
			var copy : Mock3 = FlexXBEngine.instance.deserialize(xml, Mock3);
			assertEquals(copy.id, obj.id);
			assertTrue("Deserialized object not cached", ModelObjectCache.instance.isCached(String(copy.id), Mock3));
			assertEquals("Different instances", copy, ModelObjectCache.instance.getObject(String(copy.id), Mock3));
		}
	}
}