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
package com.googlecode.flexxb.annotation.contract
{
	/**
	 * This interface describes a metadata defined at class level, that is bound 
	 * to the class owner metadata but defines particularities specific to the
	 * class itself. Good examples to this end are constructor arguments metadata
	 * or namespaces used by the class fields. They are not bound to a field name 
	 * and type but they afect the class representation.
	 * This kind of annotations does not usually need a serializer.
	 * @author Alexutz
	 * 
	 */	
	public interface IGlobalAnnotation
	{
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get classAnnotation() : IClassAnnotation;
	}
}