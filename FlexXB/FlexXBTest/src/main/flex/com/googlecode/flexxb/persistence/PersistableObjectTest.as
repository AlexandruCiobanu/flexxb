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
 package com.googlecode.flexxb.persistence
{
	import com.googlecode.testData.Persist;
	
	import flexunit.framework.TestCase;

	public class PersistableObjectTest extends TestCase
	{
		public function PersistableObjectTest(methodName:String=null)
		{
			//TODO: implement function
			super(methodName);
		}
		
		public function testObject() : void{
			var target : Persist = new Persist();
			target.isOK = true;
			target.test1 = 5;
			target.test2 = "test"
			target.commit();
			validate(target, true, 5, "test");
			target.isOK = false;
			target.test1 = 35;
			target.test2 = "test 3"
			target.rollback();
			validate(target, true, 5, "test");
		}
		
		private function validate(target : Persist, ...args) : void{
			assertEquals(target.isOK, args[0]);
			assertEquals(target.test1, args[1]);
			assertEquals(target.test2, args[2]);
		}	
	}
}