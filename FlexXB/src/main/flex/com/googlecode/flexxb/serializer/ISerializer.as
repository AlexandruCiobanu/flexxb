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
package com.googlecode.flexxb.serializer
{
	import com.googlecode.flexxb.SerializerCore;
	import com.googlecode.flexxb.annotation.Annotation;
	
	/**
	 * Interface for an annotation bound xml serializer.  
	 * @author aCiobanu
	 * 
	 */	
	public interface ISerializer
	{
		/**
		 * Serialize an object into xml
		 * @param object Object to be serialized
		 * @param annotation Annotation containing the conversion parameters 
		 * @param parentXml Parent xml that will enclose the objects xml representation
		 * @serializer
		 * @return Generated xml
		 * 
		 */			
		function serialize(object : Object, annotation : Annotation, parentXml : XML, serializer : SerializerCore) : XML;
		/**
		 * Deserialize an xml into the appropiate AS3 object
		 * @param xmlData Xml to be deserialized
		 * @param annotation Annotation containing the conversion parameters
		 * @serializer 
		 * @return Generated object
		 * 
		 */		
		function deserialize(xmlData : XML, annotation : Annotation, serializer : SerializerCore) : Object;		
	}
}