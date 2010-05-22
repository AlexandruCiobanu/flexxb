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
package com.googlecode.testData {
	import com.googlecode.flexxb.persistence.PersistableObject;

	[Bindable]
	[XmlClass(name="OrderTest", ordered="true")]
	public class Persist extends PersistableObject {
		[XmlElement(order="1")]
		public var isOK : Boolean = false;
		[XmlElement(order="3")]
		public var test1 : int;
		[XmlElement(order="2")]
		public var test2 : String;
		
		public var selected : Boolean;
		
		public var watchedRef : Persist2 = new Persist2();
		
		public var unwatched : Persist2 = new Persist2();

		public function Persist() {
			super();
			exclude("selected");
			watch("watchedRef");
		}
	}
}