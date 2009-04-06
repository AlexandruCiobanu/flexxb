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
	[Bindable]
	public class Member extends UMLObject implements IMember
	{
		protected var _class : Class;
		
		protected var _scope : Scope;
		
		protected var _visibility : Visibility;
		
		public function Member(clasz : Class)
		{
			super();
			if(!clasz){
				throw new Error("Member cannot have a null owner class");
			}
			_class = clasz;
		}
		
		public function get classReference():Class
		{
			return _class;
		}
		
		public function set classReference(value:Class):void
		{
			_class = value;
		}
		
		public function get scope():Scope
		{
			return _scope;
		}
		
		public function set scope(value:Scope):void
		{
			_scope = value;
		}
		
		public function get visibility():Visibility
		{
			return _visibility;
		}
		
		public function set visibility(value:Visibility):void
		{
			_visibility = value;
		}		
	}
}