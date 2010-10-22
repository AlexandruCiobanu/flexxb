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
	import com.googlecode.testData.List;
	import com.googlecode.testData.Mock;
	
	import org.flexunit.Assert;
	import org.flexunit.assertThat;
	import com.googlecode.flexxb.annotation.xml.Annotation;
	import com.googlecode.flexxb.annotation.xml.XmlArray;
	
	public class XmlArrayTest extends AnnotationTest {
		
		protected override function runTest(descriptor : XML) : void {
			var att1 : XmlArray = new XmlArray();//getFieldDescriptor("result", descriptor));
			validate(att1, "result", Array, "data", null, false, Mock);
		}

		protected override function customValidate(annotation : Annotation, ... args) : void {
			Assert.assertEquals("IgnoreOn is incorrect", args[3], XmlArray(annotation).ignoreOn);
			Assert.assertEquals("SerializePartialElement is incorrect", args[4], XmlArray(annotation).serializePartialElement);
			Assert.assertEquals("Type is incorrect", args[5], XmlArray(annotation).type);
		}
	}
}