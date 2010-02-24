/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 *   Copyright (C) 2008-2010 Alex Ciobanu
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
	import com.googlecode.flexxb.IXmlSerializable;

	public class CustomSerializabeObject implements IXmlSerializable {
		public var test : String;

		public function CustomSerializabeObject() {
		}

		public function get id() : String {
			return null;
		}

		public function toXml() : XML {
			return <testObject><testField>{test}</testField></testObject>;
		}

		public function get thisType() : Class {
			return CustomSerializabeObject;
		}

		public function fromXml(xmlData : XML) : Object {
			test = xmlData.testField;
			return this;
		}

		public function getIdValue(xmldata : XML) : String {
			return null;
		}
	}
}