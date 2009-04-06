/**
 *   FxMOD
 *   Copyright (C) 2008 - 2009 Alex Ciobanu
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
package com.googlecode.fxmod.model
{
	/**
	 * 
	 * @author aCiobanu
	 * 
	 */	
	public interface IMember extends IUMLObject
	{
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get classReference() : Class;
		/**
		 * 
		 * @param value
		 * 
		 */		
		function set classReference(value : Class) : void;
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get scope() : Scope;
		/**
		 * 
		 * @param value
		 * 
		 */		
		function set scope(value : Scope) : void;
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get visibility() : Visibility;
		/**
		 * 
		 * @param value
		 * 
		 */		
		function set visibility(value : Visibility) : void;
	}
}