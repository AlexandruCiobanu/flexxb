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
	import com.googlecode.flexxb.annotation.AnnotationFactory;
	import com.googlecode.flexxb.annotation.parser.ClassMetaDescriptor;
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
	
	import mx.collections.ArrayCollection;

	/**
	 * 
	 * @author User
	 * 
	 */	
	public class BaseClass extends BaseAnnotation implements IClassAnnotation
	{
		[Bindable]
		public var members : ArrayCollection;
		
		private var id : String;
		
		private var _name : QName;
		
		private var _type : Class; 
		
		private var _ordered : Boolean;
		
		private var _idField : IMemberAnnotation;
		
		private var _constructor : Constructor;
		
		public function BaseClass(descriptor : MetaDescriptor){
			super(descriptor);
		}
		
		public function getMember(fieldName : String) : IMemberAnnotation{
			if (fieldName && fieldName.length > 0) {
				for each (var member : IMemberAnnotation in members) {
					if (member.name.localName == fieldName) {
						return member;
					}
				}
			}
			return null;
		}
		
		public function get idField() : IMemberAnnotation{
			return _idField;
		}
		
		public function get constructor() : Constructor{
			return _constructor;
		}
		
		public function get name() : QName{
			return _name;
		}
		
		public function get type() : Class{
			return _type;
		}
		
		public function get ordered() : Boolean{
			return _ordered;
		}
		
		public function getAdditionalSortFields() : Array{
			return [];
		}
		
		protected override function parse(descriptor : MetaDescriptor) : void {
			super.parse(descriptor);
			
			var desc : ClassMetaDescriptor = descriptor as ClassMetaDescriptor;
			id = desc.getString(Constants.ID);
			_ordered = desc.getBoolean(Constants.ORDERED);
			_name = descriptor.fieldName;
			_type = descriptor.fieldType;
			
			for each(var meta : MetaDescriptor in desc.members){
				addMember(AnnotationFactory.instance.getAnnotation(meta, this) as IMemberAnnotation);
			}
			
			constructor.parse(desc);
		}
		/**
		 * Override this method if you require additional tasks to be 
		 * performed per member added to the class member list. 
		 * @param member
		 * 
		 */		
		protected function onMemberAdded(member : IMemberAnnotation) : void{ }
		
		private function addMember(annotation : IMemberAnnotation) : void{
			if (annotation && !isFieldRegistered(annotation)) {
				members.addItem(annotation);
				if (annotation.name.localName == id) {
					_idField = annotation;
				}
				onMemberAdded(annotation);
			}
		}
		
		private function isFieldRegistered(annotation : IMemberAnnotation) : Boolean {
			for each (var member : IMemberAnnotation in members) {
				if (member.name == annotation.name) {
					return true;
				}
			}
			return false;
		}
	}
}