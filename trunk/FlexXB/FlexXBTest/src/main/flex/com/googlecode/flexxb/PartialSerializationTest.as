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
package com.googlecode.flexxb
{
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Mock3;

	import flexunit.framework.TestCase;

	/**
	 *
	 * @author aCiobanu
	 *
	 */
	public class PartialSerializationTest extends TestCase
	{
		public function PartialSerializationTest(methodName:String=null)
		{
			super(methodName);
		}

		public function testPartialSerialization():void
		{
			var target:Mock=new Mock();
			target.aField="test";
			target.link=new Mock3();
			target.link.id=325;
			target.link.version=2;
			var xml:XML=FlexXBEngine.instance.serialize(target);
			var mk3:XML=xml.child(new QName(new Namespace("http://www.axway.com/xmlns/passport/v1"), "mock3"))[0];
			assertTrue(mk3.length() > 0);
			assertEquals("Link id is wrong", "325", mk3.@id);
			assertEquals("Link attribute is wrong", "", mk3.@attribute.toString());
			assertEquals("Link version is wrong", "", mk3.objectVersion.toString());
		}
	}
}