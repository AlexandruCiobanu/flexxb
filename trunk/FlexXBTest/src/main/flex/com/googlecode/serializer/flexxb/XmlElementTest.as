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
	import flash.utils.describeType;
	
	import flexunit.framework.TestCase;

	public class XmlElementTest extends AnnotationTest
	{
		public function XmlElementTest(methodName:String=null)
		{
			super(methodName);
		}
		
		protected override function runTest(descriptor:XML):void{
			var att1 : XmlElement = new XmlElement(getFieldDescriptor("version", descriptor));
			validate(att1, "version", Number, "objVersion", "", false);
			
			var att2 : XmlElement = new XmlElement(getFieldDescriptor("reference", descriptor));
			validate(att2, "reference", Object, "*", "", true);
		}
				
		protected override function customValidate(annotation:Annotation, ...args):void{
			assertEquals("IgnoreOn is incorrect", args[3], XmlElement(annotation).ignoreOn);
			assertEquals("SerializePartialElement is incorrect", args[4], XmlElement(annotation).serializePartialElement);
		}	
	}
}