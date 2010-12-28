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
	import com.googlecode.flexxb.api.AccessorTypeConverter;
	import com.googlecode.flexxb.api.FxApiWrapper;
	import com.googlecode.flexxb.api.FxArray;
	import com.googlecode.flexxb.api.FxAttribute;
	import com.googlecode.flexxb.api.FxClass;
	import com.googlecode.flexxb.api.FxConstructorArgument;
	import com.googlecode.flexxb.api.FxElement;
	import com.googlecode.flexxb.api.IFlexXBApi;
	import com.googlecode.flexxb.api.StageXmlConverter;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;

	/**
	 *
	 * @author Alexutz
	 * @private
	 */
	internal final class FlexXBApi implements IFlexXBApi {
		
		private static const LOG : ILogger = LogFactory.getLog(FlexXBApi);
		
		private var core : FlexXBCore;
		private var store : DescriptorStore

		/**
		 * Constructor
		 * @param core the xml serialization core
		 * @param store
		 *
		 */
		public function FlexXBApi(core : FlexXBCore, store : DescriptorStore) {
			this.core = core;
			this.store = store;
			core.context.registerSimpleTypeConverter(new StageXmlConverter());
			core.context.registerSimpleTypeConverter(new AccessorTypeConverter());
			core.processTypes(FxAttribute, FxElement, FxArray, FxConstructorArgument);
		}
		
		public function processTypeDescriptor(apiDescriptor : FxClass) : void {
			if (apiDescriptor) {
				var type : Class = apiDescriptor.type;
				store.registerDescriptor(apiDescriptor.toXml(), type);
			}
		}
		
		public function processDescriptorsFromXml(xml : XML) : void {
			if (xml) {
				var apiWrapper : FxApiWrapper = core.deserialize(xml, FxApiWrapper);
				if (apiWrapper) {
					for each (var classDescriptor : FxClass in apiWrapper.descriptors) {
						if (classDescriptor) {
							if(core.configuration.enableLogging){
								LOG.info("Processing class {0}", classDescriptor.type);
							}
							processTypeDescriptor(classDescriptor);
						}
					}
				}
			}
		}
	}
}