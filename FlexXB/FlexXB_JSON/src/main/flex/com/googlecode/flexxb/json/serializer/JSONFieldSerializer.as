/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
 * 	 FlexXB_JSON -  FlexXB extension for JSON serialization support
 *   Copyright (C) 2008-2012 Alex Ciobanu
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
package com.googlecode.flexxb.json.serializer
{
	import com.googlecode.flexxb.annotation.contract.IAnnotation;
	import com.googlecode.flexxb.core.DescriptionContext;
	import com.googlecode.flexxb.core.SerializationCore;
	import com.googlecode.flexxb.serializer.BaseSerializer;
	import com.googlecode.flexxb.util.log.ILogger;
	import com.googlecode.flexxb.util.log.LogFactory;

	/**
	 * 
	 * @author aciobanu
	 * 
	 */	
	public class JSONFieldSerializer extends BaseSerializer
	{
		private static const LOG : ILogger = LogFactory.getLog(JSONFieldSerializer);
		
		public function JSONFieldSerializer(context : DescriptionContext){
			super(context);
		}
		
		public override function serialize(object : Object, annotation : IAnnotation, serializedData : Object, serializer : SerializationCore) : Object{
			return null;
		}
		
		public override function deserialize(serializedData : Object, annotation : IAnnotation, serializer : SerializationCore) : Object{
			return null;
		} 
	}
}