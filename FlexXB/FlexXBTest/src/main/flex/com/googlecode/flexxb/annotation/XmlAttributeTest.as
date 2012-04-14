/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2012 Alex Ciobanu
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
	import com.googlecode.flexxb.xml.annotation.XmlArray;
	import com.googlecode.flexxb.xml.annotation.XmlAttribute;
	import com.googlecode.flexxb.xml.annotation.XmlClass;
	import com.googlecode.flexxb.xml.annotation.XmlConstants;
	import com.googlecode.flexxb.xml.annotation.XmlElement;
	import com.googlecode.flexxb.xml.annotation.XmlNamespace;
	import com.googlecode.flexxb.xml.serializer.XmlArraySerializer;
	import com.googlecode.flexxb.xml.serializer.XmlAttributeSerializer;
	import com.googlecode.flexxb.xml.serializer.XmlClassSerializer;
	import com.googlecode.flexxb.xml.serializer.XmlElementSerializer;
	
	import org.flexunit.Assert;

	public class XmlAttributeTest extends AnnotationTest {
		
		protected override function runTest(descriptor : XML) : void {
			var parser : MetaParser = new MetaParser(factory);
			var att1 : XmlAttribute = new XmlAttribute(parser.parseField(getFieldDescriptor("aField", descriptor))[0]);
			validate(att1, "aField", String, "stuff", null);

			var att2 : XmlAttribute = new XmlAttribute(parser.parseField(getFieldDescriptor("date", descriptor))[0]);
			validate(att2, "date", Date, "date", Stage.SERIALIZE);
		}
		
		private var factory : AnnotationFactory;
		
		[Before]
		public function before() : void{
			factory = new AnnotationFactory();
			
			factory.registerAnnotation(XmlAttribute.ANNOTATION_NAME, XmlAttribute, XmlAttributeSerializer, null);
			factory.registerAnnotation(XmlElement.ANNOTATION_NAME, XmlElement, XmlElementSerializer, null);
			factory.registerAnnotation(XmlArray.ANNOTATION_NAME, XmlArray, XmlArraySerializer, null);
			factory.registerAnnotation(XmlClass.ANNOTATION_NAME, XmlClass, XmlClassSerializer, null);
			factory.registerAnnotation(XmlConstants.ANNOTATION_NAMESPACE, XmlNamespace, null, null);
		}

		protected override function customValidate(annotation : Annotation, ... args) : void {
			Assert.assertEquals("IgnoreOn is incorrect", args[3], XmlAttribute(annotation).ignoreOn);
		}
	}
}