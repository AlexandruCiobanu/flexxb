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
package com.googlecode.flexxb.api
{
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	[XmlClass(alias="Namespace")]
	[ConstructorArg(reference="prefix")]
	[ConstructorArg(reference="uri")]
	public final class FxNamespace
	{
		/**
		 * 
		 * @param ns
		 * @return 
		 * 
		 */		
		public static function create(ns : Namespace) : FxNamespace{
			if(ns){
				return new FxNamespace(ns.prefix, ns.uri);
			}
			return null;
		}
		
		private var _prefix : String;
		private var _uri : String
		
		/**
		 * 
		 * @param prefix
		 * @param uri
		 */
		public function FxNamespace(prefix : *, uri : *){
			_prefix = prefix;
			_uri = uri;
		}
		
		[XmlAttribute]
		/**
		 * 
		 * @return 
		 */
		public function get prefix() : String{
			return _prefix;
		}
		
		[XmlAttribute]
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get uri() : String{
			return _uri;
		}
		
		public function toXml() : XML{
			return <metadata name="Namespace">
								<arg key="prefix" value={prefix} />
								<arg key="uri" value={uri} />
							</metadata>
		}
		
		public function toString() : String{
			return "Namespace[ prefix: " + _prefix + ", uri: " + _uri + "]";
		}
	}
}