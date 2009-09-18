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
package com.googlecode.flexxb {
	import com.googlecode.flexxb.IIdentifiable;

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