/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications
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
package com.googlecode.flexxb.annotation.contract
{

	/**
	 * This contact interface defines the structure of a member annotation,
	 * that is, an annotation that is used only on class fields. A basic
	 * member annotation has a reference to its parent class annotation,
	 * has an access type (read, write, read/write) and can be ignored in 
	 * one of the two stages of the engine's processing: serialization or 
	 * deserialization.  
	 * @author Alexutz
	 * 
	 */	
	public interface IMemberAnnotation extends IFieldAnnotation
	{
		/**
		 * Get a reference to the parent class annotation
		 * @return 
		 * 
		 */		
		function get classAnnotation() : IClassAnnotation;
		/**
		 * Get a flag signaling whether the field can be accesed in read only mode 
		 * (only has a getter)
		 * @return true if is in read only mode, false otherwise
		 *
		 */
		function get readOnly() : Boolean;
		
		/**
		 * Get a flag signaling whether the field can be accesed in write only mode 
		 * (only has a setter)
		 * @return true if is in write only mode, false otherwise
		 *
		 */
		function get writeOnly() : Boolean;
		
		/**
		 * Get the field accessor 
		 * @return 
		 * 
		 */		
		function get accessor() : AccessorType;
		
		/**
		 * Flag signaling whether the member annotation must be ignored in a
		 * specific processing stage or not. 
		 * @see Stage
		 * @return 
		 * 
		 */		
		function get ignoreOn() : Stage;
		
		/**
		 * Get the order value of the current annotation. This value is used of the
		 * owner class annotation has its ordered flag set to true.
		 * @return order value
		 *
		 */
		function get order() : Number;
		
		/**
		 * Flag used to signal if the current field's values are id references to objects 
		 * in the same document.
		 * @return true if id referencing is on, false otherwise
		 * 
		 */		
		function get isIDRef() : Boolean;
		
		/**
		 * Flag used to signal if current field is manditory for serialization
		 * @return true if required, false otherwise
		 */		
		function get isRequired() : Boolean;
	}
}