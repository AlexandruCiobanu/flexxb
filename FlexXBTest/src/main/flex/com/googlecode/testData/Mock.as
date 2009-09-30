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
package com.googlecode.testData {

	[Bindable]
	[XmlClass(alias="MyClass", prefix="test", uri="http://www.axway.com/xmlns/passport/v1")]
	public class Mock {
		[XmlAttribute(alias="stuff")]
		public var aField : String = "a";
		[XmlAttribute(ignoreOn="serialize")]
		public var date : Date;
		[XmlElement(alias="objVersion")]
		public var version : Number = 4;
		[XmlElement(alias="mock3", serializePartialElement="true")]
		public var link : Mock3;
		[XmlElement(serializePartialElement="true")]
		public var reference : Object;
		[XmlArray(alias="data", type="com.googlecode.testData.Mock")]
		public var result : Array;
		[XmlElement]
		public var xmlData : XML;

		[XmlElement]
		public function get readOnly() : String {
			return "YES";
		}

		[XmlElement()]
		public function set writeOnly(value : String) : void {
			trace("Mock - writeOnly");
		}

		public var someExcludedField : Boolean;

		[Argument(ref="version", optional="false")]
		public function Mock() {
			//TODO: implement function
		}
	}
}