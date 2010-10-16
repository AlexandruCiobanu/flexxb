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
	/**
	 * @private 
	 * @author User
	 * 
	 */	
	internal final class IdResolver
	{
		private var idMap : Dictionary;
		
		private var taskList : Array;
		
		public function IdResolver(){ }
		/**
		 * 
		 * @param id
		 * @param object
		 * 
		 */		
		public function bind(id : String, object : Object) : void{
			if(idMap == null){
				idMap = new Dictionary();
			}
			if(!idMap.hasOwnProperty(id)){
				idMap[id] = object;
			}
		}
		/**
		 * 
		 * 
		 */		
		public function beginDocument() : void{
			
		}
		/**
		 * 
		 * @param id
		 * @param clasz
		 * @return 
		 * 
		 */		
		private function resolve(id : String, clasz : Class = null) : Object{
			if(idMap==null){
				return null;
			}
			return idMap[id];
		}
		/**
		 * 
		 * @param item
		 * @param field
		 * @param id
		 * 
		 */		
		public function addResolutionTask(item : Object, field : QName, id : String) : void{
			if(item && item.hasOwnProperty(field)){
				if(taskList == null){
					taskList = [];
				}
				taskList.push(new ResolverTask(item, field, id));
			}
		}
		/**
		 * 
		 * 
		 */		
		public function endDocument() : void{
			resolveTasks();
			clear();
		}
		
		private function resolveTasks() : void{
			if(taskList){
				for each(var task : ResolverTask in taskList){
					task.object[task.field] = resolve(task.id);
				}
			}
		}
		
		private function clear() : void{
			if(idMap){
				for(var key : * in idMap){
					delete idMap[key];
				}
			}
			if(taskList){
				var task : ResolverTask;
				while(taskList.length > 0){
					task = taskList.pop();
					task.clear();
					task = null;
				}
			}
		}
	}
}

class ResolverTask{
	public var object : Object;
	public var field : QName;
	public var id : String;
	
	public function ResolverTask(object : Object, field : QName, id : String){
		this.object = object;
		this.field = field;
		this.id = id;
	}
	
	public function clear() : void{
		object = null;
		field = null;
		id = null;
	}	
}