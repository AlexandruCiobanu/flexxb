/**
 *   FlexXB - an annotation based xml serializer for Flex and Air applications 
 *   Copyright (C) 2008 Alex Ciobanu
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
 package com.googlecode.serializer
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	/**
	 * Object cache used to ensure object uniqueness across the application.
	 * @author Alexutz
	 * 
	 */	
	public final class ModelObjectCache
	{
		/**
		 * Singleton
		 */		
		public static const instance : ModelObjectCache = new ModelObjectCache();
		/**
		 * 
		 */		
		private var cache : Dictionary = new Dictionary();
		/**
		 * Do not call this constructor in code; use <code>ModelObjectCache.instance</code> instead. 
		 * 
		 */		
		public function ModelObjectCache(){
			if (instance) {
				throw new Error("Don't instanciate this class. Use ModelObjectCache.instance instead!");
			}
		}		
		/**
		 * Get a cached object by id and type
		 * @param id object's id
		 * @param clasz object's type
		 * @return the object cached under the given id and class.
		 * 
		 */
		public function getObject(id : String, clasz : Class) : Object {
			if (cache[clasz]) {
				return cache[clasz][id];
			} else {
				return null;
			}
		}		
		/**
		 * Determines whether an object with the given id is aleady cached
		 * @param id the id under which the object should have been cached
		 * @param clasz the class of the object
		 * @return true if there is an object cached under the given id and class.
		 * 
		 */
		public function isCached(id : String, clasz : Class) : Boolean {
			return cache[clasz] && cache[clasz][id] != null;
		}		
		/**
		 * Put an object in the cache
		 * @param id the id under which the object will be cached
		 * @param object the object itself
		 * @return if the object was succesfuly cached.
		 * 
		 */
		public function putObject(id : String, object : Object) : Boolean {
			if(!id){
				return false;
			}
			var qualifiedName : String = getQualifiedClassName(object);
			var clasz : Class = ApplicationDomain.currentDomain.getDefinition(qualifiedName) as Class;
			var old : Object = getObject(id, clasz);
			if (!cache[clasz]) {
				cache[clasz] = new Dictionary();
			}
			cache[clasz][id] = object;
			return old;
		}
		/**
		 * Clears the cache for all the objects with given class.
		 * If no class is specified, then all cache is cleared.
		 * @param clasz
		 */
		public function clearCache(clasz : Class = null) : void {
			if (clasz) {
				delete cache[clasz];
				cache[clasz] = new Dictionary();
			} else {
				for each (var clasz : Class in cache) {
					delete cache[clasz];
				} 
				cache = new Dictionary();
			}
		}
		/**
		 * Iterate through all the cached objects of the given type, calling the callback method for each
		 * @param clasz object type
		 * @param callback method that gets called for each object of the given type in the cache
		 * 
		 */		
		public function forEachOfType(clasz : Class, callback : Function) : void{
			if(cache[clasz] && callback is Function){
				for each(var item : Object in cache[clasz]){
					callback(item);
				}
			}
		}
	}
}