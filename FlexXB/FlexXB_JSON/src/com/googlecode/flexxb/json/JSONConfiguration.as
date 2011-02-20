/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 * 	 FlexXB_JSON -  FlexXB extension for JSON serialization support
 *   Copyright (C) 2008-2011 Alex Ciobanu
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
package com.googlecode.flexxb.json
{
	import com.googlecode.flexxb.core.Configuration;
	/**
	 * 
	 * @author Alexutz
	 * 
	 */	
	public final class JSONConfiguration extends Configuration
	{
		/**
		 * Flag indicating if the decoder should strictly adhere to the JSON standard or not. 
		 * The default of <code>true</code> throws errors if the format does not match the JSON 
		 * syntax exactly. Pass <code>false</code> to allow for non-properly-formatted JSON 
		 * strings to be decoded with more leniancy.
		 */		
		public var strict : Boolean;
		/**
		 * 
		 * @param parent
		 * 
		 */		
		public function JSONConfiguration(parent : Configuration = null){
			super();
			if(parent){
				super.copyFrom(parent, this);
			}
		}
		
		protected override function getInstance() : Configuration{
			return new JSONConfiguration();
		}
		
		protected override function copyFrom(source : Configuration, target : Configuration) : void{
			super.copyFrom(source, target);
			if(source is JSONConfiguration && target is JSONConfiguration){
				JSONConfiguration(target).strict = JSONConfiguration(source).strict;
			}
		}
	}
}