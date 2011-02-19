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
package com.googlecode.testData {

	[XmlClass(alias="myPathTester", defaultValueField="defaultTest")]
	public class XmlPathObject {
		[XmlElement(alias="subObject/id")]
		public var identity : Number = 2;
		[XmlElement(alias="subObject/subSubObj/ref")]
		public var reference : String = "ReferenceTo";
		[XmlArray(alias="subObject/list")]
		public var list : Array;
		[XmlAttribute(alias="anotherSub/attTest")]
		public var test : Date = new Date();
		[XmlElement()]
		public var defaultTest : String = "This is Default!!!"

		public function XmlPathObject() {
		}
	}
}