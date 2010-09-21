/**
 *   FlexXB
 *   Copyright (C) 2008-2010 Alex Ciobanu
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
package com.googlecode.flexxb
{
	import flash.utils.Dictionary;

	internal final class IdResolver
	{
		private var idMap : Dictionary;
		
		public function IdResolver(){ }
		
		public function bind(id : String, object : Object) : void{
			if(idMap == null){
				idMap = new Dictionary();
			}
			if(!idMap.hasOwnProperty(id)){
				idMap[id] = object;
			}
		}
		
		public function resolve(id : String, clasz : Class) : Function{
			return function() : Object {
				if(idMap==null){
					return null;
				}
				return idMap[id];
			};
		}
		
		public function clear() : void{
			if(idMap){
				for(var key : * in idMap){
					delete idMap[key];
				}
			}
		}
	}
}