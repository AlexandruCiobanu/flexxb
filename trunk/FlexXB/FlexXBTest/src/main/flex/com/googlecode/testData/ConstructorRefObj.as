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

	[XmlClass]
	[ConstructorArg(reference="ref1", optional="false")]
	[ConstructorArg(reference="ref2")]
	[ConstructorArg(reference="ref3", optional="true")]
	[Bindable]
	public class ConstructorRefObj {
		[XmlElement]
		public var ref1 : String;
		[XmlAttribute]
		public var ref2 : Number;
		[XmlAttribute]
		public var ref3 : Boolean;

		public function ConstructorRefObj(r1 : String, r2 : Number, r3 : Boolean) {
			ref1 = r1;
			ref2 = r2;
			ref3 = r3;
		}
	}
}