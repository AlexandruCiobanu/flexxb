/**
 *   FxMOD - FLEX Model Object Designer 
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
package com.googlecode.fxmod.uml.model.classdiagram
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */
	[Bindable]	
	public class Method extends Member
	{
		protected var _parameters : ArrayCollection;
		
		protected var _returnType : IType;
		
		public function Method(clasz : Class)
		{
			super(clasz);
		}
		
		public function get returnType() : IType{
			return _returnType;
		}
		
		public function set returnType(value : IType) : void{
			_returnType = value;
		}
		
		public function addParameter(parameter : Parameter) : void{
			
		}		
	}
}