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
package com.googlecode.flexxb.api {
	import com.googlecode.flexxb.annotation.XmlClass;

	/**
	 * This interface defines the api structure and access points
	 * @author Alexutz
	 *
	 */
	public interface IFlexXBApi {
		/**
		 * Register a type descriptor that is defined by the api components. This is especially
		 * useful when not having access to source code.
		 * @param apiDescriptor
		 *
		 */
		function processTypeDescriptor(apiDescriptor : FxClass) : void;
		/**
		 * Register the type descriptors by the mmeans of an xml file. The content is converted
		 * to api components then they are processed to register the type described in the xml file.
		 * @param xml
		 *
		 */
		function processDescriptorsFromXml(xml : XML) : void;
	}
}