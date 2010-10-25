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
package com.googlecode.flexxb.api
{
		
	[XmlClass(alias="Namespace")]
	[ConstructorArg(reference="prefix")]
	[ConstructorArg(reference="uri")]
	/**
	 * 
	 * @author Alexutz
	 * 
	 */
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
		
		/**
		 * Get string representation of the current instance
		 * @return string representing the current instance
		 */
		public function toString() : String{
			return "Namespace[ prefix: " + _prefix + ", uri: " + _uri + "]";
		}
	}
}