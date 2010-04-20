/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
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
package com.googlecode.flexxb.annotation
{
	import com.googlecode.flexxb.FlexXBEngine;
	import com.googlecode.testData.DefaultValueTestObj;
	
	import flexunit.framework.TestCase;
	
	public class DefaultValueTest extends TestCase
	{
		public function DefaultValueTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
		}
		
		public function testDefaultValue() : void{
			var v : DefaultValueTestObj ;
			var xml : XML =
				<DefaultValueTestObj>
					<min>3</min>
				</DefaultValueTestObj>;
			v = FlexXBEngine.instance.deserialize(xml, DefaultValueTestObj);
			assertEquals("String field wrong", "MyValue", v.string);
			assertEquals("min field wrong", 3, v.min);
			assertEquals("max field wrong", 5, v.max);
		}	
	}
}