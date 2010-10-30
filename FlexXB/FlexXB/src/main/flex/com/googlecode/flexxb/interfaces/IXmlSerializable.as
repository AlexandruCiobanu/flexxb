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
package com.googlecode.flexxb.interfaces {
	
	/**
	 * Interface for an object that requires custom serialization/deserialization into/from Xml
	 * @author aciobanu
	 *
	 *
	 */
	public interface IXmlSerializable extends IIdentifiable {
		/**
		 * Serialize current object into Xml
		 */
		function toXml() : XML;
		/**
		 * Deserialize this object from one of it's possible XML representation.
		 * @param xmlData xml data source
		 */
		function fromXml(xmlData : XML) : Object;
		/**
		 *
		 * @param xmldata
		 * @return
		 *
		 */
		function getIdValue(xmldata : XML) : String;
	}
}