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
package com.googlecode.flexxb.annotation
{
	import com.googlecode.flexxb.FlexXBEngine;
	import com.googlecode.testData.ConstructorRefObj;
	import com.googlecode.testData.Mock;

	import flash.utils.describeType;


	public class XmlClassTest extends AnnotationTest
	{
		public function XmlClassTest(methodName:String=null)
		{
			super(methodName);
		}

		public function testConstructorParameters():void
		{
			var target:ConstructorRefObj=new ConstructorRefObj("test", 1, true);
			FlexXBEngine.instance.serialize(null);
			var cls:XmlClass=new XmlClass(describeType(ConstructorRefObj));
			assertFalse("Class constructor should not be default", cls.constructor.isDefault());
			assertNotNull("ParameterFields is Null", cls.constructor.parameterFields);
			assertEquals("There are more or less than 3 parameters", 3, cls.constructor.parameterFields.length);
		}

		protected override function runTest(descriptor:XML):void
		{
			var a:XmlClass=new XmlClass(descriptor);
			validate(a, "Mock", Mock, "MyClass", "test", "http://www.axway.com/xmlns/passport/v1");
		}

		protected override function customValidate(annotation:Annotation, ... args):void
		{
			assertEquals("Namespace prefix is incorrect", args[3], annotation.nameSpace.prefix);
			assertEquals("Namespace uri is incorrect", args[4], annotation.nameSpace.uri);
		}
	}
}