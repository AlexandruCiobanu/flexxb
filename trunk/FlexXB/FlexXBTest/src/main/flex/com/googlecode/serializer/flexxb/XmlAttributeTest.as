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

	public class XmlAttributeTest extends AnnotationTest
	{
		public function XmlAttributeTest(methodName:String=null)
		{
			//TODO: implement function
			super(methodName);
		}
		
		protected override function runTest(descriptor:XML):void{
			var att1 : XmlAttribute = new XmlAttribute(getFieldDescriptor("aField", descriptor));
			validate(att1, "aField", String, "stuff", "");
			
			var att2 : XmlAttribute = new XmlAttribute(getFieldDescriptor("date", descriptor));
			validate(att2, "date", Date, "date", XmlMember.IGNORE_ON_SERIALIZE);
		}
				
		protected override function customValidate(annotation:Annotation, ...args):void{
			assertEquals("IgnoreOn is incorrect", args[3], XmlAttribute(annotation).ignoreOn);
		}	
	}
}