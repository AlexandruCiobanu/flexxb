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
	import com.googlecode.flexxb.interfaces.IDeserializeNotifiable;
	import com.googlecode.flexxb.interfaces.ISerializeNotifiable;
	
	import flash.events.IEventDispatcher;

	/**
	 * @private
	 * @author User
	 * 
	 */	
	internal final class ProcessNotifier
	{
		private var mappingModel : MappingModel;
		/**
		 * 
		 * @param mappingModel
		 * 
		 */		
		public function ProcessNotifier(mappingModel : MappingModel){
			this.mappingModel = mappingModel;
		}
		/**
		 * 
		 * @param dispatcher
		 * @param xmlData
		 * 
		 */		
		public function notifyPreSerialize(dispatcher : IEventDispatcher, xmlData : XML) : void{
			var object : Object = mappingModel.collisionDetector.getCurrent();
			var parent : Object = mappingModel.collisionDetector.getParent();
			if(object is ISerializeNotifiable){
				ISerializeNotifiable(object).onPreSerialize(parent, xmlData);
			}else{
				dispatcher.dispatchEvent(XmlEvent.createPreSerializeEvent(object, parent, xmlData));
			}
		}
		/**
		 * 
		 * @param dispatcher
		 * @param item
		 * @param xmlData
		 * 
		 */		
		public function notifyPreDeserialize(dispatcher : IEventDispatcher, item : Object, xmlData : XML) : void{
			var parent : Object = mappingModel.collisionDetector.getParent();
			if(item is IDeserializeNotifiable){
				IDeserializeNotifiable(item).onPreDeserialize(parent, xmlData);
			}else{
				dispatcher.dispatchEvent(XmlEvent.createPreDeserializeEvent(item, parent, xmlData));
			}			
		}
		/**
		 * 
		 * @param dispatcher
		 * @param xmlData
		 * 
		 */		
		public function notifyPostSerialize(dispatcher : IEventDispatcher, xmlData : XML) : void{
			var object : Object = mappingModel.collisionDetector.getCurrent();
			var parent : Object = mappingModel.collisionDetector.getParent();
			if(object is ISerializeNotifiable){
				ISerializeNotifiable(object).onPostSerialize(parent, xmlData);
			}else{
				dispatcher.dispatchEvent(XmlEvent.createPostSerializeEvent(object, parent, xmlData));
			}
		}
		/**
		 * 
		 * @param dispatcher
		 * @param item
		 * @param xmlData
		 * 
		 */			
		public function notifyPostDeserialize(dispatcher : IEventDispatcher, item : Object, xmlData : XML) : void{
			var parent : Object = mappingModel.collisionDetector.getParent();
			if(item is IDeserializeNotifiable){
				IDeserializeNotifiable(item).onPostDeserialize(parent, xmlData);
			}else{
				dispatcher.dispatchEvent(XmlEvent.createPostDeserializeEvent(item, parent, xmlData));
			}
		}
	}
}