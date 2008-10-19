package com.googlecode.serializer.flexxb
{
	import com.googlecode.serializer.ModelObjectCache;
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Mock3;
	
	import flexunit.framework.TestCase;

	public class ModelObjectCacheTest extends TestCase
	{
		public function ModelObjectCacheTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public function testEmptyCache() : void{
			ModelObjectCache.instance.putObject("id", new Mock());
			assertTrue("Cache does not coontain the object", ModelObjectCache.instance.isCached("id", Mock));
			ModelObjectCache.instance.clearCache(Mock);
			assertNull(ModelObjectCache.instance.getObject("id", Mock));
		}
		
		public function testCache() : void{
			var obj : Mock3 = new Mock3();
			obj.id = 352;
			obj.attribute = true;
			var xml : XML = XMLSerializer.instance.serialize(obj);
			var copy : Mock3 = XMLSerializer.instance.deserialize(xml, Mock3) as Mock3;
			assertEquals(copy.id, obj.id);
			assertTrue("Deserialized object not cached", ModelObjectCache.instance.isCached(String(copy.id), Mock3));
			assertEquals("Different instances", copy, ModelObjectCache.instance.getObject(String(copy.id), Mock3));
		} 
	}
}