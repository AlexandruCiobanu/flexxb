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
package com.googlecode.flexxb.service {

	/**
	 *
	 * @author aCiobanu
	 *
	 */
	public interface ITranslator {
		/**
		 * Create the XML request to be sent to the server
		 * @return XML request
		 *
		 */
		function createRequest() : XML;
		/**
		 * Get the response xml from the server and convert it to the response object.
		 * @param data xml response
		 * @return actual response object
		 *
		 */
		function parseResponse(data : XML) : Object;

		/**
		 *
		 * @param response the response received from the server.
		 * @return the object the represents the response.
		 */
		function extractResponseData(response : Object) : Object;
	}
}
