/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
 *   Copyright (C) 2008-2009 Alex Ciobanu
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
package com.googlecode.flexxb.annotation
{
	import com.googlecode.flexxb.error.DescriptorParsingError;
	
	import flash.utils.Dictionary;
	
	/**
	 * Defines the class constructor. Notifies the owner XmlClass whether the 
	 * described type has a default constructor or not.
	 * @author Alexutz
	 * 
	 */	
	internal class Constructor
	{
		private var owner : XmlClass;
		
		private var _arguments : Array;
		
		private var _fieldMap : Dictionary;
		
		private var _fields : Array;
		/**
		 * Constructor
		 * 
		 */		
		public function Constructor(owner : XmlClass){
			this.owner = owner;
		}
		/**
		 * Get parameter list
		 * @return Array of XMLMember objects
		 * 
		 */		
		public function get parameterFields() : Array{
			return _fields;
		}
		/**
		 * 
		 * @param fieldAnnotation
		 * @return 
		 * 
		 */		
		public function hasParameterField(fieldAnnotation : XmlMember) : Boolean{
			return !isDefault() && fieldAnnotation && _fieldMap[fieldAnnotation.fieldName];
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function isDefault() : Boolean{
			return !_arguments || _arguments.length == 0;
		} 
		/**
		 * 
		 * @param metadata
		 * 
		 */		
		public function parse(descriptor : XML) : void{
			var arguments : Object = descriptor.metadata.(@name == Argument.ANNOTATION_NAME);
			// multiple annotations on the same field are returned in reverse order with describeType
			for(var i : int = XMLList(arguments).length() - 1; i >= 0; i--){
				addArgument(new Argument(arguments[i]));
			}
		}
		/**
		 * 
		 * @param argument
		 * 
		 */		
		private function addArgument(argument : Argument) : void{
			if(!_arguments){
				_arguments = [];
				_fields = [];
				_fieldMap = new Dictionary();
			}
			if(!argument){
				throw new DescriptorParsingError(owner.fieldType, "<<Constructor>>", "Null argument.");
			}
			if(_fieldMap[argument.referenceField] != null){
				throw new DescriptorParsingError(owner.fieldType, argument.referenceField, "Argument " + argument.referenceField +  " already exists.");
			}
			_arguments.push(argument);
			var fieldAnnotation : XmlMember = owner.getMember(argument.referenceField) as XmlMember;
			if(!fieldAnnotation){
				throw new DescriptorParsingError(owner.fieldType, argument.referenceField, "Annotation for referred field does not exist");
			}
			_fieldMap[argument.referenceField] = fieldAnnotation;
			_fields.push(fieldAnnotation);
		}
	}
}