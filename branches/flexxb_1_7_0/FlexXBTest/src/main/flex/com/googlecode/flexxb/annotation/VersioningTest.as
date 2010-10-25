package com.googlecode.flexxb.annotation
{
	import com.googlecode.flexxb.FlexXBEngine;
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Mock2;
	import com.googlecode.testData.VersionedItem;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.hamcrest.object.equalTo;

	public final class VersioningTest
	{
		[Test]
		public function testMultipleVersions() : void{
			var item : VersionedItem = new VersionedItem();
			item.id = "MyId";
			item.name = "MyName";
			item.value = new Mock();
			item.value.aField = "field1";
			item.mock2 = new Mock2();
			item.mock2.id = 12345;
			
			var v1Ns : Namespace = new Namespace("http://www.me.com/me/de");
			
			var xmlV1 : XML = FlexXBEngine.instance.serialize(item);
			
			assertThat(xmlV1.name().toString(), equalTo(new QName(v1Ns, "item").toString()));
			assertThat(xmlV1.inScopeNamespaces().length, equalTo(1));
			assertThat(xmlV1.namespace().uri, equalTo("http://www.me.com/me/de"));
			assertThat(xmlV1.@v1Ns::id, equalTo("MyId"));
			assertThat(xmlV1.@v1Ns::pName, equalTo("MyName"));
			assertThat(xmlV1.child(new QName(v1Ns, "mock")).length(), equalTo(0));
			
			var xmlV2 : XML = FlexXBEngine.instance.serialize(item, false, "v2");
			
			assertThat(xmlV2.name().toString(), equalTo("VersionedItem"));
			assertThat(xmlV2.namespace().uri, equalTo(""));
			assertThat(xmlV2.id, equalTo("MyId"));
			assertThat(xmlV2.@itemName, equalTo("MyName"));
			assertThat(xmlV2.child("mock").length(), equalTo(1));
						
			var cloneV1 : VersionedItem = FlexXBEngine.instance.deserialize(xmlV1, VersionedItem, false);
			assertThat(item.id, equalTo(cloneV1.id));
			assertThat(item.name, equalTo(cloneV1.name));
			assertNull(cloneV1.value);
			assertNotNull(cloneV1.mock2);
			
			var cloneV2 : VersionedItem = FlexXBEngine.instance.deserialize(xmlV2, VersionedItem, false, "v2");			
			assertThat(item.id, equalTo(cloneV2.id));
			assertThat(item.name, equalTo(cloneV2.name));
			assertNotNull(cloneV2.value);
			assertNull(cloneV2.mock2);
		}
	}
}