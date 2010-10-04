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
package com.googlecode.flexxb
{
	/**
	 * @private
	 * @author User
	 * 
	 */	
	internal final class MappingModel
	{
		
		public var configuration : Configuration;
		
		public var descriptorStore : DescriptorStore;
		
		public var converterStore : ConverterStore;
		
		public var processNotifier : ProcessNotifier;
		
		public var collisionDetector : CircularReferenceDetector;
		
		public var idResolver : IdResolver;
		
		public function MappingModel(){
			processNotifier = new ProcessNotifier(this);
			collisionDetector = new CircularReferenceDetector();
			idResolver = new IdResolver();
			
			descriptorStore = new DescriptorStore();
			configuration = new Configuration();
			converterStore = new ConverterStore();
		}	
		
		public function performCleanup() : void{
			
		}
	}
}