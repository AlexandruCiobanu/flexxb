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
package com.googlecode.flexxb.serializer {
	import com.googlecode.flexxb.SerializerCore;
	import com.googlecode.flexxb.annotation.contract.IAnnotation;

	/**
	 * Interface for an annotation bound xml serializer.
	 * @author aCiobanu
	 *
	 */
	public interface ISerializer {
		/**
		 * Serialize an object into xml
		 * @param object Object to be serialized
		 * @param annotation Annotation containing the conversion parameters
		 * @param parentXml Parent xml that will enclose the objects xml representation
		 * @serializer
		 * @return Generated xml
		 *
		 */
		function serialize(object : Object, annotation : IAnnotation, parentXml : XML, serializer : SerializerCore) : XML;
		/**
		 * Deserialize an xml into the appropiate AS3 object
		 * @param xmlData Xml to be deserialized
		 * @param annotation Annotation containing the conversion parameters
		 * @serializer
		 * @return Generated object
		 *
		 */
		function deserialize(xmlData : XML, annotation : IAnnotation, serializer : SerializerCore) : Object;
	}
}