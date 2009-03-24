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
 package com.googlecode
{
	import com.googlecode.flexxb.ModelObjectCacheTest;
	import com.googlecode.flexxb.PartialSerializationTest;
	import com.googlecode.flexxb.XmlTests;
	import com.googlecode.flexxb.persistence.PersistenceTests;
	
	import flexunit.framework.TestSuite;
	
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class AllTests
	{
		/**
		 * 
		 * 
		 */		
		public function AllTests(){}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function allTests() : TestSuite
		{
			var ts:TestSuite = new TestSuite();	
			ts.name = "All Tests";
			ts.addTest(XmlTests.suite());
			ts.addTestSuite(ModelObjectCacheTest);
			ts.addTestSuite(PartialSerializationTest);
			ts.addTest(PersistenceTests.suite());			
 			return ts;
		}
	}
}