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
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.Mock3;
	
	import flexunit.framework.TestCase;

	public class XmlSerializerTest extends TestCase
	{
		public function XmlSerializerTest(methodName:String=null)
		{
			super(methodName);
		}
		
		protected function getObject() : Mock{
			var target : Mock = new Mock();
			target.link = new Mock3();
			target.aField = "test1";
			target.date = new Date();
			target.version = 6;
			target.result = [];
			return target;
		}
		
		protected function compare(source : Mock, copy : Mock) : void{
			assertEquals("Wrong version", source.version, copy.version);
			assertEquals("Wrong aField", source.aField, copy.aField);
			assertEquals("Wrong link id", source.link.id, copy.link.id);
			assertNull("Date not null", copy.date);
			assertEquals("Wrong result list", source.result.length, copy.result.length);
			assertFalse("Wrong excluded field", copy.someExcludedField)
		}
		
		public function testSerializeDeserialize() : void{
			var target : Mock = getObject();
			var xml : XML = XMLSerializer.instance.serialize(target);
			var copy : Mock = XMLSerializer.instance.deserialize(xml, Mock) as Mock;
			compare(target, copy);
		}		
	}
}