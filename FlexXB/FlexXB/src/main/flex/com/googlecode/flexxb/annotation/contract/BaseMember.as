/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
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
package com.googlecode.flexxb.annotation.contract
{
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
	import com.googlecode.flexxb.error.DescriptorParsingError;

	/**
	 * 
	 * @author aciobanu
	 * 
	 */	
	public class BaseMember extends BaseAnnotation implements IMemberAnnotation
	{		
		
		private var _ignoreOn : Stage;
		
		private var _order : Number;
		
		private var _name : QName;
		
		private var _type : Class;
		
		private var _isIDRef : Boolean;
		
		private var _isRequired : Boolean;
		
		private var _accessorType : AccessorType;
		
		private var _classAnnotation : IClassAnnotation;
				
		public function BaseMember(descriptor : MetaDescriptor){
			super(descriptor);
			_classAnnotation = descriptor.owner;
		}
		
		public function get classAnnotation() : IClassAnnotation {
			return _classAnnotation;
		}
		
		public function get readOnly() : Boolean {
			return _accessorType.isReadOnly();
		}
		
		public function get writeOnly() : Boolean {
			return _accessorType.isWriteOnly();
		}
		
		public function get accessor() : AccessorType {
			return _accessorType;
		}
		
		public function get ignoreOn() : Stage {
			return _ignoreOn;
		}
		
		public function get name() : QName {
			return _name;
		}
		
		public function get type() : Class {
			return _type;
		}
		
		public function get order() : Number {
			return _order;
		}
		
		public function get isIDRef() : Boolean{
			return _isIDRef;
		}

		public function get isRequired() : Boolean{
			return _isRequired;
		}

		protected override function parse(descriptor : MetaDescriptor) : void{
			super.parse(descriptor);
			_classAnnotation = descriptor.owner;
			_name = descriptor.fieldName;
			_type = descriptor.fieldType;
			_accessorType = descriptor.fieldAccess;
			_ignoreOn = Stage.fromString(descriptor.attributes[Constants.IGNORE_ON]);
			setOrder(descriptor.attributes[Constants.ORDER]);
			_isIDRef = descriptor.getBoolean(Constants.IDREF);
			_isRequired = descriptor.getBoolean(Constants.REQUIRED);
		}
		
		private function setOrder(value : String) : void {
			if (value) {
				var nr : Number;
				try {
					nr = Number(value);
				} catch (error : Error) {
					throw new DescriptorParsingError(classAnnotation.type, name.localName, "The order attribute of the annotation is invalid as number");
				}
				_order = nr;
			}
		}
	}
}