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
package com.googlecode.flexxb.json.annotation
{
	import com.googlecode.flexxb.annotation.contract.BaseClass;
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
	
	import mx.collections.SortField;

	/**
	 * 
	 * @author aciobanu
	 * 
	 */	
	public class JSONClass extends BaseClass implements IClassAnnotation
	{
		public static const NAME : String = "JSONClass";
		
		private var _alias : String;
		
		public function JSONClass(descriptor : MetaDescriptor){
			super(descriptor);
		}	
		/**
		 * Get the alias
		 * @return annotation alias
		 *
		 */
		public function get alias() : String {
			return _alias;
		}
		
		public override function getAdditionalSortFields() : Array{
			return [new SortField("alias", true, false, false)];
		}
		
		protected override function parse(descriptor : MetaDescriptor) : void {
			super.parse(descriptor);
			
			_alias = descriptor.getString(JSONConstants.ALIAS);
		}
		
		public override function get annotationName() : String {
			return NAME;
		}
	}
}