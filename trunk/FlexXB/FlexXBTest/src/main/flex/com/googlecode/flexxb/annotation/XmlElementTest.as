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
	import com.googlecode.flexxb.annotation.parser.MetaParser;
	import com.googlecode.flexxb.xml.annotation.Annotation;
	import com.googlecode.flexxb.xml.annotation.XmlElement;
	import com.googlecode.testData.Mock3;
	
	import org.flexunit.Assert;

	public class XmlElementTest extends AnnotationTest {
		
		protected override function runTest(descriptor : XML) : void {
			var parser : MetaParser = new MetaParser();
			var att1 : XmlElement = new XmlElement(parser.parseField(getFieldDescriptor("version", descriptor))[0]);
			validate(att1, "version", int, "objVersion", null, false);

			var att2 : XmlElement = new XmlElement(parser.parseField(getFieldDescriptor("reference", descriptor))[0]);
			validate(att2, "reference", Object, "reference", null, true);

			var att3 : XmlElement = new XmlElement(parser.parseField(getFieldDescriptor("link", descriptor))[0]);
			validate(att3, "link", Mock3, "mock3", null, true);
		}

		/**
		 * Custom validation. Handles the fourth and fifth parameters:
		 *   - IgnoreOn
		 *   - SerializePartialElement
		 * @param annotation
		 * @param args
		 *
		 */
		protected override function customValidate(annotation : Annotation, ... args) : void {
			Assert.assertEquals("IgnoreOn is incorrect", args[3], XmlElement(annotation).ignoreOn);
			Assert.assertEquals("SerializePartialElement is incorrect", args[4], XmlElement(annotation).serializePartialElement);
		}
	}
}