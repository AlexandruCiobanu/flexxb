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
	public class Scope
	{
		/**
		 * 
		 */		
		public static const INSTANCE : Scope = new Scope("Instance");
		/**
		 * 
		 */		
		public static const CLASSIFIER : Scope = new Scope("Classifier"); 
		
		private static var initialised : Boolean;
		
		{
			initialised = true;
		}
		
		private var name : String;
		
		public function Scope(name : String)
		{
			if(initialised){
				throw new Error("You should only use Scope.INSTANCE or Scope.CLASSIFIER");
			}
			this.name = name;
		}
	}
}