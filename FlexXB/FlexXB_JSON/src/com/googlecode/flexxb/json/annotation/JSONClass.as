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
package com.googlecode.flexxb.json.annotation
{
	import com.googlecode.flexxb.annotation.contract.BaseAnnotation;
	import com.googlecode.flexxb.annotation.contract.Constructor;
	import com.googlecode.flexxb.annotation.contract.IClassAnnotation;
	import com.googlecode.flexxb.annotation.contract.IMemberAnnotation;
	import com.googlecode.flexxb.annotation.parser.MetaDescriptor;
	
	import mx.collections.ArrayCollection;
	/**
	 * 
	 * @author aciobanu
	 * 
	 */	
	public class JSONClass extends BaseAnnotation implements IClassAnnotation
	{
		public static const NAME : String = "JSONClass";
		
		private var id : String;
		/**
		 * @private
		 */
		private var _idField : JSONMember;
		/**
		 * @private
		 */
		private var _ordered : Boolean;
		/**
		 * @private
		 */
		private var _constructor : Constructor;
		
		public function JSONClass(descriptor:MetaDescriptor)
		{
			//TODO: implement function
			super(descriptor);
		}
		
		public function get members():ArrayCollection
		{
			//TODO: implement function
			return null;
		}
		
		public function getMember(fieldName:String):IMemberAnnotation
		{
			//TODO: implement function
			return null;
		}
		
		public function get idField() : IMemberAnnotation{
			return _idField;
		}
		
		public function get constructor():Constructor
		{
			return _constructor;
		}
		
		public function get name():QName
		{
			//TODO: implement function
			return null;
		}
		
		public function get type():Class
		{
			//TODO: implement function
			return null;
		}
		
		protected override function parse(descriptor : MetaDescriptor) : void {
			super.parse(descriptor);
			
			var desc : ClassMetaDescriptor = descriptor as ClassMetaDescriptor;
			id = desc.attributes[XmlConstants.ID];
			_ordered = desc.getBooleanAttribute(XmlConstants.ORDERED);
			_name = descriptor.fieldName;
			_type = descriptor.fieldType;
			setAlias(descriptor.attributes[XmlConstants.ALIAS]);
			
			for each(var meta : MetaDescriptor in desc.members){
				addMember(AnnotationFactory.instance.getAnnotation(meta, this) as XmlMember);
			}
			
			constructor.parse(desc);
		}
	}
}