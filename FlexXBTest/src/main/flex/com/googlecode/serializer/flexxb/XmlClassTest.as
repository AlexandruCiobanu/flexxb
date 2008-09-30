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
	
	
	public class XmlClassTest extends AnnotationTest
	{
		public function XmlClassTest(methodName:String=null){
			super(methodName);
		}
		
		protected override function runTest(descriptor:XML):void{
			var a : XmlClass = new XmlClass(descriptor);
			validate(a, "Mock", Mock, "MyClass", "test", "http://www.axway.com/xmlns/passport/v1");
		}
				
		protected override function customValidate(annotation:Annotation, ...args):void{
			assertEquals("Namespace prefix is incorrect", args[3], annotation.nameSpace.prefix);
			assertEquals("Namespace uri is incorrect", args[4], annotation.nameSpace.uri);
		}
	}
}