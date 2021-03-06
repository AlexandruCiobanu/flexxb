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
package com.googlecode.testData.xsi
{
	[XmlClass]
	[XmlClass(version="xsiNS")]
	[Namespace(prefix="a", uri="http://test.com/xsiNS", version="xsiNS")]
	[Namespace(prefix="xsi", uri="http://www.w3.org/2001/XMLSchema-instance", version="xsiNS")]
	public class Main
	{
		[XmlAttribute]
		[XmlAttribute(version="xsiNS")]
		public var id : Number = 0;
		
		[XmlElement(setXsiType="true", getRuntimeType="true")]
		[XmlElement(setXsiType="true", getRuntimeType="true", namespace="a", version="xsiNS")]
		public var property : BaseItem;
		
		[XmlArray(alias="members", memberName="listItem", setXsiType="true", getRuntimeType="true")]
		[XmlArray(alias="members", memberName="listItem", setXsiType="true", getRuntimeType="true", namespace="a", version="xsiNS")]
		public var list : Array;
		
		public function Main()
		{
		}
	}
}