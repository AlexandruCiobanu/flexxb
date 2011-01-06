/**
 *   FlexXBTest
 *   Copyright (C) 2008-2011 Alex Ciobanu
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
	import com.googlecode.flexxb.core.FxBEngine;
	import com.googlecode.testData.Node;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;

	public class NamespaceTest
	{
		public function NamespaceTest()
		{
		}
		
		[Test]
		public function doInternalNamespaceTest() : void{
			var node : Node = new Node();
			var xml : XML = FxBEngine.instance.getXmlSerializer().serialize(node) as XML;
			namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
			assertThat(xml.@xsi::type, equalTo("xml"));
		}
	}
}