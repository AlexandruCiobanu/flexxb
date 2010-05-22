/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
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
package com.googlecode.flexxb {
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Mock3;
	import org.flexunit.Assert;
	

	public class ModelObjectCacheTest {
		
		[Test]
		public function testEmptyCache() : void {
			ModelObjectCache.instance.putObject("id", new Mock());
			Assert.assertTrue("Cache does not coontain the object", ModelObjectCache.instance.isCached("id", Mock));
			ModelObjectCache.instance.clearCache(Mock);
			Assert.assertNull(ModelObjectCache.instance.getObject("id", Mock));
		}
		
		[Test]
		public function testCache() : void {
			var obj : Mock3 = new Mock3();
			obj.id = 352;
			obj.attribute = true;
			var xml : XML = FlexXBEngine.instance.serialize(obj);
			var copy : Mock3 = FlexXBEngine.instance.deserialize(xml, Mock3);
			Assert.assertEquals(copy.id, obj.id);
			Assert.assertTrue("Deserialized object not cached", ModelObjectCache.instance.isCached(String(copy.id), Mock3));
			Assert.assertEquals("Different instances", copy, ModelObjectCache.instance.getObject(String(copy.id), Mock3));
		}
	}
}