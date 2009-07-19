/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
 *   Copyright (C) 2008-2009 Alex Ciobanu
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
package com.googlecode.testData
{
	[XmlClass]
	[ConstructorArg(reference="ref1", optional="false")]
	[ConstructorArg(reference="ref2")]
	[ConstructorArg(reference="ref3", optional="true")]
	[Bindable]
	public class ConstructorRefObj
	{
		[XmlElement]
		public var ref1 : String;
		[XmlAttribute]
		public var ref2 : Number;
		[XmlAttribute]
		public var ref3 : Boolean;
			
		public function ConstructorRefObj(r1 : String, r2 : Number, r3 : Boolean)
		{
			ref1 = r1;
			ref2 = r2;
			ref3 = r3;
		}
	}
}