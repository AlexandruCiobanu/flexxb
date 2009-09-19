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
package com.googlecode.flexxb
{
	import com.googlecode.testData.NameOrdered;
	import com.googlecode.testData.Persist;

	import flexunit.framework.TestCase;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public class XmlElementOrderTest extends TestCase
	{
		public function XmlElementOrderTest(methodName:String=null)
		{
			super(methodName);
		}

		public function testNumericOrder():void
		{
			var test:Persist=new Persist();
			test.test1=3;
			test.test2="valoare";
			var xml:XML=FlexXBEngine.instance.serialize(test);
			assertEquals("ChildOrder not ok for first child", "isOK", (xml.children()[0] as XML).name().toString());
			assertEquals("ChildOrder not ok for second child", "test2", (xml.children()[1] as XML).name().toString());
			assertEquals("ChildOrder not ok for third child", "test1", (xml.children()[2] as XML).name().toString());
		}

		public function testNameOrder():void
		{
			var test:NameOrdered=new NameOrdered();
			test.test1=3;
			test.test2="valoare";
			test.reference="ref";
			var xml:XML=FlexXBEngine.instance.serialize(test);
			assertEquals("ChildOrder not ok for first child", "reference", (xml.children()[0] as XML).name().toString());
			assertEquals("ChildOrder not ok for second child", "test2", (xml.children()[1] as XML).name().toString());
			assertEquals("ChildOrder not ok for third child", "TestOk", (xml.children()[2] as XML).name().toString());
			assertEquals("ChildOrder not ok for third child", "variable", (xml.children()[3] as XML).name().toString());
		}
	}
}