/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */
package com.googlecode.flexxb.annotation {
	import com.googlecode.flexxb.FlexXBEngine;
	import com.googlecode.flexxb.annotation.parser.MetaParser;
	import com.googlecode.flexxb.annotation.xml.Annotation;
	import com.googlecode.flexxb.annotation.xml.XmlClass;
	import com.googlecode.testData.ConstructorRefObj;
	import com.googlecode.testData.Mock;
	
	import flash.utils.describeType;
	
	import org.flexunit.Assert;


	public class XmlClassTest extends AnnotationTest {
				
		[Test]
		public function testConstructorParameters() : void {
			var target : ConstructorRefObj = new ConstructorRefObj("test", 1, true);
			FlexXBEngine.instance.serialize(null);
			var parser : MetaParser = new MetaParser();
			var cls : XmlClass = parser.parseDescriptor(describeType(ConstructorRefObj))[0];
			Assert.assertFalse("Class constructor should not be default", cls.constructor.isDefault());
			Assert.assertNotNull("ParameterFields is Null", cls.constructor.parameterFields);
			Assert.assertEquals("There are more or less than 3 parameters", 3, cls.constructor.parameterFields.length);
		}

		protected override function runTest(descriptor : XML) : void {
			var parser : MetaParser = new MetaParser();
			var a : XmlClass = parser.parseDescriptor(descriptor)[0];
			validate(a, "Mock", Mock, "MyClass", "test", "http://www.axway.com/xmlns/passport/v1");
		}

		protected override function customValidate(annotation : Annotation, ... args) : void {
			Assert.assertEquals("Namespace prefix is incorrect", args[3], annotation.nameSpace.prefix);
			Assert.assertEquals("Namespace uri is incorrect", args[4], annotation.nameSpace.uri);
		}
	}
}