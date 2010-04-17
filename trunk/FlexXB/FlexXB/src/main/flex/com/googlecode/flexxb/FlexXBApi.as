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
package com.googlecode.flexxb {
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
	 *
	 */
	internal final class FlexXBApi implements IFlexXBApi {
		
		private static var log : ILogger = LogFactory.getLog(FlexXBApi);
		
		private var engine : FlexXBEngine;
		private var store : DescriptorStore

		/**
		 * Constructor
		 * @param store
		 *
		 */
		public function FlexXBApi(engine : FlexXBEngine, store : DescriptorStore) {
			this.engine = engine;
			this.store = store;
			engine.registerSimpleTypeConverter(new StageXmlConverter());
			engine.registerSimpleTypeConverter(new AccessorTypeConverter());
			engine.processTypes(FxAttribute, FxElement, FxArray, FxConstructorArgument);
		}

		/**
		 *
		 * @see IFlexXBApi#processTypeDescriptor()
		 *
		 */
		public function processTypeDescriptor(apiDescriptor : FxClass) : void {
			if (apiDescriptor) {
				var type : Class = apiDescriptor.type;
				store.registerDescriptor(apiDescriptor.toXml(), type);
			}
		}

		/**
		 *
		 * @see IFlexXBApi#processDescriptorsFromXml()
		 *
		 */
		public function processDescriptorsFromXml(xml : XML) : void {
			if (xml) {
				var apiWrapper : FxApiWrapper = engine.deserialize(xml, FxApiWrapper);
				if (apiWrapper) {
					for each (var classDescriptor : FxClass in apiWrapper.descriptors) {
						if (classDescriptor) {
							if(engine.configuration.enableLogging){
								log.info("Processing class {0}", classDescriptor.type);
							}
							processTypeDescriptor(classDescriptor);
						}
					}
				}
			}
		}
	}
}