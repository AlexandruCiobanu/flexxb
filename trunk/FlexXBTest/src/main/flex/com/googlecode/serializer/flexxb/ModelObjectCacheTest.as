package com.googlecode.serializer.flexxb
{
	import com.googlecode.serializer.ModelObjectCache;
	import com.googlecode.testData.Mock;
	
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
	}
}