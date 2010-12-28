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
	import com.googlecode.flexxb.annotation.contract.Stage;
	import com.googlecode.flexxb.annotation.parser.MetaParser;
	import com.googlecode.flexxb.xml.annotation.Annotation;
	import com.googlecode.flexxb.xml.annotation.XmlAttribute;
	
	import org.flexunit.Assert;

	public class XmlAttributeTest extends AnnotationTest {
		
		protected override function runTest(descriptor : XML) : void {
			var parser : MetaParser = new MetaParser();
			var att1 : XmlAttribute = new XmlAttribute(parser.parseField(getFieldDescriptor("aField", descriptor))[0], null);
			validate(att1, "aField", String, "stuff", null);

			var att2 : XmlAttribute = new XmlAttribute(parser.parseField(getFieldDescriptor("date", descriptor))[0], null);
			validate(att2, "date", Date, "date", Stage.SERIALIZE);
		}

		protected override function customValidate(annotation : Annotation, ... args) : void {
			Assert.assertEquals("IgnoreOn is incorrect", args[3], XmlAttribute(annotation).ignoreOn);
		}
	}
}