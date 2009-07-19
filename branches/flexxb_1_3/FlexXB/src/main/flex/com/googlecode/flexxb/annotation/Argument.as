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
	/**
	 * Defines a constructor argument. This annotaton is used when a class has a 
	 * non default constructor. In order to maintain the business restrictions, FlexXB 
	 * will determine the values of the arguments based on the received xml and call 
	 * the constructor with those values. 
	 * <p/>An argument has a reference; the reference is the name of the class field  
	 * whose value it represents. A non default constructor will most often configure 
	 * some of the object's fields when called. Since the only available data is the 
	 * incoming xml, arguments must specify the field the the constructor will modify 
	 * with the received value. 
	 * <p/><b>The class field referenced in the argument must have an annotation defined
	 *  for it</b>
	 * @author Alexutz
	 * 
	 */	
	public class Argument extends BaseAnnotation
	{
		/**
		 * The annotation's name
		 */		
		public static const ANNOTATION_NAME : String = "ConstructorArg";
		/**
		 * Reference attribute name
		 */		
		public static const ARGUMENT_REF : String = "reference";
		/**
		 * Optional attribute name
		 */		
		public static const ARGUMENT_OPTIONAL : String = "optional";
		/**
		 * 
		 */		
		private var _referenceField : String;
		/**
		 * 
		 */		
		private var _optional : Boolean;
		/**
		 * Constructor
		 * 
		 */		
		public function Argument(descriptor : XML)
		{
			super(descriptor);
		}
		/**
		 * Get optional flag
		 * @return 
		 * 
		 */		
		public function get optional() : Boolean{
			return _optional;
		}
		/**the reference field name
		 * @return 
		 * 
		 */		
		public function get referenceField() : String{
			return _referenceField;
		}
		/**
		 * 
		 * @see com.googlecode.flexxb.annotation.BaseAnnotation#parse()
		 * 
		 */		
		protected override function parse(descriptor : XML) : void{
			_referenceField = descriptor.arg.(@key == ARGUMENT_REF).@value;
			_optional = descriptor.arg.(@key == ARGUMENT_OPTIONAL).@value == "true";
		}
		/**
		 * 
		 * @see com.googlecode.flexxb.annotation.BaseAnnotation#annotationName()
		 * 
		 */		
		public override function get annotationName():String{
			return ANNOTATION_NAME;
		}
	}
}