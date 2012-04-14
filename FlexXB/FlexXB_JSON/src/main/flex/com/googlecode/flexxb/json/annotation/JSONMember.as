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
	import com.googlecode.flexxb.annotation.contract.AccessorType;
	import com.googlecode.flexxb.annotation.contract.BaseAnnotation;
	import com.googlecode.flexxb.annotation.contract.BaseMember;
	import com.googlecode.flexxb.annotation.contract.Constants;
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	import com.googlecode.flexxb.annotation.contract.IMemberAnnotation;
	import com.googlecode.flexxb.annotation.contract.Stage;
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
	import com.googlecode.flexxb.error.DescriptorParsingError;

	/**
	 * 
	 * @author aciobanu
	 * 
	 */	
	public class JSONMember extends BaseMember implements IMemberAnnotation
	{		
		private var _alias : String;
						
		public function JSONMember(descriptor : MetaDescriptor){
			super(descriptor);
		}
		
		public final function get alias() : String{
			return _alias;
		}
		
		/**
		 * Get a flag to signal wether to use the owner's alias or not
		 * @return true if it must use the owner's alias, false otherwise
		 *
		 */
		public final function useOwnerAlias() : Boolean {
			return _alias == JSONConstants.ALIAS_ANY;
		}
		
		protected override function parse(descriptor : MetaDescriptor) : void{
			super.parse(descriptor);
			_alias = descriptor.getString(JSONConstants.ALIAS);
		}
	}
}