/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2011 Alex Ciobanu
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
	import com.googlecode.flexxb.core.FxBEngine;
	import com.googlecode.flexxb.annotation.parser.MetaParser;
	import com.googlecode.flexxb.xml.annotation.Annotation;
	import com.googlecode.flexxb.xml.annotation.XmlArray;
	import com.googlecode.testData.List;
	import com.googlecode.testData.Mock;
	import com.googlecode.testData.VectoredElement;
	
	import flash.utils.describeType;
	
	import org.flexunit.Assert;
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	
	public class XmlArrayTest extends AnnotationTest {
		
		protected override function runTest(descriptor : XML) : void {
			var parser : MetaParser = new MetaParser();
			var att1 : XmlArray = new XmlArray(parser.parseField(getFieldDescriptor("result", descriptor))[0], null);
			validate(att1, "result", Array, "data", null, false, Mock);
		}

		protected override function customValidate(annotation : Annotation, ... args) : void {
			Assert.assertEquals("IgnoreOn is incorrect", args[3], XmlArray(annotation).ignoreOn);
			Assert.assertEquals("SerializePartialElement is incorrect", args[4], XmlArray(annotation).serializePartialElement);
			Assert.assertEquals("Type is incorrect", args[5], XmlArray(annotation).memberType);
		}
		
		[Test]
		public function validateVectorSupport() : void{
			var parser : MetaParser = new MetaParser();
			var xml : XML = describeType(VectoredElement);
			var att1 : XmlArray = new XmlArray(parser.parseField(xml.factory.variable.(@name=="list")[0])[0], null);
			assertThat(att1.type, equalTo(Vector.<String>));
			assertThat(att1.memberType, equalTo(String));
		}
	}
}