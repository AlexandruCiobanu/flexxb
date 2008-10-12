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
 package com.googlecode.serializer.flexxb
{
	import flexunit.framework.TestSuite;

	public class XmlTests extends TestSuite
	{
		public function XmlTests(param:Object=null)
		{
			super(param);
		}
		/**
		 * 
		 * @return a test suite
		 */
		public static function suite() : TestSuite
		{
			var ts:TestSuite = new TestSuite();
			ts.name = "Xml Tests";
			ts.addTestSuite(XmlClassTest);
			//ts.addTestSuite(XmlClassSerializerTest);
			ts.addTestSuite(XmlAttributeTest);
			//ts.addTestSuite(XmlAttributeSerializerTest);
			ts.addTestSuite(XmlElementTest);
			//ts.addTestSuite(XmlElementSerializerTest);
			ts.addTestSuite(XmlArrayTest);
			//ts.addTestSuite(XmlArraySerializerTest);
			ts.addTestSuite(XmlSerializerTest);
			return ts;
		}		
	}
}