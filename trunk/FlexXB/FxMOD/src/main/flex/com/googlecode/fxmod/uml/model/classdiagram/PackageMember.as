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
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	[Bindable]
	public class PackageMember extends UMLObject implements IPackageMember, IType
	{
		protected var _packageReference : Package;
		/**
		 * Constructor 
		 * 
		 */		
		public function PackageMember()
		{
			super();
		}
		/**
		 * 
		 * @see IPackageMember#packageReference()
		 * 
		 */		
		public function get packageReference() : Package
		{
			/return _packageReference;
		}
		/**
		 * 
		 * @see IPackageMember#packageReference()
		 * 
		 */			
		public function set packageReference(value : Package):void
		{
			_packageReference = value;
		}
		/**
		 * 
		 * @see IType#shortName()
		 * 
		 */		
		public function get shortName() : String{
			return name;
		}
		/**
		 * 
		 * @see IType#longName()
		 * 
		 */		
		public function get longName() : String{
			if(_packageReference){
				return _packageReference.name + "." + name;
			}
			return name;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function toString() : String{
			return longName;
		}		
	}
}