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
	
	import flexunit.framework.TestCase;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public class XmlSpecialCharEscapeTest extends TestCase
	{
		public function XmlSpecialCharEscapeTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public function testEscapeCharsOnElements() : void{
			var target : NameOrdered = new NameOrdered();
			target.test2 = "EscapeChar <b>OK</b>";
			target.reference = "<test </meeee>";
			target.list = ["Alt escape test <juice />", "nik", "test4<", "<test5>"];
			var xml : XML = FlexXBEngine.instance.serialize(target);
			assertEquals("Escape Char element is wrong", "EscapeChar <b>OK</b>", (xml.test2[0] as XML).children()[0]);
			assertEquals("Reference has wrong escape chars", "<test </meeee>", (xml.reference[0] as XML).children()[0]);
			assertEquals("Array member has wrong escape chars", "Alt escape test <juice />", xml.list[0].testerElem[0].children()[0]);
			assertEquals("Array member has wrong escape chars", "nik", xml.list[0].testerElem[1].children()[0]);
			assertEquals("Array member has wrong escape chars", "test4<", xml.list[0].testerElem[2].children()[0]);
			assertEquals("Array member has wrong escape chars", "<test5>", xml.list[0].testerElem[3].children()[0]);
		}		
	}
}