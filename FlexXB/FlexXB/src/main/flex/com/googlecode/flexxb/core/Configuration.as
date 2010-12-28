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
package com.googlecode.flexxb.core {
	import com.googlecode.flexxb.cache.ICacheProvider;

	/**
	 *
	 * @author Alexutz
	 *
	 */
	public class Configuration {
		
		/**
		 * Serializing persistable objects can be done by including only the fields
		 * whose values have been changed.
		 */
		public var onlySerializeChangedValueFields : Boolean = false;
		/**
		 * Use this flag to control whether to permit logging or not. This is mostly intended for
		 * debugging the (de)serialization process.<br/>
		 * <b>Logging can slow down the process up to 20 times. Use with caution!</b>
		 */		
		public var enableLogging : Boolean = false;
		/**
		 * Reference to an ICacheProvider implementor. Use this field to instruct the engine to use
		 * an object caching mechanism.
		 */		
		public var cacheProvider : ICacheProvider;
		/**
		 * Reference to a version extractor instance used to determine automatically the version of
		 * an xml document.
		 */		
		public var versionExtractor : IVersionExtractor;
		/**
		 * Constructor
		 *
		 */
		public function Configuration() {}
		/**
		 * Flag signaling the presence or not of a cache provider. It is a
		 * quick determination of the use of a caching mechanism. 
		 * @return true if cache is used, false otherwise
		 * 
		 */		
		public function get allowCaching() : Boolean{
			return cacheProvider != null;
		}
		/**
		 * Flag signaling whether the engine should attempt to automatically
		 * determine the version of the received xml document. This setting
		 * is overridden by specifying a non empty version value when 
		 * deserializing the xml document. 
		 * @return true if detection is auto, false otherwise
		 * 
		 */		
		public function get autoDetectVersion() : Boolean{
			return versionExtractor != null;
		} 
		
		public final function clone() : Configuration{
			var copy : Configuration = getInstance();
			copyFrom(this, copy);
			return copy;
		}
		
		protected function getInstance() : Configuration{
			return new Configuration();
		}
		
		protected function copyFrom(source : Configuration, target : Configuration) : void{
			if(source && target){
				target.cacheProvider = source.cacheProvider;
				target.versionExtractor = source.versionExtractor;
				target.enableLogging = source.enableLogging;			
				target.onlySerializeChangedValueFields = source.onlySerializeChangedValueFields;
			}
		} 
	}
}